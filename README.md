# Running Docker Containers in a VM
This projects contains the __Vagrant__ recipe to create a VM with the latest version of __Docker__ and __Docker Compose__.

## Creating the VM
In order to create the VM you must have installed ```vagrant```, which is made freely available from Hashicorp on [their website](https://www.vagrantup.com/).

Next, clone this repository or download it to a directory of your choice and from it run the following at a command propt:
```bash
$> vagrant up
```
Vagrant will create a new virtual machine based on Ubuntu Xenial 16.04.4 LTS and then it will run the ```setup.sh``` script which:
1. updates the system
2. adds the Docker CE APT repository
3. installs Docker
4. creates the ```docker``` group
5. adds the ```vagrant``` user to the ```docker``` group
6. downloads and installs the latest version of Docker Compose

## Operating from behind a proxy

In order to support a scenario where Vagrant is running behind a proxy, e.g. when running in an enterprise environment, the ```Vagrantfile``` includes a reference to the ```vagrant-proxyconf``` [plugin](https://github.com/tmatilai/vagrant-proxyconf); in order to enable it and have Vagrant automatically install it if lacking, replace this line in the ```Vagrantfile```:
```bash  
    required_plugins = %w( vagrant-vbguest vagrant-disksize )
```  
with this:
```bash
   required_plugins = %w( vagrant-vbguest vagrant-disksize vagrant-proxyconf )
```
then tweak the proxy section:
```bash
    if Vagrant.has_plugin?("vagrant-proxyconf")
        # let CNTLM listen on the vboxnet interface, set your localhost
        # as the proxy for VirtualBox machines, so APT cen get through
        # (tweak as needed!)
        config.proxy.http     = "http://192.168.33.1:3128/"
        config.proxy.https    = "http://192.168.33.1:3128/"
        config.proxy.no_proxy = "localhost,127.0.0.1,.example.com"
    end
```
as needed; in the example above, a local [CNTLM proxy](http://cntlm.sourceforge.net/) was installed and configured on the host machine to listen on the ```vboxnet0``` NIC. Please note that for security reasons, by default CNTLM only listens on the loopback interface; unless explicitly told to do otherwise
```bash
Listen		127.0.0.1:3128             # loopback
Listen		192.168.33.1:3128          # virtualbox
```
it is not reachable by VirtualBox VMs.

## Using the VM
In order to use the VM to run your Docker containers, you simply need to log into it:
```bash
$> vagrant ssh
```
and then use the command line to run any docker-related commands. 

If you need to share files between the host (your PC) and the VM you can place them in the same directory where ```Vagrantfile``` and ```setup.sh``` are, because ```vagrant``` makes sure it is mounted as a shared folder on the guest VM under ```/vagrant```. This is an easy way to move ```Dockerfile```s and ```docker-compose.yml```s back and forth.

## Exposing the containers to the outer world
If you want to expose your containers to the world, you mey need to play with the ```Vagrantfile```; the Hashicorp website is an excellent starting point to learn how to tune you VM's network settings via Vagrant.

## Feedback and contributions
...are obviously exceedingly welcome; please use issues and pull requests to contribute back.