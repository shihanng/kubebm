0. Install vagrant-rsync-back
```
vagrant plugin install vagrant-rsync-back
```

1. Create the nodes.
```
vagrant up
```

2. SSH into the master node and setup Kubernetes master.
```
vagrant ssh master
$ sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --service-cidr=10.244.0.0/16 --apiserver-advertise-address=192.168.50.110
$ sudo cp -i /etc/kubernetes/admin.conf /vagrant/config
$ sudo chown $(id -u):$(id -g) /vagrant/config
```

3. Do rsync-back to get the `admin.conf` from guest to host.
```
vagrant rsync-back
```
