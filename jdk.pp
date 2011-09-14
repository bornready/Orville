import 'augeas.pp'
class jdk{

define jdk_wget($source,$destination) {
		package { "wget": ensure => latest }	
		exec {"wget-$name":
			command =>  "/usr/bin/wget --output-document=$destination $source",
			creates => "$destination",
		}
	}

	include augeas	

	$sun_jdk_bin="/opt/sun/sun-jdk-6.bin"

	file{"/opt/sun":
		ensure => directory,
	}	

	jdk_wget{"sun-jdk-bin":
		require=>File["/opt/sun"],		
		source => "http://download.oracle.com/otn-pub/java/jdk/6u27-b07/jdk-6u27-linux-x64.bin",
		destination => $sun_jdk_bin,
	}

	file{"$sun_jdk_bin":
		require=>JDK_Wget["sun-jdk-bin"],
		mode => 755,

	}

	exec {"sun-jdk-bin":
		require => File["$sun_jdk_bin"],
		cwd => "/opt/sun",	
		command => "/opt/sun/sun-jdk-6.bin",
		creates => "/opt/sun/jdk1.6.0_27",
	}



	augeas{"java_home":
		require => Package["augeas"],
		context => "/files/etc/environment/",
		changes => ["set JAVA_HOME /opt/sun/jdk1.6.0_27", "set PATH[last()+1] \$PATH:\$JAVA_HOME/bin"],
	}

}












