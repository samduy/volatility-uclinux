#### `linux_pstree` (the first one that works, without modification)

```
$ volatility linux_pstree
Volatility Foundation Volatility Framework 2.6
WARNING : volatility.debug    : Overlay structure tty_struct not present in vtypes
WARNING : volatility.debug    : Overlay structure sockaddr_un not present in vtypes
WARNING : volatility.debug    : Overlay structure net_device not present in vtypes
WARNING : volatility.debug    : Overlay structure in_ifaddr not present in vtypes
Name                 Pid             Uid            
WARNING : volatility.debug    : Overlay structure tty_struct not present in vtypes
WARNING : volatility.debug    : Overlay structure sockaddr_un not present in vtypes
WARNING : volatility.debug    : Overlay structure net_device not present in vtypes
WARNING : volatility.debug    : Overlay structure in_ifaddr not present in vtypes
init                 1                              
.dhcpcd              41                             
.sh                  42                             
.inetd               43                             
kthreadd             2                              
.ksoftirqd/0         3                              
.kworker/0:0         4                              
.kworker/0:0H        5                              
.kworker/u2:0        6                              
.netns               7                              
.writeback           8                              
.crypto              9                              
.bioset              10                             
.kblockd             11                             
.kworker/0:1         12                             
.kswapd0             13                             
.fsnotify_mark       14                             
.bioset              20                             
.bioset              21                             
.bioset              22                             
.bioset              23                             
.bioset              24                             
.bioset              25                             
.bioset              26                             
.bioset              27                             
.bioset              28                             
.bioset              29                             
.bioset              30                             
.bioset              31                             
.bioset              32                             
.bioset              33                             
.bioset              34                             
.bioset              35                             
.deferwq             36                             
.kworker/u2:1        37
```

#### `linux_pslist` (with some modification)

```
$ volatility linux_pslist
Volatility Foundation Volatility Framework 2.6
WARNING : volatility.debug    : Overlay structure tty_struct not present in vtypes
WARNING : volatility.debug    : Overlay structure sockaddr_un not present in vtypes
WARNING : volatility.debug    : Overlay structure net_device not present in vtypes
WARNING : volatility.debug    : Overlay structure in_ifaddr not present in vtypes
WARNING : volatility.debug    : Overlay structure tty_struct not present in vtypes
WARNING : volatility.debug    : Overlay structure sockaddr_un not present in vtypes
WARNING : volatility.debug    : Overlay structure net_device not present in vtypes
WARNING : volatility.debug    : Overlay structure in_ifaddr not present in vtypes
Offset     Name                 Pid             PPid            Uid             Gid    DTB        Start Time
---------- -------------------- --------------- --------------- --------------- ------ ---------- ----------
0x0781baa0 init                 1               0               0               0      0x00000000 -
0x0781b720 kthreadd             2               0               0               0      0xea000487 -
0x0781b3a0 ksoftirqd/0          3               2               0               0      0xea000487 -
0x0781b020 kworker/0:0          4               2               0               0      0xea000487 -
0x07829ac0 kworker/0:0H         5               2               0               0      0xea000487 -
0x07829740 kworker/u2:0         6               2               0               0      0xea000487 -
0x078293c0 netns                7               2               0               0      0xea000487 -
0x07829040 writeback            8               2               0               0      0xea000487 -
0x07852ae0 crypto               9               2               0               0      0xea000487 -
0x07852760 bioset               10              2               0               0      0xea000487 -
0x078523e0 kblockd              11              2               0               0      0xea000487 -
0x07852060 kworker/0:1          12              2               0               0      0xea000487 -
0x0796ab00 kswapd0              13              2               0               0      0xea000487 -
0x0796a780 fsnotify_mark        14              2               0               0      0xea000487 -
0x0796a400 bioset               20              2               0               0      0xea000487 -
0x0796a080 bioset               21              2               0               0      0xea000487 -
0x079a9b20 bioset               22              2               0               0      0xea000487 -
0x079a97a0 bioset               23              2               0               0      0xea000487 -
0x079a9420 bioset               24              2               0               0      0xea000487 -
0x079a90a0 bioset               25              2               0               0      0xea000487 -
0x079c0b40 bioset               26              2               0               0      0xea000487 -
0x079c07c0 bioset               27              2               0               0      0xea000487 -
0x079c0440 bioset               28              2               0               0      0xea000487 -
0x079c00c0 bioset               29              2               0               0      0xea000487 -
0x079cdb60 bioset               30              2               0               0      0xea000487 -
0x079cd7e0 bioset               31              2               0               0      0xea000487 -
0x079cd460 bioset               32              2               0               0      0xea000487 -
0x079cd0e0 bioset               33              2               0               0      0xea000487 -
0x079f4b80 bioset               34              2               0               0      0xea000487 -
0x079f4800 bioset               35              2               0               0      0xea000487 -
0x079f4480 deferwq              36              2               0               0      0xea000487 -
0x079f4100 kworker/u2:1         37              2               0               0      0xea000487 -
0x07a21820 dhcpcd               41              1               0               0      0x00000000 -
0x07a214a0 sh                   42              1               0               0      0x00000000 -
0x07a21ba0 inetd                43              1               0               0      0x00000000 -
```

#### `linux_pidhashtable`

```
$ volatility linux_pidhashtable
Volatility Foundation Volatility Framework 2.6
WARNING : volatility.debug    : Overlay structure tty_struct not present in vtypes
WARNING : volatility.debug    : Overlay structure sockaddr_un not present in vtypes
WARNING : volatility.debug    : Overlay structure net_device not present in vtypes
WARNING : volatility.debug    : Overlay structure in_ifaddr not present in vtypes
WARNING : volatility.debug    : Overlay structure tty_struct not present in vtypes
WARNING : volatility.debug    : Overlay structure sockaddr_un not present in vtypes
WARNING : volatility.debug    : Overlay structure net_device not present in vtypes
WARNING : volatility.debug    : Overlay structure in_ifaddr not present in vtypes
Offset     Name                 Pid             PPid            Uid             Gid    DTB        Start Time
---------- -------------------- --------------- --------------- --------------- ------ ---------- ----------
0x078523e0 kblockd              11              2               0               0      0xea000487 -
0x079a9420 bioset               24              2               0               0      0xea000487 -
0x0781b3a0 ksoftirqd/0          3               2               0               0      0xea000487 -
0x079f4100 kworker/u2:1         37              2               0               0      0xea000487 -
0x079c00c0 bioset               29              2               0               0      0xea000487 -
0x07829040 writeback            8               2               0               0      0xea000487 -
0x07a214a0 sh                   42              1               0               0      0x00000000 -
0x0796a080 bioset               21              2               0               0      0xea000487 -
0x079f4b80 bioset               34              2               0               0      0xea000487 -
0x0796ab00 kswapd0              13              2               0               0      0xea000487 -
0x079c0b40 bioset               26              2               0               0      0xea000487 -
0x07829ac0 kworker/0:0H         5               2               0               0      0xea000487 -
0x079cd7e0 bioset               31              2               0               0      0xea000487 -
0x07852760 bioset               10              2               0               0      0xea000487 -
0x079a97a0 bioset               23              2               0               0      0xea000487 -
0x0781b720 kthreadd             2               0               0               0      0xea000487 -
0x079f4480 deferwq              36              2               0               0      0xea000487 -
0x079c0440 bioset               28              2               0               0      0xea000487 -
0x078293c0 netns                7               2               0               0      0xea000487 -
0x07a21820 dhcpcd               41              1               0               0      0x00000000 -
0x0796a400 bioset               20              2               0               0      0xea000487 -
0x079cd0e0 bioset               33              2               0               0      0xea000487 -
0x07852060 kworker/0:1          12              2               0               0      0xea000487 -
0x079a90a0 bioset               25              2               0               0      0xea000487 -
0x0781b020 kworker/0:0          4               2               0               0      0xea000487 -
0x079cdb60 bioset               30              2               0               0      0xea000487 -
0x07852ae0 crypto               9               2               0               0      0xea000487 -
0x07a21ba0 inetd                43              1               0               0      0x00000000 -
0x079a9b20 bioset               22              2               0               0      0xea000487 -
0x0781baa0 init                 1               0               0               0      0x00000000 -
0x079f4800 bioset               35              2               0               0      0xea000487 -
0x0796a780 fsnotify_mark        14              2               0               0      0xea000487 -
0x079c07c0 bioset               27              2               0               0      0xea000487 -
0x07829740 kworker/u2:0         6               2               0               0      0xea000487 -
0x079cd460 bioset               32              2               0               0      0xea000487 -
```

#### `linux_psaux`

Gathers processes along with full command line and start time. (start time doesn't work yet).

```
$ # volatility linux_psaux
Volatility Foundation Volatility Framework 2.6
WARNING : volatility.debug    : Overlay structure tty_struct not present in vtypes
WARNING : volatility.debug    : Overlay structure sockaddr_un not present in vtypes
WARNING : volatility.debug    : Overlay structure net_device not present in vtypes
WARNING : volatility.debug    : Overlay structure in_ifaddr not present in vtypes
Pid    Uid    Gid    Arguments                                                       
WARNING : volatility.debug    : Overlay structure tty_struct not present in vtypes
WARNING : volatility.debug    : Overlay structure sockaddr_un not present in vtypes
WARNING : volatility.debug    : Overlay structure net_device not present in vtypes
WARNING : volatility.debug    : Overlay structure in_ifaddr not present in vtypes
1      0      0      /init                                                           
2      0      0                                                                      
3      0      0                                                                      
4      0      0                                                                      
5      0      0                                                                      
6      0      0                                                                      
7      0      0                                                                      
8      0      0                                                                      
9      0      0                                                                      
10     0      0                                                                      
11     0      0                                                                      
12     0      0                                                                      
13     0      0                                                                      
14     0      0                                                                      
20     0      0                                                                      
21     0      0                                                                      
22     0      0                                                                      
23     0      0                                                                      
24     0      0                                                                      
25     0      0                                                                      
26     0      0                                                                      
27     0      0                                                                      
28     0      0                                                                      
29     0      0                                                                      
30     0      0                                                                      
31     0      0                                                                      
32     0      0                                                                      
33     0      0                                                                      
34     0      0                                                                      
35     0      0                                                                      
36     0      0                                                                      
37     0      0                                                                      
41     0      0      dhcpcd -p -a eth0                                               
42     0      0      -/bin/sh                                                        
43     0      0      /bin/inetd 
```

#### `linux_psenv`

Gathers processes along with their static environment variables

```
$ volatility linux_psenv
Volatility Foundation Volatility Framework 2.6
WARNING : volatility.debug    : Overlay structure tty_struct not present in vtypes
WARNING : volatility.debug    : Overlay structure sockaddr_un not present in vtypes
WARNING : volatility.debug    : Overlay structure net_device not present in vtypes
WARNING : volatility.debug    : Overlay structure in_ifaddr not present in vtypes
Name   Pid    Environment 
WARNING : volatility.debug    : Overlay structure tty_struct not present in vtypes
WARNING : volatility.debug    : Overlay structure sockaddr_un not present in vtypes
WARNING : volatility.debug    : Overlay structure net_device not present in vtypes
WARNING : volatility.debug    : Overlay structure in_ifaddr not present in vtypes
init              1      HOME=/ TERM=linux
kthreadd          2      
ksoftirqd/0       3      
kworker/0:0       4      
kworker/0:0H      5      
kworker/u2:0      6      
netns             7      
writeback         8      
crypto            9      
bioset            10     
kblockd           11     
kworker/0:1       12     
kswapd0           13     
fsnotify_mark     14     
bioset            20     
bioset            21     
bioset            22     
bioset            23     
bioset            24     
bioset            25     
bioset            26     
bioset            27     
bioset            28     
bioset            29     
bioset            30     
bioset            31     
bioset            32     
bioset            33     
bioset            34     
bioset            35     
deferwq           36     
kworker/u2:1      37     
dhcpcd            41     PATH=/bin:/usr/bin:/etc:/sbin:/usr/sbin ?=0
sh                42     TERM=linux PATH=/bin:/usr/bin:/etc:/sbin:/usr/sbin
inetd             43     TERM=unknown PATH=/bin:/usr/bin:/etc:/sbin:/usr/sbin
```

#### `linux_psscan`

Scan physical memory for processes.

```
$ volatility linux_psscan
Volatility Foundation Volatility Framework 2.6
WARNING : volatility.debug    : Overlay structure tty_struct not present in vtypes
WARNING : volatility.debug    : Overlay structure sockaddr_un not present in vtypes
WARNING : volatility.debug    : Overlay structure net_device not present in vtypes
WARNING : volatility.debug    : Overlay structure in_ifaddr not present in vtypes
WARNING : volatility.debug    : Overlay structure tty_struct not present in vtypes
WARNING : volatility.debug    : Overlay structure sockaddr_un not present in vtypes
WARNING : volatility.debug    : Overlay structure net_device not present in vtypes
WARNING : volatility.debug    : Overlay structure in_ifaddr not present in vtypes
Offset     Name                 Pid             PPid            Uid             Gid    DTB        Start Time
---------- -------------------- --------------- --------------- --------------- ------ ---------- ----------
0x00201dec                      116             -20836767       -               -      0xea000487 -
0x0781b020 kworker/0:0          4               2               0               0      0xea000487 -
0x0781b3a0 ksoftirqd/0          3               2               0               0      0xea000487 -
0x0781b720 kthreadd             2               0               0               0      0xea000487 -
0x0781baa0 init                 1               0               0               0      0x00000000 -
0x07829040 writeback            8               2               0               0      0xea000487 -
0x078293c0 netns                7               2               0               0      0xea000487 -
0x07829740 kworker/u2:0         6               2               0               0      0xea000487 -
0x07829ac0 kworker/0:0H         5               2               0               0      0xea000487 -
0x07852060 kworker/0:1          12              2               0               0      0xea000487 -
0x078523e0 kblockd              11              2               0               0      0xea000487 -
0x07852760 bioset               10              2               0               0      0xea000487 -
0x07852ae0 crypto               9               2               0               0      0xea000487 -
0x0796a080 bioset               21              2               0               0      0xea000487 -
0x0796a400 bioset               20              2               0               0      0xea000487 -
0x0796a780 fsnotify_mark        14              2               0               0      0xea000487 -
0x0796ab00 kswapd0              13              2               0               0      0xea000487 -
0x079a90a0 bioset               25              2               0               0      0xea000487 -
0x079a9420 bioset               24              2               0               0      0xea000487 -
0x079a97a0 bioset               23              2               0               0      0xea000487 -
0x079a9b20 bioset               22              2               0               0      0xea000487 -
0x079c00c0 bioset               29              2               0               0      0xea000487 -
0x079c0440 bioset               28              2               0               0      0xea000487 -
0x079c07c0 bioset               27              2               0               0      0xea000487 -
0x079c0b40 bioset               26              2               0               0      0xea000487 -
0x079cd0e0 bioset               33              2               0               0      0xea000487 -
0x079cd460 bioset               32              2               0               0      0xea000487 -
0x079cd7e0 bioset               31              2               0               0      0xea000487 -
0x079cdb60 bioset               30              2               0               0      0xea000487 -
0x079f4100 kworker/u2:1         37              2               0               0      0xea000487 -
0x079f4480 deferwq              36              2               0               0      0xea000487 -
0x079f4800 bioset               35              2               0               0      0xea000487 -
0x079f4b80 bioset               34              2               0               0      0xea000487 -
0x07a21120 sh                   45              42              -               -      0xea000487 -
0x07a214a0 sh                   42              1               0               0      0x00000000 -
0x07a21820 dhcpcd               41              1               0               0      0x00000000 -
0x07a21ba0 inetd                43              1               0               0      0x00000000 -
```

#### `linux_psxview`

Find hidden processes with various process listings.

```
$ volatility linux_psxview
Volatility Foundation Volatility Framework 2.6
WARNING : volatility.debug    : Overlay structure tty_struct not present in vtypes
WARNING : volatility.debug    : Overlay structure sockaddr_un not present in vtypes
WARNING : volatility.debug    : Overlay structure net_device not present in vtypes
WARNING : volatility.debug    : Overlay structure in_ifaddr not present in vtypes
WARNING : volatility.debug    : Overlay structure tty_struct not present in vtypes
WARNING : volatility.debug    : Overlay structure sockaddr_un not present in vtypes
WARNING : volatility.debug    : Overlay structure net_device not present in vtypes
WARNING : volatility.debug    : Overlay structure in_ifaddr not present in vtypes
Offset(V)  Name                    PID pslist psscan pid_hash kmem_cache parents leaders
---------- -------------------- ------ ------ ------ -------- ---------- ------- -------
INFO    : volatility.debug    : SLUB is currently unsupported.
0x078523e0 kblockd                  11 True   True   True     False      False   True   
0x079a9420 bioset                   24 True   True   True     False      False   True   
0x0781b3a0 ksoftirqd/0               3 True   True   True     False      False   True   
0x079f4100 kworker/u2:1             37 True   True   True     False      False   True   
0x079c00c0 bioset                   29 True   True   True     False      False   True   
0x07829040 writeback                 8 True   True   True     False      False   True   
0x07a214a0 sh                       42 True   True   True     False      False   True   
0x0796a080 bioset                   21 True   True   True     False      False   True   
0x079f4b80 bioset                   34 True   True   True     False      False   True   
0x0796ab00 kswapd0                  13 True   True   True     False      False   True   
0x079c0b40 bioset                   26 True   True   True     False      False   True   
0x07829ac0 kworker/0:0H              5 True   True   True     False      False   True   
0x079cd7e0 bioset                   31 True   True   True     False      False   True   
0x07852760 bioset                   10 True   True   True     False      False   True   
0x079a97a0 bioset                   23 True   True   True     False      False   True   
0x0781b720 kthreadd                  2 True   True   True     False      True    True   
0x079f4480 deferwq                  36 True   True   True     False      False   True   
0x079c0440 bioset                   28 True   True   True     False      False   True   
0x078293c0 netns                     7 True   True   True     False      False   True   
0x07a21820 dhcpcd                   41 True   True   True     False      False   True   
0x0796a400 bioset                   20 True   True   True     False      False   True   
0x079cd0e0 bioset                   33 True   True   True     False      False   True   
0x07852060 kworker/0:1              12 True   True   True     False      False   True   
0x079a90a0 bioset                   25 True   True   True     False      False   True   
0x0781b020 kworker/0:0               4 True   True   True     False      False   True   
0x079cdb60 bioset                   30 True   True   True     False      False   True   
0x07852ae0 crypto                    9 True   True   True     False      False   True   
0x07a21ba0 inetd                    43 True   True   True     False      False   True   
0x079a9b20 bioset                   22 True   True   True     False      False   True   
0x0781baa0 init                      1 True   True   True     False      True    True   
0x079f4800 bioset                   35 True   True   True     False      False   True   
0x0796a780 fsnotify_mark            14 True   True   True     False      False   True   
0x079c07c0 bioset                   27 True   True   True     False      False   True   
0x07829740 kworker/u2:0              6 True   True   True     False      False   True   
0x079cd460 bioset                   32 True   True   True     False      False   True   
0x00321b28 swapper                   0 False  False  False    False      True    False  
0x00201dec                         116 False  True   False    False      False   False  
0x07a21120 sh                       45 False  True   False    False      False   False
```
