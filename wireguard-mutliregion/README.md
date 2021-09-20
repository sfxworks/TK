# Multiregional single cluster with Wireguard

# Overview
This scenario goes over utilizing Wireguard in order to create a cluster across multiple regions. By the end of this document, one will have a set of Kubernetes nodes that utilize Wireguard to establish a network shared amongst regions behind nat. 


# Site to site router peering

Utilizing a router on a network, one can set up a Wireguard site-to-site network to join a Kubernetes node against another network. The concept is similar to how one would do this with IPSec. However, instructions differ among different routers. 

- [OPNSense Wireguard Configuration](https://docs.opnsense.org/manual/how-tos/wireguard-client.html)
- [PFSense Wireguard Configuration](https://docs.netgate.com/pfsense/en/latest/vpn/wireguard/index.html)
- [OpenWRT Wireguard Configuration](https://openwrt.org/docs/guide-user/services/vpn/wireguard/start)

If a router lacks the capabilities to create a Wireguard tunnel, follow the solution below to create a Wireguard endpoint. An endpoint may also be ideal for preventing one network from colliding with other networks that one wishes to peer with that are not within control. 

## Wireguard Endpoint Prereq

This example will create a Wireguard edge endpoint that all nodes on a LAN to use as a peering endpoint. All Kubernetes nodes will have an interface that holds a Wireguard interface named wg0. Kubelet will report its node IP to be the address of that interface. 

- Ensure the CNI's CIDR does not conflict with the Wireguard CIDR
- Ensure the network's Wireguard CIDR does not conflict with a neighbor's network. Use a spreadsheet or similar to ensure each site gets a unique address. A /24 is more than enough for one site. A /16 for the whole space will ensure that up to 255 sites can join one network.
- Ensure the Wireguard CIDR does not conflict with any site networks. For example, 192.168.0.0/24 is used at home sites.

## Steps

1. Consider and determine a standard port for Wireguard to establish a peer connection. The default port is 51820. 
2. Consider and determine which node that will be designated as the "next-hop" node. Then, port-forward the determined port to this node. This node will be used for peering with one or many sites as well as the local Wireguard network.
3. Create a Wireguard config for this node and provide an IP that does not conflict with any other sites. For example, if the home Wireguard site is 10.100.0.0/24, and the entire network will live under 10.100.0.0/16, set the first node's IP to 10.100.0.1/16. 
4. Start your node with the `--node-ip=10.100.0.1` flag for kubelet. As referenced in https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/kubelet-integration/#the-kubelet-drop-in-file-for-systemd, extra arguments can be placed in /etc/default/kubelet (for DEBs), or /etc/sysconfig/kubelet (for RPMs).
5. Repeat the process for all nodes, ensuring each has a unique IP address.
6. Peer the site with an office, friend's house, business, or colocation using the "next-hop" node with the "next-hop" node on their NAT. 