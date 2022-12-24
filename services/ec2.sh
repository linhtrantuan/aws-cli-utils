#!/bin/bash

# AWS ec2
aws_ec2_list() {
	aws ec2 describe-instances --query 'Reservations[].Instances[].{Name: Tags[?Key==`Name`].Value | [0], InstanceId:InstanceId,PrivateIp:PrivateIpAddress,PublicIp:PublicIpAddress,State:State.Name}' --output table
}

aws_ec2_get() {
	instance_id=$1
	aws ec2 describe-instances --instance-ids $instance_id
}

aws_ec2_reboot() {
	instance_id=$1
	echo "Reboot the ec2 instance ${instace_id}"
	aws ec2 reboot-instances --instance-ids $instance_id
}


aws_ec2_list_images() {
	aws ec2 describe-images --owners self
}
aws_ec2_create_image() {
	instance_id=$1
	aws_ec2_instance_name=$(aws ec2 describe-instances \
		--instance-ids $instance_id \
		--query 'Reservations[*].Instances[*].{Tags:Tags[?Key == `Name`] | [0].Value}' \
		--output text)

	aws ec2 create-image \
	    --no-reboot \
	    --instance-id $instance_id \
	    --name ${aws_ec2_instance_name}-`date '+%Y-%m-%d-%H-%M-%S'` \
	    --description ${aws_ec2_instance_name}-`date '+%Y-%m-%d-%H-%M-%S'` \
	    --query "ImageId" --output text
}

aws_ec2_get_image() {
	image_id=$1
	aws ec2 describe-images --image-ids $image_id
}
