# netbox-vagrant

**Nuthshell:** Quickest NetBox install for Demo or Production(*recommended that you tweak slightly for production*).

This repository houses the components needed to build [NetBox](https://github.com/digitalocean/netbox/) using [Vagrant](https://www.vagrantup.com/intro) and [Hyper-V](https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v).

The original rrepository is [netbox-vagrant git repo](https://github.com/ryanmerolle/netbox-vagrant/) and uses Virtual Box instead of Hyper-V.

## Quickstart

 1. Enable Hyper-V and install Vagrant
 2. Clone [this respository](https://github.com/JB-BR/netbox-vagrant) ```# git clone https://github.com/JB-BR/netbox-vagrant .``` 
 3. Navigate to directory containing the repository on your local system and start vagrant
```# vagrant up```
 4. Log into VM (optional)
```# vagrant ssh```
 5. Play with Netbox demo in browser of choice [http://netbox.localhost:8080](http://netbox.localhost:8080) (Admin credentials use "admin" for userid and password - can be changed & credentials do not have quotes)
 6. (Optional) [NAPALM Config](http://netbox.readthedocs.io/en/stable/configuration/optional-settings/#napalm_username), [Email Config](http://netbox.readthedocs.io/en/stable/configuration/optional-settings/#email), [LDAP](http://netbox.readthedocs.io/en/stable/installation/ldap/)

## Upgrading

### Standard Update
The [normal NetBox upgrade process](https://github.com/digitalocean/netbox/blob/develop/docs/installation/upgrading.md) can be followed using the instructions to Clone the Git Repository (latest master release).

### Destroy and re-deploy update
⚠️ You will lose all your data, only do this witha test system ⚠️

You can also destroy your current netbox VM and create a new one. The install script will take care of installing the latest version. 
```
# vagrant destroy
# vagrant up
```

## Netbox Configuration Used
The [NetBox installation](https://github.com/digitalocean/netbox/blob/develop/docs/installation/netbox.md) process is followed leveraging:

* VM Memory: 2048 (edit Vagrantfile if you would like to change)
* VM CPUs: 1 (edit Vagrantfile if you would like to change)
* Ubuntu Hirsute Hippo 21.04 (updated)
* Python 3 (deprecated python2)
* GIT - Cloning the Netbox latest master release from github (as opposed to downloading a tar of a particular release)
* Ngnix (deprecated Apache)

## Security
* Netbox/Django superuser account is ```admin``` with a password ```admin``` and an email of ```admin@example.com``` (can be changed after startup)
* SECRET_KEY is randomly generated using generate_secret_key.py
* Postgres DB is setup using account is "nebox" with a password "J5brHrAXFLQSif0K" and the database "netbox" using the default port (all without quotes and can be changed after startup)
* [Forwarded Ports](https://www.vagrantup.com/docs/networking/forwarded_ports.html) - to add additional VM access / port forwarding (ssh, remote psql, etc)
* [Vagrant Credentials](https://www.vagrantup.com/docs/boxes/base.html#default-user-settings) - to understand credentials used for vagrant / Ubuntu VM

## Notes
* [bootstrap.sh](bootstrap.sh) can be used to bootstrap any Ubuntu Xenial setup & not just Vagrant (with slight tweaking)
* Additional Support Resources include:
 * [NetBox Github page](https://github.com/digitalocean/netbox/)
 * [NetBox Read the Docs](http://netbox.readthedocs.io/en/stable/)
 * [NetBox-discuss mailing list](https://groups.google.com/forum/#!forum/netbox-discuss)
 * [NAPALM Github page](https://github.com/napalm-automation/napalm/)
 * [NAPALM Read the Docs](https://napalm.readthedocs.io/)
 * [Join the Network to Code community on Slack](https://networktocode.herokuapp.com)