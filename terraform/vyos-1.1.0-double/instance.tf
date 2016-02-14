resource "template_file" "001_base_configuration_vyos01" {
    template = "${file("config/001_base_configuration.sh")}"
    vars = {
        fqdn = "test-vyos-1.1.0-i01"
        short_name = "vyos01"
        private_ip_mine = "${aws_instance.vyos01.private_ip}"
        private_ip_peer = "${aws_instance.vyos02.private_ip}"
    }
}

resource "template_file" "001_base_configuration_vyos02" {
    template = "${file("config/001_base_configuration.sh")}"
    vars = {
        fqdn = "test-vyos-1.1.0-i02"
        short_name = "vyos02"
        private_ip_mine = "${aws_instance.vyos02.private_ip}"
        private_ip_peer = "${aws_instance.vyos01.private_ip}"
    }
}

resource "template_file" "010_ipsec_configuration_vyos01" {
    template = "${file("config/010_ipsec_configuration.sh")}"
    vars = {
        fqdn = "test-vyos-1.1.0-i01"
        short_name = "vyos01"
        internal_ip_mine_range = "192.168.100.13/30"
        private_ip_mine = "${aws_instance.vyos01.private_ip}"
        private_ip_peer = "${aws_instance.vyos02.private_ip}"
    }
}

resource "template_file" "010_ipsec_configuration_vyos02" {
    template = "${file("config/010_ipsec_configuration.sh")}"
    vars = {
        fqdn = "test-vyos-1.1.0-i02"
        short_name = "vyos02"
        internal_ip_mine_range = "192.168.100.14/30"
        private_ip_mine = "${aws_instance.vyos02.private_ip}"
        private_ip_peer = "${aws_instance.vyos01.private_ip}"
    }
}


resource "aws_instance" "vyos01" {
    connection {
        user = "${var.key_username}"
        key_file = "${var.key_path}"
        agent = true
    }
    ami = "${var.vyos_1_1_0_ami}"
    instance_type = "${var.instance_type}"
    key_name = "${var.key_name}"

    subnet_id = "${var.subnet_id}"
    associate_public_ip_address = true

    tags = {
        Name = "test-vyos-1.1.0-i01"
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
    ami = "${var.vyos_1_1_0_ami}"
    instance_type = "${var.instance_type}"
    key_name = "${var.key_name}"

    subnet_id = "${var.subnet_id}"
    associate_public_ip_address = true

    tags = {
        Name = "test-vyos-1.1.0-i02"
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
        "rm -f /tmp/010_ipsec_configuration.sh",
        "touch /tmp/010_ipsec_configuration.sh",
        "chmod 755 /tmp/010_ipsec_configuration.sh",
        "cat <<FILEXXX > /tmp/010_ipsec_configuration.sh",
        "${template_file.010_ipsec_configuration_vyos01.rendered}",
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
        "rm -f /tmp/010_ipsec_configuration.sh",
        "touch /tmp/010_ipsec_configuration.sh",
        "chmod 755 /tmp/010_ipsec_configuration.sh",
        "cat <<FILEXXX > /tmp/010_ipsec_configuration.sh",
        "${template_file.010_ipsec_configuration_vyos02.rendered}",
        "FILEXXX"
      ]
    }
    provisioner "remote-exec" {
        inline = [
            "/tmp/001_base_configuration.sh"
        ]
    }
}

