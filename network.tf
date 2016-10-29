### VPC

resource "aws_vpc" "vpc" {
    cidr_block = "10.0.0.0/8"
    instance_tenancy = "default"
    tags {
        Name = "ktaka_vpc01"
    }
}

### Subnet

resource "aws_subnet" "pub" {
    vpc_id = "${aws_vpc.vpc.id}"
    cidr_block = "10.255.1.0/24"

    tags {
        Name = "ktaka_vpc01_pub"
    }
}

resource "aws_subnet" "priv" {
    vpc_id = "${aws_vpc.vpc.id}"
    cidr_block = "10.0.0.0/16"

    tags {
        Name = "ktaka_vpc01_priv"
    }
}

### security group

resource "aws_security_group" "local" {
  name = "ktaka_vpc01_local"
  description = "Allow all inbound traffic from 10.0.0.0/8"
  vpc_id = "${aws_vpc.vpc.id}"

  ingress {
      from_port = 0
      to_port = 65535
      protocol = "tcp"
      cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
      from_port = 0 
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
      from_port = 0 
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "ktaka_vpc01_local"
  }
}

resource "aws_security_group" "ssh" {
  name = "ktaka_vpc01_ssh"
  description = "Only SSH"
  vpc_id = "${aws_vpc.vpc.id}"

# hanzo
  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["124.41.93.194/32"]
  }
# bose
  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["124.41.86.39/32"]
  }

  egress {
      from_port = 0 
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "ktaka_vpc01_ssh"
  }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_route_table" "public" {
    vpc_id = "${aws_vpc.vpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.igw.id}"
    }
    tags {
        Name = "ktaka_vpc01_pub"
    }
}

resource "aws_route_table" "local" {
    vpc_id = "${aws_vpc.vpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        instance_id = "${aws_instance.gw01.id}"
    }
    tags {
        Name = "ktaka_vpc01_local"
    }
}

resource "aws_route_table_association" "pub" {
    subnet_id = "${aws_subnet.pub.id}"
    route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "priv" {
    subnet_id = "${aws_subnet.priv.id}"
    route_table_id = "${aws_route_table.local.id}"
}



