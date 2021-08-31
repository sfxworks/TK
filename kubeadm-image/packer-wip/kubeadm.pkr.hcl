source "qemu" "example" {
  iso_url           = "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-11.0.0-amd64-netinst.iso"
  output_directory  = "output_debian_tdhtest"
  shutdown_command  = "echo 'packer' | sudo -S shutdown -P now"
  disk_size         = "5000M"
  format            = "raw"
  accelerator       = "kvm"
  ssh_username      = "root"
  ssh_password      = "s0m3password"
  ssh_timeout       = "20m"
  vm_name           = "tdhtest"
  net_device        = "virtio-net"
  disk_interface    = "virtio"
  boot_wait         = "10s"
}

build {
  sources = ["source.qemu.example"]
}