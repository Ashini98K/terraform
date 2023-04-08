resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow ssh access and conection to the internet"

  # Role that specifies how and what sort of traffic can come into the instance
  ingress = [{
    cidr_block  = ["0.0.0.0/0"]
    description = "ssh ingress"
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    self        = false

    ipv6_cidr_blocks = []
    security_groups  = []
    prefixs_list_ids = []
  }]

  # This allows traffic from the security group out to the rest of the internet
  egress = [{
    cidr_block  = ["0.0.0.0/0"]
    description = "internet egress"
    protocol    = -1
    from_port   = 0
    to_port     = 0
    self        = false

    ipv6_cidr_blocks = []
    security_groups  = []
    prefixs_list_ids = []
  }]
}
