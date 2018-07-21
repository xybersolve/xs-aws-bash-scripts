# ansty

> Ansible helper script

```sh
$ antsy --help



   Script: antsy
   Purpose: Manage ansible projects, setup and configuration
   Usage: antsy [-h|--help] [-v|--version]

   Options:
     --help:  help and usage
     --version: show version info
     --install: Install ansible on Ubuntu
     --setup: Setup & configure local ansible project
     --keys: Setup keys for client automation access
     --dist: Copy scripts to scripts bin directory
     --sync: Synchronize local ansible code to bastion server (rsync)
     --watch: Synchronize automatically anytime code is updated

     --role=<role_name>: create a role
       -h|--handlers: create 'handlers'
       -t|--temp*: create 'templates'
       -f|--files: create 'files'
       -d|--defaults: create 'defaults'
       -p: use current directory

   Examples:
     antsy --install
     antsy --check-stack
     antsy --setup
     antsy --keys
     antsy --info
     antsy --install --setup --keys --info
     antsy --sync
     antsy --role=mysql -p -d -h -f -t
     antsy --role=mysql -p --defaults --handlers -files --temp
     antsy --watch
     antsy --dist --host=54.241.221.184 --user=ubuntu --dir=bin
     antsy --dist --hostname=control --dir=bin

```

## [License](LICENSE.md)
