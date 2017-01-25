sudo apt-get  update 
sudo apt-get install aptitude git screen -y 
ssh-keyscan  github.com >> ~/.ssh/known_hosts
git clone git@github.com:ktaka-ccmp/kubernetes-setup-ansible.git
cd kubernetes-setup-ansible/
git checkout lvs-aws
#time ./setup.sh 

cd
git clone git@github.com:ktaka-ccmp/kubernetes-ingress.git
cd kubernetes-ingress/
git checkout ktaka 
