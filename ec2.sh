#!/usr/bin/env bash

declare -r EC2_CONFIG_FILE=~/bin/ec2.conf.sh

source "${EC2_CONFIG_FILE}" \
  || { echo "Unable to open EC2 config file: ${EC2_CONFIG_FILE}"; exit 1; }

__get_region_names() {
  aws ec2 describe-regions \
    --query "Regions[*].RegionName" \
    --output text
}

__get_vpc_id() {
  local vpc_name=${1:-${VPC_NAME}}
  # if not pre-assined
  if [[ -z ${VPC_ID} ]]; then
    VPC_ID=$( \
      aws ec2 describe-vpcs \
        --filters "Name=tag:Name,Values=${vpc_name}" \
        --query 'Vpcs[*].VpcId' \
        --output text
    )
  fi
  echo "${VPC_ID}"
}

__get_public_subnet_id() {
  local vpc_name=${1:?vpc name is required}
  #local -r public_filter='Name=tag:Tier,Values=public'
  #local -r vpc_filter="Name=vpc-id,Values=${VPC_ID}"
  local -r name_tag_filter="Name=tag:Name,Values=${vpc_name}-public*"
  local -r query='Subnets[*].SubnetId'
  #--filters "${public_filter}" \
  #  "${public_filter}" \

 # if not pre-assined
  if [[ -z ${SUBNET_ID} ]]; then
    SUBNET_ID=$( \
      aws ec2 describe-subnets \
        --filters  \
          "${name_tag_filter}" \
          --query "${query}" \
          --output text
    )
  fi
  echo "${SUBNET_ID}"
}

__get_subnets() {
  local vpc_id=${1:-${VPC_ID}}
  local -r vpc_id_filter="Name=vpc-id,Values=${vpc_id}"

  __get_vpc_id && {
    aws ec2 describe-subnets \
      --filters "${vpc_id_filter}"
  }
}

__get_network_acls() {
  local vpc_name="${1:-${VPC_NAME}}"
  local VPC_ID=$( __get_vpc_id "${vpc_name}" )

  aws ec2 describe-network-acls \
    --filters Name=vpc-id,Values=${VPC_ID}
}

__get_image_id() {
  local region=${1:-${REGION}}
  local os=${2:-${IMAGE_OS}}
  local query='Images[*].[ImageId,CreationDate]'
  #local owner=amazon
  #local state=available
  #local architecture=x86_64

  # amzn-ami-hvm-2017.03.0.20170417-x86_64-gp2
  # ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-20170414
  [[ -z ${os} ]] && die "OS is required field: --os=<os>"
  local -A os_name=(
    ['ubuntu']='ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64*'
    ['trusty']='ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64*'
    ['xenial']='ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*'
    ['amazon']='amzn-ami-hvm*'
    ['linux']='amzn-ami-hvm*'
  )
  local name="${os_name[${os}]:-${os_name['trusty']}}"
  local filter="Name=name,Values=${name}"
  # if not pre-assined
  if [[ -z ${IMAGE_ID} ]]; then
    # get first image in list sorted in reverse by creation date
    IMAGE_ID=$(aws ec2 describe-images \
      --filters "${filter}" \
      --query "${query}" \
      --output text \
        | sort -k2 -r \
        | head -n1 \
        | awk {'print $1'} )
  fi

  echo "${IMAGE_ID}"
}

__get_security_group_id() {
  local security_group_name=${1:-${SECURITY_GROUP_NAME}}
  local filter="Name=tag:Name,Values=${security_group_name}"
  local query="SecurityGroups[*].GroupId"

  SECURITY_GROUP_ID=$(
    aws ec2 describe-security-groups \
      --filters "${filter}" \
      --query "${query}" \
      --output text
  )

  echo ${SECURITY_GROUP_ID}
}

__create_security_group(){
  SECURITY_GROUP_ID=$(
    aws ec2 create-security-group \
      --group-name adminsg \
      --description "admin security group" \
      --vpc-id ${VPC_ID} \
      --output text \
      --query 'GroupId'
   )

   aws ec2 authorize-security-group-ingress \
      --group-id $vpcdbsg_id \
      --source-group $vpcadminsg_id \
      --protocol tcp
      --port 3306
}

__delete_key_pair() {
  local -r key_name="${1:-${KEY_NAME}}"

  aws ec2 delete-key-pair \
    --region ${REGION} \
    --key-name "${key_name}"
}

__show_instances() {
  aws ec2 describe-instances \
  --query 'Reservations[*].Instances[*].{Id:InstanceId,Pub:PublicIpAddress,Pri:PrivateIpAddress,State:State.Name}' \
  --output table
}

__get_all_instance_ids() {
  aws ec2 describe-instances \
    --query 'Reservations[*].Instances[*].[InstanceId]' \
    --output text
}

__get_running_instance_ids() {
  aws ec2 describe-instances \
    --query 'Reservations[*].Instances[*].[InstanceId]' \
    --filters "Name=instance-state-name,Values=running" --output text
}


__get_instance_id_by_name() {
  local name="${1:?name is a required parameter}"

  aws ec2 describe-instances \
    --query 'Reservations[*].Instances[*].[InstanceId]' \
    --filters "Name=tag:Name,Values=${name}" \
    --output text
}

__get_instance_by_environment() {
  aws ec2 describe-instances --output table --query \
  'Reservations[*].Instances[*].[Tags[?Key==`Name`]|[0].Value,Tags[?Key==`Environment `]|[0].Value,InstanceId,InstanceType,PublicIpAddress,PrivateIpAddress,Placement.AvailabilityZone]' \
 --filters Name=tag:Environment,Values=Production

}

__get_instance_by_id() {
  local -r instance_id=${1:?Instance ID is a required argument}
  #wget -q -O - http://169.254.169.254/latest/meta-data/instance-id
  aws ec2 describe-instances --instance-ids "${instance_id}"
}

__get_instances_by_region() {
  local region="${1:?region argument is required}"
  aws ec2 --region "${region}" describe-instances --query \
    'Reservations[*].Instances[*].[Tags[?Key==`Name`]|[0].Value,Tags[?Key==`Environment `]|[0].Value,InstanceId,InstanceType,PublicIpAddress,PrivateIpAddress,Placement.AvailabilityZone]' \
    --output text
}

__get_instances_all_regions() {
  local regions=($( __get_region_names ))

  for region in "${regions[@]}"; do
    printf "\n${_xsLIGHTYELLOW}Region: %s${_xsRESET}\n" "${region}"
    __get_instances_by_region "${region}"
  done
}

__get_instance_attributes() {
  echo "__get_instance_attributes"
  local instance_name=${1:?Instance name is requiredF argument}
  local instance_id=$( __get_instance_id_by_name "${instance_name}" )
  echo "__get_instance_attributes: ${instance_name}, ${instance_id}"

  aws ec2 describe-instance-attribute \
   --instance-id ${instance-id} \
   --attribute disableApiTermination

}

__start_instance() {
  local name=${1:?name argument is required}
  INSTANCE_ID=$( __get_instance_id_by_name "${name}" )
  #echo "Starting: ${INSTANCE_ID}"; return;
  aws ec2 start-instances \
    --instance-id "${INSTANCE_ID}"
}

__stop_instance() {
  local name=${1:?name argument is required}
  INSTANCE_ID=$( __get_instance_id_by_name "${name}" )
  aws ec2 stop-instances \
    --instance-id "${INSTANCE_ID}"

  aws ec2 wait instance-stopped \
    --instance-ids "${INSTANCE_ID}"
}

__terminate_instance() {
  local name=${1:?name argument is required}
  INSTANCE_ID=$( __get_instance_id_by_name "${name}" )
  echo "Terminate: ${INSTANCE_ID}"
  return
  aws ec2 terminate-instances \
    --instance-ids "${INSTANCE_ID}"
}

__change_instance_type() {
  local name=${1:?name argument is required}
  local type=${2:?type argment is required}
  INSTANCE_ID=$( __get_instance_id_by_name "${name}" )
  echo "INSTANCE_ID: ${INSTANCE_ID}"
  echo "INSTANCE_TYPE: ${INSTANCE_TYPE}"
  return

  echo "Stopping instance..."
  aws ec2 stop-instances \
    --instance-id "${INSTANCE_ID}"

  echo "Waiting for instance to stop..."
  aws ec2 wait instance-stopped \
    --instance-ids "${INSTANCE_ID}"

  echo "Modifying instance type..."
  aws ec2 modify-instance-attribute \
    --instance-id "${INSTANCE_ID}" \
    --instance-type "${INSTANCE_TYPE}"

  echo "Wait 3 seconds..."
  sleep 3

  echo "Starting instance..."
  aws ec2 start-instances \
    --instance-id "${INSTANCE_ID}"

  echo "Waiting for instance to start..."
  aws ec2 wait instance-running \
    --instance-ids "${INSTANCE_ID}"
}

__create_tag() {
  tag_name="${1}"
  tag_vale="${2}"

  aws ec2 create-tags --tags 'Key=Scope,Value="Linux Server Management"' --resources i-yyyyyyyy i-xxxxxxxx
}



# ----------------------------------
# RDS
#
# TODO:  RDS routines will be moved to 'rds.sh' and 'rds', with 'common.sh' (regions)
#
__get_rds_by_region() {
  local region="${1:?region argument is required}"

  aws rds --region "${region}" describe-db-instances \
    --output text
}

__get_rds_all_regions() {
  local regions=($( __get_region_names ))

  for region in "${regions[@]}"; do
    printf "\nRegion: %s\n" "${region}"
    __get_rds_by_region "${region}"
  done
}
