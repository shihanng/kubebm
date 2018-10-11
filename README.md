1. Edit the `./ansible/hosts` file to include the IP addresses of the nodes.
For example a single node config would look like this:
```
[nodes]
192.168.0.10
```

2. Execute Ansible playbook to provision the machine.
```
export PRIV_KEY=""
pushd ansible
ansible-playbook --diff --check -vv provision.yml --private-key=~/.ssh/id_rsa --ask-become-pass
popd
```

3. SSH into the master node and setup Kubernetes master.
```
$ sudo kubeadm init
```

4. Use the `/etc/kubernetes/admin.conf` from the master to use it as the
   `KUBECONFIG`.

5. Taint the master node so that we can use the master as single-host cluster.
```
kubectl taint nodes --all node-role.kubernetes.io/master-
```

6. Install networking.
```
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
```

7. When we have more machines to join the the cluster, we can generate the join
   command from the master like the following.
```
$ sudo kubeadm token create --print-join-command
```

# References
- [A. Ellis, Kubernetes on bare-metal in 10 minutes](https://blog.alexellis.io/kubernetes-in-10-minutes/)
- [A. Ellis, Your instant Kubernetes cluster](https://blog.alexellis.io/your-instant-kubernetes-cluster/)
