output "public_ip" {
  value = aws_instance.web.public_ip
  value = aws_instance.ubuntu_web.public_ip
}
output "ssh_example" {
  value = "ssh -i /home/ec2-user/tf-ansible-nginx-web/myRSA_SSH_Key.pem ec2-user@${aws_instance.web.public_ip}"
  value = "ssh -i /home/ec2-user/tf-ansible-nginx-web/myRSA_SSH_Key.pem ubuntur@${aws_instance.ubuntu_web.public_ip}"
}
output "http_url" {
  value = "http://${aws_instance.web.public_ip}"
  value = "http://${aws_instance.ubuntu_web.public_ip}"
}
