#Type to create nagios check commands.
define nagios::nrpe::command ($check_command) {

  File <| tag == 'nrpe' |>
  Package <| tag == 'nrpe' |>
  Service <| tag == 'nrpe' |>

  $nrpe = $::osfamily ? {
    RedHat  =>  'nrpe',
    Debian  =>  'nagios-nrpe-server',
    default =>  'nagios-nrpe-server',
  }

  file { "/etc/nagios/nrpe.d/${name}.cfg":
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    require => [ Package[ $nrpe ], File['/etc/nagios/nrpe.d'], ],
    notify  => Service[ $nrpe ],
    content => template('nagios/nrpe_command.erb');
  }

}
