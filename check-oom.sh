#/bin/bash
datetofind=$(date "+%b %d %T"|cut -d":" -f1)
# wait 58 s , so we catch everything since cron should start us shortly after the minute
sleep 58
# the first argument has to be a bash script to which we will pipe the message
grep  "$datetofind" /var/log/syslog |grep -q OOM && ( 

       (echo Out-Of-Memory found in /var/log/syslog; 
       echo "System status:"
       echo
       docker stats --no-stream | tr -d "%" | awk '{if($7>80)print "Warning: " $1 "/" $2" uses over 80%  RAM ("$7"%)"}'
       echo
       echo "OOM_Incidents ( last 3 ):"
       echo
       grep OOM /var/log/syslog|grep "$(date "+%b %d %T"|cut -d":" -f1)"|tail -n3;
       echo 
       echo "containers ever restarted"
       docker ps -a --format '{{.Names}}'|while read a ;do docker container inspect $a| jq .[].State.OOMKilled|grep true -q && echo "OOM $a";done
       ) | bash "$1"
)
