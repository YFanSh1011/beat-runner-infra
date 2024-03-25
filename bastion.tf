data "aws_ami" "amazon_linux" {
  most_recent = true
  filter {
    name   = "name"
    values = ["al2023-ami-2023.4.*-kernel-6.1-x86_64"]
  }

  owners = ["amazon"]
}

resource "aws_instance" "bastion_host" {
  instance_type = "t2.micro"
  ami           = data.aws_ami.amazon_linux.image_id

  tags = merge(
    local.common_tags,
    tomap({ "Name" = "${local.prefix}-bastion" })
  )
}