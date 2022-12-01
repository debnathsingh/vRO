#!/bin/bash
#[#scriptContent#=#string# <#
#        .SYNOPSIS
#       HealthCheck Script
#
#        .DESCRIPTION
#       This script will fetch the healthcheck information of any system
#
#       .PARAMETER Name
#        HealthCheck Script.
#
#       .INPUTS
#       None. 
#
#
#       .OUTPUTS
#       The healthcheck report
#
#       .VERSIONa
#       1.0
#
#       .DEVELOPER
#        vRO Automation Team
    #>
#clear the screen
S="-------------------------------------------------------"
D="*******************************************************"
echo -e "\n$D"
echo -e "\tSystem Health Status"
echo -e "$D"
#------PRINT SYSTEM DETAILS-------#
hostname -f &> /dev/null && printf "Hostname : $(hostname -s)\n\n"
#------PRINT SYSTEM UPTIME----#
echo -e "$S"
echo -e "\n System up time:"
echo -e "$S"
bootTime=$(date;uptime)
echo -e "$bootTime"
#-------System patch information----#
echo -e "$S"
echo -e "\n System patch details:"
echo -e "$S"
patch=$(rpm -qa kernel --last)
echo -e "$patch"
#------PRINT TOP CPU UTILIZATION----#
echo -e "$S"
echo -e "\n\n Top CPU utilization:"
echo -e "$S"
CPU=$(ps -eo pid,ppid,cmd,%cpu --sort=-%cpu |head)
echo -e "$CPU"
#------PRINT TOTAL CPU UTILIZATION----#
echo -e "$S"
echo "Total Number of CPU/cores: $(getconf _NPROCESSORS_ONLN)"
top -bn1 | grep "Cpu(s)" | \sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print "CPU Usage: " 100 - $1"%"}'
#------PRINT TOTAL MEMORY UTILIZATION----#
echo -e "$S"
echo "Total Memory: $(grep MemTotal /proc/meminfo | awk '{print $2 /1024/1024}') GB"
free | grep Mem | awk '{print "Memory Usage: " $3/$2 * 100.0 "%"}'
#------PRINT TOP MEMORY UTILIZATION----#
echo -e "$S"
echo -e "\n Top MEM utilization:"
echo -e "$S"
MEM=$(ps -eo pid,ppid,cmd,%mem --sort=-%mem |head)
echo -e "$MEM"
#------PRINT DISK UTILIZATION-------#
echo -e "$S"
echo -e "\n DISK usage on server:"
echo -e "$S"
DISK=$(df -h |grep -v ^none | (sort -n -k 5))
echo -e "$DISK"
#-------PROCESS CURRENTLY RUNNING----#
echo -e "$S$S"
echo -e "Process currently running on server:"
echo -e "$S$S"
processRunning=$(systemctl list-units --type service | grep running)
echo -e "$processRunning"
#-------PROCESS FAILED----#
echo -e "$S$S"
echo -e "Process failed on server:"
echo -e "$S$S"
processFailed=$(systemctl list-units --type service | grep failed)
echo -e "$processFailed"
#-------Network interface runnning----#
echo -e "$S$S"
echo -e "Network interface available on server:"
echo -e "$S$S"
networkInterface=$(ifconfig -a)
echo -e "$networkInterface"
#-------Ping check on server----#
echo -e "$S$S"
echo -e "Ping check report on server:"
echo -e "$S$S"
pingCheck=$(ping -O google.com -c 5)
echo -e "$pingCheck"
echo -e "\n --------Report end-------"