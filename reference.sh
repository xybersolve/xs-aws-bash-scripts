#
# General notes
#

:<<'FILTERS'
--filters "Name=string,Values=string,string"

* describe-instances
  --filters "Name=instance-type,Values=m1.small"
  --filters Name=vpc-id,Values=vpc-e2f17e8b
  --instance-ids i-1234567890abcdef0
  # all instances with tag key 'Owner'
  --filters "Name=tag-key,Values=Owner"
  --filters "Name=tag:Purpose,Values=test"
  # multiple
  --filters "Name=instance-type,Values=m1.small,m1.medium" "Name=availability-zone,Values=us-west-2c"
  --filters file://filters.json

filters.json
[
  {
    "Name": "instance-type",
    "Values": ["m1.small", "m1.medium"]
  },
  {
    "Name": "availability-zone",
    "Values": ["us-west-2c"]
  }
]
FILTERS

:<<'QUERIES'
--query 'Reservations[].Instances[].["Tags[*][?Key==Name].Value[]'
--query 'Reservations[].Instances[].{id: InstanceId, tagvalue: Tags[*][?Key==`Name`].Value}'
--query 'Reservations[].Instances[].SecurityGroups[?GroupName==default].GroupId'
--query 'Reservations[].Instances[].[ InstanceId,[Tags[?Key==Name].Value][0][0],State.Name,InstanceType,Placement.AvailabilityZone ]'
QUERIES
