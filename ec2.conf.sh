#
# Default configuration for ec2 routines
#
# AWS Variables
declare REGION='us-west-2'
declare VPC_NAME='xybersolve-prod'
declare KEY_NAME='transible-key'
declare SECURITY_GROUP_NAME='docker-machine-sg'
declare IMAGE_OS='ubuntu' # ubuntu, trusty, xenial, amazon, linux

# Infrastructure Variables
declare VPC_ID=''
declare SUBNET_ID=''
declare IMAGE_ID=''
declare SECURITY_GROUP_ID=''

# global support definitions
declare _xsRESET='\e[0m'
declare _xsDEFAULT='\e[39m'
declare _xsRED='\e[31m'
declare _xsGREEN='\e[32m'
declare _xsYELLOW='\e[33m'
declare _xsBLUE='\e[34m'
declare _xsMAGENTA='\e[35m'
declare _xsCYAN='\e[36m'
declare _xsLIGHTGRAY='\e[37m'
declare _xsDARKGRAY='\e[90m'
declare _xsLIGHTRED='\e[91m'
declare _xsLIGHTGREEN='\e[92m'
declare _xsLIGHTYELLOW='\e[93m'
declare _xsLIGHTBLUE='\e[94m'
declare _xsLIGHTMAGENTA='\e[95m'
declare _xsLIGHTCYAN='\e[96m'
declare _xsWHITE='\e[97m'
