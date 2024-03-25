data "aws_ami" "amazon_linux" {
  most_recent = true
  filter {
    name   = "name"
    values = ["al2023-ami-2023.4.*-kernel-6.1-x86_64"]
  }

  owners = ["amazon"]
}

resource "aws_instance" "bastion" {
  instance_type          = "t2.micro"
  user_data              = file("./templates/bastion/user-data.sh")
  ami                    = data.aws_ami.amazon_linux.image_id
  iam_instance_profile   = aws_iam_instance_profile.bastion.name
  key_name               = var.bastion_key_name
  subnet_id              = aws_subnet.public_a.id
  vpc_security_group_ids = [aws_security_group.bastion.id]

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

resource "aws_security_group" "bastion" {
  name   = "${local.prefix}-bastion"
  vpc_id = aws_vpc.main.id

  tags = local.common_tags
}

resource "aws_vpc_security_group_ingress_rule" "allow_inbound_ssh" {
  security_group_id = aws_security_group.bastion.id
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "allow_outbound_http" {
  security_group_id = aws_security_group.bastion.id
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "allow_outbound_https" {
  security_group_id = aws_security_group.bastion.id
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "allow_outbound_private_postgres" {
  security_group_id            = aws_security_group.bastion.id
  ip_protocol                  = "tcp"
  from_port                    = 5432
  to_port                      = 5432
  referenced_security_group_id = aws_db_subnet_group.main.id
}