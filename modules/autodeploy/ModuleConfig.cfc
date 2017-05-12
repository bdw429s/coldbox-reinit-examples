/**
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* Module Config
*/
component {

	// Module Properties
	this.title 				= "autodeploy";
	this.author 			= "Ortus Solutions";
	this.webURL 			= "http://www.ortussolutions.com";
	this.description 		= "Auto deployment detector";
	this.version			= "1.2.0";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup 	= true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// Module Entry Point
	this.entryPoint			= "autodeploy";
	// Model Namespace
	this.modelNamespace		= "autodeploy";
	// CF Mapping
	this.cfmapping			= "autodeploy";
	// Module Dependencies
	this.dependencies 		= [];

	/**
	* Configure
	*/
	function configure(){
		// SES Routes
		routes = [
			// Convention Route
			{ pattern="/:handler/:action?" }
		];

		// Interceptors
		interceptors = [
			{ class="#moduleMapping#.interceptors.Deploy", name="deploy@#this.modelNamespace#" }
		];
	}

	/**
	* Fired when the module is registered and activated.
	*/
	function onLoad(){
		// parse parent settings
		parseParentSettings();
	}

	/**
	* Fired when the module is unregistered and unloaded
	*/
	function onUnload(){

	}

	//**************************************** PRIVATE ************************************************//	

	/**
	* parse parent settings
	*/
	private function parseParentSettings(){
		var oConfig 		= controller.getSetting( "ColdBoxConfig" );
		var configStruct 	= controller.getConfigSettings();
		var autodeploy 		= oConfig.getPropertyMixin( "autodeploy", "variables", structnew() );

		//defaults
		configStruct.autodeploy = {
			// The tag file location, realtive or absolute
			"tagFile" : "config/_deploy.tag",
			// The model to use for running deployment commands. Must be a valid WireBox mapping
			"deployCommandObject" :  ""
		};

		// incorporate settings
		structAppend( configStruct.autodeploy, autodeploy, true );

	}

}