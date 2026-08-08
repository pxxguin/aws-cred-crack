# i will use latest ama linux
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }
}

resource "aws_instance" "victim_server" {
  ami                  = data.aws_ami.amazon_linux.id
  instance_type        = "t3.micro" 
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required" # this enforces IMDBSv2
    http_put_response_hop_limit = 2          # container access opened
  }

  # if i run in ec2? i'll run docker container
  user_data = <<-EOF
              #!/bin/bash 
              dnf update -y
              dnf install -y docker
              systemctl start docker
              systemctl enable docker

              docker run -d --net=host --name production-app moomin03/malicious-agent:latest
              EOF

  tags = {
    Name = "SupplyChain-POC-Target"
  }
}
