# define my role in ec2
resource "aws_iam_role" "ec2_role" {
  name = "demo-ec2-supplychain-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com" # i'll use ec2
        }
      }
    ]
  })
}

# i want to make s3 readable
resource "aws_iam_role_policy_attachment" "s3_readonly" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess" # grant s3 read only access fuck write
}
# this is my fk profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "demo-ec2-instance-profile"
  role = aws_iam_role.ec2_role.name
}
