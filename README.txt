This will create A VPC with 6 subnets, and an internet GW 
  3 Private and 3 public 
  Amazon will create each subnet in three different availability zones specified in the var.azs
       availability_zone = element(var.azs, count.index).
  NOTE - You can also associate each subnet to a specific available zone by specify just one zone 
        availability_zone = element(var.azs, 0)  see the mgmt subnet
This also create Security Groups for Web, App and DB servers.
  Allows WebServers talk to AppServers
  Allows AppServers talk to DBServers
  Allows the world talk to WebServers on HTTPS
  Allow SSH from a restricted network.
  Allow SSH between Web Servers
  Allow SSH between App Servers
  Allow SSH between DB Servers

Please modify the vars.tf file to match your environments.
Please also some useful aws cli realated to SG sg-cmdline.txt file 
There is a quick instruction on how to create your AWS credential (how2crAWSkey.txt).

Please see the vpc-info.png file for more info relationship between vpc, subnet, 
availability zones, and security groups.
