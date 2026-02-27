output "public_ips" {
  value = {
    amazon_linux = aws_instance.web.public_ip
    ubuntu_linux = aws_instance.ubuntu_web.public_ip
  }
}

output "ssh_examples" {
  value = {
    amazon_linux = "ssh -i /home/ec2-user/tf-ansible-nginx-web/myRSA_SSH_Key.pem ec2-user@${aws_instance.web.public_ip}"
    ubuntu_linux = "ssh -i /home/ec2-user/tf-ansible-nginx-web/myRSA_SSH_Key.pem ubuntu@${aws_instance.ubuntu_web.public_ip}"
  }
}

output "http_urls" {
  value = {
    amazon_linux = "http://${aws_instance.web.public_ip}"
    ubuntu_linux = "http://${aws_instance.ubuntu_web.public_ip}"
  }
}
