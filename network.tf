# create a custom route table for public subnets
# public subnets can reach to the internet buy using this
resource "aws_route_table" "dunhumby-crt" {
    vpc_id = "${aws_vpc.dunhumby-vpc.id}"
    route {
        cidr_block = "0.0.0.0/0" //associated subnet can reach everywhere
    }

    tags = {
        Name = "dunhumby-crt"
    }
}

# route table association for the public subnets
resource "aws_route_table_association" "dunhumby-crt-public-subnet" {
    subnet_id = "${aws_subnet.dunhumby-subnet.id}"
    route_table_id = "${aws_route_table.dunhumby-crt.id}"
}

# security group
resource "aws_security_group" "ssh-allowed" {

    vpc_id = "${aws_vpc.dunhumby-vpc.id}"

    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        
        // This means, all ip address are allowed to ssh !
        // Do not do it in the production. Put your office or home address in it!
        cidr_blocks = ["0.0.0.0/0"]
    }

    //If you do not add this rule, you can not reach the NGIX
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags {
        Name = "ssh-allowed"
    }
