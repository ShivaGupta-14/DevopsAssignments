# Shell Scripting Assignment

## Task

Create a shell script that prints the current date, hostname, username, disk usage and running processes. The script has to use variables, take input from the user with read -p, create a directory with mkdir, create a file with touch, and save the running processes into that file using the > redirection.

## Script

File name: sysinfo.sh

```bash
#!/bin/bash

current_date=$(date)
host_name=$(hostname)
user_name=$(whoami)

echo "Current Date : $current_date"
echo "Hostname : $host_name"
echo "Username : $user_name"

echo
echo "Disk Usage"
df -h /

echo
echo "Running Processes"
ps aux | head -n 10

echo
read -p "Enter a name for the report directory: " dir_name

mkdir -p "$dir_name"
echo "Directory created : $dir_name"

file_name="$dir_name/processes.txt"
touch "$file_name"
echo "File created : $file_name"

ps aux > "$file_name"
echo "Processes saved in $file_name"
```

## How to run

```bash
chmod +x sysinfo.sh
./sysinfo.sh
```

## Output

```
Current Date : Thu Sep  3 22:11:55 IST 2026
Hostname : devops
Username : ubuntu

Disk Usage
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda1       8.7G  2.1G  6.7G  24% /

Running Processes
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root           1  0.0  0.6  22472 12844 ?        Ss   20:48   0:03 /sbin/init
root           2  0.0  0.0      0     0 ?        S    20:48   0:00 [kthreadd]
root           3  0.0  0.0      0     0 ?        S    20:48   0:00 [pool_workqueue_release]
root           4  0.0  0.0      0     0 ?        I<   20:48   0:00 [kworker/R-rcu_g]
root           5  0.0  0.0      0     0 ?        I<   20:48   0:00 [kworker/R-rcu_p]
root           6  0.0  0.0      0     0 ?        I<   20:48   0:00 [kworker/R-slub_]
root           7  0.0  0.0      0     0 ?        I<   20:48   0:00 [kworker/R-netns]
root           9  0.0  0.0      0     0 ?        I<   20:48   0:00 [kworker/0:0H-events_highpri]
root          12  0.0  0.0      0     0 ?        I<   20:48   0:00 [kworker/R-mm_pe]

Directory created : systemreport
File created : systemreport/processes.txt
Processes saved in systemreport/processes.txt
```

## Commands used

| Command | Purpose |
|---|---|
| date | prints the current date and time |
| hostname | prints the name of the machine |
| whoami | prints the name of the current user |
| df -h | prints the disk usage in a readable form |
| ps aux | prints all the running processes |
| read -p | shows a message and takes input from the user |
| mkdir -p | creates a directory and gives no error if it already exists |
| touch | creates an empty file |
| > | sends the output of a command into a file |

## Variables used

```bash
current_date=$(date)
host_name=$(hostname)
user_name=$(whoami)
file_name="$dir_name/processes.txt"
```

The output of a command is stored in a variable using $( ) and then used later with $variable. The value of dir_name comes from the user input and file_name is made from it.

## What I understood

A shell script is a file containing commands which run one after another. The first line #!/bin/bash is the shebang and it tells the system which shell should run the file.

read -p waits for the user to type something, so the same script can be used with different directory names without editing the code.

The > redirection sends the output of ps aux into the file instead of printing it on the screen. If the file already has data then > overwrites it, and >> would add the new data at the end.

The file created by the script is systemreport/processes.txt and it contains the full process list from the time the script was run.
