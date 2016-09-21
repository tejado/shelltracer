# Shelltracer
Small sh script collection for SSH User Login notifications over [pushover.net](https://pushover.net/).  
Can also be used for other notifications, like OS startups, letsencrypt renewal, ...! Only limited by you imagination!

## Installation
Download the repo files, copy "config.sample" to "config" and adjust it. 
Then add following line to your /etc/pam.d/sshd file:
```
session         optional        pam_exec.so             /root/shelltracer/exec.sh
```

