#!/bin/bash
BOXNAME="projectmanagement"
PLAYBOOK="projectmanagementserver"
cat << "EOF"
                               /                      /
                          ,.. /                  ,.. /
                        ,'   ';                ,'   ';
             ,,.__    _,' /';  .    ,,.__    _,' /';  .
            :','  ~~~~    '. '~    :','  ~~~~    '. '~
           :' (   )         ):,   :' (   )         )::,
           '. '. .=----=..-~ .;'  '. '. .=----=..-~  .;'
            '  ;' ::    ':. '"     '  ;'  ::   ':.  '"
              (:  ':     ;)          (:   ':    ;)
               \\  '"   ./            \\   '"  ./
                '"      '"             '"      '"
EOF

function clean {
	cd ~/project_internal/ansible/vagrant/virtualbox
	vagrant destroy $BOXNAME
	#sleep 10
	vagrant up $BOXNAME
	#sleep 10
	rsa_=$(vagrant ssh cm -c "cat ~/.ssh/id_rsa.pub")
	sleep 5
	vagrant ssh $BOXNAME -c "echo $rsa_ > ~/.ssh/authorized_keys"
	sleep 5
	rsa_=$(echo "empty")
}

function provision {
	echo "Please standby to type passwords for your environment and vault..."
	cd ~/project_internal/ansible/vagrant/virtualbox
	vagrant ssh cm -c "ansible-playbook -s -k -i /etc/ansible/environments/development/inventory -u vagrant /etc/ansible/playbooks/"$PLAYBOOK".yml --ask-vault-pass"
}

function lint {
	cd ~/project_internal/ansible/vagrant/virtualbox
	echo "Using: ansible-lint playbook.yml"
	vagrant ssh cm -c "ansible-lint /etc/ansible/playbooks/"$PLAYBOOK".yml"
	echo "Linting complete, all problems should be listed above..."
}

function all {
	lint
	clean
	provision
}

function installLint {
	cd ~/project_internal/ansible/vagrant/virtualbox
	echo "Copying: Linting rules from local repo folder to CM machine..."
	vagrant ssh cm -c "sudo cp /etc/ansible/roles/BuildServer/files/IndentionErrorRule.py /usr/local/lib/python2.7/dist-packages/ansiblelint/rules/"
  vagrant ssh cm -c "sudo cp /etc/ansible/roles/BuildServer/files/PackageInstallVersionRule.py /usr/local/lib/python2.7/dist-packages/ansiblelint/rules/"
}

echo '\033[1;35m************ Select operation ************\033[0m' 
echo "1) Clean machine"
echo "2) Provision"
echo "3) Lint"
echo "4) All of the above"
echo "5) Install Lint rules from local folder"
echo "6) Exit"

read n

case $n in
    1) clean;;
    2) provision;;
    3) lint;;
		4) all;;
		5) installLint;;
    *) echo "Bye...";;
esac


