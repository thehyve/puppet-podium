# Copyright 2017 The Hyve.
class podium::user inherits podium::params {

    $user = $::podium::params::user
    $home = $::podium::params::podiumuser_home

    # Create datashowcase user.
    user { $user:
        ensure     => present,
        comment    => 'User running Podium microservices',
        home       => $home,
        managehome => true,
        shell      => '/bin/bash',
    }
    # Make home only accessible for the user
    -> file { $home:
        ensure => directory,
        mode   => '0755',
        owner  => $user,
    }

}

