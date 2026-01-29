cat /var/log/syslog # it will log the entire file's data and if logs are so long, terminal might crash

tail -n 10  /var/log/syslog # to read last n lines
tail -f -n 10 /var/log/syslog # to log in real time, it will list logs in real time with n lines at a time