/*********************************************************************************
Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldbox.org | www.luismajano.com | www.ortussolutions.com
*******************************************************************************
The magic of auto deployments	
**/
component extends="coldbox.system.Interceptor" accessors="true"{

	// The tag file location
	property name="tagFilePath" 		default="";
	// The deploy command object to execute.
	property name="deployCommandObject" default="";

	/**
	* Configure the interceptor
	*/
	function configure(){
	}

	/**
	* Register the tag
	*/
	function afterConfigurationLoad(){
		// Try to locate the path
		variables.tagFilepath 			= locateFilePath( getSetting( "autodeploy" ).tagFile );
		variables.deployCommandObject 	= getSetting( "autoDeploy" ).deployCommandObject;
		
		// Validate it
		if( len( variables.tagFilepath ) eq 0 ){
			throw( 'Tag file not found: #getSetting( "autodeploy" ).tagFile#. Please create the file or check the location of the tag file' );
		}
		
		// Save TimeStamp
		setSetting( "_deploytagTimestamp", fileLastModified( variables.tagFilepath ) );
		
		if( log.canInfo() ){
			log.info("Deploy tag registered successfully.");
		}
	}

	/**
	* Function at post process
	*/
	function postProcess( event, interceptData ){
		// get the timestamp of the configuration file
		var tagTimestamp = fileLastModified( variables.tagFilepath );
		
		// Check if setting exists
		if ( settingExists( "_deploytagTimestamp" ) ){
			// get current timestamp
			var appTimestamp = getSetting( "_deploytagTimestamp" );
			
			//Validate Timestamp
			if ( dateCompare( tagTimestamp, appTimestamp ) eq 1 ){
				lock scope="application" type="exclusive" timeout="25" throwOntimeout="true"{
					// concurrency lock
					if ( dateCompare( tagTimestamp, appTimestamp ) eq 1 ){
						try{
							// commandobject
							if( len( variables.deployCommandObject ) ){
								getInstance( variables.deployCommandObject ).execute();
								// Log
								if( log.canInfo() ){
									log.info( "Deploy command object executed!" );
								}
							}
							
							// Mark Application for shutdown
							applicationStop();
							
							// Log Reloading
							if( log.canInfo() ){
								log.info( "Deploy tag reloaded successfully." );
							}
						} catch(Any e) {
							//Log Error
							log.error( "Error in deploy tag: #e.message# #e.detail#", e.stackTrace );
						}
					} // end if dateCompare
				} //end lock
			} // end if dateCompare

			// stop interception chain
			return true;
			
		} // end if setting exists
		else {
			configure();
		}
	}

	/******************************** PRIVATE ************************************/

	/**	
	* Get datetime stamp of file
	*/
	private function fileLastModified( required string filename ){
		var objFile =  createObject( "java", "java.io.File" ).init( arguments.filename );
		// Calculate adjustments fot timezone and daylightsavindtime
		var Offset = ( ( GetTimeZoneInfo().utcHourOffset ) + 1 ) * -3600;
		// Date is returned as number of seconds since 1-1-1970
		return DateAdd( 's', ( Round( objFile.lastModified() / 1000 ) ) + Offset, CreateDateTime( 1970, 1, 1, 0, 0, 0 ) );
	}

}