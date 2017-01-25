
resource "aws_instance" "lvs012" {
	private_ip = "10.0.128.12"
	tags {
        	Name = "ktaka_lvs012"
		Owner = "ktaka"
    	}

        ami = "ami-2a34e94a"
        instance_type = "t2.small"
        subnet_id = "${aws_subnet.pub.id}"
	vpc_security_group_ids = ["${aws_security_group.ssh.id}","${aws_security_group.local.id}"]
        source_dest_check = false
        key_name = "ktaka.root"
	iam_instance_profile = "ktaka_role"

	root_block_device {
		volume_type = "gp2"
		volume_size = 10
		delete_on_termination = "true"
	}
}

resource "aws_eip" "lvs012" {
    instance = "${aws_instance.lvs012.id}"
    vpc = true
}

