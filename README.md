# volatility-uclinux

This project aims to create a profile and some other modification on Volatility so that it can conduct some memory forensics on the memory that obtained from a uClinux system.

# Instructions

## Download the patches (this project)
```
$ git clone https://github.com/samduy/volatility-uclinux.git
```

* All the patches are located in a `volatility-patches/<date>` directory.
* Ready made profiles are at: `profiles` folder.
* Sample memories (for testing) are located in `sample_memories` directory.

## Download the Volatility

```
$ git clone https://github.com/volatilityfoundation/volatility.git
$ cd volatility
$ git checkout f3c9dfee -b uclinux
```
(The modifications are based on the above commit:`f3c9dfee`. However, it's expected to run even with the latest commit.)

## Apply the patches

* First, take a look at what changes are in the patch:
```
$ git apply --stat path/to/volatility-uclinux/volatility-patches/20180214/all_in_one_20180214.patch
```

* To see if there is any conflicts or errors:
```
$ git apply --check path/to/volatility-uclinux/volatility-patches/20180214/all_in_one_20180214.patch
```

* To actually apply the patch:
```
$ git am --signoff path/to/volatility-uclinux/volatility-patches/20180214/all_in_one_20180214.patch
```

(The reason for this is that `git am` allows you to sign off an applied patch. This may be useful for later reference.)

## Load the uClinux profile to Volatility

```bash
$ cd /path/to/volatility
$ cp /path/to/volatility-uclinux/profiles/uClinux_VersatilePB.zip plugins/overlays/linux/
```

### Testing if the profile is loaded properly

```bash
$ cd path/to/volatility
$ python vol.py --info | grep uClinux
Volatility Foundation Volatility Framework 2.6
LinuxuClinux_VersatilePBARM - A Profile for Linux uClinux_VersatilePB ARM
```

Now Volatility should be ready to run with uClinux memory dumps. Let's check it out!

## Testing

### Unzip the sample memory

```
$ cp path/to/volatility-uclinux/sample_memories/mem2.dump.bz2 /tmp/
$ cd /tmp/
$ bzip2 -d mem2.dump.bz2
```

### Run some commands on the sample memory

```
$ cd path/to/volatility
$ python vol.py --profile=LinuxuClinux_VersatilePBARM -f /tmp/mem2.dump linux_pslist
```

For more information on the commands that work with uClinux, please refer to:
* [Some working_commands_20171130.md](./working_commands_20171130.md)

## Some useful information

* [Build a uClinux kernel](../../wiki/Build-a-uClinux-kernel) for more detail.
* [Make a uClinux profile for Volatility](../../wiki/Profile-for-Volatility) for more detail.
* [Some manual memory inspection](../../wiki/Manual-memory-inspection)
* [Working with Volatility Shell](../../wiki/Working-with-Volatility-shell)
