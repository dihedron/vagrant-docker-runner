# Running Docker Containers in a VM
This projects contains the vagrant recipe to create a VM with the latest version of Docker and Docker Compose.

## Creating the VM
In order to create the VM you must have installed ```vagrant```, which is freely available from the [Hashicorp website](https://www.vagrantup.com/).

Next, clone this repository or download it to a directory of your choice and from it run the following at a command propt:
```bash
$> vagrant up
```
Vagrant will create a new virtual machine based on Ubuntu Xenial 16.04.4 LTS and then it will run the ```setup.sh``` script which:
1. updates the system
2. adds the Docker-CE APT repository
3. installs docker
4. creates the ```docker``` group
5. adds the ```vagrant``` user to the ```docker``` group
6. downloads and installs the latest version of ```docker-compose```

## Using the VM
In order to use the VM to run your Docker containers, you simply need to log into it:
```bash
$> vagrant ssh
```
and then use the command line to run any docker-related commands. 

If you need to share files, between the host (your PC) and the VM, you can place them in the same directory where ```Vagrantfile``` and ```setup.sh``` are, because ```vagrant``` makes sure it is mounted as a shared folder on the guest VM under ```/vagrant```. This is an easy way to move ```Dockerfile```s and ```docker-compose.yml```s back and forth.

## Feedback and contributions
...are obviously exceedingly welcome.