<cfcomponent output="false">

	<cffunction name="get" output="false" access="remote">
		<cfargument name="id" required="true" />
 		<cfreturn createObject("component", "task").init(arguments.id)>
	</cffunction>


	<cffunction name="save" output="false" access="remote">
		<cfargument name="obj" required="true" />
		<cfset obj.save() /> 		
		<cfreturn obj />
	</cffunction>


	<cffunction name="delete" output="false" access="remote">
		<cfargument name="id" required="true" />
		<cfset var obj = get(arguments.id)>
		<cfset obj.delete()>
	</cffunction>



	<cffunction name="getAll" output="false" access="remote" returntype="mytodolist.Task[]">
		<cfargument name="done" required="false" default="false" />
		<cfset var qRead="">
		<cfset var obj="">
		<cfset var ret=arrayNew(1)>

		<cfquery name="qRead" datasource="mytodolist">
			select id
			from Task
			where done = <cfqueryparam value="#arguments.done#" cfsqltype="CF_SQL_BIT" />
			order by priority
		</cfquery>

		<cfloop query="qRead">
		<cfscript>
			obj = createObject("component", "Task").init(qRead.id);
			ArrayAppend(ret, obj);
		</cfscript>
		</cfloop>
		<cfreturn ret>
	</cffunction>



	<cffunction name="getAllAsQuery" output="false" access="remote" returntype="query">
		<cfargument name="fieldlist" default="*" hint="List of columns to be returned in the query.">

		<cfset var qRead="">

		<cfquery name="qRead" datasource="mytodolist">
			select #arguments.fieldList#
			from Task
		</cfquery>

		<cfreturn qRead>
	</cffunction>




</cfcomponent>