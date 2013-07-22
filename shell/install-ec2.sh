#!/bin/bash
#Install script for the Amazon EC2 AMI and API Tools. 
#Written by Abhimanyu Dubey for Dr. Dhruv Batra's MLP Laboratory, Virginia Polytechnic Institute and State University, 2013.
echo $1 $2 $3 $4 $5 $6 $7 $8 $9 ${10}
CDIR=$(pwd)
echo "Current Working Directory $CDIR"

#Install Java if not present.
if [ ! type java ]; then
if type yum
	then
	sudo yum -y install java-1.6.0-openjdk
else
	if type apt-get
	then
	sudo apt-get install openjdk-6-jre
	fi
fi
fi

#Install EC2 API and AMI Tools
if [ -d ~/.scm ]; then
	rm -f -r ~/.scm
fi
mkdir -p ~/.scm/ec2/tools
curl -o /tmp/ec2-api-tools.zip http://s3.amazonaws.com/ec2-downloads/ec2-api-tools.zip
unzip /tmp/ec2-api-tools.zip -d /tmp
cp -r /tmp/ec2-api-tools-*/* ~/.scm/ec2/tools
curl -o /tmp/ec2-ami-tools.zip http://s3.amazonaws.com/ec2-downloads/ec2-ami-tools.zip
unzip /tmp/ec2-ami-tools.zip -d /tmp
cp -rf /tmp/ec2-ami-tools-*/* ~/.scm/ec2/tools

#Setting up local paths in bash configuration and in a config file that will be used by StarCluster Config Generation.
touch ~/.scm/ec2/configsc
echo "#!/bin/bash" >> ~/.scm/ec2/configsc
echo "#Configuration Variables
export EC2_KEYPAIR_NAME=$6
export EC2_KEYPAIR_LOCATION=~/.scm/ec2/certificates/$6.pem
export EC2_BASE=~/.scm/ec2
export EC2_HOME=~/.scm/ec2/tools
export EC2_PRIVATE_KEY=~/.scm/ec2/certificates/ec2-pk.pem
export EC2_CERT=~/.scm/ec2/certificates/ec2-cert.pem
export EC2_URL=https://ec2.amazonaws.com
export AWS_ACCOUNT_NUMBER=$3
export AWS_ACCESS_KEY_ID=$1
export AWS_SECRET_ACCESS_KEY=$2
export PATH=$PATH:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:~/.scm/ec2/tools/bin
export JAVA_HOME=/usr" | tee ~/.scm/ec2/configsc >> ~/.bashrc

#Copy Certs
if [ -f $4 ]
	then
	mkdir -p ~/.scm/ec2/certificates
	cp $4 ~/.scm/ec2/certificates/ec2-cert.pem
	echo "Certificate Written."
else
	if [ -f $CDIR/$4 ]
	then
		mkdir -p ~/.scm/ec2/certificates
		cp $CDIR/$4 ~/.scm/ec2/certificates/ec2-cert.pem
		echo "Certificate Written."
	fi
fi
if [ -f $5 ]
	then
	mkdir -p ~/.scm/ec2/certificates
	cp $5 ~/.scm/ec2/certificates/ec2-pk.pem
	echo "S3 PrivateKey Written."
else
	if [ -f $CDIR/$5 ]
	then
		mkdir -p ~/.scm/ec2/certificates
		cp $CDIR/$5 ~/.scm/ec2/certificates/ec2-pk.pem
		echo "S3 PrivateKey Written."
	fi
fi
if [ -f $7 ]
	then
	cp $7 ~/.scm/ec2/certificates/$6.pem
	chmod 400 ~/.scm/ec2/certificates/$6.pem
	echo "EC2 PrivateKey Written."
else
	if [ -f $CDIR/$7 ]
	then
		cp $CDIR/$7 ~/.scm/ec2/certificates/$6.pem
		chmod 400 ~/.scm/ec2/certificates/$6.pem
		echo "EC2 PrivateKey Written."
	fi
fi
echo "Installation of EC2 Completed Successfully."
