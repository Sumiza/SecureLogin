#!/bin/bash

echo "Select what you would like to do:
        1) Install ssh key
        2) Remove password login
        3) Change ssh port
        4) Install 2FA for password login (Google Authenticator)"

read -r ans
if [ "$ans" = "1" ]; then
        echo "Select where the key is located:
                1) Remote (will wget key)
                2) Paste in key
                3) File location"
        read -r ans
        if [ "$ans" = "1" ]; then
               echo "Paste in the remote location of file (wget)"
               read -r ans
               if ! command -v wget &> /dev/null; then
                        apt install wget -y
               fi
               wget -O tempkey "$ans"
               holdkey=$(cat tempkey)
               rm tempkey
        elif [ "$ans" = "2" ]; then
                echo "Paste in your public key"
                read -r ans
                holdkey="$ans"
        elif [ "$ans" = "3" ]; then
                echo "Paste in the file with your public key"
                read -r ans
                holdkey=$(cat "$ans")
        fi
        
        if [ "$(grep "$holdkey" ~/.ssh/authorized_keys)" = "" ]; then
                echo "--------------------
                $holdkey
                --------------------
                Do you want to add this key? y/n"
                read -r ans
                if [ "$ans" = "y" ]; then
                        mkdir -p ~/.ssh
                        chmod 700 ~/.ssh
                        $holdkey >> ~/.ssh/authorized_keys
                        chmod 600 ~/.ssh/authorized_keys
                        sed -i '/PubkeyAuthentication /c\PubkeyAuthentication yes' /etc/ssh/sshd_config
                        tail -n 1 ~/.ssh/authorized_keys
                        echo "Key has been added"
                else
                        echo "Nothing was added"
                fi

        else
                echo "This key is already there, nothing added."
        fi
elif [ "$ans" = "2" ]; then
        echo "Do you want to remove password access y/n"
        read -r ans
        if [ "$ans" = "y" ]; then
                sed -i '/PasswordAuthentication /c\PasswordAuthentication no' /etc/ssh/sshd_config
                echo "Password authentication has been removed"
        fi

elif [ "$ans" = "3" ]; then
        echo "What port would you like to change to? (remember to update firewall if you have one)"
        read -r ans
        if [ "$ans" != "" ]; then
                sed -i "/Port /c\Port $ans" /etc/ssh/sshd_config
                echo "ssh port set to $ans"
        fi
elif [ "$ans" = "4" ]; then
        if ! command -v google-authenticator &> /dev/null; then
                        apt install libpam-google-authenticator -y
        fi
        google-authenticator -t -d -f --rate-limit=3 --rate-time=30 --window-size=3
        sed -i '/ChallengeResponseAuthentication /c\ChallengeResponseAuthentication yes' /etc/ssh/sshd_config
        if [ "$(grep "auth required pam_google_authenticator.so" /etc/pam.d/sshd)" = "" ]; then
                "auth required pam_google_authenticator.so" >> /etc/pam.d/sshd
        fi
fi
systemctl restart sshd
