#!/usr/bin/env bash
# cleanup image for template creation
export BASH_XTRACEFD=1
set -ux

unset HISTFILE

/usr/sbin/setenforce 0
/usr/bin/systemctl stop rsyslog
/usr/bin/systemctl stop auditd
/usr/bin/systemctl disable --now kdump

/sbin/logrotate -f /etc/logrotate.conf

test -x /bin/package-cleanup && /bin/package-cleanup -y --oldkernels --count=1
test -x /bin/dnf && /bin/dnf -y remove --oldinstallonly --setopt installonly_limit=2

test -x /usr/sbin/subscription-manager && /usr/sbin/subscription-manager unregister
test -x /usr/sbin/subscription-manager && /usr/sbin/subscription-manager clean

/usr/bin/yum clean all
/bin/rm -rf /var/cache/yum
/bin/rm -rf /var/cache/dnf

test -d /var/db/sudo/lectured && /bin/rm -f /var/db/sudo/lectured/*

test -f /var/log/audit/audit.log && /bin/cat /dev/null > /var/log/audit/audit.log
test -f /var/log/messages && /bin/cat /dev/null > /var/log/messages
test -f /var/log/wtmp && /bin/cat /dev/null > /var/log/wtmp
test -f /var/log/lastlog && /bin/cat /dev/null > /var/log/lastlog
test -f /var/log/grubby && /bin/cat /dev/null > /var/log/grubby

/bin/rm -f /var/log/audit/audit.log.*
/bin/rm -f /var/log/messages-*
/bin/rm -f /var/log/maillog-*
/bin/rm -f /var/log/cron-*
/bin/rm -f /var/log/spooler-*
/bin/rm -f /var/log/secure-*
/bin/rm -f /var/log/yum-*
/bin/rm -f /var/log/up2date-*
/bin/rm -f /var/log/dmesg.old
/bin/rm -f /var/log/*-????????
/bin/rm -f /var/log/*.gz
/bin/rm -f /var/log/vboxadd-*

/bin/rm -rf /var/log/anaconda
/bin/rm -rf /root/.ssh
/bin/rm -f /root/anaconda-ks.cfg
/bin/rm -f /root/anaconda-ks.post.log
/bin/rm -f /root/original-ks.cfg
/bin/rm -f /root/.bash_history

/bin/sed -i '/^[ \t]*\(HWADDR\|UUID\)/d' /etc/sysconfig/network-scripts/ifcfg-e*
/bin/rm -f /etc/udev/rules.d/70-persistent-net.rules
/bin/rm -f /etc/dhcp/dhclient-exit-hooks
test -f /etc/machine-id && /bin/cat /dev/null > /etc/machine-id
test -f /var/lib/dbus/machine-id && /bin/cat /dev/null > /var/lib/dbus/machine-id

echo "localhost" > /etc/hostname
echo "127.0.0.1 localhost localhost.localdomain localhost4 localhost4.localdomain4" > /etc/hosts
echo "::1       localhost localhost.localdomain localhost6 localhost6.localdomain6" >> /etc/hosts

/bin/rm -f /etc/ssh/ssh_host_*
/bin/rm -rf /tmp/*
/bin/rm -rf /var/tmp/*

touch /.template
