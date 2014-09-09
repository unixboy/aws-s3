#!/bin/sh
export EC2_AMI_DIR = /ec2-ami-tools
export EC2_KEY_DIR = /ebs/resource_library
# Account identifiers
export EC2_ACC=abc
export EC2_PRIVATE_KEY=$EC2_KEY_DIR/pk-ABC.pem
export EC2_CERT=$EC2_KEY_DIR/cert-XXXXXXX.pem
export ACCESS_KEY=XXXXXXXXXXXX
export SECRET_KEY=XXXXXXXXXXXX
export JAVA_HOME=/usr# Directories that you don't want imaged
export EXCLUDED_DIRS=/ebs/resource_library,/ebs/www,/tmp,/proc,/mnt,/sys/,/dev/shm,/dev/pts,/lib/init/rw,/dev
export AMI_NAME_PREFIX=ec2-ami
export EC2_HOME=$EC2_AMI_DIR
export PATH=$PATH:$EC2_AMI_DIR/bin
TODAY=`date +%Y-%m-%d`
export AMI_NAME=$AMI_NAME_PREFIX-$TODAY
function upload_to_s3() {
ec2-upload-bundle -b $AMI_NAME -m /mnt/$AMI_NAME.manifest.xml -a $ACCESS_KEY -s $SECRET_KEY
if [ $? -ne 0 ]; then
upload_to_s3
else
rm -rf /mnt/$AMI_NAME*
fi
}
ec2-bundle-vol -c $EC2_CERT -k $EC2_PRIVATE_KEY -u $EC2_ACCNO -e $EXCLUDED_DIRS -d /mnt -p $AMI_NAME
upload_to_s3
