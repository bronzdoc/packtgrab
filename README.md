# packtgrab

Grab a book a day for free from Packt Pub, https://www.packtpub.com/packt/offers/free-learning.

Set yout credentials in the packt_auth.yaml file
```
---
PACKT_EMAIL:    your www.packtpub.com email
PACKT_PASSWORD: your www.packtpub.com password
```

Add it as a cron

    crontab -e

Within the open cron editor(assuming you clone it at $HOME)

    0 14 * * * {your ruby path}/ruby {you packtgrab.rb path}/packtgrab.rb

or you could use it whatever you like... be creative

#### now go to https://www.packtpub.com and create an account they are awesome!

---
######This little program was inspired by https://github.com/draconar/grab_packt

