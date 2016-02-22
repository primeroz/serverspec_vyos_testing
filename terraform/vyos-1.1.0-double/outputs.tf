output "vyos01_private_ip" {
  value = "${aws_instance.vyos01.private_ip}"
}

output "vyos02_private_ip" {
  value = "${aws_instance.vyos02.private_ip}"
}

output "vyos01_public_ip" {
  value = "${aws_instance.vyos01.public_ip}"
}

output "vyos02_public_ip" {
  value = "${aws_instance.vyos02.public_ip}"
}
