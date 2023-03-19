This will create A VPC with 6 subnets, and an internet GW 
  3 Private and 3 public (web,app,db subnets)
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
