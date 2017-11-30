# volatility-uclinux

Volatility profile for uclinux

# Manual

## Build uClinux kernel

### Download latest kernel

From: <https://sourceforge.net/projects/uclinux/files/uClinux%20Stable/dist-20160919/uClinux-dist-20160919.tar.bz2/download>

### Install toolchain and other tools

* Cross compiler
```bash
$ sudo apt-get install gcc-arm-linux-gnueabi
```

* Download toolchains for uClinux, at:
<https://sourceforge.net/projects/uclinux/files/Tools/arm-uclinuxeabi-20160831/arm-uclinuxeabi-tools-20160831.tar.gz/download>

After downloading, unzip it and copy to corresponding directories.

* Other dependency tools
```bash
$ sudo apt-get -y install libncurses5-dev bc lzop u-boot-tools genromfs
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

#### Troubleshooting

1. It may complain that some compilers (such as: `arm-linux-gcc`,...) are lacked, we just need to make symlinks from the current `arm-linux-gnueabi-*` to them:

```bash
$ cd /usr/bin
$ for i in `ls arm-linux-gnueabi-*`; do ln -sf $i arm-linux${i#arm-linux-gnueabi}; done
```

2. Remember to download toolchains for uClinux (`arm-uClinux-gnueabi-*`) and install them to `/usr/local` so that some modules can be built succesfully. (e.g. `usr/net-tools/`,...)

3. Some errors may appear when compiling modules in `usr/net-tools/` directory. For some reasons, the header files can't be found (or the parameter of INCLUDE DIR in the Makefile did not work as expected). One workaround for that is: copying all `*.h` files from `usr/net-tools` and `usr/net-tools/include/` to the `usr/net-tools/lib` directory.

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

#### N-th boot (after so many fails)
```bash
$ qemu-system-arm -M versatilepb -kernel images/zImage --append "console=ttyAMA0,115200" -nographic
```

=> Booting log ^^: [boot.log](./boot.log)

## Dump the memory from QEMU

After booting uClinux on QEMU, on the console, press `Ctrl + a` then `c` to switch to QEMU monitoring console. 

### With dump-guest-memory?
```
(qemu) dump-guest-memory -p ./guest-mem.dump
```

### With pmemsave

Dump the memory (256M):
```
(qemu) pmemsave 0 0x0fffffff mem.dump
```

## Loading uClinux profile to Volatility

```bash
$ cd /path/to/volatility
$ cp /path/to/uClinux_profile.zip plugins/overlays/linux/
```

### Testing if the profile is loaded properly

```bash
$ python vol.py --info | grep uClinux
Volatility Foundation Volatility Framework 2.6
LinuxuClinux_ARM_VersatilePBARM - A Profile for Linux uClinux_ARM_VersatilePB ARM
```

## Testing the memory  with Volatility uClinux profile

### Issue 1: Overlay structures not present in vtypes

```
$ volatility -f ~/project/source/uClinux-dist/mem.dump  imageinfo
Volatility Foundation Volatility Framework 2.6
INFO    : volatility.debug    : Determining profile based on KDBG search...
WARNING : volatility.debug    : Overlay structure tty_struct not present in vtypes
WARNING : volatility.debug    : Overlay structure sockaddr_un not present in vtypes
WARNING : volatility.debug    : Overlay structure net_device not present in vtypes
WARNING : volatility.debug    : Overlay structure in_ifaddr not present in vtypes
WARNING : volatility.debug    : Overlay structure tty_struct not present in vtypes
WARNING : volatility.debug    : Overlay structure sockaddr_un not present in vtypes
WARNING : volatility.debug    : Overlay structure net_device not present in vtypes
WARNING : volatility.debug    : Overlay structure in_ifaddr not present in vtypes
          Suggested Profile(s) : No suggestion (Instantiated with LinuxKali3-amd64x64)
                     AS Layer1 : FileAddressSpace (/root/project/source/uClinux-dist/mem.dump)
                      PAE type : No PAE
                           DTB : -0x1L
```

### Issue 2: No suitable address space mapping found

```
$ volatility -f ~/project/source/uClinux-dist/mem.dump --profile=LinuxuClinux_ARM_VersatilePBARM linux_lsmod
Volatility Foundation Volatility Framework 2.6
WARNING : volatility.debug    : Overlay structure tty_struct not present in vtypes
WARNING : volatility.debug    : Overlay structure sockaddr_un not present in vtypes
WARNING : volatility.debug    : Overlay structure net_device not present in vtypes
WARNING : volatility.debug    : Overlay structure in_ifaddr not present in vtypes
WARNING : volatility.debug    : Overlay structure tty_struct not present in vtypes
WARNING : volatility.debug    : Overlay structure sockaddr_un not present in vtypes
WARNING : volatility.debug    : Overlay structure net_device not present in vtypes
WARNING : volatility.debug    : Overlay structure in_ifaddr not present in vtypes
No suitable address space mapping found
Tried to open image as:
 MachOAddressSpace: mac: need base
 LimeAddressSpace: lime: need base
 WindowsHiberFileSpace32: No base Address Space
 WindowsCrashDumpSpace64BitMap: No base Address Space
 WindowsCrashDumpSpace64: No base Address Space
 HPAKAddressSpace: No base Address Space
 VMWareMetaAddressSpace: No base Address Space
 VirtualBoxCoreDumpElf64: No base Address Space
 QemuCoreDumpElf: No base Address Space
 VMWareAddressSpace: No base Address Space
 WindowsCrashDumpSpace32: No base Address Space
 SkipDuplicatesAMD64PagedMemory: No base Address Space
 WindowsAMD64PagedMemory: No base Address Space
 LinuxAMD64PagedMemory: No base Address Space
 AMD64PagedMemory: No base Address Space
 IA32PagedMemoryPae: No base Address Space
 IA32PagedMemory: No base Address Space
 OSXPmemELF: No base Address Space
 MachOAddressSpace: MachO Header signature invalid
 LimeAddressSpace: Invalid Lime header signature
 WindowsHiberFileSpace32: PO_MEMORY_IMAGE is not available in profile
 WindowsCrashDumpSpace64BitMap: Header signature invalid
 WindowsCrashDumpSpace64: Header signature invalid
 HPAKAddressSpace: Invalid magic found
 VMWareMetaAddressSpace: VMware metadata file is not available
 VirtualBoxCoreDumpElf64: ELF Header signature invalid
 QemuCoreDumpElf: ELF Header signature invalid
 VMWareAddressSpace: Invalid VMware signature: 0xea0003ff
 WindowsCrashDumpSpace32: Header signature invalid
 SkipDuplicatesAMD64PagedMemory: Incompatible profile LinuxuClinux_ARM_VersatilePBARM selected
 WindowsAMD64PagedMemory: Incompatible profile LinuxuClinux_ARM_VersatilePBARM selected
 LinuxAMD64PagedMemory: Incompatible profile LinuxuClinux_ARM_VersatilePBARM selected
 AMD64PagedMemory: Incompatible profile LinuxuClinux_ARM_VersatilePBARM selected
 IA32PagedMemoryPae - EXCEPTION: 'swapper_pg_dir'
 IA32PagedMemory - EXCEPTION: 'swapper_pg_dir'
 OSXPmemELF: ELF Header signature invalid
 FileAddressSpace: Must be first Address Space
 ArmAddressSpace - EXCEPTION: 'swapper_pg_dir'
```

# Some manual tests on our memory

The purpose is to see if:

* The accquired memory is corruptted or not.
* We can get any  information from the Non-MMU system
* We can implement lacking features for volatility based on the results of manual tests.

## 1. Convert dumped memory to physical raw:

```bash
$ volatility -f mem.dump --profile=LinuxuClinux_ARM_VersatilePBARM imagecopy -O converted.raw
```

## 2. Test: Kernel Identity Paging

(Ref: [BOOK] Page 607)

The method mentioned by the book is using `linux_volshell` plugin, but our profile is not working yet, so this module does not work consequently. However, we can do it manually by `hand` (means, by other linux `tradditional` tools).

The idea is: we try to locate data associated with the initial Linux process ("swapper") in physical memory. 

In order to do that, we first need to get the offset of the name member (`comm`) within the `task_struct`. Then we use this offset, plus the address of the process `init_task` that we can find in in `System.map` (and compute with architecture's shift, if neccessary) to find its physical address in memory. Finally, we read that address from the raw memory file, to see if it is actually the name ("swapper") or not.

### Get offset of the name member (`comm`) within `task_struct`

```bash
$ cd /path/to/uClinux/profile/dir
$ grep "<comm>" module.dwarf
<2><0xc3b><DW_TAG_member> DW_AT_name<comm> DW_AT_decl_file<0x00000021 /masked/sensitive/path/source/uClinux-dist/linux/include/linux/sched.h> DW_AT_decl_line<0x00000609> DW_AT_type<<0x00007b67>> DW_AT_data_member_location<632>
```

=> We noticed the last number: `DW_AT_data_member_location` equals to `632`. It is the offset of member `comm` within the struct `task_struct`.

### Find the `virtual address` of the process list head (init_task)

By looking in the System.map (the term `virtual address` may not be correct in this case: uClinux with No-MMU. However, this is how it be done in general cases).

```bash
$ grep -w init_task boot/System.map 
00321b28 D init_task
```

=> So, we know that the `init_task` process are located at the `virtual` address: `0x00321b28`

### Read the actual data in the raw memory

In general, we have to add the `architecture's identity-mapping shift` (`0xc0000000` in `32-bit` systems). However, we suppose in this case (uClinux without MMU), there is no such `shifting`. We can add the address found in the `System.map` directly with the physical offset, the result SHOULD be: the physical address of the name member (`comm`) within the struct `task_struct` in the raw memory.

#### 1. Firstly, calculate that address

```bash
$ python -c 'print (0x00321b28 + 632)'
3284384
```

#### 2. Then, read the raw memory directly.

```bash
$ xxd -s 3284384 -l 16 converted.raw 
00321da0: 7377 6170 7065 7200 0000 0000 0000 0000  swapper.........
```

=> We can confirm that the name of the `init_task` (initial Linux process) is: "swapper", exact as we expected.

## 3. Conclusion

* The System.map is actually has the `physical` addresses.
* We do not need to add `architecture's identity-mapping shift` when computing physical addresses.
* The volatility source code might need to be updated accordingly (for this case).
```
File: volatility/plugins/overlays/linux/linux.py 
Functions:
VolatilityLinuxIntelValidAS
VolatilityLinuxARMValidAS
```

# Some notes

### Save some configurations to a file to shorten the command we use

```
$ cat ~/.volatilityrc 
[DEFAULT]
PROFILE=LinuxuClinux_ARM_VersatilePBARM
LOCATION=file:////masked/sensitive/path/source/uClinux-dist/converted.raw
```

### Finding the kernel DTB

Source: volatility/plugins/overlays/linux/linux.py

Search for: `swapper_pg_dir` symbol (x86) or `init_level4_pgt` (x64).

What is the symbol for uClinux? => ???
(Ref: [BOOK] Page.608)

### Some working commands on 20171130

[[ Refer to the file here |working_commands_20171130.md]]
