* Systems need to build in local for LAB Environment.

#### Physcial Machines:

1. instructor.example.com               192.168.0.254

#### Virtual Machines:

2. node2.public.cluster1.example.com	172.16.0.1
3. node1.private.cluster1.example.com	172.17.0.1
4. node3.storage1.cluster1.example.com	172.18.0.1
5. node4.storage2.cluster1.example.com	172.19.0.1

---------------------------------------------------------

#### Instructor machine prerequeties:

* Physcial machine with i5 Processor, 32GB RAM, /root with 40GB space.
* Instructor machine (Physical Host) installed with Linux mint Qiana 17.
* KVM installed in Instructor machine, With Bridge.
* KVM holds 4 VMs which need for me to prepare for RH436.
* Instructor machine Supply local Yum repo (Centos6.5).
* 1 VM installed and configured with Ubuntu DNS Server for name resolving with 192.168.0.200.

---------------------------------------------------------

#### Setup the Instructor machine.

* Partition defined

```
NAME    MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda       8:0    0 298.1G  0 disk 
├─sda1    8:1    0   571M  0 part /boot
├─sda2    8:2    0  41.9G  0 part /
├─sda3    8:3    0   1.9G  0 part [SWAP]
├─sda4    8:4    0 188.5G  0 part /home
├─sda5    8:5    0     5G  0 part 
├─sda6    8:6    0     5G  0 part 
├─sda7    8:7    0     5G  0 part 
├─sda8    8:8    0     5G  0 part 
├─sda9    8:9    0     5G  0 part 
├─sda10   8:10   0     5G  0 part 
├─sda11   8:11   0     5G  0 part 
├─sda12   8:12   0     5G  0 part 
├─sda13   8:13   0     5G  0 part 
├─sda14   8:14   0     5G  0 part 
├─sda15   8:15   0     5G  0 part 
├─sda16 259:0    0     5G  0 part 
└─sda17 259:1    0   5.2G  0 part
```

From /dev/sda5 to /dev/sda10 assigned for VMs.

---------------------------------------------------------

#### Installing KVM.

```
# grep -Ec '(vmx|svm|lm)' /proc/cpuinfo

# grep -E --color=always '(vmx|svm|lm)' /proc/cpuinfo

# sudo apt get update && sudo apt-get upgrade -y 

# sudo apt-get install virt-manager -y

# sudo apt-get install qemu-kvm libvirt-bin ubuntu-vm-builder bridge-utils -y

# virt-manager
```

---------------------------------------------------------

#### Network setup.


* Router IP changed to 192.168.0.1
* Add all VMs ip to route from instructor machine (192.168.0.254)

```
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet manual

auto br0
iface br0 inet static
        address 192.168.0.254
	netmask 255.255.255.0
        network 192.168.0.0
	gateway 192.168.0.1
        broadcast 192.168.0.255
	dns-nameservers 192.168.0.100 192.168.0.200 192.168.0.1 8.8.8.8 8.8.4.4
        bridge_ports eth0
        bridge_stp off
        bridge_fd 0
        bridge_maxwait 0
	post-up route add -net 172.16.0.0 netmask 255.255.255.0 gw 192.168.0.254
	post-up route add -net 172.17.0.0 netmask 255.255.255.0 gw 192.168.0.254
	post-up route add -net 172.18.0.0 netmask 255.255.255.0 gw 192.168.0.254
	post-up route add -net 172.19.0.0 netmask 255.255.255.0 gw 192.168.0.254
```


Restart the network using 


```
# sudo ifdown eth0 && sudo ifup eth0
```

