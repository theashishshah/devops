crontab -e              # edit current user's crontab
sudo crontab -e         # edit root's crontab
crontab -l              # list current user's jobs (was: crontab l — typo)
sudo vim /etc/crontab   # system-wide crontab (includes user column)

# /etc/crontab example line (minute hour dom mon dow user command):
# * * * * * username /path/to/command