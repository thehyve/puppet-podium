# Copyright 2017 The Hyve.
class podium::complete inherits podium::params {
    include ::podium
    include ::podium::database
    include ::podium::artefacts
    include ::podium::services

    package{ 'elasticsearch':
      ensure => latest,
    }
}
