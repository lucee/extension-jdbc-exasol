component extends="types.Driver" implements="types.IDatasource" {

	this.className="{class-name}";
	this.bundleName="{bundle-name}";
	this.dsn="{connstr}";
	this.type.port=this.TYPE_FREE;
	this.type.database=this.TYPE_FREE;	
	this.value.host="localhost";
	this.value.port=8563;
	
	
	fields=[

		field(
			"Schema",
			"schema",
			"",
			false,
			"Name of the schema that should be opened after login. If the schema cannot be opened, the login fails with a java.sql.SQLException."
		)
	
		,field(
			"Encryption (0=off, 1=on)",
			"encryption",
			"1,0",
			false,
			"Switches automatic encryption on or off (0=off, 1=on).",
			"radio",
			0
		)

		,field(
			"Kerberos Service Name",
			"kerberosservicename",
			"",
			false,
			"Principal name of the Kerberos service. If nothing is specified, the name [exasol] will be used as default."
		)
		,field(
			"Kerberos Host Name",
			"kerberoshostname",
			"",
			false,
			"Host name of the Kerberos service. If nothing is specified, the host name of the connections string will be used as default"
		)
		,field(
			"Fetch Size",
			"fetchsize",
			"2000",
			false,
			"Amount of data in kB which should be obtained by Exasol during a fetch. The JVM can run out of memory if the value is too high."
		)
		,field(
			"Debug (0=off, 1=on)",
			"debug",
			"1,0",
			false,
			"Switches on the driver's log function. The driver then writes a log file named jdbc_timestamp.log for each established connection.
			These files contain information on the called driver methods and the progress of the JDBC connection.
			It can assist the Exasol Support in the diagnosis of problems.",
			"radio"
			,0
		)
		,field(
			"Log Directory",
			"logdir",
			"",
			false,
			"Defines the directory where the JDBC debug log files should be written to (in debug mode)."
		)
		,field(
			"Client Name",
			"clientname",
			"Generic JDBC client",
			false,
			"Tells the server what the application is called."
		)
		,field(
			"Client Version",
			"clientversion",
			"",
			false,
			"Tells the server the version of the application."
		)
		,field(
			"Login Timeout",
			"logintimeout",
			"0",
			false,
			"Maximum time (in seconds) the driver waits for the database for a connect or disconnect request. 0 == unlimited."
		)
		,field(
			"Connect Timeout",
			"connecttimeout",
			"2000",
			false,
			"Maximum time (in milliseconds) the driver waits to establish a TPC connection to a server. This timeout is used to limit the login time especially in case of a large cluster with multiple reserve nodes."
		)
		,field(
			"Query Timeout",
			"querytimeout",
			"0",
			false,
			"Defines the time (in seconds) for a statement to run before it is automatically aborted. 0 == unlimited."
		)
		,field(
			"Super Connection (0=off, 1=on)",
			"superconnection",
			"1,0",
			false,
			"Only the SYS user can set the parameter.
			superconnection should only be used in case of significant performance problems where it is impossible to log in and execute queries within a reasonable time. By that parameter you can analyze the system and kill certain processes which cause the problem",
			"radio"
			,0
		)
		,field(
			"Worker (0=off, 1=on)",
			"worker",
			"1,0",
			false,
			"The sub-connections for parallel read and insert have this flag switched on.",
			"radio"
			,0
		)
		,field(
			"Worker Token (0=off, 1=on)",
			"workertoken",
			"1,0",
			false,
			"Is necessary to establish parallel sub-connections.",
			"radio"
			,0
		)
		,field(
			"Connection Pool Size",
			"connectionPoolSize",
			"64",
			false,
			"Changes the maximum size of the connection pool. You can change it only once in the driver instance. Valid values: 0<connectionPoolSize<8192"
		)
		,field(
			"Snapshot Transactions (0=off, 1=on)",
			"snapshottransactions",
			"1,0",
			false,
			"The parameter defines the transaction Snapshot Mode for the connection. The default value for the parameter is 0.
			Set the parameter to 1 to enable Snapshot Mode for system tables.",
			"radio"
			,0
		)
		,field(
			"Authentication Method",
			"authmethod",
			"accesstoken,refreshtoken",
			false,
			"Specifies the authentication method for OpenID.",
			"radio"
		)

		,field(
			"Fingerprint",
			"fingerprint",
			"",
			false,
			"Fingerprint for the connection. To disable TLS validations, use NOCERTCHECK. NOCERTCHECK is case insensitive."
		)

		
		,field(
			"Validate Server Certificate (0=off, 1=on)",
			"validateservercertificate",
			"1,0",
			false,
			"Enables or disables the TLS server certificate validation.",
			"radio"
			,0
		)
		,field(
			"Legacy Encryption (0=off, 1=on)",
			"legacyencryption",
			"1,0",
			false,
			"Enables use of the old ChaCha encryption for the client-server communication and disables the new TLS encryption.",
			"radio",
			0
		)
		,field(
			"Socket Factory",
			"socketfactory",
			"",
			false,
			"Specifies the name of a SocketFactory that should be used while connecting to the server."
		)
		,field(
			"Enable Numeric Type Conversion (0=off, 1=on)",
			"enablenumerictypeconversion",
			"1,0",
			false,
			"The driver will show column decimal data types of a result set that can be converted to integer types as int or longint.",
			"radio"
			,0
		)




	];
	
	data={};

	public function customParameterSyntax() {
		return {leadingdelimiter:';',delimiter:';',separator:'='};
	}

	public boolean function literalTimestampWithTSOffset() {
		return true;
	}
	
	public void function onBeforeUpdate() {
		
		// translate on/off to 1/0
		loop array=getFields() item="local.field" {
			if(field.getType()=="radio" && (field.getDefaultValue()=="on,off" || field.getDefaultValue()=="off,on") && structKeyExists(form, "custom_"&field.getName()) ) {
				form["custom_"&field.getName()]=form["custom_"&field.getName()]=="on"?1:0;
			}
		}
		
		// remove all empty values fields
		loop struct=duplicate(form) index="local.n" item="local.v" {
			if(left(n,7)=="custom_" && isEmpty(v)){
				structDelete(form,n,false);
			}
		}
	}
	
	/**
	* returns array of fields
	*/
	public array function getFields() {
		return fields;
	}

	/**
	* returns display name of the driver
	*/
	public string function getName()  output="no" {
		return "Exasol Database";
	}

	/**
	* returns description for the driver
	*/
	public string function getDescription()   output="no" {
		return "Exasol is a parallelized relational database management system (RDBMS) which runs on a cluster of standard computer hardware servers.";
	}

	/**
	* return if String class match this
	*/
	public boolean function equals(required className, required dsn) output="false" {
		return this.className EQ arguments.className;
	}
}