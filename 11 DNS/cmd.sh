lsof # list of open files, it lists all the files opened on your machine
lsof -i :portnumber # list the file(process) that are running on a specific port
lsof -u usernmae # list the process (fiels) opened by a particular user
lsof -i -P -n | grep LISTEN

ifconfig 
ip a
ipconfig # To list network interfaces