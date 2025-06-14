sudo mkdir -p /etc/kernel/cmdline.d
cat << EOF | sudo tee -a /etc/kernel/cmdline.d/hugepages.conf
default_hugepagesz=1G
hugepagesz=1G
hugepages=192
EOF
sudo clr-boot-manager update
sudo reboot
