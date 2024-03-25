data "aws_ami" "amazon_linux" {
  most_recent = true
  filter {
    name   = "name"
    values = ["al2023-ami-2023.4.*-kernel-6.1-x86_64"]
  }

  owners = ["amazon"]
}

output "ami_id" {
  value = data.aws_ami.amazon_linux.image_id
}