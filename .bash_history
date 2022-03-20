sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt update
apt-cache policy docker-ce
sudo apt install docker-ce
sudo systemctl status docker
docker run --name jenkins   --volume jenkins_home:/var/jenkins_home   -p 8080:8080   -p 50000:50000   jenkins/jenkins:lts 
docker ps
docker ps -a
docker start ed82bfc6276f
docker ps -a
sudo mkdir /var/jenkins_home
ls /var/jenkins_home/
docker -ps
docker ps
docker stop ed82bfc6276f
