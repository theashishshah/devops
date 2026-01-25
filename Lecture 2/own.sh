sudo passwd username # to directly change password of any user(admin can do this)
passwd # can change own password with old password

# so when any user run sudo like: sudo cat /etc/shadow
# linux say, ok for a moment you can take power of root user because you're added in sudo group, else other time you will run like a normal user

sudo su - # if you're in sudo group then switch to root user (su: switch user)
sudo -i # switch to root user

groups # will list the groups you're in
sudo usermod -aG sudo username   # safe, recommended
sudo adduser username sudo       # Ubuntu shortcut

groups username # to see groups of a user 

sudo gpasswd -d username groupname # to remove a user from a group
sudo deluser username groupname # to remove a user from a group

getent group groupname # to get all the user in a group

sudo groupadd groupname # to create a group
sudo addgroup groupname # to create a group
sudo groupadd -g GID groupname # create a group with a specific group ID