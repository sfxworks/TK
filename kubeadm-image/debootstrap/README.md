# Debootstrap kubeadm

## Prerequisites

- Nodes have 1 empty physical volume
- Single master kubeadm node with static IP 

Steps

1. Run `kubeadm token create --print-join-command`
2. Fill in appropriate information at kubeadm/kubeadm.conf
3. Ensure hosts have sda1 formatted with ext4 (or adjust ltsp/ltsp.conf appropriately)
4. Run `build.sh`
5. Boot a baremetal node to join it in the cluster.