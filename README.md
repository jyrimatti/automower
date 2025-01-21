# Homekit.sh plugin for Husqvarna Automower

Prerequisites
-------------
- get a computer (e.g. a server or a Raspberry Pi)
- install [Nix](https://nixos.org/download/)
- install [Homekit.sh](https://github.com/jyrimatti/homekit.sh)

Setup for home automation
-------------------------

```
cd ~/.config/homekit.sh/accessories
```

Clone this repo
```
git clone https://github.com/jyrimatti/automower.git
cd automower
```

Store Automower credentials and address
```
echo '<my automower clientid>' > .automower-clientid
echo '<my automower clientsecret>' > .automower-clientsecret
chmod go-rwx .automower*
```

Setup for data collection
-------------------------

```
cd ~/.config/homekit.sh/accessories/automower
```

Create the database
```
./automower_createdb.sh
```

Running nix-shell periodically will bork your server by creating lots of files under /tmp, so you need to install dependencies globally by executing:
```
ls *collect2db.sh | tr ' ' '\n' | while read -r f; do { grep '^#!\s*nix-shell' $f; }; done | sed 's/.*-p//' | tr ' ' '\n' | sort | uniq | grep -v '^$' | sed 's/^/nixpkgs\./' | tr '\n' ' ' | { echo -n 'NIXPKGS_ALLOW_UNFREE=1 nix-env -I channel:nixos-24.11-small -iA '; cat; }
```

and modify path in crontab:
```
PATH=/home/pi/.local/nix-override:/home/pi/.nix-profile/bin:/usr/bin:/bin
```

Use cron job to read values periodically, for example:
```
* * * * * cd ~/.config/homekit.sh/accessories/automower; ./automower_collect2db.sh 2>&1 1>/dev/null | logger -p cron.info -t automower
```

External hosting
----------------
If you want to replicate your collected database to another host, you can use a cron job:

```
0,15,30,45 * * * * cd ~/.config/homekit.sh/accessories/automower; ./automower_rsync.sh <remoteuser> <remotehost> <remotepath> 2>&1 1>/dev/null | logger -p cron.info -t automowerrsync
```

Make sure to configure your SSH to use public-key authentication for the remote host.
