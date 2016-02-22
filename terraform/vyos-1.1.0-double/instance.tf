resource "template_file" "001_base_configuration_vyos01" {
    template = "${file("config/001_base_configuration.sh")}"
    vars = {
        fqdn = "test-vyos-1.1.7-i01"
        short_name = "vyos01"
        private_ip_mine = "${aws_instance.vyos01.private_ip}"
        private_ip_peer = "${aws_instance.vyos02.private_ip}"
    }
}

resource "template_file" "001_base_configuration_vyos02" {
    template = "${file("config/001_base_configuration.sh")}"
    vars = {
        fqdn = "test-vyos-1.1.7-i02"
        short_name = "vyos02"
        private_ip_mine = "${aws_instance.vyos02.private_ip}"
        private_ip_peer = "${aws_instance.vyos01.private_ip}"
    }
}

resource "template_file" "010_interfaces_configuration_vyos01" {
    template = "${file("config/010_interfaces_configuration.sh")}"
    vars = {
        fqdn = "test-vyos-1.1.7-i01"
        internal_ip_mine_range = "192.168.100.13/30"
        rtr_id_mine = "1"
        rtr_id_peer = "2"
        private_ip_mine = "${aws_instance.vyos01.private_ip}"
        private_ip_peer = "${aws_instance.vyos02.private_ip}"
    }
}

resource "template_file" "010_interfaces_configuration_vyos02" {
    template = "${file("config/010_interfaces_configuration.sh")}"
    vars = {
        fqdn = "test-vyos-1.1.7-i02"
        internal_ip_mine_range = "192.168.100.14/30"
        rtr_id_mine = "2"
        rtr_id_peer = "1"
        private_ip_mine = "${aws_instance.vyos02.private_ip}"
        private_ip_peer = "${aws_instance.vyos01.private_ip}"
    }
}

resource "template_file" "015_ipsec_configuration_vyos01" {
    template = "${file("config/015_ipsec_configuration.sh")}"
    vars = {
        private_ip_mine = "${aws_instance.vyos01.private_ip}"
        private_ip_peer = "${aws_instance.vyos02.private_ip}"
    }
}

resource "template_file" "015_ipsec_configuration_vyos02" {
    template = "${file("config/015_ipsec_configuration.sh")}"
    vars = {
        private_ip_mine = "${aws_instance.vyos02.private_ip}"
        private_ip_peer = "${aws_instance.vyos01.private_ip}"
    }
}

resource "template_file" "030_ospf_configuration_vyos01" {
    template = "${file("config/030_ospf_configuration.sh")}"
    vars = {
        ospf_area_0_range = "192.168.100.12/30"
        internal_ip_mine_range = "192.168.100.13/30"
        internal_ip_mine = "192.168.100.13"
        internal_ip_peer = "192.168.100.14"
        rtr_id_mine = "1"
        rtr_id_peer = "2"
    }
}

resource "template_file" "030_ospf_configuration_vyos02" {
    template = "${file("config/030_ospf_configuration.sh")}"
    vars = {
        ospf_area_0_range = "192.168.100.12/30"
        internal_ip_mine_range = "192.168.100.14/30"
        internal_ip_mine = "192.168.100.14"
        internal_ip_peer = "192.168.100.13"
        rtr_id_mine = "2"
        rtr_id_peer = "1"
    }
}


resource "aws_instance" "vyos01" {
    connection {
        user = "${var.key_username}"
        key_file = "${var.key_path}"
        agent = true
    }
    ami = "${var.vyos_1_1_7_ami}"
    instance_type = "${var.instance_type}"
    key_name = "${var.key_name}"

    subnet_id = "${var.subnet_id}"
    associate_public_ip_address = true

    tags = {
        Name = "test-vyos-1.1.7-i01"
        project = "${var.project}"
        environment = "${var.env}"
    }

    provisioner "file" {
        source = "config/vbash-show.sh"
        destination = "/tmp/vbash-show.sh"
    }
    provisioner "remote-exec" {
        inline = [
            "chmod a+x /tmp/vbash-show.sh"
        ]
    }

}

resource "aws_instance" "vyos02" {
    connection {
        user = "${var.key_username}"
        key_file = "${var.key_path}"
        agent = true
    }
    ami = "${var.vyos_1_1_7_ami}"
    instance_type = "${var.instance_type}"
    key_name = "${var.key_name}"

    subnet_id = "${var.subnet_id}"
    associate_public_ip_address = true

    tags = {
        Name = "test-vyos-1.1.7-i02"
        project = "${var.project}"
        environment = "${var.env}"
    }

    provisioner "file" {
        source = "config/vbash-show.sh"
        destination = "/tmp/vbash-show.sh"
    }
    provisioner "remote-exec" {
        inline = [
            "chmod a+x /tmp/vbash-show.sh"
        ]
    }

}

resource "null_resource" "provision_vyos01" {
    depends_on = ["aws_instance.vyos01"]
    triggers = {
        instance_id = "${aws_instance.vyos01.id}"
    }
    connection {
        host = "${aws_instance.vyos01.public_ip}"
        user = "${var.key_username}"
        key_file = "${var.key_path}"
        agent = true
    }

    provisioner "remote-exec" {
      inline = [
        "rm -f /tmp/001_base_configuration.sh",
        "touch /tmp/001_base_configuration.sh",
        "chmod 755 /tmp/001_base_configuration.sh",
        "cat <<FILEXXX > /tmp/001_base_configuration.sh",
        "${template_file.001_base_configuration_vyos01.rendered}",
        "FILEXXX"
      ]
    }
    provisioner "remote-exec" {
      inline = [
        "rm -f /tmp/010_interfaces_configuration.sh",
        "touch /tmp/010_interfaces_configuration.sh",
        "chmod 755 /tmp/010_interfaces_configuration.sh",
        "cat <<FILEXXX > /tmp/010_interfaces_configuration.sh",
        "${template_file.010_interfaces_configuration_vyos01.rendered}",
        "FILEXXX"
      ]
    }
    provisioner "remote-exec" {
      inline = [
        "rm -f /tmp/015_ipsec_configuration.sh",
        "touch /tmp/015_ipsec_configuration.sh",
        "chmod 755 /tmp/015_ipsec_configuration.sh",
        "cat <<FILEXXX > /tmp/015_ipsec_configuration.sh",
        "${template_file.015_ipsec_configuration_vyos01.rendered}",
        "FILEXXX"
      ]
    }
    provisioner "remote-exec" {
      inline = [
        "rm -f /tmp/030_ospf_configuration.sh",
        "touch /tmp/030_ospf_configuration.sh",
        "chmod 755 /tmp/030_ospf_configuration.sh",
        "cat <<FILEXXX > /tmp/030_ospf_configuration.sh",
        "${template_file.030_ospf_configuration_vyos01.rendered}",
        "FILEXXX"
      ]
    }

    provisioner "remote-exec" {
        inline = [
            "/tmp/001_base_configuration.sh"
        ]
    }
}

resource "null_resource" "provision_vyos02" {
    depends_on = ["aws_instance.vyos02"]
    triggers = {
        instance_id = "${aws_instance.vyos02.id}"
    }
    connection {
        host = "${aws_instance.vyos02.public_ip}"
        user = "${var.key_username}"
        key_file = "${var.key_path}"
        agent = true
    }


    provisioner "remote-exec" {
      inline = [
        "rm -f /tmp/001_base_configuration.sh",
        "touch /tmp/001_base_configuration.sh",
        "chmod 755 /tmp/001_base_configuration.sh",
        "cat <<FILEXXX > /tmp/001_base_configuration.sh",
        "${template_file.001_base_configuration_vyos02.rendered}",
        "FILEXXX"
      ]
    }
    provisioner "remote-exec" {
      inline = [
        "rm -f /tmp/010_interfaces_configuration.sh",
        "touch /tmp/010_interfaces_configuration.sh",
        "chmod 755 /tmp/010_interfaces_configuration.sh",
        "cat <<FILEXXX > /tmp/010_interfaces_configuration.sh",
        "${template_file.010_interfaces_configuration_vyos02.rendered}",
        "FILEXXX"
      ]
    }
    provisioner "remote-exec" {
      inline = [
        "rm -f /tmp/015_ipsec_configuration.sh",
        "touch /tmp/015_ipsec_configuration.sh",
        "chmod 755 /tmp/015_ipsec_configuration.sh",
        "cat <<FILEXXX > /tmp/015_ipsec_configuration.sh",
        "${template_file.015_ipsec_configuration_vyos02.rendered}",
        "FILEXXX"
      ]
    }
    provisioner "remote-exec" {
      inline = [
        "rm -f /tmp/030_ospf_configuration.sh",
        "touch /tmp/030_ospf_configuration.sh",
        "chmod 755 /tmp/030_ospf_configuration.sh",
        "cat <<FILEXXX > /tmp/030_ospf_configuration.sh",
        "${template_file.030_ospf_configuration_vyos02.rendered}",
        "FILEXXX"
      ]
    }

    provisioner "remote-exec" {
        inline = [
            "/tmp/001_base_configuration.sh",
            "/tmp/010_interfaces_configuration.sh",
            "/tmp/015_ipsec_configuration.sh",
            "/tmp/030_ospf_configuration.sh"
        ]
    }

}

