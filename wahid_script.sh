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
sed -i '/PID_FILE=/var/run/dropbear.pid/a OPTIONS=“-p 443”' /etc/init.d/dropbear

# install badvpn
wget -O /usr/bin/badvpn-udpgw "https://raw.github.com/arieonline/autoscript/master/conf/badvpn-udpgw"
if [ "$OS" == "x86_64" ]; then
  wget -O /usr/bin/badvpn-udpgw "https://raw.github.com/arieonline/autoscript/master/conf/badvpn-udpgw64"
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

# install squid
yum -y install squid
sed -i '/http_access allow localhost/a http_access allow all' /etc/squid/squid.conf
sed -i 's/http_access deny all/ http_access allow all/g' /etc/squid/squid.conf
sed -i 's/http_port 3128/ http_port 8080/g' /etc/squid/squid.conf
sed -i '/4320/a via off' /etc/squid/squid.conf
sed -i '/via off/a forwarded_for off' /etc/squid/squid.conf
sed -i '/forwarded_for off/a request_header_access Allow allow all' /etc/squid/squid.conf
sed -i '/request_header_access Allow allow all/a request_header_access Authorization allow all' /etc/squid/squid.conf
sed -i '/request_header_access Authorization allow all/a request_header_access WWW-Authenticate allow all' /etc/squid/squid.conf
sed -i '/request_header_access WWW-Authenticate allow all/a request_header_access Proxy-Authorization allow all' /etc/squid/squid.conf
sed -i '/request_header_access Proxy-Authorization allow all/a request_header_access Proxy-Authenticate allow all' /etc/squid/squid.conf
sed -i '/request_header_access Proxy-Authenticate allow all/a request_header_access Cache-Control allow all' /etc/squid/squid.conf
sed -i '/request_header_access Cache-Control allow all/a request_header_access Content-Encoding allow all' /etc/squid/squid.conf
sed -i '/request_header_access Content-Encoding allow all/a request_header_access Content-Encoding allow all' /etc/squid/squid.conf
sed -i '/request_header_access Content-Encoding allow all/a request_header_access Content-Type allow all' /etc/squid/squid.conf
sed -i '/request_header_access Content-Type allow all/a request_header_access Date allow all' /etc/squid/squid.conf
sed -i '/request_header_access Date allow all/a request_header_access Expires allow all' /etc/squid/squid.conf
sed -i '/request_header_access Expires allow all/a request_header_access Host allow all' /etc/squid/squid.conf
sed -i '/request_header_access Host allow all/a request_header_access If-Modified-Since allow all' /etc/squid/squid.conf
sed -i '/request_header_access If-Modified-Since allow all/a request_header_access Last-Modified allow all' /etc/squid/squid.conf
sed -i '/request_header_access Last-Modified allow all' /a request_header_access Location allow all' /etc/squid/squid.conf
sed -i '/request_header_access Location allow all/a request_header_access Pragma allow all' /etc/squid/squid.conf
sed -i '/request_header_access Pragma allow all/a request_header_access Accept allow all' /etc/squid/squid.conf 
sed -i '/request_header_access Accept allow all/a request_header_access Accept-Charset allow all' /etc/squid/squid.conf 
sed -i '/request_header_access Accept-Charset allow all/a request_header_access Accept-Encoding allow all' /etc/squid/squid.conf 
sed -i '/request_header_access Accept-Encoding allow all/a request_header_access Accept-Language allow all' /etc/squid/squid.conf 
sed -i '/request_header_access Accept-Language allow all' /a request_header_access Content-Language allow all' /etc/squid/squid.conf 
sed -i '/request_header_access Content-Language allow all/a request_header_access Mime-Version allow all' /etc/squid/squid.conf 
sed -i '/request_header_access Mime-Version allow all/a request_header_access Retry-After allow all' /etc/squid/squid.conf 
sed -i '/request_header_access Retry-After allow all/a request_header_access Title allow all' /etc/squid/squid.conf 
sed -i '/request_header_access Title allow all/a request_header_access Connection allow all' /etc/squid/squid.conf 
sed -i '/request_header_access Connection allow all/a request_header_access Proxy-Connection allow all' /etc/squid/squid.conf 
sed -i '/request_header_access Proxy-Connection allow all/a request_header_access User-Agent allow all' /etc/squid/squid.conf 
sed -i '/request_header_access User-Agent allow all/a request_header_access Cookie allow all' /etc/squid/squid.conf 
sed -i '/request_header_access Cookie allow all/a request_header_access All deny all' /etc/squid/squid.conf
sed -i '/request_header_access All deny all/a dns_nameservers 8.8.8.8 8.8.4.4' /etc/squid/squid.conf
sed -i '/dns_nameservers 8.8.8.8 8.8.4.4/a visible_hostname proxy.premium' /etc/squid/squid.conf

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
echo "Squid3   : port 8080"  | tee -a log-install.txt
echo "Httpd    : port 80"  | tee -a log-install.txt
echo "Badvpn   : port 7300"  | tee -a log-install.txt
echo "Webmin   : http://$MYIP:10000/"  | tee -a log-install.txt
echo "Timezone : Asia/Jakarta"  | tee -a log-install.txt
echo "============================================"  | tee -a log-install.txt
echo "TERIMAKASIH TELAH MENGUNAKAN JASA KAMI :D"  | tee -a log-install.txt
echo "============================================"  | tee -a log-install.txt
