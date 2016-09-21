# Shelltracer
Small sh script collection for SSH User Login notifications over [pushover.net](https://pushover.net/).  
Can also be used for other notifications, like OS startups, letsencrypt renewal, ...! Only limited by you imagination!

## Installation
Download the repo files, copy "config.sample" to "config" and adjust it. 
Then add following line to your /etc/pam.d/sshd file:
```
session         optional        pam_exec.so             /root/shelltracer/exec.sh
```

## Demo

![screenshot_lockscreen](https://cloud.githubusercontent.com/assets/3774136/18708456/2b20a088-7ffb-11e6-9381-ac06e43553ab.png)
![screenshot_pushover](https://cloud.githubusercontent.com/assets/3774136/18708455/2b206ffa-7ffb-11e6-898a-dbe5c7ad2d03.png)

