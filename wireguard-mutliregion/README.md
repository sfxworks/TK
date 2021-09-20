# Multiregional single cluster with Wireguard

# Overview
This scenario goes over utilizing wireguard in order to create a cluster across multiple regions. This utilizes Wireguard in order to establish a network shared amongst regions behind nat. 


# Site to site router peering

Utilizing a router on your network, you can setup a wireguard site-to-site network to join a kubernetes node against another network. The concept is similar to how one would do this with ipsec. Instructions differ amoung different routers. 

- OPNSense Wireguard Configuration
- PFSense Wireguard Configuration
- OpenWRT Wireguard Configuration

If your router lacks the capabilities to create a wireguard tunnel, follow the solution below to create your own wireguard endpoint and separate network. This may also be ideal in order to prevent the common 192 cidr from colliding with other networks. 

## Wireguard Endpoint Prereq

This example will go over creating a wireguard edge endpoint that all nodes on your LAN will peer with. All kubernetes nodes will have an interface that holds a wireguard interface named wg0. Kubelet will report it's node IP to be the address of that interface. 

- Ensure your CNI cidr does not conflict with your wireguard CIDR
- Ensure your network's wireguard CIDR does not conflict with a neighbords. Use a spreadsheet or similar to ensure each site get's a unique address. A /24 is more than enough for one site. A /16 for the whole space will ensure that up to 255 sites can join in one network.
- Ensure your wireguard CIDR does not confict with any site networks. For example, 192.168.0.0/24 is commonly used at home sites.

## Steps

1. Consider and determine a common port for wireguard to establish a peer connection with. The default port is 51820. 
2. Consider and determine which node you want to designate as the "next-hop" node. Port forward your determined port to this node. This will be used for peering with one or many sites as well as your local network.
3. Create a wireguard config for this node and provide it an IP that does not conflict with your other sites. For example, if your home site is 10.100.0.0/24, and your entire network will live under 10.100.0.0/16, set your first node's IP to 10.100.0.1/16. 
4. Start your node with the `--node-ip=10.100.0.1` flag for kubelet. As referenced in https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/kubelet-integration/#the-kubelet-drop-in-file-for-systemd, extra arguments can be placed in /etc/default/kubelet (for DEBs), or /etc/sysconfig/kubelet (for RPMs).
5. Repeat the process for all nodes, ensuring each has a unique IP address.
6. Peer your site with your office, friends house, business or colocation for example using the "next-hop" node with the "next-hop" node on their NAT. 