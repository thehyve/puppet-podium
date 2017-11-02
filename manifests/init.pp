# Class: podium
# ===========================
#
# Full description of class podium here.
#
# Parameters
# ----------
#
# * `user`
# The system user to be created that runs the application (default: podium).
#
# * `user_home`
# The home directory where the application files are stored (default: /home/${user}).
#
# * `registry_version`
# Version of the registry in Nexus (default: 1.0.2).
#
# * `podium_version`
# Version of the podium artefacts in Nexus (default: 0.0.7).
#
# * `nexus_url`
# The url of the repository to fetch the artefacts from
# (default: https://repo.thehyve.nl).
#
# * `registry_repository`
# Which Nexus repository to use for the registry [releases, snapshots] (default: releases).
#
# * `podium_repository`
# Which Nexus repository to use for Podium [releases, snapshots] (default: releases).
#
# * `gateway_db_password`
# The Gateway database user's password. Required.
#
# * `uaa_db_password`
# The UAA database user's password. Required.
#
#
# Examples
# --------
#
# @example
#    class { '::podium':
#    }
#
# Authors
# -------
#
# Gijs Kant <gijs@thehyve.nl>
#
# Copyright
# ---------
#
# Copyright 2017 The Hyve.
#
class podium {

    include ::podium::user

    case $::osfamily {
        'redhat': {
            $default_java = 'java-1.8.0-openjdk'
        }
        'debian': {
            $default_java = 'openjdk-8-jdk'
        }
        default: {
            $default_java = 'openjdk-8-jdk'
        }
    }

    class { '::java':
        package => hiera('java::package', $default_java),
    }
    if $::osfamily == 'Debian' {
        package { 'haveged':
            ensure => installed,
        }
    }

}
