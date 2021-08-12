resource "aws_vpc" "network" {
  cidr_block           = "10.0.0.0/24"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "spacenet"
  }
}

resource "aws_subnet" "subnet" {
  cidr_block        = aws_vpc.network.cidr_block
  vpc_id            = aws_vpc.network.id
  availability_zone = "eu-central-1a"
}

resource "aws_security_group" "ingress" {
  name = "allow-all-sg"

  vpc_id = aws_vpc.network.id

  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]

    from_port = 22
    to_port   = 22
    protocol  = "tcp"
  }

  egress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]

    from_port = 0
    to_port   = 0
    protocol  = "-1"
  }

}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.network.id
  tags = {
    Name = "gateway"
  }
}

resource "aws_route_table" "route-table" {
  vpc_id = aws_vpc.network.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }

  tags = {
    Name = "route-table"
  }
}

resource "aws_route_table_association" "subnet-association" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.route-table.id
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-hirsute-21.04-amd64-server-20210720"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  key_name               = var.key_pair_name
  vpc_security_group_ids = [aws_security_group.ingress.id]
  subnet_id              = aws_subnet.subnet.id

  tags = {
    Name = "AstroneerServer"
  }
}

resource "aws_eip" "elastic_ip" {
  instance = aws_instance.server.id
  vpc      = true
}
