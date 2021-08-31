set -e

#Install ltsp if it's not already
wget https://ltsp.org/misc/ltsp-ubuntu-ppa-focal.list -O /etc/apt/sources.list.d/ltsp-ubuntu-ppa-focal.list
wget https://ltsp.org/misc/ltsp_ubuntu_ppa.gpg -O /etc/apt/trusted.gpg.d/ltsp_ubuntu_ppa.gpg
apt update
apt install --install-recommends ltsp ltsp-binaries dnsmasq nfs-kernel-server openssh-server squashfs-tools ethtool net-tools epoptes
gpasswd -a root epoptes


#Make server image
mkdir -p /srv/image/
cd /srv/image/
debootstrap stable kubeadm http://deb.debian.org/debian/

#Preconfigure (system)
cp -r $WORKDIR/systemd/* kubeadm/etc/systemd/system/
cp $WORKDIR/modules/k8s.conf kubeadm/etc/modules-load.d/k8s.conf
cp $WORKDIR/sysctl/k8s.conf kubeadm/etc/sysctl.d/k8s.conf

#Entrypoint
chroot kubeadm /bin/bash -x << 'EOF'
set -e
apt-get update -y
apt install linux-image-amd64 -y
apt install wget apt-transport-https ca-certificates curl gnupg2 -y

#Packages and keys

wget https://ltsp.org/misc/ltsp-ubuntu-ppa-focal.list -O /etc/apt/sources.list.d/ltsp-ubuntu-ppa-focal.list && wget https://ltsp.org/misc/ltsp_ubuntu_ppa.gpg -O /etc/apt/trusted.gpg.d/ltsp_ubuntu_ppa.gpg && apt update
curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list
curl -L https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable:cri-o:1.22/Debian_Testing/Release.key | apt-key add -
curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/Debian_Testing/Release.key | apt-key add -
echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/Debian_Testing/ /" > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
echo "deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/1.22/Debian_Testing/ /" > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable:cri-o:1.22.list

#Update
apt-get update -y && apt-get upgrade -y
apt install --install-recommends ltsp epoptes-client kubeadm kubelet cri-o cri-o-runc -y

systemctl enable crio
systemctl enable kubelet
systemctl enable kubeadm-join
EOF

#Post configure (apps) 
cp $WORKDIR/crio/crio.conf kubeadm/etc/crio/crio.conf
cp $WORKDIR/kubeadm/kubeadm.conf kubeadm/etc/ltsp/kubeadm-join.conf

#Post configure (server)

cp $WORKDIR/ltsp/ltsp.conf /etc/ltsp/ltsp.conf

ltsp dnsmasq 
ltsp image /srv/image/kubeadm
ltsp ipxe
ltsp nfs
ltsp initrd
