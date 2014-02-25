# install wget and curl
yum -y install wget curl
yum -y install nano screen

# setting repo
wget http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
wget http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
rpm -Uvh epel-release-6-8.noarch.rpm
rpm -Uvh remi-release-6.rpm

if [ "$OS" == "x86_64" ]; then
  wget http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
  rpm -Uvh rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
else
  wget http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.i686.rpm
  rpm -Uvh rpmforge-release-0.5.3-1.el6.rf.i686.rpm
fi

sed -i 's/enabled = 1/enabled = 0/g' /etc/yum.repos.d/rpmforge.repo
sed -i -e "/^\[remi\]/,/^\[.*\]/ s|^\(enabled[ \t]*=[ \t]*0\\)|enabled=1|" /etc/yum.repos.d/remi.repo
rm -f *.rpm
cd

# update
yum -y update
yum -y groupinstall 'Development Tools'
yum -y install cmake screen

# setting port ssh
sed -i '/Port 22/a Port 143' /etc/ssh/sshd_config
sed -i 's/#Port 22/Port  22/g' /etc/ssh/sshd_config

# install dropbear
wget http://dl.fedoraproject.org/pub/epel/5/i386/epel-release-5-4.noarch.rpm
rpm -Uvh epel-release*rpm
yum -y install dropbear
echo "OPTIONS=\"-p 443\"" > /etc/sysconfig/dropbear
echo "/bin/false" >> /etc/shells

# install badvpn
wget -O /usr/bin/badvpn-udpgw "https://raw.github.com/kunwabu/badvpn/master/badvpn-udpgw"
if [ "$OS" == "x86_64" ]; then
  wget -O /usr/bin/badvpn-udpgw64 "https://raw.github.com/kunwabu/badvpn/master/badvpn-udpgw64"
fi
sed -i '$ i\screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300' /etc/rc.local
sed -i '$ i\screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300' /etc/rc.d/rc.local
chmod +x /usr/bin/badvpn-udpgw
screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300

# install webmin
wget http://prdownloads.sourceforge.net/webadmin/webmin-1.670-1.noarch.rpm
rpm -i webmin-1.670-1.noarch.rpm;
rm webmin-1.670-1.noarch.rpm
service webmin restart

# install screenfetch
wget https://github.com/kunwabu/config/raw/master/screenfetch-dev
mv screenfetch-dev /usr/bin/screenfetch
chmod +x /usr/bin/screenfetch
echo "clear" >> .bash_profile
echo "screenfetch" >> .bash_profile

# install squid
yum -y install squid
yum -y install squid
wget -O /etc/squid/squid.conf "https://github.com/kunwabu/config/raw/master/squid.conf"


# install httpd
yum -y install httpd

# service
service sshd restart
service dropbear start
service httpd start
service squid start

# aktivasi
chkconfig sshd on
chkconfig dropbear on
chkconfig webmin on
chkconfig httpd on
chkconfig squid on

# info
echo "Abdul Wahid Syarifuddin| @kunwabu | 750D569E" | tee log-install.txt
echo "=============================================" | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Sukses Terinstall"  | tee -a log-install.txt
echo "------------------------------------------"  | tee -a log-install.txt
echo "OpenSSH  : port 22, 143"  | tee -a log-install.txt
echo "Dropbear : port 443"  | tee -a log-install.txt
echo "Squid3   : port 80, 8080"  | tee -a log-install.txt
echo "Badvpn   : port 7300"  | tee -a log-install.txt
echo "Webmin   : http://$MYIP:10000/"  | tee -a log-install.txt
echo "Timezone : Indonesia/Madura"  | tee -a log-install.txt
echo "============================================"  | tee -a log-install.txt
echo "TERIMAKASIH TELAH MENGUNAKAN JASA KAMI :D"  | tee -a log-install.txt
echo "============================================"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
