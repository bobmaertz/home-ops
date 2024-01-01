sudo qm clone 9000 999 --name test-clone-cloud-init
sudo qm set 999 --sshkey ~/.ssh/id_rsa.pub
sudo qm set 999 --ipconfig0 ip=192.168.1.201/24,gw=192.168.1.1
sudo qm start 999

sudo qm stop 999 && sudo qm destroy 999
rm focal-server-cloudimg-amd64.img


