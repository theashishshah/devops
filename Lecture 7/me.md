What types of signal does blutooth and wifi emits that using wifi we can connect to internet but not using bluetooth? why? if both are emiting waves then why not?  

- So containers are just a normal linux process and if they can get linux kernel then they can easily intract with hardwares or get/set hardware, right? so what docker does? 
```sql 
Container Process
      ↓ (system calls)
Linux Kernel
      ↓
Device Drivers
      ↓
Hardware
--  An advanced process launcher + isolation configurator
```


- in case of macOS/windows docker brings it own linux kernel that talks to host OS and all the container(which is technically linux processes) talks to linux kernels and linux kernel talks to host OS and this way running multiple containers is so fast and efficient.
- in case of linux(ubuntu OS), it already has linux kernel so docker containers directly intracts with linux kernel and here docker doesn't neet to create any VM to get the linux kernels that's why docker containers runs so smoothly on ubuntu OS.
- So running a mongodb, postgres, redis db or other open source services inside a docker container is easy because docker container contains all the essentials runtime env, libraries, etc to run a service and when these services needs hardware they can intract with linux kernel based on the host OS, and work is done without overhead of maintaining the dependencies, libraries, runtime environment of each process because each process comes with its own environment to run that process.

eg: let's say you want to run a mongodb databse on your local machine: 
then what are the things you'll need to run this db.
- because db is just a good/structure way to perform CRUD operation on disk/hardwares, so this service somehow needs hardware access and will manage according to it.
- to interact with hardware  either I can create my own OS, kernel and other system or I can use neccessary library and can use the other's OS and kernel and when I say to perform these task, this kernel will perform
- so that's why we can use mongodb image and run inside docker.