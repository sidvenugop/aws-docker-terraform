resource "aws_instance" "dh-datapipeline" {

    ami = "${lookup(var.AMI, var.AWS_REGION)}"
    instance_type = "t2.micro"

    # VPC
    subnet_id = "${aws_subnet.dunhumby-subnet.id}"

    # Security Group
    vpc_security_group_ids = ["${aws_security_group.ssh-allowed.id}"]

    # the Public SSH key
    key_name = "${aws_key_pair.dunhumby-key-pair.id}"

    # Script Copy
    provisioner "file" {
        source = "docker.sh"
        destination = "/tmp/docker.sh"
    }
    
    provisioner "file" {
        source = "init.sh"
        destination = "/tmp/init.sh"
    }

    provisioner "remote-exec" {
        inline = [
            "chmod +x /tmp/init.sh",
            "sudo /tmp/init.sh"
        ]
    }

    connection {
        user = "${var.EC2_USER}"
        private_key = "${file("${var.PRIVATE_KEY_PATH}")}"
    }
}

resource "aws_key_pair" "dunhumby-key-pair" {
    key_name = "dunhumby-key-pair"
    public_key = "${file(var.PUBLIC_KEY_PATH)}"
}
