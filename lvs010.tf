
resource "aws_instance" "lvs010" {
	private_ip = "10.0.128.10"
	tags {
        	Name = "ktaka_lvs010"
		Owner = "ktaka"
    	}

        ami = "ami-2a34e94a"
        instance_type = "t2.small"
        subnet_id = "${aws_subnet.pub.id}"
	security_groups = ["${aws_security_group.ssh.id}","${aws_security_group.local.id}"]
        source_dest_check = false
        key_name = "ktaka.root"
	iam_instance_profile = "ktaka_role"

	root_block_device {
		volume_type = "gp2"
		volume_size = 10
		delete_on_termination = "true"
	}
}

resource "aws_eip" "lvs010" {
    instance = "${aws_instance.lvs010.id}"
    vpc = true
}

