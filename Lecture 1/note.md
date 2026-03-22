# Lecture 1: Getting Started with DevOps & Linux

This lecture introduces the core foundations of DevOps: Linux, Virtualization, and the Cloud. It focuses on understanding how servers work and the essential command-line tools needed to manage them.

---

## 1. What is Linux?
- **Concept**: Linux is primarily a **Kernel**, not a full OS on its own. It's the core layer between hardware and software.
- **Development**: Written in **C/C++**.
- **Kernel vs. OS**: When we say "Ubuntu" or "CentOS," we are talking about **Linux Distributions (Distros)**—which combine the Linux Kernel with a shell (like Bash), a desktop environment, and pre-installed tools.

---

## 2. Virtualization & Hypervisors
To run multiple operating systems on a single physical machine, we use a software layer called a **Hypervisor**.

| Feature | Hypervisor Type 1 (Bare Metal) | Hypervisor Type 2 (Hosted) |
| :--- | :--- | :--- |
| **Location** | Runs directly on physical hardware. | Runs on top of a Host OS (like Windows/macOS). |
| **Performance** | High performance (direct hardware access). | Moderate performance (depends on Host OS). |
| **Kernel** | Brings its own light kernel. | Uses the Host's kernel to manage resources. |
| **Example** | VMware ESXi, Xen, Microsoft Hyper-V. | VirtualBox, VMware Workstation. |

---

## 3. The Cloud and AWS EC2
Modern DevOps happens in the cloud. Instead of buying physical servers, we use **Cloud Providers** (like AWS, Azure, GCP).
- **EC2 (Elastic Compute Cloud)**: A service that lets you "spin up" a Virtual Machine (VM) in minutes.
- **Terminal Access**: You don't get a monitor; you connect to the machine's terminal over the internet.

---

## 4. SSH: Secure Shell
To remotely control a Linux machine, we use **SSH**.
- **Command**: `ssh -i your-key.pem username@ip-address`
- **Port**: Default SSH port is **22**.
- **Authentication**: Usually done via a public/private key pair (`.pem` file) for security.

---

## 5. Linux CLI: The "Swiss Army Knife"

### A. Navigation & Filesystem
- `pwd`: **P**rint **W**orking **D**irectory (where am I?).
- `ls`: List files.
    - `-l`: Long format (shows permissions/size).
    - `-a`: Show hidden files (starts with `.`).
    - `-h`: Human-readable sizes (K, M, G).
- `cd`: Change Directory.
    - `cd -`: Go back to the previous folder.
    - `cd ~`: Go to the Home folder.
- `mkdir`: Make a directory.
- `tree`: Visualizes the folder structure as a tree.

### B. File Operations
- `cat`: Print file content to the terminal.
- `cp`: **C**o**p**y (syntax: `cp <source> <destination>`).
- `mv`: **M**o**v**e or **Rename** (syntax: `mv <old_name> <new_name>`).
- `find`: Find files (syntax: `find filename.js`).

### C. Permissions & Power
- `sudo`: **S**ubstituted **U**ser **DO** (Run as root/admin).
- `chmod 400`: Change file permissions (common for SSH keys to make them secure).
- `man <command>`: **Man**ual page (The documentation for any command). Press `q` to exit.

---

## 6. Package Management (Debian/Ubuntu)
We use the `apt` package manager to install software.
- `sudo apt update`: Downloads the latest **list** of available software. (It doesn't install anything yet).
- `sudo apt upgrade`: Downloads and **installs** the actual updates.
- `cat /etc/os-release`: Check which version of Linux you are running.

---

## 7. Professional Tips & Concepts
- **Reverse Engineering**: Understanding how a system works by breaking it down to its basics.
- **Scrum & SWOT**: Concepts used by DevOps teams to manage projects efficiently.
- **Chaining Commands**: Use `&&` to run multiple commands if the first one succeeds (e.g., `mkdir test && cd test`).

> [!TIP]
> **Why is Linux preferred in DevOps?** 
> Because it is lightweight, open-source, highly secure, and works perfectly without a GUI (Graphical User Interface), saving precious RAM/CPU for actual web applications.
