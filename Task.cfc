<cfcomponent output="false" alias="mytodolist.Task">
	<!---
		 These are properties that are exposed by this CFC object.
		 These property definitions are used when calling this CFC as a web services, 
		 passed back to a flash movie, or when generating documentation

		 NOTE: these cfproperty tags do not set any default property values.
	--->
	<cfproperty name="id" type="string" default="">
	<cfproperty name="description" type="string" default="">
	<cfproperty name="done" type="boolean" default="false">
	<cfproperty name="priority" type="numeric" default="0">

	<cfscript>
		//Initialize the CFC with the default properties values.
		variables.id = "";
		variables.description = "";
		variables.done = false;
		variables.priority = 0;
	</cfscript>

	<cffunction name="init" output="false" returntype="task">
		<cfargument name="id" required="false">
		<cfscript>
			if( structKeyExists(arguments, "id") )
			{
				load(arguments.id);
			}
			return this;
		</cfscript>
	</cffunction>

	<cffunction name="getId" output="false" access="public" returntype="any">
		<cfreturn variables.Id>
	</cffunction>

	<cffunction name="setId" output="false" access="public" returntype="void">
		<cfargument name="val" required="true">
		<cfset variables.Id = arguments.val>
	</cffunction>

	<cffunction name="getDescription" output="false" access="public" returntype="any">
		<cfreturn variables.Description>
	</cffunction>

	<cffunction name="setDescription" output="false" access="public" returntype="void">
		<cfargument name="val" required="true">
		<cfset variables.Description = arguments.val>
	</cffunction>

	<cffunction name="getDone" output="false" access="public" returntype="any">
		<cfreturn variables.Done>
	</cffunction>

	<cffunction name="setDone" output="false" access="public" returntype="void">
		<cfargument name="val" required="true" type="boolean">
		<cfset variables.Done = arguments.val>
	</cffunction>

	<cffunction name="getPriority" output="false" access="public" returntype="any">
		<cfreturn variables.Priority>
	</cffunction>

	<cffunction name="setPriority" output="false" access="public" returntype="void">
		<cfargument name="val" required="true">
		<cfif (IsNumeric(arguments.val)) OR (arguments.val EQ "")>
			<cfset variables.Priority = arguments.val>
		<cfelse>
			<cfthrow message="'#arguments.val#' is not a valid numeric"/>
		</cfif>
	</cffunction>



	<cffunction name="save" output="false" access="public" returntype="void">
		<cfargument name="DoCreate" required="no">
		<cfscript>
			if((getid() eq "") OR ((structkeyexists(arguments, "DoCreate")) AND (arguments.DoCreate EQ true)))
			{
				create();
			}else{
				update();
			}
		</cfscript>
	</cffunction>



	<cffunction name="load" output="false" access="public" returntype="void">
		<cfargument name="id" required="true" >
		<cfset var qRead="">
		<cfquery name="qRead" datasource="mytodolist">
			select 	id, description, done, priority
			from Task
			where id = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.id#" />
		</cfquery>

		<cfscript>
			setid(qRead.id);
			setdescription(qRead.description);
			setdone(qRead.done);
			setpriority(qRead.priority);
		</cfscript>
	</cffunction>



	<cffunction name="create" output="false" access="private" returntype="void">
		<cfset var qCreate="">

		<cfset var local0= createUUID()>
		<cfset var local1=getdescription()>
		<cfset var local2=getdone()>
		<cfset var local3=getpriority()>

		<cfquery name="qCreate" datasource="mytodolist">
			insert into Task(id, description, done, priority)
			values (
				<cfqueryparam value="#local0#" cfsqltype="CF_SQL_VARCHAR" />,
				<cfqueryparam value="#local1#" cfsqltype="CF_SQL_VARCHAR" />,
				<cfif local2 EQ "">null<cfelse><cfqueryparam value="#local2#" cfsqltype="CF_SQL_BIT" /></cfif>,
				<cfif local3 EQ "">null<cfelse><cfqueryparam value="#local3#" cfsqltype="CF_SQL_SMALLINT" /></cfif>
			)
		</cfquery>
		
		<!--- set the new id --->
		<cfset setId(local0) />
		
	</cffunction>



	<cffunction name="update" output="false" access="private" returntype="void">
		<cfset var qUpdate="">

		<cfquery name="qUpdate" datasource="mytodolist" result="status">
			update Task
			set id = <cfqueryparam value="#getid()#" cfsqltype="CF_SQL_VARCHAR" />,
				description = <cfqueryparam value="#getdescription()#" cfsqltype="CF_SQL_VARCHAR" />,
				done = <cfqueryparam value="#getdone()#" cfsqltype="CF_SQL_BIT" />,
				priority = <cfqueryparam value="#getpriority()#" cfsqltype="CF_SQL_SMALLINT" />
			where id = <cfqueryparam value="#getid()#" cfsqltype="CF_SQL_VARCHAR">
		</cfquery>
	</cffunction>



	<cffunction name="delete" output="false" access="public" returntype="void">
		<cfset var qDelete="">

		<cfquery name="qDelete" datasource="mytodolist" result="status">
			delete
			from Task
			where id = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#getid()#" />
		</cfquery>
	</cffunction>


</cfcomponent>