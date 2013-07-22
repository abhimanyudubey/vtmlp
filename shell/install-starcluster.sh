#!/bin/bash
#Install script for the StarCluster Management System. 
#Written by Abhimanyu Dubey for Dr. Dhruv Batra's MLP Laboratory, Virginia Polytechnic Institute and State University, 2013.

#Remove earlier configurations if present
if [ -f ~/.starcluster/config ]; then
	rm -fr ~/.starcluster 
fi

mkdir ~/.starcluster
#Check if Amazon EC2 is installed or not.(install-ec2.sh creates a configsc file containing configurations)
if [ -f ~/.scm/ec2/configsc ]; then

	#Source configuration.
	echo "EC2 Configuration for StarCluster detected, proceeding with installation."
	source ~/.scm/ec2/configsc

	#Downloading stable release 0.93.3
	curl -O https://pypi.python.org/packages/source/S/StarCluster/StarCluster-0.93.3.tar.gz
	tar xvzf StarCluster-0.93.3.tar.gz
	cd StarCluster-0.93.3

	#Installing StarCluster.
	sudo python setup.py install
	cd ..
	sudo rm -fr StarCluster-0.93.3
	sudo rm -fr StarCluster-0.93.3.tar.gz

	#Writing the config file.
	touch ~/.starcluster/config
	echo "[global]" >> ~/.starcluster/config
	echo "DEFAULT_TEMPLATE=default" >> ~/.starcluster/config
	echo "[aws info]" >> ~/.starcluster/config
	echo "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" >> ~/.starcluster/config
	echo "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" >> ~/.starcluster/config
	echo "AWS_USER_ID=$AWS_ACCOUNT_NUMBER" >> ~/.starcluster/config
	echo "[key $EC2_KEYPAIR_NAME]" >> ~/.starcluster/config
	echo "KEY_LOCATION=$EC2_KEYPAIR_LOCATION" >> ~/.starcluster/config
	echo "#KeyAddLocation" >> ~/.starcluster/config

	#This is the default cluster template.
	echo "[cluster default]" >> ~/.starcluster/config
	echo "KEYNAME=$EC2_KEYPAIR_NAME" >> ~/.starcluster/config
	echo "CLUSTER_SIZE = 20" >> ~/.starcluster/config

	echo "CLUSTER_USER = sgeadmin" >> ~/.starcluster/config
	#User 'sgeadmin' is required because ec2 AMIs connect using that username.

	echo "NODE_IMAGE_ID = ami-c10276a8" >> ~/.starcluster/config
	#This AMI is Ubuntu 12.04 64-bit with StarCluster support and Graphlab integration.(for VT-MLP)

	echo "NODE_INSTANCE_TYPE = t1.micro" >> ~/.starcluster/config
	#t1.micro instances are in the free tier.

	echo "Default cluster configuration: 20 t1.micro instances, with ami-c10276a8"
	echo "Configuration file written, view help in the starcluster tutorial to add/edit custom profiles and settings."
	#This completes the very basic configuration of MIT StarCluster.
	echo "#ClusterAddLocation" >> ~/.starcluster/config
else
	echo "Amazon API/AMI Tools installation incomplete, run install-ec2.sh again and retry."
	#Failed API/AMI Tools installation.

fi
