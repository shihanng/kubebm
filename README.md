A simple demo to setup Kubernetes on bare-metal (and also on VM via [Vagrant](https://www.vagrantup.com/).

# Requirements

-  [Ubuntu 18.04.1 LTS (Bionic Beaver)](http://releases.ubuntu.com/18.04/). The [Vagrantfile](./vagrant/Vagrantfile) is based on this distribution.
-  [Ansible](https://www.ansible.com/)

For VMs we need:

- [Vagrant](https://www.vagrantup.com/)
- [vagrant-rsync-back](https://github.com/smerrill/vagrant-rsync-back) to obtain the `KUBECONFIG` file from the master node.

```
$ vagrant plugin install vagrant-rsync-back
```

# Setup

## Provisioning

### Bare-metal

Execute Ansible playbook to provision the machine.

```
cd ansible
export PRIV_KEY=""
ansible-playbook --diff --check -vv provision.yml --private-key="${PRIV_KEY}" --ask-become-pass
```

### VM

Use Vagrant.

```
cd vagrant
vagrant up
```

## Initialize the Kubernetes master for both bare-metal and VM.

1. SSH into the master node and setup Kubernetes master with `kubeadm`.

```
# export IP_ADDR="" # For Vagrant, this should be 192.168.50.110
# kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address="${IP_ADDR}"
```

2. Copy the `/etc/kubernetes/admin.conf` file and use that with `kubectl` to talk with kubernetes. We can use the `KUBECONFIG` environment variable for this. For Vagrant this can be done with:

```
# cp -i /etc/kubernetes/admin.conf /vagrant/config
# chown vagrant:vagrant /vagrant/config
```

On the host, run the follwing under the `vagrant/` directory to copy the config file to host

```
$ vagrant rsync-back
$ ls kubernetes
config
```

## Install networking.

### For bare-metal:
```
$ kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/bc79dd1505b0c8681ece4de4c0d86c5cd2643275/Documentation/kube-flannel.yml
```

### For Vagrant's VM use the `kube-flannel.yml` in the `vagrant/` directory.
```
$ kubectl apply -f kube-flannel.yml
```

## Setting up single-host cluster.

Taint the master node so that we can use the master as single-host cluster.

```
$ kubectl taint nodes --all node-role.kubernetes.io/master-
```

## Adding worker node to cluster.

When we have more machines to join the the cluster, we can generate the join command within the master node and use the resulting `kubeadm join` command in the worker node to add it into the cluster.

```
# kubeadm token create --print-join-command
kubeadm join <IP-ADDR> --token <SECRET> --discovery-token-ca-cert-hash <HASH>
```

# References
- [A. Ellis, Kubernetes on bare-metal in 10 minutes](https://blog.alexellis.io/kubernetes-in-10-minutes/)
- [A. Ellis, Your instant Kubernetes cluster](https://blog.alexellis.io/your-instant-kubernetes-cluster/)
- [Creating a single master cluster with kubeadm](https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm)
