resource "yandex_vpc_network" "net" {
  name = "tfhexlet"
}

resource "yandex_vpc_subnet" "subnet" {
  name           = "tfhexlet"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.net.id
  v4_cidr_blocks = ["192.168.192.0/24"]
}

resource "yandex_mdb_postgresql_cluster" "pgcluster" {
  name        = "tfhexlet"
  environment = "PRESTABLE"
  network_id  = yandex_vpc_network.net.id

  config {
    version = var.yc_postgresql_version
    resources {
      resource_preset_id = "s2.micro"
      disk_type_id       = "network-ssd"
      disk_size          = 15
    }
    postgresql_config = {
      max_connections    = 100
    }
  }

  maintenance_window {
    type = "WEEKLY"
    day  = "SAT"
    hour = 12
  }

  host {
    zone      = "ru-central1-a"
    subnet_id = yandex_vpc_subnet.subnet.id
  }
  depends_on  = [yandex_vpc_network.net, yandex_vpc_subnet.subnet]
}

resource "yandex_mdb_postgresql_user" "dbuser" {
  cluster_id = yandex_mdb_postgresql_cluster.dbcluster.id
  name       = var.db_user
  password   = var.db_password
  depends_on = [yandex_mdb_postgresql_cluster.dbcluster]
}

resource "yandex_mdb_postgresql_database" "db" {
  cluster_id = yandex_mdb_postgresql_cluster.dbcluster.id
  name       = var.db_name
  owner      = yandex_mdb_postgresql_user.dbuser.name
  lc_collate = "en_US.UTF-8"
  lc_type    = "en_US.UTF-8"
  depends_on = [yandex_mdb_postgresql_cluster.dbcluster]
}

// Digital Ocean Experience
# terraform {
#   required_providers {
#     // Здесь указываются все провайдеры, которые будут использоваться
#     digitalocean = {
#       source = "digitalocean/digitalocean"
#       // Версия может обновиться
#       version = "~> 2.0"
#     }
#     # datadog = {
#     #   source = "DataDog/datadog"
#     #   version = "3.34.0"
#     # }
#     # yandex = {
#     #   source = "yandex-cloud/yandex"
#     #   version = "0.104.0"
#     # }
#   }
# }


# // Установка значения переменной
# provider "digitalocean" {
#   token = var.do_token
# }

# # provider "datadog" {
# #   api_key = var.datadog_api_key
# #   app_key = var.datadog_app_key
# # }

# // Create droplets
# // web - произвольное имя ресурса
# resource "digitalocean_droplet" "web1" {
#   image  = "ubuntu-22-04-x64"
#   // Имя внутри Digital Ocean
#   // Задается для удобства просмотра в веб-интерфейсе
#   name   = "web-1"
#   // Регион, в котором располагается датацентр
#   // Выбирается по принципу близости к клиентам
#   region = "ams3"
#   // Тип сервера, от этого зависит его мощность и стоимость
#   size   = "s-1vcpu-1gb"
# }

# resource "digitalocean_droplet" "web2" {
#   image  = "ubuntu-22-04-x64"
#   name   = "web-2"
#   region = "ams3"
#   size   = "s-1vcpu-1gb"
# }





# # resource "datadog_monitor" "terraform" {
# #   name               = "Name for monitor terraform"
# #   type               = "metric alert"
# #   message            = "Monitor triggered"
# #   query = "avg:system.load.1{host:MacBook-Pro-Elena.local}"

# # }

# // describe data source
# # data "yandex_compute_image" "img" {
# #   family = "ubuntu-2204-lts"
# # }

# # output "show-img" {
# #   value = data.yandex_compute_image.img
# # }

# # resource "yandex_compute_instance" "vm" {
# #   name        = "test"
# #   ...
# #   boot_disk {
# #     initialize_params {
# #       image_id = data.yandex_compute_image.img.id
# #     }
# #   }
# #   ...
# # }
