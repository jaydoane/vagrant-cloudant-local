# Vagrant-Ansible Cloudant Local Cluster Installer

Install a Cloudant Local cluster using Vagrant and Ansible

## Prerequisites

These instructions assume you have a Mac running at least Yosemite
with homebrew installed, and that you *don't* already have Vagrant and
VirtualBox installed.

- `brew install brew-cask`
- `brew install Caskroom/cask/virtualbox`
- `brew install Caskroom/cask/vagrant`
- `pyenv virtualenv ansible`
- `pyenv activate ansible`
- `pip install ansible`
- `pip install s3cmd`
- `vagrant plugin install vagrant-hostmanager`
- `vagrant plugin install vagrant-host-shell`
- create ~/.s3cfg containing `access_key` and `secret_key` for accessing
  `s3://cloudant-local-installer/releases/latest`

## Usage

- `ansible-playbook -i local get_latest_installer.yml`
- `vagrant box add https://atlas.hashicorp.com/ubuntu/boxes/trusty64`
  or change to whichever platform you want
- `vagrant up`
