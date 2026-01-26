symbolic notation:
drwxrwxrwx # d=dir
-r-e--e--  # -=file
lrwx-----x # l=link


drwxr-x--- 4 ubuntu ubuntu 4096 Jan 25 19:45 .


# test cmd
sudo vim /var/finance.txt

sudo chmod o+w finance.txt # o=other, g=group, u=user + (to add) - (to remove) + r=read, w=write, x=execute
sudo  chown newownername:groupname fil/dir # change the owner, may be user or only group
sudo chown :groupname file/dir  # keep the ower same and change the group
sudo chmod +x filename # this is for all owner, group and others



Octal notaion: # 0 - 7
sudo chmod 777 file/dir name # to change the permission using octal notation

sudo mkdir dir
dwrxr-xr-x 755 # these permission will get if root/sudoer create a dir and ower will be root

mkdir dirname
drwxrwxr-x  775 # these permission will get if dir is craeted with sudo and owner will be user

sudo touch filename
-rw-r--r-- 644 # owner will be root

touch filename
-rw-rw-r-- 664 # and owner will be user only

# remark!: so when you run any cmd line using sudo, you get the power of sudo at that time only because you're allowed to get that power because you're in sudo group and cmd line run will be considered of root only not of the user who is running that cmd.

# remark!: whoever creating and if it is creating for it self then that will get all the permission and its group as well.


sudo mkdir hello
drwxr-xr-x 2 root   root   4096 Jan 26 17:47 hello  | 755 # root is creating, so this dir belong to root and its group, right? 

mkdir hello1
drwxrwxr-x 2 ubuntu ubuntu 4096 Jan 26 17:49 hello1 | 775 # a user is creating, so this belong to its group and giving all permission to its group because it knows about his group

sudo touch script.js
-rw-r--r-- 1 root   root      0 Jan 26 17:49 script.js | 644

touch shell.sh
-rw-rw-r-- 1 ubuntu ubuntu    0 Jan 26 17:53 shell.sh | 664

# this is done by umask in profile folder
du # disk uses in kb format


drwxrwsrwt 
d rwx rws rwt # s = Set-GID, t=Sticky Bit

# So one problem we've right now is that: 
# when a user create a fiile or group then that user becomes the owner of the file/dir and also of that file/dir group is belong to that user only, so we won't want this in case of we're a part of any  group and we're creating file/dir in that dir
# instead we want the owner should be the parent who's we're accessing.
to do so we use Set-GID # set group id

2 = S  2777
sudo chmod g+s dirname 
# so change dir permission from x to s then automatically every dir/file any user will create will have group as root


t = sticky bit # owner only can delele a file
t = 1 1777
sudo chmod o+t dirname


# set group id that sets ownership while creating a file
# sticky bit: that protects from editing anyone apart from owner