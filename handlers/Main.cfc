﻿component extends="coldbox.system.EventHandler"{	// Default Action	function index(event,rc,prc){		sleep( 500 );		prc.welcomeMessage = "Welcome to ColdBox!";		event.setView("main/index");	}	// Do something	function doSomething(event,rc,prc){		setNextEvent("main.index");	}	function touchDeployTag(event,rc,prc){		fileWrite( '/config/_deploy.tag', now() );		event.noRender();	}	/************************************** IMPLICIT ACTIONS *********************************************/	function onAppInit(event,rc,prc){		// Spoof a slightly slower framework load to mimic a real		sleep( 1000 );	}	function onRequestStart(event,rc,prc){	}	function onRequestEnd(event,rc,prc){	}	function onSessionStart(event,rc,prc){	}	function onSessionEnd(event,rc,prc){		var sessionScope = event.getValue("sessionReference");		var applicationScope = event.getValue("applicationReference");	}	function onException(event,rc,prc){		event.setHTTPHeader( statusCode = 500 );		//Grab Exception From private request collection, placed by ColdBox Exception Handling		var exception = prc.exception;		//Place exception handler below:	}	function onMissingTemplate(event,rc,prc){		//Grab missingTemplate From request collection, placed by ColdBox		var missingTemplate = event.getValue("missingTemplate");	}}