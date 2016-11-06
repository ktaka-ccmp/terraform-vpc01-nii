#!/bin/bash

host_min=10
host_max=15

for i in $(seq $host_min $host_max) ; do

host=v$(printf %03d $i)

cat << EOF > ${host}.tf

resource "aws_instance" "${host}" {
	private_ip = "10.0.$i.0"
	tags {
        	Name = "ktaka_${host}"
		Owner = "ktaka"
    	}

        ami = "ami-2a34e94a"
        instance_type = "t2.micro"
        subnet_id = "\${aws_subnet.priv.id}"
	security_groups = ["\${aws_security_group.local.id}"]
        source_dest_check = true
        key_name = "ktaka.root"
	iam_instance_profile = "ktaka_role"

	root_block_device {
		volume_type = "gp2"
		volume_size = 10
		delete_on_termination = "true"
	}
}

resource "aws_network_interface" "${host}" {
	subnet_id = "\${aws_subnet.priv.id}"
	private_ips = ["10.0.$i.1"]
	security_groups = ["\${aws_security_group.local.id}"]
	source_dest_check = true
	attachment {
		instance = "\${aws_instance.${host}.id}"
		device_index = 1
	}
}

EOF

done

