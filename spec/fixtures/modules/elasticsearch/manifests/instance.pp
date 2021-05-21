#  This define allows you to create or remove an elasticsearch instance
#
# @param ensure
#   Controls if the managed resources shall be `present` or `absent`.
#   If set to `absent`, the managed software packages will be uninstalled, and
#   any traces of the packages will be purged as well as possible, possibly
#   including existing configuration files.
#   System modifications (if any) will be reverted as well as possible (e.g.
#   removal of created users, services, changed log settings, and so on).
#   This is a destructive parameter and should be used with care.
#
# @param ca_certificate
#   Path to the trusted CA certificate to add to this node's java keystore.
#
# @param certificate
#   Path to the certificate for this node signed by the CA listed in
#   ca_certificate.
#
# @param config
#   Elasticsearch configuration hash.
#
# @param configdir
#   Path to directory containing the elasticsearch configuration.
#   Use this setting if your packages deviate from the norm (/etc/elasticsearch).
#
# @param configdir_recurselimit
#   Dictates how deeply the file copy recursion logic should descend when
#   copying files from the `elasticsearch::configdir` to instance `configdir`s.
#
# @param daily_rolling_date_pattern
#   File pattern for the file appender log when file_rolling_type is `dailyRollingFile`
#
# @param datadir
#   Allows you to set the data directory of Elasticsearch
#
# @param datadir_instance_directories
#   Control whether individual directories for instances will be created within
#   each instance's data directory.
#
# @param deprecation_logging
#   Wheter to enable deprecation logging. If enabled, deprecation logs will be
#   saved to ${cluster.name}_deprecation.log in the elastic search log folder.
#
# @param deprecation_logging_level
#   Default deprecation logging level for Elasticsearch.
#
# @param file_rolling_type
#   Configuration for the file appender rotation. It can be `dailyRollingFile`
#   or `rollingFile`. The first rotates by name, and the second one by size.
#
# @param init_defaults
#   Defaults file content in hash representation.
#
# @param init_defaults_file
#   Defaults file as puppet resource.
#
# @param init_template
#   Service file as a template
#
# @param jvm_options
#   Array of options to set in jvm_options.
#
# @param keystore_password
#   Password to encrypt this node's Java keystore.
#
# @param keystore_path
#   Custom path to the java keystore file. This parameter is optional.
#
# @param logdir
#   Log directory for this instance.
#
# @param logging_config
#   Hash representation of information you want in the logging.yml file.
#
# @param logging_file
#   Instead of a hash you can supply a puppet:// file source for the logging.yml file
#
# @param logging_level
#   Default logging level for Elasticsearch.
#
# @param logging_template
#  Use a custom logging template - just supply the reative path, ie
#  $module_name/elasticsearch/logging.yml.erb
#
# @param private_key
#   Path to the key associated with this node's certificate.
#
# @param purge_secrets
#   Whether or not keys present in the keystore will be removed if they are not
#   present in the specified secrets hash.
#
# @param rolling_file_max_backup_index
#   Max number of logs to store whern file_rolling_type is `rollingFile`
#
# @param rolling_file_max_file_size
#   Max log file size when file_rolling_type is `rollingFile`
#
# @param secrets
#   Optional configuration hash of key/value pairs to store in the instance's
#   Elasticsearch keystore file. If unset, the keystore is left unmanaged.
#
# @param security_plugin
#   Which security plugin will be used to manage users, roles, and
#   certificates. Inherited from top-level Elasticsearch class.
#
# @param service_flags
#   Service flags used for the OpenBSD service configuration, defaults to undef.
#
# @param ssl
#   Whether to manage TLS certificates for Shield. Requires the ca_certificate,
#   certificate, private_key and keystore_password parameters to be set.
#
# @param status
#   To define the status of the service. If set to `enabled`, the service will
#   be run and will be started at boot time. If set to `disabled`, the service
#   is stopped and will not be started at boot time. If set to `running`, the
#   service will be run but will not be started at boot time. You may use this
#   to start a service on the first Puppet run instead of the system startup.
#   If set to `unmanaged`, the service will not be started at boot time and Puppet
#   does not care whether the service is running or not. For example, this may
#   be useful if a cluster management software is used to decide when to start
#   the service plus assuring it is running on the desired node.
#
# @param system_key
#   Source for the Shield system key. Valid values are any that are
#   supported for the file resource `source` parameter.
#
# @author Richard Pijnenburg <richard.pijnenburg@elasticsearch.com>
# @author Tyler Langlois <tyler.langlois@elastic.co>
#
define elasticsearch::instance (
  Enum['absent', 'present']          $ensure                        = $elasticsearch::ensure,
  #Optional[Stdlib::Absolutepath]     $ca_certificate                = undef,
  #Optional[Stdlib::Absolutepath]     $certificate                   = undef,
  Optional[Hash]                     $config                        = undef,
  #Stdlib::Absolutepath               $configdir                     = "${elasticsearch::configdir}/${name}",
  Integer                            $configdir_recurselimit        = $elasticsearch::configdir_recurselimit,
  String                             $daily_rolling_date_pattern    = $elasticsearch::daily_rolling_date_pattern,
  #Optional[Elasticsearch::Multipath] $datadir                       = undef,
  Boolean                            $datadir_instance_directories  = $elasticsearch::datadir_instance_directories,
  Boolean                            $deprecation_logging           = false,
  String                             $deprecation_logging_level     = 'DEBUG',
  String                             $file_rolling_type             = $elasticsearch::file_rolling_type,
  Hash                               $init_defaults                 = {},
  #Optional[Stdlib::Absolutepath]     $init_defaults_file            = undef,
  String                             $init_template                 = $elasticsearch::init_template,
  Array[String]                      $jvm_options                   = $elasticsearch::jvm_options,
  Optional[String]                   $keystore_password             = undef,
  #Optional[Stdlib::Absolutepath]     $keystore_path                 = undef,
  #Stdlib::Absolutepath               $logdir                        = "${elasticsearch::logdir}/${name}",
  Hash                               $logging_config                = {},
  Optional[String]                   $logging_file                  = undef,
  String                             $logging_level                 = $elasticsearch::default_logging_level,
  Optional[String]                   $logging_template              = undef,
  #Optional[Stdlib::Absolutepath]     $private_key                   = undef,
  Boolean                            $purge_secrets                 = $elasticsearch::purge_secrets,
  Integer                            $rolling_file_max_backup_index = $elasticsearch::rolling_file_max_backup_index,
  String                             $rolling_file_max_file_size    = $elasticsearch::rolling_file_max_file_size,
  Optional[Hash]                     $secrets                       = undef,
  Optional[Enum['shield', 'x-pack']] $security_plugin               = $elasticsearch::security_plugin,
  Optional[String]                   $service_flags                 = undef,
  Boolean                            $ssl                           = false,
  #Elasticsearch::Status              $status                        = $elasticsearch::status,
  Optional[String]                   $system_key                    = $elasticsearch::system_key,
) {

  File {
    owner => $elasticsearch::elasticsearch_user,
    group => $elasticsearch::elasticsearch_group,
  }

  Exec {
    path => [ '/bin', '/usr/bin', '/usr/local/bin' ],
    cwd  => '/',
  }

  # ensure
  if ! ($ensure in [ 'present', 'absent' ]) {
    fail("\"${ensure}\" is not a valid ensure parameter value")
  }

  if $ssl or ($system_key != undef) {
    if $security_plugin == undef or ! ($security_plugin in ['shield', 'x-pack']) {
      fail("\"${security_plugin}\" is not a valid security_plugin parameter value")
    }
  }

  $notify_service = $elasticsearch::restart_config_change ? {
    true  => Elasticsearch::Service[$name],
    false => undef,
  }

  if ($ensure == 'present') {

    # Logging file or hash
    if ($logging_file != undef) {
      $logging_source = $logging_file
      $logging_content = undef
      $_log4j_content = undef
    } elsif ($elasticsearch::logging_file != undef) {
      $logging_source = $elasticsearch::logging_file
      $logging_content = undef
      $_log4j_content = undef
    }

    if $ssl {
      if ($keystore_password == undef) {
        fail('keystore_password required')
      }
    }

    $require_service = Class['elasticsearch::package']
    $before_service  = undef

  } else {

    file { $configdir:
      ensure  => 'absent',
      recurse => true,
      force   => true,
    }

    $require_service = undef
    $before_service  = File[$configdir]

    $init_defaults_new = {}
  }
}
