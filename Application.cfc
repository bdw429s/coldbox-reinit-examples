/**
* Copyright 2005-2007 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
* www.ortussolutions.com
* ---
*/
component{
	// Application properties
	this.name = hash( getCurrentTemplatePath() );
	this.sessionManagement = true;
	this.sessionTimeout = createTimeSpan(0,0,30,0);
	this.setClientCookies = true;

	// Java Integration
	this.javaSettings = { 
		loadPaths = [ ".\lib" ], 
		loadColdFusionClassPath = true, 
		reloadOnChange= false 
	};

	// COLDBOX STATIC PROPERTY, DO NOT CHANGE UNLESS THIS IS NOT THE ROOT OF YOUR COLDBOX APP
	COLDBOX_APP_ROOT_PATH = getDirectoryFromPath( getCurrentTemplatePath() );
	// The web server mapping to this application. Used for remote purposes or static purposes
	COLDBOX_APP_MAPPING   = "";
	// COLDBOX PROPERTIES
	COLDBOX_CONFIG_FILE 	 = "";
	// COLDBOX APPLICATION KEY OVERRIDE
	COLDBOX_APP_KEY 		 = "";

	// application start
	public boolean function onApplicationStart(){
		application.cbBootstrap = new coldbox.system.Bootstrap( COLDBOX_CONFIG_FILE, COLDBOX_APP_ROOT_PATH, COLDBOX_APP_KEY, COLDBOX_APP_MAPPING );
		application.cbBootstrap.loadColdbox();
		return true;
	}

	// application end
	public void function onApplicationEnd( struct appScope ){
		arguments.appScope.cbBootstrap.onApplicationEnd( arguments.appScope );
	}

	// request start
	public boolean function onRequestStart( string targetPage ){
		
		cfparam( name="application.reiniting", default=false );
		
		// Fail fast so users coming in during the reinit just get an instant maintenance page.
		if( application.reiniting ) {
			writeOutput( 'Under maintenance' );
			// You don't have to return a 500, I just did this so JMeter would report it differently than a 200 
			cfHeader( statusCode="501", statustext="Under maintenance" );
			return false;
		}
					
		var appKey 			= 'cbController';
		var cbController 	= "";
		var needReinit 		= application.cbBootstrap.isfwReinit();

		// Initialize the Controller If Needed, double locked
		if( NOT structkeyExists( application, appkey ) OR NOT application[ appKey ].getColdboxInitiated() OR needReinit ){
			lock type="exclusive" name="#application.cbBootstrap.getAppHash()#" timeout="30" throwontimeout="true"{
				// double lock
				if( NOT structkeyExists( application, appkey ) OR NOT application[ appKey ].getColdboxInitiated() OR needReinit ){						

					try{
						// Let the world know we're reinitting.
						application.reiniting = true;
						
						// Verify if we are Reiniting?
						if( structkeyExists( application, appKey ) AND application[ appKey ].getColdboxInitiated() AND needReinit ){	
							// process preReinit interceptors
							application[ appKey ].getInterceptorService().processState( "preReinit" );
							// Shutdown the application services
							application[ appKey ].getLoaderService().processShutdown();
						}
	
						// Reload ColdBox
						application.cbBootstrap.loadColdBox();
						// Remove any context stragglers
						structDelete( request, "cb_requestContext" );
					} catch( any e ) {
						rethrow;
					} finally{
						application.reiniting = false;
					}
					
				}
			} // end lock
		}


		// Calling this again.  It won't trigger a reinit, but it does have additional logic for things like singleton reload.		
		application.cbBootstrap.reloadChecks();
		
		// Process A ColdBox Request Only
		if( findNoCase( 'index.cfm', listLast( arguments.targetPage, '/' ) ) ){
			application.cbBootstrap.processColdBoxRequest();
		}
		return true;
	}

	public void function onSessionStart(){
		application.cbBootStrap.onSessionStart();
	}

	public void function onSessionEnd( struct sessionScope, struct appScope ){
		arguments.appScope.cbBootStrap.onSessionEnd( argumentCollection=arguments );
	}

	public boolean function onMissingTemplate( template ){
		return application.cbBootstrap.onMissingTemplate( argumentCollection=arguments );
	}

}