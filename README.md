# Puppet module for Podium.

[![Build Status](https://travis-ci.org/thehyve/puppet-podium.svg?branch=master)](https://travis-ci.org/thehyve/puppet-podium/branches)

This is the repository containing a puppet module for deploying the [Podium application](https://github.com/thehyve/podium),
an open source, microservices based request portal.

The module creates the system user `podium`, downloads and installs
the Podium services application, and configures the databases.
The repository used to fetch the required Podium packages from is configurable and defaults to `repo.thehyve.nl`.


## Dependencies and installation

### Puppet modules
The module depends on the `java`, `stdlib`, `archive` and `postgresql` modules.

The most convenient way is to run `puppet module install` as `root`:
```bash
sudo puppet module install puppetlabs-java
sudo puppet module install puppetlabs-stdlib
sudo puppet module install puppet-archive
sudo puppet module install puppetlabs-postgresql
```
Alternatively, the modules and their dependencies can be cloned from `github.com`
and copied into `/etc/puppetlabs/code/modules`:
```bash
git clone https://github.com/puppetlabs/puppetlabs-java java
pushd java; git checkout 1.5.0; popd
git clone https://github.com/puppetlabs/puppetlabs-stdlib stdlib
pushd stdlib; git checkout 4.17.0; popd
git clone https://github.com/voxpupuli/puppet-archive.git archive
pushd archive; git checkout v1.3.0; popd
git clone https://github.com/puppetlabs/puppetlabs-postgresql postgresql
pushd postgresql; git checkout 4.7.1; popd
cp -r stdlib archive postgresql /etc/puppetlabs/code/modules/
```

### Install the `podium` module
Copy the `podium` module repository to the `/etc/puppetlabs/code/modules` directory:
```bash
cd /etc/puppetlabs/code/modules
git clone https://github.com/thehyve/puppet-podium.git podium
```

## Configuration

### The node manifest

For each node where you want to install Podium, the module needs to be included with
`include ::podium::complete`.

Here is an example manifest file `manifests/test.example.com.pp`:
```puppet
node 'test.example.com' {
    include ::podium::complete
}
```
The node manifest can also be in another file, e.g., `site.pp`.

### Configuring a node using Hiera

It is preferred to configure the module parameters using Hiera.

To activate the use of Hiera, configure `/etc/puppetlabs/code/hiera.yaml`. Example:
```yaml
---
:backends:
  - yaml
:yaml:
  :datadir: '/etc/puppetlabs/code/hieradata'
:hierarchy:
  - '%{::clientcert}'
  - 'default'
```
Defaults can then be configured in `/etc/puppetlabs/code/hieradata/default.yaml`, e.g.:
```yaml
---
podium::podium_version: 0.0.7

postgresql::globals::version: 9.6 # the postgresql server version to use/install.
postgresql::globals::manage_package_repo: false # use the default package repository to install postgresql.
```

Machine specific configuration should be in `/etc/puppetlabs/code/hieradata/${hostname}.yaml`, e.g.,
`/etc/puppetlabs/code/hieradata/test.example.com.yaml`:
```yaml
---
podium::app_url: https://podium.example.com
podium::gateway_db_password: choose a secure password
podium::uaa_db_password: choose a secure password
podium::registry_git_ssh_key: |
  -----BEGIN RSA PRIVATE KEY-----
  ...
  -----END RSA PRIVATE KEY-----
```

### Configuring a node in the manifest file

Alternatively, the node specific configuration can also be done with class parameters in the node manifest.
Here is an example:
```puppet
node 'test.example.com' {
    # Site specific configuration for Podium
    class { '::podium::params':
        app_url              => 'https://podium.example.com',
        gateway_db_password  => 'choose a secure password',
        uaa_db_password      => 'choose a secure password',
        registry_git_ssh_key => '-----BEGIN RSA PRIVATE KEY-----',
    }

    include ::podium::complete
}
```

### Configuring the use of a proxy
```puppet
node 'test.example.com' {
    ...

    # Configure a proxy for fetching artefacts
    Archive::Nexus {
        proxy_server => 'http://proxyurl:80',
    }
    # Configure a proxy for fetching packages with yum
    Yumrepo {
        proxy => 'http://proxyurl:80',
    }
}
```


## Masterless installation
It is also possible to use the module without a Puppet master by applying a manifest directly using `puppet apply`.

There is an example manifest in `examples/complete.pp`.

```bash
sudo puppet apply --modulepath=${modulepath} examples/complete.pp
```
where `modulepath` is a list of directories where Puppet can find modules in, separated by the system path-separator character (on Ubuntu/CentOS it is `:`).
Example:
```bash
sudo puppet apply --modulepath=${HOME}/puppet/:/etc/puppetlabs/code/modules/ examples/complete.pp
```


## Test
There are some automated tests, run using [rake](https://github.com/ruby/rake).

A version of `ruby` before `2.3` is required. [rvm](https://rvm.io/) can be used to install a specific version of `ruby`.
Use `rvm install 2.1` to use `ruby` version `2.1`.

The tests are automatically run on our Bamboo server: [PUPPET-PODIUM](https://ci.ctmmtrait.nl/browse/PUPPET-PODIUM).

### Rake tests
Install rake using the system-wide `ruby`:
```bash
yum install ruby-devel
gem install bundler
export PUPPET_VERSION=4.4.2
bundle
```
or using `rvm`:
```bash
rvm install 2.4
gem install bundler
export PUPPET_VERSION=4.4.2
bundle
```
Run the test suite:
```bash
rake test
```

## Classes

Overview of the classes defined in this module.

| Class name | Description |
|------------|-------------|
| `::podium` | Creates the system user. |
| `::podium::config` | Generates the application configuration. |
| `::podium::artefacts` | Downloads the requires artefacts. |
| `::podium::services` | Creates and starts the Podium services. |
| `::podium::database`  | Configures PostgreSQL databases. |
| `::podium::complete` | Installs all of the above. |


## Module parameters

Overview of the parameters that can be used in Hiera to configure the module.
Alternatively, the parameters of the `::podium::params` class can be used to configure these settings.

| Hiera key | Default value | Description |
|-----------|---------------|-------------|
| `podium::nexus_url`     | `https://repo.thehyve.nl` | The Nexus/Maven repository server. |
| `podium::registry_version`       | `0.0.3` | The version of the Podium registry to install. |
| `podium::registry_repository`    | `releases` | The repository to use for the registry. [`snapshots`, `releases`] |
| `podium::podium_version`       | `0.0.7` | The version of Podium to install. |
| `podium::podium_repository`    | `releases` | The repository to use for Podium. [`snapshots`, `releases`] |
| `podium::user`          | `podium` | System user that owns the application assets. |
| `podium::user_home`     | `/home/${user}` | The user home directory |
| `podium::registry_git_ssh_key` | | The secret key used to access the config repository. |
| `podium::gateway_db_password`       | | The password for the Gateway database. |
| `podium::uaa_db_password`       | | The password for the Uaa database. |
| `podium::app_url`       | | The address where the Podium application will be available. |
| `podium::gateway_app_port` | 8080 | The port where the Gateway service should listen on. |
| `podium::registry_memory` | `200m` | Memory allocated for the Registry service. |
| `podium::gateway_memory` | `2g` | Memory allocated for the Gateway service. |
| `podium::uaa_memory` | `1g` | Memory allocated for the UAA service. |
| `podium::reply_address` | | The email address used in emails. |
| `podium::request_template_tokens` | [] | Basic authentication tokens `username:password` for the request template endpoint. |
| `podium::disable_services` | false | (Temporarily) disable the services. |

Access to the [config repository](https://github.com/thehyve/bbmri-podium-config) is possible through ssh.
Generate a key pair with `ssh-keygen -f bbmri-podium-config`, upload the public key
to https://github.com/thehyve/bbmri-podium-config/settings/keys, and set the private key
using the `podium::registry_git_ssh_key` property.

Note that the modules only serves the application over plain HTTP, by configuring a simple Apache virtual host.
For enabling HTTPS, a separate Apache instance needs to be setup as a proxy.
Typically, the application should be installed in a small virtual machine where this module is applied,
with an SSL proxy installed on the host machine.


## License

Copyright &copy; 2017&ndash;2018  The Hyve.

The puppet module for Podium is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the [GNU General Public License](LICENSE) along with this program. If not, see https://www.gnu.org/licenses/.

