# Fedora CoreOS RPI ARM Image

UEFI Firmware source: https://github.com/pftf/RPi4/releases
FCOS Source: https://fedorapeople.org/groups/fcos-images/builds/latest/aarch64/

Steps
1. Get aarch64 raw image
2. Generate ignition.yaml
3. run coreos-installer on usb
4. Mount partition sdx2 
5. Copy uefi directtory to mounted directory's EFI folder
6. Run e2fsck & tune2fs on partition sdx3. Issue ref: https://github.com/coreos/fedora-coreos-tracker/issues/258#issuecomment-703183547


Sources: 
https://www.raspberrypi.org/forums/viewtopic.php?t=304318
https://medium.com/geekculture/how-to-install-fedora-on-a-headless-raspberry-pi-62adfb7efc5