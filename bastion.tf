data "aws_ami" "amazon_linux" {
  most_recent = true
  filter {
    name   = "name"
    values = ["al2023-ami-2023.4.*-kernel-6.1-x86_64"]
  }

  owners = ["amazon"]
}

resource "aws_instance" "bastion" {
  instance_type        = "t2.micro"
  user_data            = file("./templates/bastion/user-data.sh")
  ami                  = data.aws_ami.amazon_linux.image_id
  iam_instance_profile = aws_iam_instance_profile.bastion.name

  tags = merge(
    local.common_tags,
    tomap({ "Name" = "${local.prefix}-bastion" })
  )
}

resource "aws_iam_role" "bastion" {
  name               = "${local.prefix}-bastion"
  assume_role_policy = file("./templates/bastion/instance-profile-policy.json")

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "bastion_attach_policy" {
  role       = aws_iam_role.bastion.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_instance_profile" "bastion" {
  name = "${local.prefix}-bastion-instance-profile"
  role = aws_iam_role.bastion.name
}