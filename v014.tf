
resource "aws_instance" "v014" {
	private_ip = "10.0.14.0"
	tags {
        	Name = "ktaka_v014"
		Owner = "ktaka"
    	}

        ami = "ami-2a34e94a"
        instance_type = "t2.micro"
        subnet_id = "${aws_subnet.priv.id}"
	security_groups = ["${aws_security_group.local.id}"]
        source_dest_check = true
        key_name = "ktaka.root"
	iam_instance_profile = "ktaka_role"

	root_block_device {
		volume_type = "gp2"
		volume_size = 10
		delete_on_termination = "true"
	}
}

resource "aws_network_interface" "v014" {
	subnet_id = "${aws_subnet.priv.id}"
	private_ips = ["10.0.14.1"]
	security_groups = ["${aws_security_group.local.id}"]
	source_dest_check = true
	attachment {
		instance = "${aws_instance.v014.id}"
		device_index = 1
	}
}

