variable "do_token" {
  description = "Какое-то описание"
  // Тип значения переменной
  type        = string
  // Значение по умолчанию, которое используется если не задано другое
  default = "какое-то значение по умолчанию"
  // Прячет значение переменной из всех выводов
  // По умолчанию false
  sensitive = true
}

variable "datadog_api_key" {
  type = string
  sensitive = true
}

variable "datadog_app_key" {
  type = string
  sensitive = true
}

variable "yc_iam_token" {
  type = string
  sensitive = true
}

variable "yc_cloud_id" {
  type = string
  sensitive = true
}

variable "yc_folder_id" {
  type = string
  sensitive = true
}

variable "yc_postgresql_version" {
  type = number
  default = 16
  sensitive = true
}

variable "db_user" {
  type = string
  sensitive = true
}

variable "db_password" {
  type = string
  sensitive = true
}

variable "db_name" {
  type = string
  sensitive = true
}