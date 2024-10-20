# main.tf
provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  token      = var.aws_token
  region     = var.aws_region
}


#provider "aws" {
# access_key = "AKIA45ATMYYBTV3ACWVL" ## replace with your access key
# secret_key = "+nxozwOr65aXMEqt5hoL1WJsgIVkorTZkQdVOdTe" ## replace with your secret key
#token      = "FwoGZXIvYXdzECAaDPFSghJKxNOwm9CseiKzAU9O4LcsPQhP9qwdaeKa5MmdG114xKs9818kuw/OqtyNLhIZRQWzhIC6naqTWB4gkBRiPnPg9MpXoqA0/kBULjVNLaLz0mcnhCP9h1xA3sY5DiaN9ZPSxzF6//bzFqlOhIMn/O7fULZHWyuuSkExstxsoWyY+FAiNURz+1eBmRphSGahasSlB8RZlXxw7M78KViNoWIC0kyoiT7ctswvfp9GuG4VjnHaixAPvE68s/6mDUvCKJOf1LgGMi1+/NZJ3im+jAgPOsOO0c0mLISW5meXgRZLr0IVEAXZX+Ye0ViTEnO3qTHZ76Y=" ## replace with token 
#region     = "us-east-1"
#}

resource "aws_instance" "project_demo" {
  ami = "ami-04b70fa74e45c3917" # Canonical, Ubuntu, 24.04 LTS, amd64 noble image build on 2024-04-23
  #ami                    = "ami-0e001c9271cf7f3b9" #Canonical, Ubuntu, 22.04 LTS, amd64 jammy image build on 2024-04-11
  #ami                    = "ami-06aa3f7caf3a30282" # Canonical, Ubuntu, 20.04 LTS, amd64 focal image build on 2023-10-25
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.demo.id]


  tags = {
    Name = "project1_demo"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y ansible
              git clone https://github.com/jvsocial/setup-jenkins-on-aws-ubuntu.git
              sudo ansible-playbook setup-jenkins-on-aws-ubuntu/setup-jenkins-ubuntu.yaml
              sudo cat /var/lib/jenkins/secrets/initialAdminPassword > jenkinspass.txt
              EOF
}

resource "aws_security_group" "demo" {
  name        = "demo_sg"
  description = "Demo security group"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 81
    to_port     = 81
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
