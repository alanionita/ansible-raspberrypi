update:
	ansible-playbook -i inventory.ini update.yml --user $(user)

shutdown:
	ansible-playbook -i inventory.ini shutdown.yml --user $(user)

ssh:
	ansible-playbook -i inventory.ini ssh.yml --user $(user)

apps:
	ansible-playbook -i inventory.ini apps.yml --user $(user)