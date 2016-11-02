
resource "aws_instance" "v011" {
	private_ip = "10.0.11.0"
	tags {
        	Name = "ktaka_v011"
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

