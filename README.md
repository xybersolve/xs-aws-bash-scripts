# xs-aws-bash-scripts

Bash script that encapsulates AWS cli to make it easier to use in
real world admin. While orchestration is better handled with high level tool,
like Terraform, awscli is extremely useful for managing resources from
the command line.

> This is a work in progress. Ultimately, I want detachable lib scripts
(ext: *.sh), which can be consumed by any other script, with no dependencies.
They will be fronted by a script of the same name (minus .sh), which will act
as a utility interface. So far, the closest to this goal is ec2 & ec2.sh.


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
    ec2 --get-vpc-id=*prod* --region=us-west-2
    ec2 --get-subnets=*prod-staging*
    ec2 --get-pub-sub-id=*prod-web*
    ec2 --get-public-ip=*prod-web2
    ec2 --get-image-id=ubuntu --region=us-west-2
    ec2 --get-sg-id=*internal
    ec2 --get-inst-by-id=i-0a3d3a9663d252ebd
    ec2 --get-inst-id-by-name=*web*
    ec2 --show-instances
    ec2 --start-inst=*staging-web*
    ec2 --stop-inst=*staging-web*
    ec2 --terminate-inst=*prod-web1
    ec2 --change-inst-type=*prod-web2 --type=t2.micro
    ec2 --change-inst-type=*prod-web2 --type=t2.medium
    ec2 --create-image=*prod-web2 --image=Web2

```
#### img
> sources ec2.sh

```sh
Script: img
Purpose: Manage AWS Images
Usage: img [options]

Options:
  --help:  help and usage
  --version: show version info
  --get-ami-id=<ami type>: Get EC2 AMI id
  --create=<instance name>: Create AMI Image from instance (stop, create & start)
  --image=<name>: Set image name

Examples:
  img --get-ami-id=ubuntu (ubuntu, trusty, xenial, amazon, linux)
  img --create=*prod-web2 --image=prod-web2


```

TODO
- [ ] Move all image related routines to img (out of ec2)
- [ ] Make ec2.sh lib routines independent (e.g., no config or dependencies)
- [ ] Create sh lib for every script category (img, alm, etc), move actual routines to lib scripts.

## [License](LICENSE.md)
