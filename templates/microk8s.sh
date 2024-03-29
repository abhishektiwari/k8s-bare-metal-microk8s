cat <<EOF
# Install microk8s
sudo apt install snapd -y
sudo snap install microk8s --classic --channel=$(<./data/channel)

until sg microk8s -c 'sudo microk8s status --wait-ready'; 
  do sleep 5; echo "waiting for node status.."; 
done
EOF
for user in `cat ./data/ssh.users`;
do
cat <<EOF

# Configure user ${user}
sudo usermod -a -G microk8s ${user}
sudo chown -f -R ${user} ~/.kube
sudo echo "alias kubectl='microk8s kubectl'" >> /home/${user}/.bash_aliases

# Postpone updates indefinitely
sudo snap refresh --hold=forever microk8s

EOF
done