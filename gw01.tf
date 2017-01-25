
resource "aws_instance" "gw01" {
	private_ip = "10.0.128.241"
	tags {
        	Name = "ktaka_gw01"
		Owner = "ktaka"
    	}

        ami = "ami-2a34e94a"
        instance_type = "t2.micro"
        subnet_id = "${aws_subnet.pub.id}"
	vpc_security_group_ids = ["${aws_security_group.ssh.id}","${aws_security_group.local.id}"]
        source_dest_check = false
        key_name = "ktaka.root"
	iam_instance_profile = "ktaka_role"

	root_block_device {
		volume_type = "standard"
		volume_size = 10
		delete_on_termination = "true"
	}
}

resource "aws_eip" "gw01" {
    instance = "${aws_instance.gw01.id}"
    vpc = true
}

