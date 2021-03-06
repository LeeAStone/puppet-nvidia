class nvidia::linux::ubuntu (
	Integer[1] $driver_version,
) {
	$package_name = "nvidia-${driver_version}"

	# Ensure that our custom fact can run
	ensure_resource('package', 'pciutils', {'ensure' => 'present' })

	if $nvidiagfx {
		include apt

		apt::ppa { 'ppa:graphics-drivers/ppa':
			package_manage => true
		}

		apt::pin { 'main':
			packages => 'nvidia-*',
			priority => 501,
			origin => 'ppa.launchpad.net'
		}
	
		ensure_resource( 'package', $package_name, {
			'ensure' => 'present',
			require => Class['apt::update']
		})
	}
}
