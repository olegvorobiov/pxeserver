#!/bin/bash

. variables.txt
# yum install -y dhcp tftp tftp-server syslinux vsftpd xinetd 


# echo "#DHCP Server Configuration file." >> /etc/dhcp/dhcpd.conf
# echo "ddns-update-style interim;" >> /etc/dhcp/dhcpd.conf
# echo "ignore client-updates;" >> /etc/dhcp/dhcpd.conf
# echo "authoritative;" >> /etc/dhcp/dhcpd.conf
# echo "allow booting;" >> /etc/dhcp/dhcpd.conf
# echo "allow bootp;" >> /etc/dhcp/dhcpd.conf
# echo "allow unknown-clients;" >> /etc/dhcp/dhcpd.conf
# echo  >> /etc/dhcp/dhcpd.conf
# echo "#internal subnet for my DHCP Server" >> /etc/dhcp/dhcpd.conf
# echo "subnet $dhcp_subnet netmask $dhcp_netmask {" >> /etc/dhcp/dhcpd.conf
# echo "range $dhcp_range;" >> /etc/dhcp/dhcpd.conf
# echo "option domain-name-servers $dhcp_dns_server;" >> /etc/dhcp/dhcpd.conf
# echo "option domain-name $dhcp_domain_name;" >> /etc/dhcp/dhcpd.conf
# echo "option routers 192.168.1.1;" >> /etc/dhcp/dhcpd.conf
# echo "option broadcast-address 192.168.1.255;" >> /etc/dhcp/dhcpd.conf
# echo "default-lease-time 600;" >> /etc/dhcp/dhcpd.conf
# echo "max-lease-time 7200;" >> /etc/dhcp/dhcpd.conf
# echo  >> /etc/dhcp/dhcpd.conf
# echo "# IP of PXE Server" >> /etc/dhcp/dhcpd.conf
# echo "next-server $dhcp_ip;" >> /etc/dhcp/dhcpd.conf
# echo "filename \"pxelinux.0\";" >> /etc/dhcp/dhcpd.conf
# echo "}" >> /etc/dhcp/dhcpd.conf

# sed -i "s/disable.*/disable\t\t\t= no/" /etc/xinetd.d/tftp

# cp -vp /usr/share/syslinux/{pxelinux.0,menu.c32,memdisk,mboot.c32,chain.c32} /var/lib/tftpboot/

# mkdir /var/lib/tftpboot/{pxelinux.cfg,networkboot}

# cd /tmp
# mount -o loop *.iso /mnt 
# cd /mnt/
# cp -av * /var/ftp/pub
# cp -p /mnt/images/pxeboot/{vmlinuz,initrd.img} /var/lib/tftpboot/networkboot/
# cd /
# umount /mnt/

echo "default menu.c32" >> /var/lib/tftpboot/pxelinux.cfg/default
echo "prompt 0" >> /var/lib/tftpboot/pxelinux.cfg/default
echo "timeout 30" >> /var/lib/tftpboot/pxelinux.cfg/default
echo "MENU TITLE ######## PXE Menu #########" >> /var/lib/tftpboot/pxelinux.cfg/default
echo "LABEL 1" >> /var/lib/tftpboot/pxelinux.cfg/default
echo "MENU LABEL ^1) Install CentOS 7" >> /var/lib/tftpboot/pxelinux.cfg/default
echo "KERNEL /networkboot/vmlinuz" >> /var/lib/tftpboot/pxelinux.cfg/default
echo "APPEND initrd=/networkboot/initrd.img inst.repo=ftp://$dhcp_ip/pub ks=ftp://$dhcp_ip/pub/centos7.cfg" >> /var/lib/tftpboot/pxelinux.cfg/default




systemctl start xinetd
systemctl start dhcpd
systemctl start vsftpd
systemctl enable xinetd
systemctl enable dhcpd
systemctl enable vsftpd