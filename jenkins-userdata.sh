#!/bin/bash
set -ex
apt-get update -y
apt-get install -y fontconfig openjdk-17-jre docker.io git unzip curl

curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key -o /usr/share/keyrings/jenkins-keyring.asc
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" > /etc/apt/sources.list.d/jenkins.list
apt-get update -y
apt-get install -y jenkins

snap install aws-cli --classic
snap install kubectl --classic

usermod -aG docker jenkins
systemctl enable --now docker
systemctl enable --now jenkins
systemctl restart jenkins
