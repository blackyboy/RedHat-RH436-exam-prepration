;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     example.com. root.db.example.com. (
                     2014112301         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      ns.example.com.
ns      IN      A       192.168.0.200

node2.public.cluster1     IN      A       172.16.0.1
node1.private.cluster1    IN      A       172.17.0.1
node3.storage1.cluster1   IN      A       172.18.0.1
node4.storage2.cluster1	  IN	  A	  172.19.0.1
