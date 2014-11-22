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

---------------------------------------------------------

#### Yum repo setup.


* First copy the ISO files of RHEL6, RHEL7, Centos6, Centos7, Ubuntu-14 to /tmp and rename as centos65.iso, centos70.iso, rhel70.iso, ubuntu1404.iso
* Create a script using below command and run it to automate.


```
sudo mkdir -p /var/www/html/pub/rhel6

sudo mkdir -p /var/www/html/pub/rhel7

sudo mkdir -p /var/www/html/pub/centos6

sudo mkdir -p /var/www/html/pub/centos7

sudo mkdir -p /var/www/html/pub/ubuntu14

ls -l /var/www/html/pub/

sudo setfacl -m u:babinlonston:rwx /var/www

sudo service vsftpd restart

sudo service apache2 restart

sudo cp /tmp/rhel-ks.cfg /var/www/html/pub/

sudo chmod 644 /var/www/html/pub/rhel-ks.cfg

sudo cp /tmp/centos-ks.cfg /var/www/html/pub/

sudo chmod 644 /var/www/html/pub/centos-ks.cfg

sleep 1
 
sudo mount -t iso9660 -o loop /tmp/centos65.iso /mnt/

sleep 2

sudo cp -rav /mnt/* /var/www/html/pub/centos6/

sleep 2

sudo umount /mnt/

sleep 2

sudo mount -t iso9660 -o loop /tmp/centos70.iso /mnt/

sleep 2

sudo cp -rav /mnt/* /var/www/html/pub/centos7/

sleep 2

sudo umount /mnt

sleep 2

sudo mount -t iso9660 -o loop /tmp/rhel70.iso /mnt/

sleep 2

sudo cp -avr /mnt/* /var/www/html/pub/rhel7/

sleep 2

sudo umount /mnt

sleep 2

sudo mount -t iso9660 -o loop /tmp/ubuntu1404.iso /mnt/

sleep 2

sudo cp -avr /mnt/* /var/www/html/pub/ubuntu14/

sleep 2

sudo umount /mnt
```
