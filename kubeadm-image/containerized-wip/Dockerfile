FROM debian

RUN apt-get update -y
RUN apt install linux-image-5.10.0-8-amd64 -y
RUN apt install wget apt-transport-https ca-certificates curl gnupg2 -y

#Packages and keys

RUN wget https://ltsp.org/misc/ltsp-ubuntu-ppa-focal.list -O /etc/apt/sources.list.d/ltsp-ubuntu-ppa-focal.list && wget https://ltsp.org/misc/ltsp_ubuntu_ppa.gpg -O /etc/apt/trusted.gpg.d/ltsp_ubuntu_ppa.gpg && apt update
RUN curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list
RUN curl -L https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable:cri-o:1.22/Debian_Testing/Release.key | apt-key add -
RUN curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/Debian_Testing/Release.key | apt-key add -
RUN echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/Debian_Testing/ /" > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
RUN echo "deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/1.22/Debian_Testing/ /" > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable:cri-o:$VERSION.list



#Update
RUN apt-get update -y && apt-get upgrade -y

RUN apt install --install-recommends ltsp ltsp-binaries dnsmasq nfs-kernel-server openssh-server squashfs-tools ethtool net-tools epoptes kubeadm kubelet cri-o cri-o-runc -y


#Configure

#Systemd
COPY systemd/* /etc/systemd/system/

#Kubernetes
COPY modules/k8s.conf /etc/modules-load.d/k8s.conf
COPY sysctl/k8s.conf /etc/sysctl.d/k8s.conf


#LTSP
RUN systemctl enable ltsp-init.service

CMD [ "/sbin/init" ]

#PRIV required for dnsmasq
# process is missing required capability NET_ADMIN
