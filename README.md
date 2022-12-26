# aws-cli-utils
This is the project to collect helpful aws cli commandline with complex options to support your working
## Why I want to write this project.
- Sometimes, aws cli is list, get, describes. It is pretty hard to remmebers.
- Sometimes, you want to add more options on purpose and you want to have a place to collect and reuse it in the future. That is the reason I defined that structure to help me collect helpful commandlines and share on the github.



## Setup dependencies
```
brew install remind101/formulae/assume-role
brew install peco

# This password is used to encrypt your tmp credential.
echo "random_string" > ~/.password_assume_role_encrypted
```


## Settings when open terminal
```
echo "source /opt/lamhaison-tools/aws-cli-utils/main.sh" >> ~/.bashrc
```


## Setting on ~/.aws/config

```

[PROFILE_NAME-dev]
region = region
role_arn = arn:aws:iam::ACCOUNT_NAME:role/PROFILE_NAME-dev
source_profile = SOURCE_PROFILE
mfa_serial = arn:aws:iam::ACCOUNT_NAME_MFA:mfa/ACCOUNT_NAME

[PROFILE_NAME-stg]
region = region
role_arn = arn:aws:iam::ACCOUNT_NAME:role/PROFILE_NAME-stg
source_profile = SOURCE_PROFILE
mfa_serial = arn:aws:iam::ACCOUNT_NAME_MFA:mfa/ACCOUNT_NAME


[PROFILE_NAME-prd]
region = region
role_arn = arn:aws:iam::ACCOUNT_NAME:role/PROFILE_NAME-prod
source_profile = SOURCE_PROFILE
mfa_serial = arn:aws:iam::ACCOUNT_NAME_MFA:mfa/ACCOUNT_NAME
```


## How to use
```
# Input your MFA
admin@MacBook-Pro-cua-Admin ~ % aws_assume_role_set_name PROFILE_NAME-dev
You set the assume role name PROFILE_NAME-dev
Running assume-role PROFILE_NAME-dev
MFA code: 165933
Encrypt temporary credential for assume-role PROFILE_NAME-dev at /tmp/aws_temporary_credentials/PROFILE_NAME-dev.zip
~
{
    "AccountAliases": [
        "PROFILE_NAME"
    ]
}
AccountId 1110987654321 


admin@MacBook-Pro-cua-Admin aws_cli_results % aws_ec2_list
------------------------------------------------------------------------------------------------------
|                                          DescribeInstances                                         |
+---------------------+---------------------------------+---------------+----------------+-----------+
|     InstanceId      |              Name               |   PrivateIp   |   PublicIp     |   State   |
+---------------------+---------------------------------+---------------+----------------+-----------+
|  i-0512340c9dc5fb531|  demo-dev-jenkins-master        |  x.x.x.x      |  1.123.123.123 |  running  |
|  i-0712343f1a9565397|  demo-dev-mongodb-master        |  y.y.y.y      |  1.123.123.123 |  running  |
+---------------------+---------------------------------+---------------+----------------+-----------+
```