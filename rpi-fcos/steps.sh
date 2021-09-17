set -e
export DEVICE=/dev/sdc

# create ignition
podman run -i --rm quay.io/coreos/butane:release --pretty --strict < ignition.yaml > ignition.ign
#Install
sudo podman run --pull=always --privileged --rm \
    -v /dev:/dev -v /run/udev:/run/udev -v .:/data -w /data \
    quay.io/coreos/coreos-installer:release \
    install $DEVICE -i ignition.ign -f fedora-coreos-34.20210915.dev.0-metal.aarch64.raw --offline --insecure
#Mount EFI
mkdir /tmp/efi 
sudo mount ${DEVICE}2 /tmp/efi
#Copy UEFI
sudo cp -r uefi/* /tmp/uefi/EFI
sudo umount /tmp/uefi

#fsck
sudo e2fsck -f ${DEVICE}3
sudo tune2fs -U random ${DEVICE}3

