resource "aws_instance" "vyos1" {
    connection {
        user = "${var.key_username}"
        key_file = "${var.key_path}"
        agent = true
    }
    ami = "${var.vyos_1_1_0_ami}"
    instance_type = "${var.instance_type}"
    key_name = "${var.key_name}"

    associate_public_ip_address = true

    tags = {
        Name = "test-vyos-1.1.0-i1"
        project = "${var.project}"
        environment = "${var.env}"
    }

}

