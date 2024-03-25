resource "aws_instance" "bastion_host" {
  instance_type = "t2.micro"
  ami           = data.aws_ami.amazon_linux.image_id

  tags = merge(
    local.common_tags,
    map("Name", "${local.prefix}-bastion")
  )
}