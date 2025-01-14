# Summary

A collection of Ansible playbooks that support the management on Raspberry Pi device headlessly. 

# Dependencies

Host machine: sshpass, nmap, ansible

# Pre-requisites

Key items required:
- A running device
- An Ethernet connection and cable
- An OS configured with SSH setup for REMOTE_USER, REMOTE_PASSWORD auth
- A REMOTE_IP for the Raspberry Pi device on the local network
- A ssh key on host machine and HOST_KEY_PATH
- An inventory file that outlines password and later private key

## Host: Raspberry Pi OS config

- Use Raspberry Pi Imager app
- Flash the correct version to SD card using Imager UI
- Click 'Edit Settings'
    - General: set username and password REMOTE_USER, REMOTE_PASSWORD
    - General: set locale
    - Services: enable SSH and password auth
- Flash the card and eject when done
- Insert the card into the Raspberry Pi device
- Power on the device and make sure it's connected to network via Ethernet

## Host: Discover Raspberry Pi IP 

- Get local network address `ip addr` and grab "inet" IP range
- Host: Install and use `nmap`
- Run nmap on the network `nmap -sn IP_RANGE` (IP_RANGE from above steps)
- Record IPs and number of hosts found
- Power on Raspberry Pi, allow 5min+ for first power cycle, then restart device
- Rerun nmap and capture new IP as REMOTE_IP

## Host: Create ssh keys

- Create a new key `ssh-keygen -b 4096` and save as 'banana'
- Add it as an identity `ssh-add ~/.ssh/banana`, where ~/.ssh/banana becomes HOST_KEY_PATH
- Copy the public key to host `ssh-copy-id -i HOST_KEY_PATH REMOTE_USER@REMOTE_IP`, eg HOST_KEY_PATH = ~/.ssh/banana

## Host: Create `inventory.ini`

Initially with version A: 

```ini
[rpi]

REMOTE_IP ansible_password=REMOTE_PASSWORD

```

Later changing it to version B after "Playbook: ssh.yml" is executed

```ini
[rpi]

127.0.0.1 ansible_ssh_private_key_file=HOST_KEY_PATH

```

# Running: Generic  

`make user=REMOTE_USER PLAYBOOK`

REMOTE_USER - pre-configured user on device

PLAYBOOK - each make command is set up to be a 1-2-1 map with a playbook

eg

`make user=test_user ssh`

# Running: Sequence of playbooks

## Update the device

`make user=REMOTE_USER update`

## SSH: configure the device

`make user=REMOTE_USER ssh`

Change the inventory.ini from vers. A to vers. B, removing `ansible_password` and adding `ansible_ssh_private_key_file`

Host machine will not be able to ssh into Remote machine without auth key.

SSH config will only allow SSH key auth and block password and root auth.

# Authors

Alan Ionita

# License

MIT
