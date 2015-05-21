<cfoutput>
	<!DOCTYPE HTML>
	<html>
		<head>

			<title>#application._taffy.settings.docs.APIName# Documentation - #application._taffy.settings.docs.APIversion#</title>

			<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		
			<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap.min.css">
			<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap-theme.min.css">
			<style type="text/css">
				<cfinclude template="custom.css">
			</style>
		
		</head>
		<body>
			<script>
				window.taffy = { resources: {} };
			</script>
			
			<div class="container">
				<div class="row">
					<div class="col-md-9" role="main">
						<div class="masthead top-mast">
							<h2>#application._taffy.settings.docs.APIName#</h2>
							<span class="ver text-muted" style="left: 0">Version #application._taffy.settings.docs.APIversion#</span>
						</div>
						<div class="row" id="resources">
							<div class="panel-group" id="resourcesAccordion">
					
								<cfloop from="1" to="#arrayLen(application._taffy.uriMatchOrder)#" index="local.resource">
									<cfset local.currentResource = application._taffy.endpoints[application._taffy.uriMatchOrder[local.resource]] />
									<div class="panel panel-default">
										<div class="panel-heading">
											<a name="#local.resource#"></a>
											<h4 class="panel-title">
												<a href="###local.currentResource.beanName#" class="accordion-toggle" data-toggle="collapse" data-parent="##resourcesAccordion">
													#local.currentResource.beanName#
												</a>
												<cfloop list="DELETE|warning,PATCH|warning,PUT|warning,POST|danger,GET|primary" index="local.verb">
													<cfif structKeyExists(local.currentResource.methods, listFirst(local.verb,'|'))>
														<span class="verb label label-success">#ucase(listFirst(local.verb,'|'))#</span>
													</cfif>
												</cfloop>
												<code style="float:right; margin-top: -18px; display: inline-block;">#local.currentResource.srcUri#</code>
											</h4>
										</div>
										<div id="#local.currentResource.beanName#">
											<div class="panel-body resourceWrapper">
												<div class="col-md-12 docs">
													<cfset local.metadata = getMetaData(application._taffy.factory.getBean(local.currentResource.beanName)) />
													<cfset local.docData = getHintsFromMetadata(local.metadata) />
													<cfif structKeyExists(local.docData, 'hint')><div class="doc">#docData.hint#</div><hr/></cfif>
													<cfset local.found = { get=false, post=false, put=false, patch=false, delete=false } />
													<cfloop from="1" to="#arrayLen(local.docData.functions)#" index="local.f">
														<cfset local.func = local.docData.functions[local.f] />
														<cfset verbs = "GET,POST,PUT,DELETE,OPTIONS,HEAD" />
														<cfset thisVerb = local.func.name />
														<cfif structKeyExists(local.func,"taffy_verb")>
															<cfset thisVerb = local.func.taffy_verb />
														<cfelseif structKeyExists(local.func,"taffy:verb")>
															<cfset thisVerb = local.func['taffy:verb'] />
														</cfif>
														<cfif listFindNoCase(verbs, thisVerb) eq 0>
															<cfscript>continue;</cfscript><!--- this has to be script for CF8 compat --->
														</cfif>
														<cfset local.found[local.func.name] = true />
														<div class="col-md-12"><strong>#thisVerb#</strong></div>
														<cfif structKeyExists(local.func, "hint")>
															<div class="col-md-12 doc">#local.func.hint#</div>
														</cfif>
														<cfloop from="1" to="#arrayLen(local.func.parameters)#" index="local.p">
														<cfset local.param = local.func.parameters[local.p] />
															<div class="row">
																<div class="col-md-11 col-md-offset-1">
																	<cfif not structKeyExists(local.param, 'required') or not local.param.required>
																		optional
																	<cfelse>
																		required
																	</cfif>
																	<cfif structKeyExists(local.param, "type")>
																		#local.param.type#
																	</cfif>
																	<strong>#local.param.name#</strong>
																	<cfif structKeyExists(local.param, "default")>
																		<cfif local.param.default eq "">
																			(default: "")
																		<cfelse>
																			(default: #local.param.default#)
																		</cfif>
																	<cfelse>
																		<!--- no default value --->
																	</cfif>
																	<cfif structKeyExists(local.param, "hint")>
																		<br/><span class="doc">#local.param.hint#</span>
																	</cfif>
																</div>
															</div>
														</cfloop>
													</cfloop>
												</div><!-- /col-md-6 (docs) -->
											</div>
										</div>
									</div>
								</cfloop>
					
							</div><!-- /panel-group -->
		
		
							<br />
							<cfif arrayLen(application._taffy.uriMatchOrder) eq 0>
								<div class="panel panel-warning">
									<div class="panel-heading">Taffy is running but you haven't defined any resources yet.</div>
									<div class="panel-body">
										<p>
											It looks like you don't have any resources defined. Get started by creating the folder
											<code>#guessResourcesFullPath()#</code>, in which you should place your
											Resource CFC's.
										</p>
										<p>
											Or you could set up a bean factory, like <a href="http://www.coldspringframework.org/">ColdSpring</a>
											or <a href="https://github.com/seancorfield/di1">DI/1</a>. Want to know more about using bean factories with Taffy?
											<a href="https://github.com/atuttle/Taffy/wiki/So-you-want-to:-use-an-external-bean-factory-like-coldspring-to-completely-manage-resources">Check out the wiki!</a>
										</p>
										<p>
											If all else fails, I recommend starting with <a href="https://github.com/atuttle/Taffy/wiki/Getting-Started">Getting Started</a>.
										</p>
									</div>
								</div>
							</cfif>
							<div class="alert alert-info">Resources are listed in matching order. From top to bottom, the first URI to match the request is used.</div>
						</div><!-- /resources -->
					</div>
					<div class="col-md-3" role="complementary">
						<nav class="affix-top" data-spy="affix">
							<h4>Resources</h4>
							<ul class="nav bs-docs-sidenav">
								<cfloop from="1" to="#arrayLen(application._taffy.uriMatchOrder)#" index="local.resource">
									<cfset local.currentResource = application._taffy.endpoints[application._taffy.uriMatchOrder[local.resource]] />
									<li class="">
										<a href="###local.resource#">
											#local.currentResource.beanName#
										</a>
									</li>
								</cfloop>
							</ul>
						</nav>	
					</div>			
				</div>
			</div><!-- /container -->
			
			<script src="//code.jquery.com/jquery-1.11.3.min.js"></script>
			<script src="//code.jquery.com/jquery-migrate-1.2.1.min.js"></script>
			<!-- Latest compiled and minified JavaScript -->
			<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/js/bootstrap.min.js"></script>
		
		</body>
	</html>
</cfoutput>
