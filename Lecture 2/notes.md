1. How can I create multiple users in my ec2 machine?
2. How can I assign different permission?
3. How can I work with volumes?
4. How can we access pen drive or something? how can I change permission for different users?
5. What's sudo?


## Types of Users:
1. Root users (id = 0)
2. System users (id = 1-999)
3. Local users (id > 999 till 60,000 but can be changable)


## Login to remote machine:
- by default aws doesn't provide mechanism to login via password instead we do only ssh
- but we can change this permision in the below folder:

cd /etc/ssh
cd sshd_config.d/ (in this folder we've everything about permission )

vim editor:
i (to insert mode)
esc + :wq (write and quit)

- restart ssh process
sudo sysstemctl restart ssh
