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
