resource "aws_ami" "packer-ami" {
         name          = "unknown"
}

resource "aws_ebs_snapshot" "packer-snap" {
         volume_id = "unknown"
}
