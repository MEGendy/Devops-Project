data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "web" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.web.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  associate_public_ip_address = true
  key_name = aws_key_pair.devops.key_name
  user_data = <<-EOF
    #!/bin/bash
    dnf install -y docker
    systemctl enable --now docker

    aws ecr get-login-password --region us-east-1 \
      | docker login --username AWS --password-stdin 530751149473.dkr.ecr.us-east-1.amazonaws.com

    docker pull 530751149473.dkr.ecr.us-east-1.amazonaws.com/docker-lab:1.0
    docker run -d --name my-web --restart unless-stopped -p 80:80 \
      530751149473.dkr.ecr.us-east-1.amazonaws.com/docker-lab:1.0
  EOF

  tags = {
    Name = "devops-web-server"
  }
}
