data "aws_ami" "ghe-instance" {
    owners = ["895557238572"]
    filter {
        name   = "name"
        values = ["GitHub Enterprise Server ${var.ges_version}"]
    }
}

data "template_file" "user-data" {
  template = "${file("${path.module}/../scripts/ges-provisioning-script.sh")}"
  vars {
    role = "${var.ges_role}"
    license_url = "${var.license_url}"
    primary_ip = "${var.primary_ip}"
    public_hostname = "${var.public_hostname}"
    ges_mgmt_password = "${var.ges_mgmt_password}"
  }
}

data "template_file" "settings-config" {
  template = "${file("${path.module}/../scripts/ges-settings.json")}"
  vars {
    public_hostname = "${var.public_hostname}"
  }
}

# Network Interface for the GHE instance
resource "aws_network_interface" "ges-network-adapter" {
  subnet_id = "${var.ges_subnet_id}"

  security_groups = [
    "${var.ges_sg_id}",
  ]

  tags {
    Name = "${var.name_tag_prefix}-ges-ec2"
  }
}

resource "aws_instance" "ges-ec2" {
  ami                  = "${data.aws_ami.ghe-instance.image_id}"
  instance_type        = "${var.instance_type}"
  key_name             = "${var.ec2_key_name}"
  user_data = "${data.template_file.user-data.rendered}"

  network_interface {
    device_index          = 0
    network_interface_id  = "${aws_network_interface.ges-network-adapter.id}"
  }

  ebs_block_device = {
    delete_on_termination = true
    device_name           = "/dev/sda2"
    iops                  = 4000
    volume_size           = 1024
    volume_type           = "gp2"
  }

  provisioner "file" {
    content = "${data.template_file.settings-config.rendered}"
    destination = "/tmp/ges-settings.json"

    connection {
      type     = "ssh"
      port = "122"
      user     = "admin"
      private_key = "${file("${var.private_key_path}")}"
    }
  }

  tags {
    Name = "${var.name_tag_prefix}-${var.ges_role}-ges-ec2"
  }
}