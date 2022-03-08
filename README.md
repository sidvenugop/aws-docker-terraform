# aws-docker-terraform

This Repo performs below actions
-> Creates VPC, subnet and does association with route table.
-> Launches EC2 within VPC using above subnet.
-> Creates Role for S3 bucket and adds read/write policies and gives EC2 access to it.
-> Cretaes S3 bucket and assigns above role to it.
-> Cretaes init script to run docker.sh as a service so that container comes up after every reboot.
-> docker.sh pulls image and runs the container on port 8080.

 USAGE
 
 -> Clone the repo and run below commands to have the resources created
 
 -> ssh-keygen -f dunhumby-key-pair
-> terraform init
-> terraform plan -out terraform.out
-> terraform apply terraform.out
