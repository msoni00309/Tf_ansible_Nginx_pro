[web]
${public_ip} ansible_user=ec2-user ansible_ssh_private_key_file=${pem_path} ansible_ssh_common_args='-o StrictHostKeyChecking=no'

[ubuntuweb]
${ubuntu_public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=${pem_path} ansible_ssh_common_args='-o StrictHostKeyChecking=no'
