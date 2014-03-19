---
layout: post
title:  "Updating Arch Linux on DigitalOcean"
date:   2014-03-14 11:03:00
categories: how-to-fix
disqus: 'updating-arch-linux-on-digialocean'
---

I have been wanting to try Arch Linux for a while so I spun up a DigitalOcean droplet with Arch Linux installed. Unfortunately DigitalOcean's image (2013.05) is almost a year old which causes problems when updating. Here are the fixes.

## Filesystem Issue

These instructions are based off instructions in an [Arch announcement][1] but more specific for a fresh DigitalOcean install.

When I ran `pacman -Syu` to upgrade the system I received the following errors:

    error: failed to commit transaction (conflicting files)
    filesystem: /bin exists in filesystem
    filesystem: /sbin exists in filesystem
    filesystem: /usr/sbin exists in filesystem

This fix is as follows:

1. Update the package databases if you haven't already.

        pacman -Sy

2. First remove the conflicting package by running and entering yes.

        pacman -S sysvinit-tools

3. Then upgrade all of the system in increments to ensure that the above directories are ready to be removed and symlinked when the filesystem package is finally upgraded.

        pacman -Su --ignore filesystem,bash
        pacman -S bash
        pacman -Su

## Network Issue

An upgraded version of systemd will change the behavior for naming network interfaces. Previously udev would name the first network interface eth0. After updating it will be given a new name derived from its hardware connection. If this is not fixed your droplet will lose internet after a reboot. Also the package netcfg used by Arch to configure the network has been replaced by netctl. We can fix both of these problems at the same time.

1. Install netctl by following this [DigitalOcean tutorial][2] but replace eth0 with `enp0s3` everywhere you type eth0. The tutorial will have you restart, go ahead and do that. If you restart and cannot connect to the internet, double check that your ethernet connection is named `enp0s3` by viewing every interfaces name by running `ls /sys/class/net/`.

2. Systemd still has a service that will try to initialize the old eth0 interface. Disabling the service will prevent the boot process from slowing down due to waiting for a non-existent interface.

    ```
    systemctl disable network@eth0
    ```

## Underlying Problem

I am new to Arch Linux but from what I have gleaned so far, Arch Linux installs are meant to stay up-to-date. If you let your system fall behind in upgrades then it can be difficult to figure out the correct upgrade path (as package upgrades might have inter-dependencies that get complicated as time progresses). The real fix for this problem is for DigitalOcean to keep their Arch Linux image more up-to-date.

[1]: https://www.archlinux.org/news/binaries-move-to-usrbin-requiring-update-intervention/
[2]: https://www.digitalocean.com/community/articles/how-to-upgrade-arch-from-netcfg-to-netctl-on-a-digitalocean-vps
