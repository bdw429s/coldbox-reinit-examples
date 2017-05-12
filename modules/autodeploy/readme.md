[![Build Status](https://travis-ci.org/coldbox-modules/cbox-autodeploy.svg?branch=master)](https://travis-ci.org/coldbox-modules/cbox-autodeploy)

# WELCOME TO THE AUTODEPLOY MODULE
This module checks a tag file for timestamp modifications and if detected it will then continue to stop the ColdFusion application via `applicationStop()`.  It can also be optionally configured to execute a deploy command object when the timestamp check is detected.

## LICENSE
Apache License, Version 2.0.

## IMPORTANT LINKS
- https://github.com/ColdBox/cbox-autodeploy

## SYSTEM REQUIREMENTS
- Lucee 4.5+
- ColdBox 4+

# INSTRUCTIONS

Just drop into your modules folder or use [CommandBox](http://www.ortussolutions.com/products/commandbox) to install

`box install autodeploy`

## Settings
You can add configuration settings to your `ColdBox.cfc` under a structure called `autodeploy`:

```js
autodeploy = {
    // The tag file location, realtive or absolute from the root of your application.
    "tagFile" : "config/_deploy.tag",
    // The model to use for running deployment commands. Must be a valid WireBox mapping
    "deployCommandObject" :  ""
};
```

## Deploy Tag
The deploy tag: `_deploy.tag` must be in the root's `config` folder of your application. The module ships with a `config` folder. You must copy the contents to your application's root `config` folder.

## Update Deploy Tag

### CommandBox
We include a recipe for you to update the deploy tag: `config/deploy.boxr`.  Just run the recipe using CommandBox: `box recipe deploy.boxr`

### ANT
To update the timestamp in the deploy tag, run the `config/deploy.xml` file in Ant within the module or touch the file with a new timestamp. 

### Manually (Other)
Just change the contents of the file or touch its timestamp.

## Deploy Command Object
You can optionally create and register a deploy command object via WireBox.  This command object must implement one method:

```
function execute(){}
```

Which will be executed upon a new timestamp change for you before stopping the application and restarting it.


********************************************************************************
Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.ortussolutions.com
********************************************************************************
####HONOR GOES TO GOD ABOVE ALL
Because of His grace, this project exists. If you don't like this, then don't read it, its not for you.

>"Therefore being justified by faith, we have peace with God through our Lord Jesus Christ:
By whom also we have access by faith into this grace wherein we stand, and rejoice in hope of the glory of God.
And not only so, but we glory in tribulations also: knowing that tribulation worketh patience;
And patience, experience; and experience, hope:
And hope maketh not ashamed; because the love of God is shed abroad in our hearts by the 
Holy Ghost which is given unto us. ." Romans 5:5

###THE DAILY BREAD
 > "I am the way, and the truth, and the life; no one comes to the Father, but by me (JESUS)" Jn 14:1-12