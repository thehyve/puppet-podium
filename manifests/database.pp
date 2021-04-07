# Copyright 2017 The Hyve.
class podium::database inherits podium::params {

    include ::podium
    include ::podium::config

    $gateway_dbname = $podium::params::gateway_dbname
    $gateway_db_user = $podium::params::gateway_db_user
    $gateway_db_password = $podium::params::gateway_db_password
    $uaa_dbname = $podium::params::uaa_dbname
    $uaa_db_user = $podium::params::uaa_db_user
    $uaa_db_password = $podium::params::uaa_db_password

    class { '::postgresql::server':
    }

    # Databases
    postgresql::server::database { $gateway_dbname: }
    postgresql::server::database { $uaa_dbname: }

    # Database users
    postgresql::server::role { $gateway_db_user:
        password_hash => postgresql::postgresql_password ($gateway_db_user, $gateway_db_password),
    }
    postgresql::server::role { $uaa_db_user:
        password_hash => postgresql::postgresql_password ($uaa_db_user, $uaa_db_password),
    }

    # Database grants
    postgresql::server::database_grant { 'grant for gateway user':
        db        => $gateway_dbname,
        privilege => 'ALL',
        role      => $gateway_db_user,
    }
    postgresql::server::database_grant { 'grant for uaa user':
        db        => $uaa_dbname,
        privilege => 'ALL',
        role      => $uaa_db_user,
    }

}

