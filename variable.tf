variable "project_name"    {
        type = string
        default = "tf-ansible-nginx-web"
}
variable "aws_region"      {
        type = string
        default = "eu-north-1"
}
variable "access_key" {
        type = string
        sensitive = true
}

variable "secret_key" {
        type = string
        sensitive = true
}
variable "ami_id" {
        type    = string
        default = "ami-0d8d3b1122e36c000"
}
variable "ubuntu_ami" {
        type = string
        default = "ami-0030e4319cbf4dbf2"
}
variable "instance_type"   {
        type = string
        default = "t3.micro"
}
variable "ssh_key_name"    {
        type = string
} # existing AWS key pair name in global variable

variable "allow_ssh_cidr"  {
        type = string
        default = "0.0.0.0/0"
}
variable "http_cidr"       {
        type = string
        default = "0.0.0.0/0"
}
variable "tags" {
        type = map(string)
        default = { Owner = "MS", Env = "Dev" }
}
variable "private_key_path" {
        description = "Absolute path to the SSH private key (.pem) used by Ansible/SSH"
        type        = string
        default     = "~/Tf_ansible_Nginx_pro/myRSA_SSH_Key.pem"
}
