# SecureLogin

Quick script to secure the login for a new server, for debian

```
bash <(wget -qO- https://raw.githubusercontent.com/Sumiza/SecureLogin/main/secure.sh)
```
if you dont have certificates installed:
```
bash <(wget --no-check-certificate -qO- https://raw.githubusercontent.com/Sumiza/SecureLogin/main/secure.sh)
```


Does basic configuration for different login types
```
        1) Install ssh key
        2) Remove password login
        3) Change ssh port
        4) Install 2FA with password login (Google Authenticator)
```
1.  Install a ssh key by these methods:
```
	1) Remote (will wget key)
	2) Paste in key
	3) File location 
```
It will also set all the permissions for the authorized_keys file and folder

2.  Will remove the ability to log in with a password, make sure you have alternative ways set up to log in as this can lock you out.

3.  Changes the ssh port, (security through obscurity joke here) but it will cut down on a lot of noise.

4.  Will install the Google autenticator and set it up to work with your password, ssh keys will bypass the 2FA.
