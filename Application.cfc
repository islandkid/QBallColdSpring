component extends="qballfw1.framework" {

	this.name = "qball";
	this.sessionManagement = true;
	this.dataSource = this.name;
	this.ormEnabled = true;
	this.ormsettings = {
		cfclocation="./model",
		dbcreate="update",
		eventhandling="true",
		eventhandler="root.model.eventHandler",
		logsql="true"
	};

	this.mappings["/root"] = getDirectoryFromPath(getCurrentTemplatePath());

	variables.framework = {
		reloadApplicationOnEveryRequest=false,
		trace=true
	};

	public function setupApplication() {
		var bf = createObject('component','coldspring.beans.DefaultXmlBeanFactory').init();
		bf.loadBeans( expandPath('config/coldspring.xml') );
		setBeanFactory(bf);
	}

	/*public function onRequestStart(string targetPath) {
		super.onRequestStart(arguments.targetPath);
	}*/

	public function setupRequest() {
		if (isDefined('url.resetMyApp')){
			applicationstop();
			location(url="#replaceNoCase(CGI.SCRIPT_NAME, 'index.cfm', '')#", addToken="no");
		}
		if(structKeyExists(url, "init")) {
			setupApplication();
			ormReload();
			location(url="index.cfm",addToken=false);
		}
		controller("user.checkAuthorization");
	}

}