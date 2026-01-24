# User management
# cmd lines
- whoami
- sudo cat /etc/passwd ( to list users in the system)
- sudo cat /etc/shadow ( to list password of all users)
- id username ( to see more about a particular user ) # : low level cmd line
- sudo useradd username ( to create a user ) # but how can I give password to this user?
- sudo passwd username ( to create/update password )
- sudo userdel -r username
- sudo useradd -m username ( to create user with home dir ) # : low level cmd line

- sudo adduser username ( to create user with skeleton dir) # : high level cmd line 
    -- it goes into same group as name but what if I don't want to let it go in the same group or want to change its group, how can I?
- sudo ls /home
- sudo ls -la /home/username
    -- how can I login user username and password


# Group list 
- sudo cat /etc/group ( list group)
- sudo groupadd / addgroup groupname ( to creat a new group )
- (how can I list all users in a group )
- sudo usermod -aG groupName userName ( to add a user into a group)
- sudo delgroup groupname (to delete the group)
- sude usermod -l newusername oldusername ( to change username of a user)
- sudo usermod -d newdir olduser ( to change user's dir ')

- sudo sysstemctl restart ssh
- su - username (to change user)



User login ways: 
1. using username and password: ssh username@ip then password but it is not secure
2. using public and private key: 
    1. create a user
    2. create ssh key for the user
    3. sudo -u username mkdir -p /home/username/.shh ( ownership as user) 
    4. sudo chmod 700 /home/username/.shh ( to change permission of the dir)
    5. ssh-keygen -t rsa -b 4096 -f dir/keyfilename.username ( to create ssh key)
    6. echo 'public key' | sudo -u username tee(to create junction) /home/username/.shh/authorized_keys ( to insert public key for ssh)
    7. now you can login user private key: but might need to change key permission using chmod 400 keyname
    8. shh -i "key" username@ip


Root login using password:
1. change the /etc/ssh/sshd_config.d$ vim 60-cloudimg-settings.conf value 
    PermitRootLogin yes
    save and restart
2. root starts with # and $ for other users