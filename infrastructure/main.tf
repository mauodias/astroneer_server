data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-hirsute-21.04-amd64-server-20210720"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "server" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  tags = {
    Name = "AstroneerServer"
  }
}
