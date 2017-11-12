# Manual

## Build uClinux kernel

### Download latest kernel

From: <https://sourceforge.net/projects/uclinux/files/uClinux%20Stable/dist-20160919/uClinux-dist-20160919.tar.bz2/download>

### Install toolchain and other tools

* Cross compiler
```bash
$ sudo apt-get install gcc-arm-linux-gnueabi
```

Download toolchains for uClinux, at:
<https://sourceforge.net/projects/uclinux/files/Tools/arm-uclinuxeabi-20160831/arm-uclinuxeabi-tools-20160831.tar.gz/download>

After downloading, unzip it and copy to corresponding directories.

* Other dependency tools
```bash
$ sudo apt-get -y install libncurses5-dev bc lzop u-boot-tools genromfs
```

* For Freescale:
```
$ sudo apt-get install bison
```

### Compile

```bash
$ make menuconfig
```

* Select a vendor profile (configuration file): we choose a board `Versatile-PB-noMMU` from `ARM`.
  * Reasons:
    1. It uses ARM architecture, that means we don't need to install other cross-compiler (like M68K, things will be more complicated).
    2. The machine `versatilepb` is supported by QEMU ARM
    3. It does not have MMU (and the impact of lacking MMU is exactly what we want to verify).

```
vendors/ARM/Versatile-PB-noMMU/config.arch
```

* Save and Exit.

* Make (with Debug Information enabled: `CONFIG_DEBUG_INFO=y`)
```
$ make modules CONFIG_DEBUG_INFO=y
$ make -j 16 CONFIG_DEBUG_INFO=y
```

* Make some other images (such as ROMFS that we will need later):
```bash
$ make image
```

#### Troubleshooting

1. It may complain that some compilers (such as: `arm-linux-gcc`,...) are lacked, we just need to make symlinks from the current `arm-linux-gnueabi-*` to them:

```bash
$ cd /usr/bin
$ for i in `ls arm-linux-gnueabi-*`; do ln -sf $i arm-linux${i#arm-linux-gnueabi}; done
```

2. Remember to download toolchains for uClinux (`arm-uClinux-gnueabi-*`) and install to `/usr/local` so that some modules can be built succesfully. (e.g. `usr/net-tools/`,...)

3. Some errors may appear when compiling modules in `usr/net-tools/` directory. For some reasons, the header files can be found (or the parameter of INCLUDE DIR in the Makefile did not work as expected). One workaround for that is: copying all `*.h` files from `usr/net-tools` and `usr/net-tools/include/` to the `usr/net-tools/lib` directory.

```bash
$ cd [build_root]
$ cp user/net-tools/*.h user/net-tools/lib/
$ cp user/net-tools/include/*.h user/net-tools/lib/
```

## Make uClinux profile for Volatility

In order to make a Volatility profile, we need two files:

1. A vtypes (kernel's data structure) file: `module.dwarf`
2. A Symbols file: `System.map`

### Install tools

```bash
$ sudo apt-get install dwarfdump
```

### Create vtypes 

After compiling the kernel, one file named `module.o` will be created in `linux/kernel`. (Make sure to enable `CONFIG_DEBUG_INFO=y` when compiling so that this file can contain debug information. Otherwise, this step is useless).

```bash
$ cd [build_root]/linux/kernel
$ dwarfdump -di ./module.o > module.dwarf
```

The file `module.dwarf` is what we need for the next steps.

* Test the file:

```bash
$ head module.dwarf 

.debug_info

<0><0x0+0xb><DW_TAG_compile_unit> DW_AT_producer<GNU C89 7.2.0 -mlittle-endian -mabi=aapcs-linux -mno-thumb-interwork -mfpu=vfp -marm -march=armv5te -mtune=arm9tdmi -mfloat-abi=soft -mtls-dialect=gnu -g -Os -std=gnu90 -fno-strict-aliasing -fno-common -fno-dwarf2-cfi-asm -fno-ipa-sra -funwind-tables -fno-delete-null-pointer-checks -fno-stack-protector -fomit-frame-pointer -fno-var-tracking-assignments -fno-strict-overflow -fconserve-stack --param allow-store-data-races=0> DW_AT_language<DW_LANG_C89> DW_AT_name<kernel/module.c> DW_AT_comp_dir<...
```

### Copy Symbols

After compiling the kernel, one file named `System.map` will be created in `[build_root]/linux` folder. That's the file we need for the next steps

### Making the profile

```bash
$ mkdir uClinux_profile
$ cd uClinux_profile
$ cp [build_root]/linux/kernel/module.dwarf .
$ mkdir boot
$ cd boot
$ cp [build_root]/linux/System.map
$ cd ..
$ zip uClinux.zip boot/System.map module.dwarf
```

## Booting uClinux on QEMU

### Run QEMU

#### Create HDD image

Not sure if it's neccessary, just try.

```
$ qemu-img create -f qcow hda.img 100M
```

#### First boot
```bash
$ qemu-system-arm -M versatilepb -m 256 -kernel linux/arch/arm/boot/zImage -initrd linux/usr/initramfs_data.cpio.gz -hda hda.img --append "root=/dev/ram console=ttyAMA0" -serial stdio
```

```
$ qemu-system-arm -M versatilepb -kernel images/zImage --append "console=ttyAMA0,115200" -serial stdio
```

=> Error:
```
VFS: Cannot open root device "ram" or unknown-block(1,0): error -2
Please append a correct "root=" boot option; here are the available partitions:
0100            8192 ram0  (driver?)
0101            8192 ram1  (driver?)
0102            8192 ram2  (driver?)
0103            8192 ram3  (driver?)
0104            8192 ram4  (driver?)
0105            8192 ram5  (driver?)
0106            8192 ram6  (driver?)
0107            8192 ram7  (driver?)
0108            8192 ram8  (driver?)
0109            8192 ram9  (driver?)
010a            8192 ram10  (driver?)
010b            8192 ram11  (driver?)
010c            8192 ram12  (driver?)
010d            8192 ram13  (driver?)
010e            8192 ram14  (driver?)
010f            8192 ram15  (driver?)
Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(1,0)
CPU: 0 PID: 1 Comm: swapper Not tainted 4.4.0-uc0 #5
Hardware name: ARM-Versatile PB
[<0001a270>] (unwind_backtrace) from [<00017f14>] (show_stack+0x10/0x14)
[<00017f14>] (show_stack) from [<00067b98>] (panic+0x9c/0x250)
[<00067b98>] (panic) from [<002b639c>] (mount_block_root+0x230/0x314)
[<002b639c>] (mount_block_root) from [<002b67d4>] (prepare_namespace+0x1b4/0x230)
[<002b67d4>] (prepare_namespace) from [<002b5f98>] (kernel_init_freeable+0x1d4/0x228)
[<002b5f98>] (kernel_init_freeable) from [<00215d30>] (kernel_init+0x8/0x118)
[<00215d30>] (kernel_init) from [<00014f20>] (ret_from_fork+0x14/0x34)
---[ end Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(1,0)
```

#### N-th boot (after so many fails)
```bash
$ qemu-system-arm -M versatilepb -kernel images/zImage --append "console=ttyAMA0,115200" -serial stdio
```

=> Boot log ^^:
```
pulseaudio: set_sink_input_volume() failed
pulseaudio: Reason: Invalid argument
pulseaudio: set_sink_input_mute() failed
pulseaudio: Reason: Invalid argument
Uncompressing Linux... done, booting the kernel.
Booting Linux on physical CPU 0x0
Linux version 4.4.0-uc0 (tor@NIS) (gcc version 5.4.0 (GCC) ) #49 Sun Nov 12 17:51:15 CET 2017
CPU: ARM926EJ-S [41069265] revision 5 (ARMv5TEJ), cr=00091176
CPU: VIVT data cache, VIVT instruction cache
Machine: ARM-Versatile PB
sched_clock: 32 bits at 24MHz, resolution 41ns, wraps every 89478484971ns
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 32512
Kernel command line: console=ttyAMA0,115200
PID hash table entries: 1024 (order: 0, 4096 bytes)
Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
Inode-cache hash table entries: 8192 (order: 3, 32768 bytes)
Memory: 126560K/131072K available (2084K kernel code, 112K rwdata, 596K rodata, 476K init, 69K bss, 4512K reserved, 0K cma-reserved)
Virtual kernel memory layout:
    vector  : 0x00000000 - 0x00001000   (   4 kB)
    fixmap  : 0xffc00000 - 0xfff00000   (3072 kB)
    vmalloc : 0x00000000 - 0xffffffff   (4095 MB)
    lowmem  : 0x00000000 - 0x08000000   ( 128 MB)
    modules : 0x00000000 - 0x08000000   ( 128 MB)
      .text : 0x00008000 - 0x002a67b8   (2682 kB)
      .init : 0x002a7000 - 0x0031e000   ( 476 kB)
      .data : 0x0031e000 - 0x0033a120   ( 113 kB)
       .bss : 0x0033a120 - 0x0034b62c   (  70 kB)
NR_IRQS:224
VIC @10140000: id 0x00041190, vendor 0x41
FPGA IRQ chip 0 "SIC" @ 10003000, 13 irqs, parent IRQ: 63
clocksource: timer3: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1911260446275 ns
Console: colour dummy device 80x30
Calibrating delay loop... 538.21 BogoMIPS (lpj=2691072)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
Mountpoint-cache hash table entries: 1024 (order: 0, 4096 bytes)
VFP support v0.3: implementor 41 architecture 1 part 10 variant 9 rev 0
clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 19112604462750000 ns
NET: Registered protocol family 16
Serial: AMBA PL011 UART driver
dev:f1: ttyAMA0 at MMIO 0x101f1000 (irq = 44, base_baud = 0) is a PL011 rev1
console [ttyAMA0] enabled
dev:f2: ttyAMA1 at MMIO 0x101f2000 (irq = 45, base_baud = 0) is a PL011 rev1
dev:f3: ttyAMA2 at MMIO 0x101f3000 (irq = 46, base_baud = 0) is a PL011 rev1
fpga:09: ttyAMA3 at MMIO 0x10009000 (irq = 70, base_baud = 0) is a PL011 rev1
clocksource: Switched to clocksource timer3
NET: Registered protocol family 2
TCP established hash table entries: 1024 (order: 0, 4096 bytes)
TCP bind hash table entries: 1024 (order: 0, 4096 bytes)
TCP: Hash tables configured (established 1024 bind 1024)
UDP hash table entries: 256 (order: 0, 4096 bytes)
UDP-Lite hash table entries: 256 (order: 0, 4096 bytes)
NET: Registered protocol family 1
NetWinder Floating Point Emulator V0.97 (double precision)
futex hash table entries: 256 (order: -1, 3072 bytes)
romfs: ROMFS MTD (C) 2007 Red Hat, Inc.
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
brd: module loaded
smc91x.c: v1.1, sep 22 2004 by Nicolas Pitre <nico@fluxnic.net>
smc91x smc91x.0 eth0: SMC91C11xFD (rev 1) at 10010000 IRQ 57
 [nowait]
smc91x smc91x.0 eth0: Ethernet addr: 52:54:00:12:34:56
NET: Registered protocol family 17
Freeing unused kernel memory: 476K (002a7000 - 0031e000)
Shell invoked to run file: /etc/rc
Command: hostname versatile
Command: echo "Mounting filesystems..."
Mounting filesystems...
Command: mount -t proc proc /proc
Command: mount -t sysfs sys /sys
Command: mkdir -m 755 /dev/pts
/dev/pts: File exists
Command: mount -t devpts devpts /dev/pts
Command: mount -t tmpfs tmpfs /tmp
Command: mount -t tmpfs tmpfs /var
Command: mkdir -m 1777 /var/tmp
Command: mkdir -m 755 /var/log
Command: mkdir -m 755 /var/run
Command: mkdir -m 1777 /var/lock
Command: mkdir -m 755 /var/empty
Command: mkdir -m 755 /var/mnt
Command: ifconfig lo 127.0.0.1
Command: route add -net 127.0.0.0 netmask 255.0.0.0 lo
Command: dhcpcd -p -a eth0 &
[41]
Command: cat /etc/motd
Welcome to
          ____ _  _
         /  __| ||_|                 
    _   _| |  | | _ ____  _   _  _  _ 
   | | | | |  | || |  _ \| | | |\ \/ /
   | |_| | |__| || | | | | |_| |/    \
   |  ___\____|_||_|_| |_|\____|\_/\_/
   | |
   |_|

For further infosmc91x smc91x.0 eth0: link up
rmation check:
http://www.uclinux.org/

Execution Finished, Exiting

Sash command shell (version 1.1.1)
/> Jan  1 00:00:00 dhcpcd[41]: dhcpConfig: failed to write cache file /etc/dhcpc/dhcpcd-eth0.cache: No such file or directory

Jan  1 00:00:00 dhcpcd[41]: dhcpConfig: failed to write info file /etc/dhcpc/dhcpcd-eth0.info: No such file or directory

: Bad command or file name
/> 
/> ls
bin
dev
etc
home
init
lib
mnt
proc
sbin
sys
tmp
usr
var
/>
```

# volatility-uclinux
Volatility profile for uclinux
