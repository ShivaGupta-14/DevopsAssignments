# Network Fundamentals Assignment

Below is each networking command, its output, and what I understood from it.

## 1. ip addr show

Shows all the network interfaces of the machine with their IP addresses and MAC addresses.

```
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host noprefixroute 
       valid_lft forever preferred_lft forever
2: enp0s1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 52:54:00:c8:d1:c0 brd ff:ff:ff:ff:ff:ff
    inet 192.168.252.2/24 metric 100 brd 192.168.252.255 scope global dynamic enp0s1
       valid_lft 3423sec preferred_lft 3423sec
    inet6 fd06:d551:66b5:703c:5054:ff:fec8:d1c0/64 scope global dynamic mngtmpaddr noprefixroute 
       valid_lft 2591962sec preferred_lft 604762sec
    inet6 fe80::5054:ff:fec8:d1c0/64 scope link 
       valid_lft forever preferred_lft forever
```

There are two interfaces here. lo is the loopback interface with IP 127.0.0.1 and it is used by the machine to talk to itself. enp0s1 is the real network interface and its IP is 192.168.252.2. The /24 means the first 24 bits are the network part, so the subnet mask is 255.255.255.0. The line link/ether shows the MAC address which is the hardware address of the card. UP means the interface is working.

## 2. ip -br addr

Shows the same information in a short form.

```
lo               UNKNOWN        127.0.0.1/8 ::1/128 
enp0s1           UP             192.168.252.2/24 metric 100 fd06:d551:66b5:703c:5054:ff:fec8:d1c0/64 fe80::5054:ff:fec8:d1c0/64 
```

The -br option means brief. It gives only the interface name, its state and its IP, so it is easier to read when we only want to check the IP quickly.

## 3. hostname -I

Prints only the IP addresses of the machine.

```
192.168.252.2 fd06:d551:66b5:703c:5054:ff:fec8:d1c0 
```

This is the fastest way to get the IP without reading the full output of ip addr.

## 4. Public IP vs Private IP

```
$ curl ifconfig.me
49.36.xxx.xxx
```

My machine IP is 192.168.252.2 but the internet sees a different IP. This is the difference between private and public IP.

A private IP is used inside a local network and it cannot be reached directly from the internet. The private ranges are 10.0.0.0/8, 172.16.0.0/12 and 192.168.0.0/16. My IP 192.168.252.2 falls in the private range.

A public IP is given by the ISP and it is unique on the internet. When my machine sends a request, the router replaces my private IP with the public IP. This is called NAT, Network Address Translation. That is why many devices in one home can share a single public IP.

## 5. ip route

Shows the routing table of the machine.

```
default via 192.168.252.1 dev enp0s1 proto dhcp src 192.168.252.2 metric 100 
192.168.252.0/24 dev enp0s1 proto kernel scope link src 192.168.252.2 metric 100 
192.168.252.1 dev enp0s1 proto dhcp scope link src 192.168.252.2 metric 100 
```

The first line is the default route. It means if the destination is not in my own network then send the packet to 192.168.252.1, which is my gateway or router. The second line says the network 192.168.252.0/24 is directly connected, so packets for that range do not need the gateway.

## 6. ping

Checks if a host is reachable and how much time the reply takes.

```
PING google.com (192.178.158.113) 56(84) bytes of data.
64 bytes from lcdels-in-f113.1e100.net (192.178.158.113): icmp_seq=1 ttl=101 time=37.7 ms
64 bytes from lcdels-in-f113.1e100.net (192.178.158.113): icmp_seq=2 ttl=101 time=37.3 ms
64 bytes from lcdels-in-f113.1e100.net (192.178.158.113): icmp_seq=3 ttl=101 time=36.8 ms
64 bytes from lcdels-in-f113.1e100.net (192.178.158.113): icmp_seq=4 ttl=101 time=42.6 ms

--- google.com ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3135ms
rtt min/avg/max/mdev = 36.777/38.594/42.614/2.344 ms
```

ping uses the ICMP protocol. The -c 4 option sends only 4 packets. The time value is the round trip time, so 37 ms means the packet went and came back in 37 milliseconds. 0% packet loss means the connection is good. ttl is time to live and it reduces by one at every router, so it also tells roughly how many routers the packet crossed.

## 7. nslookup

Finds the IP address of a domain name using DNS.

```
Server:		127.0.0.53
Address:	127.0.0.53#53

Non-authoritative answer:
Name:	google.com
Address: 192.178.158.102
Name:	google.com
Address: 192.178.158.113
Name:	google.com
Address: 192.178.158.101
Name:	google.com
Address: 192.178.158.139
Name:	google.com
Address: 192.178.158.138
Name:	google.com
Address: 192.178.158.100
Name:	google.com
Address: 2404:6800:4002:81d::200e
```

DNS is the system that converts a domain name into an IP address, because computers can only talk using IP. The Server line shows which DNS server answered, here it is 127.0.0.53 which is the local systemd-resolved service running on port 53. Non-authoritative answer means the reply came from a cache and not from the main server of that domain. google.com gives many IPs because big websites use many servers for load balancing.

## 8. dig

Another DNS tool which gives more detail than nslookup.

```
$ dig google.com +short
192.178.158.138
192.178.158.100
192.178.158.139
192.178.158.102
192.178.158.113
192.178.158.101
```

The +short option prints only the IP addresses. Without it, dig shows the full DNS response with the question section, answer section and the query time.

## 9. traceroute

Shows the path a packet takes to reach the destination.

```
traceroute to google.com (192.178.158.113), 12 hops max, 60 byte packets
 1  _gateway (192.168.252.1)  0.416 ms  0.778 ms  0.456 ms
 2  reliance.reliance (192.168.29.1)  12.969 ms  12.959 ms  12.950 ms
 3  10.134.232.1 (10.134.232.1)  14.873 ms  14.867 ms  14.861 ms
 4  172.16.28.5 (172.16.28.5)  14.854 ms  17.532 ms  18.787 ms
 5  192.168.97.32 (192.168.97.32)  18.781 ms 192.168.97.36 (192.168.97.36)  18.775 ms 192.168.97.32 (192.168.97.32)  18.769 ms
 6  172.26.109.116 (172.26.109.116)  18.761 ms  7.404 ms  5.880 ms
 7  172.26.109.98 (172.26.109.98)  7.097 ms  10.256 ms  10.250 ms
 8  192.168.41.76 (192.168.41.76)  10.244 ms 192.168.41.72 (192.168.41.72)  10.239 ms 192.168.41.70 (192.168.41.70)  10.231 ms
 9  * * *
10  * * *
11  * * *
12  * * *
```

Every line is one router, called a hop. Hop 1 is my own gateway, hop 2 is my ISP router and after that the packet goes through the ISP network. Three time values are shown because it sends three packets to each hop. The stars mean that router did not reply, which normally happens when a router or firewall is set to ignore these packets. traceroute is useful to find where a connection is getting slow or getting blocked.

## 10. ss -tuln

Shows the ports which are open and listening on the machine.

```
Netid State  Recv-Q Send-Q                    Local Address:Port Peer Address:PortProcess
udp   UNCONN 0      0                            127.0.0.54:53        0.0.0.0:*          
udp   UNCONN 0      0                         127.0.0.53%lo:53        0.0.0.0:*          
udp   UNCONN 0      0                  192.168.252.2%enp0s1:68        0.0.0.0:*          
udp   UNCONN 0      0      [fe80::5054:ff:fec8:d1c0]%enp0s1:546          [::]:*          
tcp   LISTEN 0      4096                            0.0.0.0:22        0.0.0.0:*          
tcp   LISTEN 0      4096                      127.0.0.53%lo:53        0.0.0.0:*          
tcp   LISTEN 0      4096                         127.0.0.54:53        0.0.0.0:*          
tcp   LISTEN 0      4096                               [::]:22           [::]:*          
```

The options mean t for TCP, u for UDP, l for listening and n for numeric so it shows port numbers instead of names.

A port is a number which tells which service the data is for. One machine has one IP but many services, so the port decides which service will receive the packet. Here port 22 is SSH and port 53 is DNS. The address 0.0.0.0:22 means SSH is listening on all the interfaces of the machine.

Some common ports are 22 for SSH, 53 for DNS, 80 for HTTP, 443 for HTTPS, 3306 for MySQL and 3000 for a Node application.

## 11. netstat -tuln

Gives the same information as ss.

```
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State      
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN     
tcp        0      0 127.0.0.53:53           0.0.0.0:*               LISTEN     
tcp        0      0 127.0.0.54:53           0.0.0.0:*               LISTEN     
tcp6       0      0 :::22                   :::*                    LISTEN     
udp        0      0 127.0.0.54:53           0.0.0.0:*                          
udp        0      0 127.0.0.53:53           0.0.0.0:*                          
udp        0      0 192.168.252.2:68        0.0.0.0:*                          
udp6       0      0 fe80::5054:ff:fec8::546 :::*                               
```

netstat is the older command and ss is the newer one. ss is faster because it reads the information directly from the kernel. On new systems ss is preferred but netstat is still used a lot.

## 12. TCP vs UDP

In the output above some lines say tcp and some say udp. These are the two transport protocols.

TCP makes a connection first using a three way handshake, then sends the data. It checks that every packet reached and resends the lost packets, and it keeps the packets in correct order. So it is reliable but a little slow. It is used for SSH, HTTP, HTTPS and databases.

UDP does not make any connection and does not check anything. It just sends the packet. So it is fast but not reliable. It is used for DNS, video streaming and online games where a small loss does not matter much.

In my output DNS is on both tcp and udp because DNS normally uses UDP but switches to TCP when the reply is too big.

## 13. curl -I

Sends an HTTP request and shows only the response headers.

```
$ curl -I https://github.com
HTTP/2 200 
date: Thu, 03 Sep 2026 16:51:46 GMT
content-type: text/html; charset=utf-8
content-language: en-US
vary: X-PJAX, X-PJAX-Container, Turbo-Visit, Turbo-Frame, X-Requested-With, X-GitHub-Client-Version, Accept-Language, Sec-Fetch-Site,Accept-Encoding, Accept, X-Requested-With
etag: W/"4e180fdf44f68db2a6e56363b91cabf3"
cache-control: max-age=0, private, must-revalidate
strict-transport-security: max-age=31536000; includeSubdomains; preload
x-frame-options: deny
x-content-type-options: nosniff
x-xss-protection: 0
referrer-policy: origin-when-cross-origin, strict-origin-when-cross-origin
```

The -I option asks only for the headers and not the full page. HTTP/2 200 means the request was successful, 200 is the status code for OK. Other common codes are 301 for redirect, 404 for not found and 500 for server error.

HTTP works on port 80 and the data goes as plain text, so anyone in between can read it. HTTPS works on port 443 and the data is encrypted using TLS, so it cannot be read in between. The header strict-transport-security tells the browser to always use HTTPS for this site.

## 14. nc -zv

Checks whether a particular port of a server is open.

```
$ nc -zv google.com 443
Connection to google.com (192.178.158.138) 443 port [tcp/https] succeeded!

$ nc -zv google.com 80
Connection to google.com (192.178.158.138) 80 port [tcp/http] succeeded!
```

The -z option means only scan the port and do not send any data, and -v means verbose so it prints the result. Both ports are open on google.com. This command is useful to check if a service is reachable, for example when a website is not opening we can first check whether port 443 is open or blocked.

## What I understood overall

Every machine has a private IP inside its own network and the router converts it into one public IP for the internet using NAT. To reach any website the machine first asks DNS for the IP, then sends the packet to the default gateway, and from there it travels through many routers till it reaches the server. The port number decides which service on that server will handle the request. TCP is used when the data must reach correctly and UDP is used when speed matters more.

For checking these things, ip addr and ip route show my own network setting, ping and traceroute check the path and the reachability, nslookup and dig check the DNS, ss and netstat show my open ports, and curl and nc check whether a remote service is actually working.
