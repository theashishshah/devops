uptime # to see when it was started
man uptime # uptime -ps
ps # process status, memory uses, process id
ps aux # list all all the processes inluding background worker
ps aux | grep username  # to list out who run the process
sudo kill processId # to forcefull kill a process in system
top # to monitor real time processes 
top K # to kill a process 
df -h # disk free to show everything about disk
free -h # to see ram and tow can I increase ram in ec2
history # to see all the history
!number of history # to run again the cmd
history | grep free
history -c # to clear the history
read -s -p "message as prompt" VARABLE_NAME # To user variable #VARIABLE_NAME
 cmd # to remove the cmd from history, just use a space
echo $HISTCONTROL # this is the variable that defines to remove/add history from terminal using values: ingoreboth or ignorespace

which program # Which executable binary will run when you type a command
echo $PATH # to list out paths that a which run to check and whichever finds first, it uses that one only
whereis ls # finds binaries, source, man pages
type ls # tells if it’s alias, builtin, or file (better than which)
file <filename> # tells what kind of file it is

Compiled binaries → C, C++, Rust, Go
Script files → Bash, Python, Node

# so Alias meaning giving short name of a bigger cmd line. its like shorting a url
alias # list the all the alias that are available in our system.
alias aliasName='cmd line' # to create an alias, always give single qoute and they are not persistent

# but to create permanently alias, we can user .bashrc file
edit .bashrc file using vim/nano
restart the source file using
source .bashrc # starts the .bashrc file again or loads the changes

g or :$ or shif + g # to go bottom in vim
:1 # to go top in vim


# to make alias that takes input from cmd prompt, we write function instead of direct making alias because we can't pass values 

createfile(){
    touch $1
}
# to use it just give name followed by args
createfile app.js  or
createfile server.js

gcm(){
    git add . && git commit -m "$1"
}

gcm "initial commit"