provider "aws" {
  region     = "us-east-2"
  access_key = "AKIAJQCIDGDO5TSXAJJQ"
  secret_key = "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"
}
resource "aws_instance" "test" {
  ami           ="ami-916f59f4"
  instance_type = "t2.micro"
}
resource "aws_s3_bucket" "log_bucket" {
  bucket = "my-tf-log-bucket1"
  acl    = "log-delivery-write"

  tags {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
resource "aws_default_security_group" "default" {
    vpc_id      = "vpc-64d0b50c"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "allow_all"
  }
}
/*
  resource "aws_default_security_group" "lb_sg" {
  description = "Allow all inbound traffic"
  vpc_id      = "${aws_default_vpc.default.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags {
    Name  = "lb_sg"
  }
}
*/
resource "aws_default_vpc" "default" {
  cidr_block = "10.0.0.0/16"
}
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_default_vpc.default.id}"
}
/*
  resource "aws_default_subnet" "main" {
  vpc_id              = "${aws_default_vpc.default.id}"
  availability_zone   = "us-east-2a"
  cidr_block          = "10.0.1.0/24"

  tags {
    Name = "Main"
  }
}
resource "aws_default_subnet" "main1" {
  vpc_id              = "${aws_default_vpc.default.id}"
  availability_zone   = "us-east-2b"
  cidr_block          = "10.0.2.0/24"

  tags {
    Name ="Main1"
  }
} 
resource "aws_lb" "test" {
  name            = "test-lb-tf"
  internal        = false
  security_groups = ["${aws_default_security_group.lb_sg.id}","${aws_default_security_group.default.id}"]
  subnets         = ["${aws_default_subnet.main.id}","${aws_default_subnet.main1.id}"]

  access_logs {
    bucket  = "${aws_s3_bucket.log_bucket.bucket}"
    prefix  = "test-lb"
    enabled = true
  }

  tags {
    Environment = "production"
  }
}
resource "aws_lb_target_group" "test" {
  name     = "tf-example-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_default_vpc.default.id}"
}
*/
