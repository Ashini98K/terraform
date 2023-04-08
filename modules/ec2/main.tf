# EC2 Instance
resource "aws_instance" "test_instance" {
  # Arguments 
  ami           = "ami-0e9878fc797487093"
  instance_type = "t2.nano"

  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    # Have done string interpolation here
    Name = "Test Server ${var.env}"
  }
}
