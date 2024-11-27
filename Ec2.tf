# AMI and instance type (replace with your desired values)
variable "ami_id" {
  default = "ami-0c02fb55956c7d316" # Amazon Linux 2 AMI (region-specific)
}

variable "instance_type" {
  default = "t2.micro"
}

# Security Group for EC2 instance
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-sg"
  description = "Allow SSH and HTTP access"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "my_instance" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id # Use the public subnet
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id] # Use security group ID

  tags = {
    Name = "MyEC2Instance"
  }
}

