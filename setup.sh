#!/bin/bash

APT_QUIETNESS=""

# SYSTEM UPDATE
echo "bringing system up-to-date..."
sudo apt-get $APT_QUIETNESS update
sudo apt-get -y $APT_QUIETNESS upgrade
echo "... DONE!"

# PRE-REQUISITES
if ! which curl 2>&1 > /dev/null; then 
	echo "installing curl and other prerequisites..."
    sudo apt-get -y $APT_QUIETNESS install apt-transport-https ca-certificates curl software-properties-common
	echo "... DONE!"
fi


# DOCKER-CE REPOS AND SOFTWARE PACKAGE
if [ -z "$(apt-cache search docker-ce)" ]; then
    echo "installing Docker CE from official repositories to run as $USER..."
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo apt-key fingerprint 0EBFCD88
    # install for the current distro; on Mint user /et/os-release to get base Ubuntu distro
    # Ubuntu: sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    # Mint: sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(sed -n 's/^UBUNTU_CODENAME=\(.*\)/\1/ p' /etc/os-release) stable"
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(sed -n 's/^UBUNTU_CODENAME=\(.*\)/\1/ p' /etc/os-release) stable"
    sudo apt-get $APT_QUIETNESS update
    sudo apt-get -y $APT_QUIETNESS install docker-ce
    echo "... DONE!"
fi

# DOCKER GROUP FOR NON-ROOT EXECUTION
if ! grep -q docker /etc/group; then
    echo "adding docker group..."
    sudo groupadd docker
    echo "... DONE!"
fi

# ADD GROUP TO CURRENT USER (VAGRANT) AND RELOAD
if !  groups | grep -q docker ; then
    echo "adding docker group to ${USER}..."
    sudo usermod -aG docker $USER
    GROUP=$(id -ng)
    newgrp docker
    newgrp ${GROUP}
    echo "... DONE!"
fi

# ENABLE DOCKER AT BOOT
sudo systemctl enable docker

# INSTALL DOCKER-COMPOSE
if ! which docker-compose 2>&1 > /dev/null; then 
    echo "installing Docker compose..."
    # get latest docker compose released tag
    COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)
    curl -Ls https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > /tmp/docker-compose
    chmod +x /tmp/docker-compose
    sudo mv /tmp/docker-compose /usr/bin/docker-compose
    curl -Ls https://raw.githubusercontent.com/docker/compose/${COMPOSE_VERSION}/contrib/completion/bash/docker-compose > /tmp/docker-compose.completion
    sudo mv /tmp/docker-compose.completion /etc/bash_completion.d/docker-compose
    echo "... DONE!"
fi

docker-compose -v

# FINAL BANNER
echo "  +--------------------------------------------------------+"
echo "  | To test your new Docker VM, try logging into it via:   |"
echo "  |   $> vagrant ssh                                       |"
echo "  | and then at the command prompt enter:                  |"
echo "  |   $> docker run hello-world                            |"
echo "  |                                                        |"
echo "  | To use it as a docker-compose host, please note that   |"
echo "  | the new VM will mount the directory on the host where  |"
echo "  | the Vagrantfile is as /vagrant, so it's easy to share  |"
echo "  | files by placing them in that directory.               |"
echo "  +--------------------------------------------------------+"
