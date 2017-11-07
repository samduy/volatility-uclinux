# Manual

## Build uClinux kernel

### Download latest kernel

From: <https://sourceforge.net/projects/uclinux/files/uClinux%20Stable/dist-20160919/uClinux-dist-20160919.tar.bz2/download>

### Install toolchain and other tools

* Cross compiler
```bash
$ sudo apt-get install gcc-arm-linux-gnueabi
```

* Other dependency tools
```bash
$ sudo apt-get -y install libncurses5-dev bc lzop u-boot-tools
```

### Compile

```bash
$ make menuconfig
```

* Select a vendor profile (configuration file): we choose a board from `AcceleratedConcepts`.
  * Reason: it uses ARM architecture, that means we don't need to install other cross-compiler (like M68K, things will be more complicated).

```
vendors/AcceleratedConcepts/5300-DC/config.arch
```

* Save and Exit.

* Make (with Debug Information enabled: `CONFIG_DEBUG_INFO=y`)
```
$ make modules CONFIG_DEBUG_INFO=y M=$pwd
$ make -j 16 CONFIG_DEBUG_INFO=y M=$pwd
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

# volatility-uclinux
Volatility profile for uclinux
