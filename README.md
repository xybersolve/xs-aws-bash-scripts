# xs-aws-bash-scripts

> Bash script that encapsulates AWS cli interface to make it easier to use in
real admin. A work in progress

## Scripts:
* alm: Alarms
* asg: Auto-Scaling Groups
* dist: Distribute scripts to script bin and bastion servers
* ec2: Elastic Compute Cloud (vpc, subnets, security groups, instances, etc)
* eip: Elastic IPs
* img: AMI Images
* mon: Monitoring
* namespaces*: Namespace in monitoring
* r53: Route53
* rds: Relation Database Service

#### ec2

```sh
Script: ec2
Purpose: Wrapper to ec2.sh library rouines
Usage: ec2 [options]

Options:
  --help:  help and usage
  --version: show version info
  --get-image-id[=os name]
  --get-vpc-id[=vpc name]: Get the VPC Id
  --get-sg-id[=security group name]: Get security group id
  --get-pub-sub-id[=vpc name]: Get public subnets, using VPC name
  --get-inst-id-by-name=<instance name>: Get instance id by name
  --get-inst-by-id=<id>: get instance by id
  --get-inst-all-regions: Get instances across all regions
  --delete-key-pair=<keypair name>: Delete key pair by name
  --show-instances: Show a table of all instances
  --start-inst=<instance name>: Start an instance by name
  --stop-inst=<instance name>: Stop an instance by name
  --terminate-inst=<instance name>: Terminate instance by name
  --change-inst-type=<instance name>: change type of instance
  --create-image: Take snapshot AMI of instance

  --region=<region>: Set region

Examples:
  --get-vpc-id=*prod* --region=us-west-2
  --get-subnets=*staging*
  --get-pub-sub-id=*web*
  --get-image-id=ubuntu --region=us-west-2
  --get-sg-id=*internal
  --get-inst-by-id=i-0a3d3a9663d252ebd
  --get-inst-id-by-name=*web*
  --show-instances
  --start-inst=*staging-web*
  --stop-inst=*staging-web*
  --terminate-inst=*prod-web1
  --change-inst-type=*prod-web2 --type=t2.micro
  --change-inst-type=*prod-web2 --type=t2.medium
  --create-image=*prod-web2 --image=Web2

```

TODO
- [ ] Move all image related routines to img (out of ec2)
- [ ] Make ec2.sh lib scripts independent ec2 (e.g., no config)
- [ ] Create sh lib for every script category (img, alm, etc)

## [License](LICENSE.md)
