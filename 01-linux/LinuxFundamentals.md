# Linux Fundamentals Assignment

## Task 1: Soft Link and Hard Link

### What is an inode

In Linux a file is stored as an inode. The inode holds the actual data and the details like size, owner and permissions. The file name is only an entry in a directory which points to this inode.

### Hard Link

A hard link is another name for the same inode. Both names point to the same data so there is no original and no copy, both are same. The inode keeps a count of how many names are pointing to it and the data is removed only when this count becomes zero.

### Soft Link

A soft link is a new file with its own inode. Inside it only the path of the target file is stored, so it works like a shortcut. If the target file is deleted the soft link still exists but points to nothing, which is called a broken link.

### Difference

| Point | Hard Link | Soft Link |
|---|---|---|
| Inode | Same as target | Its own inode |
| Different filesystem | Not allowed | Allowed |
| Link to directory | Not allowed | Allowed |
| If target is deleted | Still works | Becomes broken |
| Size | Same as target | Size of the stored path |

Hard link does not work across filesystems because inode numbers are unique only inside one filesystem. Hard link to a directory is not allowed because it can create a loop in the directory tree.

### Commands

```bash
ln original.txt hard.txt      # create hard link
ln -s original.txt soft.txt   # create soft link
ls -li                        # -i shows the inode number
rm soft.txt                   # delete a link
unlink soft.txt               # another way to delete a link
```

### Output

```
===== 1. CREATE =====
total 8
262530 -rw-rw-r-- 2 ubuntu ubuntu  6 Sep  3 22:00 hard.txt
262530 -rw-rw-r-- 2 ubuntu ubuntu  6 Sep  3 22:00 original.txt
262531 lrwxrwxrwx 1 ubuntu ubuntu 12 Sep  3 22:00 soft.txt -> original.txt

===== 2. SHARED INODE =====
hello
added via hard link

===== 3. DELETE ORIGINAL =====
--- hard link still works:
hello
added via hard link
--- soft link is broken:
cat: soft.txt: No such file or directory
lrwxrwxrwx 1 ubuntu ubuntu 12 Sep  3 22:00 soft.txt -> original.txt

===== 4. RESTRICTIONS =====
ln: d: hard link not allowed for directory
total 8
drwxrwxr-x 2 ubuntu ubuntu 4096 Sep  3 22:00 d
lrwxrwxrwx 1 ubuntu ubuntu    1 Sep  3 22:00 dsoft -> d
-rw-rw-r-- 1 ubuntu ubuntu   26 Sep  3 22:00 hard.txt
lrwxrwxrwx 1 ubuntu ubuntu   12 Sep  3 22:00 soft.txt -> original.txt
```

### What I understood

original.txt and hard.txt have the same inode number and their link count is 2, which proves both names point to one file. soft.txt has a different inode, link count 1, and it shows an arrow to original.txt.

I added a line using hard.txt and then read original.txt, and the new line was there, because both names use the same inode.

After deleting original.txt the command cat hard.txt still printed the full content, but cat soft.txt failed because the path saved inside it does not exist now. The link count of hard.txt also became 1.

The command ln d dhard gave an error saying hard link not allowed for directory, but ln -s d dsoft worked fine.

## Task 2: adduser vs useradd

### useradd

useradd is a low level command and it is present on almost every Linux distribution. It only creates the user entry and nothing else. It does not make a home directory, does not set a password and does not ask anything. Everything has to be given using flags.

```bash
sudo useradd -m -d /home/john -s /bin/bash john
sudo passwd john
```

Here -m makes the home directory, -d gives its path and -s sets the login shell.

### adduser

adduser is a Perl script on Ubuntu and Debian which internally calls useradd. It creates the home directory on its own, copies the default files from /etc/skel, asks for the password and asks a few extra details.

```bash
sudo adduser testuser3
```

### Which one is preferred and why

On Ubuntu adduser is preferred for normal use because it is interactive and completes all the steps by itself, so there is less chance of mistake. useradd is preferred inside shell scripts and automation because it does not ask anything and gives full control through flags.

I created the test user testuser3 using adduser, which is the recommended command on Ubuntu. It asked for the password and then asked the extra details like full name and room number, and it made the home directory on its own.

### Creating the test user with adduser

```
$ sudo adduser testuser3
info: Adding user `testuser3' ...
info: Selecting UID/GID from range 1000 to 59999 ...
info: Adding new group `testuser3' (1003) ...
info: Adding new user `testuser3' (1003) with group `testuser3 (1003)' ...
info: Creating home directory `/home/testuser3' ...
info: Copying files from `/etc/skel' ...
New password: 
Retype new password: 
passwd: password updated successfully
Changing the user information for testuser3
Enter the new value, or press ENTER for the default
	Full Name []: Heeralal
	Room Number []: 465
	Work Phone []: 767657547374
	Home Phone []: 3454564666
	Other []: 
Is the information correct? [Y/n] y
info: Adding new user `testuser3' to supplemental / extra groups `users' ...
info: Adding user `testuser3' to group `users' ...
```

### Output

```
--- user created with useradd:
testuser1:x:1001:1001::/home/testuser1:/bin/sh
--- user created with adduser:
testuser3:x:1003:1003:Heeralal,465,767657547374,3454564666:/home/testuser3:/bin/bash

--- /home directory:
total 8
drwxr-x---  2 testuser3 testuser3 4096 Sep  3 22:14 testuser3
drwxr-x--- 10 ubuntu    ubuntu    4096 Sep  3 21:50 ubuntu

--- inside home of testuser3:
.
..
.bash_logout
.bashrc
.profile
```

### What I understood

The user testuser1 made by useradd is present in /etc/passwd but there is no folder for it inside /home, and its shell is /bin/sh. The user testuser3 made by adduser has its own home directory with .bashrc, .profile and .bash_logout copied from /etc/skel, its shell is /bin/bash, and the details I typed are also saved in /etc/passwd. This shows adduser does all the extra work automatically.

## Task 3: journalctl

### What is journalctl

journalctl is the command used to read the logs of systemd. In systemd the logs are not saved as normal text files, they are saved in a binary journal, so we cannot read them with cat. journalctl is the tool that reads that journal and shows it in readable form. So all the system logs and service logs stay in one place.

### Important options

```bash
journalctl                     # show the full log
journalctl -n 20               # last 20 lines
journalctl -f                  # follow live, like tail -f
journalctl -b                  # logs of the current boot
journalctl -b -1               # logs of the previous boot
journalctl -u ssh              # logs of one service
journalctl -u ssh -f           # fllow one service live
journalctl -p err -b           # only the errors of this boot
journalctl --since today       # logs from today
journalctl --no-pager          # print directly without opening the pager
journalctl --disk-usage        # space used by the journal
```

### Output

```
--- journalctl -n 10 :
Sep 03 22:18:02 devops sudo[4710]: pam_unix(sudo:session): session opened for user root(uid=0) by ubuntu(uid=1000)
Sep 03 22:18:02 devops sudo[4710]: pam_unix(sudo:session): session closed for user root
Sep 03 22:18:02 devops sshd[4658]: pam_unix(sshd:session): session closed for user ubuntu
Sep 03 22:18:02 devops systemd[1]: session-46.scope: Deactivated successfully.
Sep 03 22:18:02 devops systemd-logind[652]: Session 46 logged out. Waiting for processes to exit.
Sep 03 22:18:02 devops systemd-logind[652]: Removed session 46.
Sep 03 22:18:47 devops sshd[4713]: Accepted publickey for ubuntu from 192.168.252.1 port 57259 ssh2: RSA SHA256:aC3B0PYfrcWj+/iPYAoGJTdQmFHa2F3CAhrXxaCMTh8
Sep 03 22:18:47 devops sshd[4713]: pam_unix(sshd:session): session opened for user ubuntu(uid=1000) by ubuntu(uid=0)
Sep 03 22:18:47 devops systemd-logind[652]: New session 47 of user ubuntu.
Sep 03 22:18:47 devops systemd[1]: Started session-47.scope - Session 47 of User ubuntu.

--- journalctl -u ssh -n 10 (after restarting ssh):
Warning: The unit file, source configuration file or drop-ins of ssh.service changed on disk. Run 'systemctl daemon-reload' to reload units.
Sep 03 22:18:47 devops sshd[4713]: Accepted publickey for ubuntu from 192.168.252.1 port 57259 ssh2: RSA SHA256:aC3B0PYfrcWj+/iPYAoGJTdQmFHa2F3CAhrXxaCMTh8
Sep 03 22:18:47 devops sshd[4713]: pam_unix(sshd:session): session opened for user ubuntu(uid=1000) by ubuntu(uid=0)
Sep 03 22:18:47 devops sshd[4172]: Received signal 15; terminating.
Sep 03 22:18:47 devops systemd[1]: Stopping ssh.service - OpenBSD Secure Shell server...
Sep 03 22:18:47 devops systemd[1]: ssh.service: Deactivated successfully.
Sep 03 22:18:47 devops systemd[1]: Stopped ssh.service - OpenBSD Secure Shell server.
Sep 03 22:18:47 devops systemd[1]: Starting ssh.service - OpenBSD Secure Shell server...
Sep 03 22:18:47 devops sshd[4768]: Server listening on 0.0.0.0 port 22.
Sep 03 22:18:47 devops sshd[4768]: Server listening on :: port 22.
Sep 03 22:18:47 devops systemd[1]: Started ssh.service - OpenBSD Secure Shell server.

--- journalctl -p err -b :
Sep 03 22:00:08 devops deluser[4100]: The user `testuser2' does not exist.

--- journalctl --disk-usage :
Archived and active journals take up 22.0M in the file system.
```

### What I understood

I restartd the ssh service and then checked journalctl -u ssh, and the stop and start entries of that service were visible with their time. This shows how we can check the log of one particular service instead of reading the whole system log.

## Task 4: Linux Command Cheat Sheet

| Command | Purpose |
|---|---|
| pwd | shows the current directory path |
| ls -la | lists all files with details including hidden files |
| cd | changes the directory |
| mkdir | creates a directory |
| touch | creates an empty file |
| cat | shows the content of a file |
| cp | copies a file |
| mv | moves or renames a file |
| rm | deletes a file |
| chmod | changes the permission of a file |
| chown | changes the owner of a file |
| grep | searches text inside a file |
| find | searches for files inside a directory |
| whoami | shows the current user |
| hostname | shows the machine name |
| date | shows the current date and time |
| uptime | shows how long the system has been running |
| df -h | shows the disk usage of the filesystems |
| free -h | shows the memory usage |
| ps aux | shows the running processes |
| top | shows live process and cpu usage |
| kill | stops a process using its PID |
| ip addr | shows the ip address of the interfaces |
| ss -tuln | shows the listening ports |
| ping | checks if a host is reachable |
| curl | sends a request to a url |
| sudo | runs a command as administrator |

### Output

```
--- pwd:
/home/ubuntu/links
--- whoami:
ubuntu
--- hostname:
devops
--- date:
Thu Sep  3 22:00:09 IST 2026
--- uptime:
 22:00:09 up  1:11,  4 users,  load average: 0.00, 0.00, 0.00
--- ls -la:
total 16
drwxrwxr-x  3 ubuntu ubuntu 4096 Sep  3 22:00 .
drwxr-x--- 10 ubuntu ubuntu 4096 Sep  3 21:50 ..
drwxrwxr-x  2 ubuntu ubuntu 4096 Sep  3 22:00 d
lrwxrwxrwx  1 ubuntu ubuntu    1 Sep  3 22:00 dsoft -> d
-rw-rw-r--  1 ubuntu ubuntu   26 Sep  3 22:00 hard.txt
lrwxrwxrwx  1 ubuntu ubuntu   12 Sep  3 22:00 soft.txt -> original.txt
--- df -h /:
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda1       8.7G  2.1G  6.7G  24% /
--- free -h:
               total        used        free      shared  buff/cache   available
Mem:           1.9Gi       281Mi       1.0Gi       1.1Mi       754Mi       1.6Gi
Swap:             0B          0B          0B
--- ps aux:
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root           1  0.0  0.6  22472 12844 ?        Ss   20:48   0:02 /sbin/init
root           2  0.0  0.0      0     0 ?        S    20:48   0:00 [kthreadd]
root           3  0.0  0.0      0     0 ?        S    20:48   0:00 [pool_workqueue_release]
root           4  0.0  0.0      0     0 ?        I<   20:48   0:00 [kworker/R-rcu_g]
root           5  0.0  0.0      0     0 ?        I<   20:48   0:00 [kworker/R-rcu_p]
--- ip -br addr:
lo               UNKNOWN        127.0.0.1/8 ::1/128 
enp0s1           UP             192.168.252.2/24 metric 100 fd06:d551:66b5:703c:5054:ff:fec8:d1c0/64 fe80::5054:ff:fec8:d1c0/64 
--- ss -tuln:
Netid State  Recv-Q Send-Q                    Local Address:Port Peer Address:PortProcess
udp   UNCONN 0      0                            127.0.0.54:53        0.0.0.0:*          
udp   UNCONN 0      0                         127.0.0.53%lo:53        0.0.0.0:*          
udp   UNCONN 0      0                  192.168.252.2%enp0s1:68        0.0.0.0:*          
udp   UNCONN 0      0      [fe80::5054:ff:fec8:d1c0]%enp0s1:546          [::]:*          
tcp   LISTEN 0      4096                            0.0.0.0:22        0.0.0.0:*          
```

### What I understood

These are the basic commands used daily in Linux. pwd, ls and cd are used to move around the filesystem. mkdir, touch, cp, mv and rm are used to manage files. chmod and chown are used for permissons. df, free, ps and top are used to check the resources of the system. ip and ss are used to check the network. These commands are the starting point for any troubleshooting on a Linux server.
