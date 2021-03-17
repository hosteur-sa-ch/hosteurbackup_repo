#!/bin/bash

echo "Installing Hosteur Backup for Veeam Repo : Debian release"

echo "Please type your Hosteur Backup Account"
read hbuser

echo "Please type your Hosteur Backup Pasword"
read hbpasswd

echo "Please type your Backup Plan Name"
read hbplan

echo "Please type your Storage Account [VR02TDF_Restricted,VR02TDF_Restricted]"
read hbsacc

echo "Please type your Source Folder"
read hbsrcf

echo "Please type your Encryption Key (Store Carrefully !!!!)"
read hbenkey

apt install wget

wget https://s3.amazonaws.com/cb_setups/MBS/E2485941-C2F6-41CC-ACE8-3B0BDC37B854/rh6_HOSTEURSA_HosteurBackup_v2.10.2.73_20200422200232.rpm
rpm --install rh6_HOSTEURSA_HosteurBackup_v2.10.2.73_20200422200232.rpm

ln -s /opt/local/Hosteur\ Backup/bin/cbb /usr/bin/cbb

cbb addAccount -e $hbuser -p $hbpasswd -ssl yes
cbb option -set bw -b 102400

cbb addBackupPlan -n $hbplan -a $hbsacc -f $hbsrcf -c yes -ea "AES_256" -ep $hbenkey -every week -at "08:00" -weekday "su"

read -p "Do you need to start the plan now? " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
  cbb plan -r $hbuser
then
    exit 1
fi

echo "to stop plan use cbb plan -s $hbplan"
cbb getPlanDetails -n $hbplan