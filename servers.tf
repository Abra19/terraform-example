resource "yandex_compute_instance" "vm" {
  name        = "tfhexlet"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.img.id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    host        = self.network_interface[0].nat_ip_address
  }

  provisioner "remote-exec" {
  inline = [
<<EOT
sudo docker run -d -p 0.0.0.0:80:3000 \
  -e DB_TYPE=postgres \
  -e DB_NAME=${var.db_name} \
  -e DB_HOST=${yandex_mdb_postgresql_cluster.dbcluster.host.0.fqdn} \
  -e DB_PORT=6432 \
  -e DB_USER=${var.db_user} \
  -e DB_PASS=${var.db_password} \
  ghcr.io/requarks/wiki:2.5
EOT
    ]
  }
depends_on  = [yandex_mdb_postgresql_cluster.dbcluster]
}