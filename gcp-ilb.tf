resource "google_compute_instance" "default" {
  name   ="tf1"
  machine_type ="n1-standard-1"
  zone     ="us-central1-c"
  network_interface {
    network ="default"
    access_config{
    }
  }
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-8"
    }
  }
}
resource "google_compute_instance_group" "default" {
  name   ="tfg1"
  zone  ="us-central1-d"
}
resource "google_compute_instance_template" "default" {
  name_prefix  = "tftemp"
  machine_type = "n1-standard-1"
  region       = "us-central1"
  network_interface {
    network  ="default"
    access_config {
    }
  }
  disk {
    source_image  ="debian-cloud/debian-8"
    auto_delete ="true"
    boot   ="true"
  }
}
resource "google_compute_instance_group_manager" "default" {
  name = "tf-igm"
  base_instance_name = "tf"
  instance_template  = "tftemp"
  zone               = "us-central1-c"
  target_size  = 3
}
resource "google_compute_region_backend_service" "default" {
  name  ="backservice"
  protocol  ="tcp"

  backend {
    group  ="tf-igm"
  }
  health_checks=["healthtest"]
}
resource "google_compute_forwarding_rule" "default" {
  name  ="fr-us"
  backend_service  ="backservice"
}
resource "google_compute_health_check" "default" {
  name  ="healthtest"
  timeout_sec        = 1
  check_interval_sec = 1

  tcp_health_check {
    port = "80"
  }
}
