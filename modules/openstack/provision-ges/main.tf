resource "openstack_compute_instance_v2" "ghes-primary" {
    name = "ghes-primary"
    flavor_name = var.instance_size
    key_pair = openstack_compute_keypair_v2.test-keypair.name
    #security_groups = ["${openstack_compute_secgroup_v2.ghes-primary.name}"]
    
    network {
        uuid = var.network_id
    }

    block_device {
        uuid                  = openstack_blockstorage_volume_v2.ghes_pri_root.id
        source_type           = "volume"
        boot_index            = 0
        destination_type      = "volume"
        delete_on_termination = true
    }
}

resource "openstack_blockstorage_volume_v2" "ghes_pri_root" {
  region      = var.region
  name        = "ghes-pri-root-vol"
  description = "first test volume"
  size        = var.pri_root_vol_size
  image_id    = var.pri_ghes_image_name
}

resource "openstack_blockstorage_volume_v2" "ghes_pri_data" {
  region      = var.region
  name        = "ghes-pri-data-vol"
  description = "first test volume"
  size        = var.pri_data_vol_size
}

resource "openstack_compute_volume_attach_v2" "data_vol" {
  instance_id = openstack_compute_instance_v2.ghes-primary.id
  volume_id   = openstack_blockstorage_volume_v2.ghes_pri_data.id
}


resource "openstack_compute_keypair_v2" "test-keypair" {
  name       = "my-keypair"
  public_key = file("C:/Users/michaelsainz/.ssh/id_rsa.pub")
}

resource "openstack_networking_floatingip_v2" "fip_1" {
  pool = var.floating_ip_pool
}

resource "openstack_compute_floatingip_associate_v2" "fip_1" {
  floating_ip = openstack_networking_floatingip_v2.fip_1.address
  instance_id = openstack_compute_instance_v2.ghes-primary.id
}