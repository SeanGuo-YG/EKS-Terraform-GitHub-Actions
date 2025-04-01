resource "aws_security_group" "jump_sg" {
  name        = "web-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "jump-sg"
  }
}

resource "aws_instance" "ubuntu_server" {    
  ami                    = "ami-09e143e99e8fa74f9" #Ubuntu Server 24.04 LTS (HVM)
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public-subnet[0].id
  vpc_security_group_ids = [aws_security_group.jump_sg.id]
  key_name               = var.jump-key-name
  user_data     = file("user-data.sh")

  tags = {
    Name = "UbuntuServer-JumpBox"
  }
}
