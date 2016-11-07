#!/bin/bash

host_min=10
host_max=10

for i in $(seq $host_min $host_max) ; do

host=lvs$(printf %03d $i)

cat << EOF > ${host}.tf

resource "aws_instance" "${host}" {
	private_ip = "10.0.128.$i"
	tags {
        	Name = "ktaka_${host}"
		Owner = "ktaka"
    	}

        ami = "ami-2a34e94a"
        instance_type = "t2.small"
        subnet_id = "\${aws_subnet.pub.id}"
	security_groups = ["\${aws_security_group.ssh.id}","\${aws_security_group.local.id}"]
        source_dest_check = false
        key_name = "ktaka.root"
	iam_instance_profile = "ktaka_role"

	root_block_device {
		volume_type = "gp2"
		volume_size = 10
		delete_on_termination = "true"
	}
}

resource "aws_eip" "${host}" {
    instance = "\${aws_instance.${host}.id}"
    vpc = true
}

EOF

done

