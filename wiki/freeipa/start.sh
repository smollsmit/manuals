hostnamectl set-hostname ldap.hm.loc
echo "192.168.1.231 ldap.hm.loc" | sudo tee -a /etc/hosts

firewall-cmd --add-service={freeipa-ldap,freeipa-ldaps,dns,ntp} --permanent
firewall-cmd --reload

dnf module enable idm:DL1
dnf distro-sync
dnf install ipa-server ipa-server-dns

export ipaPass=
export ipaDomain=hm.loc
export ipaealm=HM.LOC

ipa-server-install --unattended \
  --domain ${ipaDomain} \
  --realm ${ipaRealm} \
  --ds-password ${ipaPass} \
  --admin-password ${ipaPass} \
  --setup-dns \
  --no-host-dns \
  --auto-reverse \
  --forwarder 192.168.1.1

kinit admin
klist

ipa user-find
ipa user-show --all UserName
