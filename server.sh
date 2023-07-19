#!/bin/bash
#General setup for the  user (ssh hardening)
#User name will be admin
useradd -m admin -s /bin/bash
echo -e "H57yUL8h\nH57yUL8h" | passwd admin #random password for admin wont be required since login will be through key and user will be able to sudo without password
mkdir /home/admin/.ssh
cp /root/.ssh/authorized_keys /home/admin/.ssh/authorized_keys
chmod 600 /home/admin/.ssh/authorized_keys
chmod 700 /home/admin/.ssh
chown -R admin:admin /home/admin/.ssh
echo $'#admin entry\nadmin ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
sed -i 's/^PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/^PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
systemctl restart sshd



