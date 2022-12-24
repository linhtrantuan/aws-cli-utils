
export assume_role_password_encrypted=`cat ~/.password_assume_role_encrypted`
export tmp_credentials=/tmp/aws_temporary_credentials
export aws_cli_results="$(echo ~/aws_cli_results)"
export aws_cli_history=${aws_cli_results}/history.json

# TODO Later
export AWS_CLI_SOURCE_SCRIPTS="/opt/lamhaison-tools/aws-cli-utils"

mkdir -p ${tmp_credentials}
mkdir -p ${aws_cli_results}

# add some help aliases
alias get-account-alias='aws iam list-account-aliases'
alias get-account-id='echo AccountId $(aws sts get-caller-identity --query "Account" --output text)'
alias aws-cli-save-commandline-to-history='history -1 >> ${aws_cli_history}'
alias aws-cli-save-all-commandlines-to-history='history |grep aws | grep -v history >> ${aws_cli_history}'


# Import sub-commandline.
for script in $(ls ${AWS_CLI_SOURCE_SCRIPTS}/services)
do
	source ${AWS_CLI_SOURCE_SCRIPTS}/services/$script
done



