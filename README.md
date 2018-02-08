# volatility-uclinux

Volatility profile for uclinux

# Manual

## Build uClinux kernel

Please refer to the Wiki page: [Build a uClinux kernel](../../wiki/Build-a-uClinux-kernel) for more detail.

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

(This part was moved to the Wiki page: [Manual memory inspection](../../wiki/Manual-memory-inspection))

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

Here: [working_commands_20171130.md](./working_commands_20171130.md)

### Working wirh Volatility Shell

* Start the interactive shell
```
$ python vol.py linux_volshell
```

* Get the profile
```python
In [1]: p = addrspace().profile
```

* Get the mapping table
```python
In [2]: tbl = p.sys_map["kernel"]
```

* Get any symbol
```python
In [3]: p.get_symbol("<symbol_name>")
```

E.g.
```python
In [3]: p.get_symbol("timekeeper")
```

* Get information of the profile
```ipython
In [7]: p.metadata
Out[7]: {'arch': 'ARM', 'memory_model': '32bit', 'os': 'linux'}
```

* View all vtypes exist in the profile
```ipython
In []: p.vtypes
```
