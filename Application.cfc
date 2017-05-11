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
				
		// Verify Reloading
		application.cbBootstrap.reloadChecks();
		
		// Process A ColdBox Request Only
		if( findNoCase( 'index.cfm', listLast( arguments.targetPage, '/' ) ) ){
			// Read only lock on all request processing
			lock name="#application.cbBootstrap.getAppHash()#" timeout="60" type="readonly" {   
				application.cbBootstrap.processColdBoxRequest();
			}
		}
		return true;
	}

	public void function onSessionStart(){
		lock name="#application.cbBootstrap.getAppHash()#" timeout="60" type="readonly" {
			application.cbBootStrap.onSessionStart();
		}
	}

	public void function onSessionEnd( struct sessionScope, struct appScope ){
		lock name="#application.cbBootstrap.getAppHash()#" timeout="60" type="readonly" {
			arguments.appScope.cbBootStrap.onSessionEnd( argumentCollection=arguments );
		}
	}

	public boolean function onMissingTemplate( template ){
		lock name="#application.cbBootstrap.getAppHash()#" timeout="60" type="readonly" {
			return application.cbBootstrap.onMissingTemplate( argumentCollection=arguments );
		}
	}

}