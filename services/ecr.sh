#!/bin/bash

aws_ecr_list_repo() {
	aws_run_commandline "aws ecr describe-repositories --query \"*[].repositoryArn\""
}

aws_ecr_login() {
	aws ecr get-login-password --region ${AWS_REGION} | docker login \
		--username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
}

aws_ecr_list_images() {
	aws_ecr_repo_name=$1
	cat <<-_EOF_
		Get images from ecr repo ${aws_ecr_repo_name:?Repo is not set or empty}
		Pull image [ docker pull ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${aws_ecr_repo_name:?Repo is not set or empty}:${image_tag:=latest} ]
	_EOF_

	aws_run_commandline "aws ecr list-images --repository-name ${aws_ecr_repo_name} --query 'imageIds[].{imageTag:imageTag}'"
}

aws_ecr_get_latest_image() {
	aws_ecr_repo_name=$1

	cat <<-_EOF_
		Get images from ecr repo ${aws_ecr_repo_name:?Repo is not set or empty}
		Pull image [ docker pull ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${aws_ecr_repo_name:?Repo is not set or empty}:${image_tag:=latest} ]
	_EOF_

	aws_run_commandline "aws ecr list-images --repository-name ${aws_ecr_repo_name} --query 'imageIds[0].{imageTag:imageTag}'"
}

aws_ecr_get_latest_image_with_hint() {
	echo "Your repository name >"
	aws_ecr_get_latest_image $(echo "$(peco_aws_ecr_list_repositorie_names)" | peco)
}

aws_ecr_list_images_with_hint() {
	echo "Your repository name >"
	aws_ecr_list_images $(echo "$(peco_aws_ecr_list_repositorie_names)" | peco)
}

aws_ecr_get_image() {
	aws_ecr_repo_name=$1
	aws_ecr_repo_image_tag=$2

	cat <<-_EOF_
		Get images from ecr repo ${aws_ecr_repo_name:?Repo is not set or empty}
		Pull image [ docker pull ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${aws_ecr_repo_name:?Repo is not set or empty}:${aws_ecr_repo_image_tag:=latest} ]
	_EOF_

	docker pull \
		${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${aws_ecr_repo_name:?Repo is not set or empty}:${aws_ecr_repo_image_tag:=latest}
}

aws_ecr_pull_image_with_hint() {
	echo "Your repository name >"
	aws_ecr_repo_name=$(echo "$(peco_aws_ecr_list_repositorie_names)" | peco)
	echo "Your image tag for ${aws_ecr_repo_name:?'aws_ecr_repo_name is unset or empty'} >"
	aws_ecr_repo_image_tag=$(echo "$(peco_aws_ecr_list_images ${aws_ecr_repo_name})" | peco)
	aws_ecr_get_image \
		${aws_ecr_repo_name:?'aws_ecr_repo_name is unset or empty'} \
		${aws_ecr_repo_image_tag:?'aws_ecr_repo_image_tag is uset or empty'}

}
