resource "aws_key_pair" "devops" {
  key_name   = "devops-ec2-key"
  public_key = file("/home/vboxuser/.ssh/devops-ec2.pub")
}
