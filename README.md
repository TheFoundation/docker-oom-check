# Docker OOM Check 

##### a simple tool that sends a report when your system had out of memory incidents

### what it does
* gets the current hour
* scans /var/log/syslog for the oom OOM occurences for the current hour entries 
* sends a report to another shell script via stdin

### usage

* basic example: `bash /your/path/docker-oom-check/check-oom.sh /path/to/your-other-script.sh`
* STDOUT will be sent to a bash instance running the shell script given as parameter
* cron example 

```
## send message if OOM exceded
59 * * * * /bin/bash /etc/custom/docker-oom-check/check-oom.sh /etc/send-notification-oom.sh  &>/var/log/oom-notify.log

```
