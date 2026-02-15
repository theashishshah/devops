what is docker image? 
- A docker image is a read-only, layered filesystem artifacts that contains application code, runtime libraries, dependencies to run the application, and starup configuration to run a container

What is docker container? 
- A container is running instance of docker image and it is isolated until specified to talk to other containers or process.


What is container runtime?
- A process that runs docker image

If docker follows client-server architecture, then I can request from anywhere to the docker, right? 
- 


How docker desktop creats VM on my local machine then creates a OS inside the docker or How things work internally? In initial when docker wasn't introduced we used have hypervisiors type 1 and type 2, that takes some part of our hardwares and intalls a new OS on that part and runs the software but how docker solves this? and what does docker do behind the scene that it is now light weight than the hypervisors?

There were two types:

Type 1 (Bare Metal)
Runs directly on hardware
Example: VMware ESXi, Microsoft Hyper-V

Type 2 (Hosted)
Runs on top of host OS
Example: VirtualBox, VMware Workstation 
- and for each we needed to install seperate OS that was the big headache


###  How VMs Work Internally
When you create a VM:
Hypervisor virtualizes hardware:
Virtual CPU
Virtual RAM
Virtual Disk
Virtual Network card
You install a full OS inside it
Linux / Windows
With its own kernel

-- So docker is trying to solve OS problem per application but why do we need OS per application because when we develop an application on different OS but it will not work as expected as on other OS, so why not create the application in a environment where OS remians same and we can send/rec this environment, so it will use hardwares of different machines in the same fashion


- So when we build application using docker container, it creates a snapshot of the OS, kernel, system dependencies, liberary and startup configuration and packed it within a image.
- and when we run this image on some other docker, it creates own environment like OS, kernel etc with exact same version and code


what is the diff between a virtual machine and a docker(macOS)? 
- virtual machine is a complete machine with its own OS + kernel and network interaces while a docker create a VM tha has only one kernel (host kernel), network interfaces and OS and diff applications uses host kernel to use the hardwares and virtual network interfaces. So there is no overhead of managing kernels