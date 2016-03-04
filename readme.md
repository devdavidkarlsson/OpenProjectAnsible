# OpenProjectAnsible

Role for ProjectManagementServer
Tue Feb 23 13:01:20 CET 2016

If you chose to create a new machine from the vagrant file, i.e. a new machine you want to provision using ansible.
First run vagrant up and then:


To be able to execute am Ansible playbook on a new machine you have to deposit the public SSH Key from the CM machine on the serverspec machine. Therefore append the public key( cat ~/.ssh/id_rsa.pub ) on CM to the ~/.ssh/authorized_keys on the new Server. A quick way of doing that is to run the lines:

```
rsa_=$(vagrant ssh cm -c "cat ~/.ssh/id_rsa.pub")
vagrant ssh openproj -c "echo $rsa_ > ~/.ssh/authorized_keys"
rsa_=$(echo "empty")
```
Then:

```
ansible-playbook -s -k -i /etc/ansible/environments/development/inventory -u vagrant /etc/ansible/playbooks/projectmanagementserver.yml --ask-vault-pass
```
for dev environment ssh password is: vagrant
vault password: password

The machine should now be provisioned using the  environment variables in the inventory and the playbook provided...

Note: Both the node and ruby verions are built from source to ensure platform compability (this is nice).


```
//Aditions to the vagrantfile for adding a projectmanagement machine:
  config.vm.define "projectmanagement" do |projectmanagement|
    projectmanagement.vm.box = "ubuntu/trusty64"
    #if Vagrant.has_plugin?("vagrant-cachier")
    #  config.cache.scope = :box
    #  config.cache.synced_folder_opts = {
    #    type: :nfs,
    #  	 mount_options: ['rw', 'vers=3', 'tcp', 'nolock']
    #  }
    #end
    projectmanagement.vm.network "private_network", ip: "172.28.128.15"
    config.vm.provider :virtualbox do |vb|
      vb.memory = 2048
    end
    #projectmanagement.vm.provision :ansible do |ansible|
    #  ansible.playbook = "../../ansible/playbooks/projectmanagementserver.yml"
    #  ansible.sudo = true
    #end
    projectmanagement.vm.provision "shell", inline: <<-SHELL
      sudo sed "s/nameserver .*/nameserver 172.28.128.5/" -i /etc/resolv.conf
    SHELL
  end
```
