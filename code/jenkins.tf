# Security Group for Bastion Host (Jenkins)

resource "aws_security_group" "bastion_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Change to your IP range for better security
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Change to your IP range for better security
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "parrot-bastion-sg"
  }
}

# EC2 Instance for Bastion Host (Jenkins)

resource "aws_instance" "bastion" {
  ami           = "ami-078701cc0905d44e4"  # Amazon Linux 2 AMI (HVM)
  instance_type = "t2.large"
  subnet_id     = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]

  associate_public_ip_address = true  # Assign a public IP address

  key_name = "parrot"

  tags = {
    Name = "parrot-bastion"
  }
}
