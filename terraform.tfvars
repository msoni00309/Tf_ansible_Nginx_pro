project_name   = "tf-ansible-nginx-web"
aws_region     = "us-east-1"
instance_type  = "t3.micro"
ssh_key_name   = "myRSA_SSH_Key"  # must exist in EC2 -> Key Pairs
allow_ssh_cidr = "0.0.0.0/0" # replace with inhouse network egress or your home IP
access_key     = ""
secret_key     = ""
