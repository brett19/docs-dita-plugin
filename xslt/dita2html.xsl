<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
	xmlns:ditamsg="http://dita-ot.sourceforge.net/ns/200704/ditamsg" version="2.0"
	exclude-result-prefixes="dita-ot ditamsg">

	<xsl:import href="plugin:org.dita.xhtml:xsl/dita2html-base.xsl" />
	<xsl:import href="plugin:org.dita.xhtml:xsl/xslhtml/dita2html5Impl.xsl" />
	<xsl:import href="plugin:org.dita.xhtml:xsl/xslhtml/hi-d2html5.xsl" />
	<xsl:import href="plugin:org.dita.xhtml:xsl/map2htmtoc/map2htmlImpl.xsl" />

	<xsl:param name="FILEDIR" />
	<xsl:param name="FILENAME" />
	<xsl:param name="input.map.url" />

	<xsl:variable name="input.map" select="document($input.map.url)" />

	<xsl:output method="html" encoding="UTF-8" indent="no" omit-xml-declaration="yes" />

	<xsl:template match="/">

		<html lang="en">
			<head>

				<meta charset="utf-8" />
				<meta http-equiv="X-UA-Compatible" content="IE=edge" />
				<meta name="viewport" content="width=device-width, initial-scale=1" />
				<meta name="description" content="Couchbase Server product documentation" />

				<style>
					body{
						padding-top:40px; /* make the container go all the way to the bottom of the top bar */
					}</style>

				<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>

				<link
					href="//netdna.bootstrapcdn.com/twitter-bootstrap/2.3.2/css/bootstrap-combined.min.css"
					rel="stylesheet" />
				<script src="//netdna.bootstrapcdn.com/twitter-bootstrap/2.3.2/js/bootstrap.js" />

				<link rel="stylesheet" href="//yandex.st/highlightjs/8.0/styles/default.min.css" />
				<script src="//yandex.st/highlightjs/8.0/highlight.min.js"></script>

				<link href='http://fonts.googleapis.com/css?family=Open+Sans:400italic,400,700' rel='stylesheet' type='text/css' />

				<link href="../css/base.css" rel="stylesheet" />
				<script src="../js/main.js"></script>

			</head>

			<body>
				<header class="navbar navbar-fixed-top">
					<div class="navbar-inner">
						<div class="container-fluid container">
							<a class="brand" href="http://www.couchbase.com/"> <img src="../images/cb-icon-sofa.png" class="logo" /></a>
							<a class="brand" style="color:#000552;" href="/">Couchbase Documentation <small>beta</small></a>
							<div class="nav-collapse collapse">
								<ul class="nav">
									<li><a href="/">Docs Home</a></li>
									<li><a href="/archive-index.html">Docs Archive</a></li>
								</ul>
							</div><!--/.nav-collapse -->
							<!--<div><gcse:searchresults></gcse:searchresults></div>-->
						</div>
					</div>
				</header>

				<div id="content" class="container-fluid container">
					<div class="row-fluid">


						<xsl:apply-templates select="*" mode="chapterBody" />
					</div>
				</div>

				<footer>
					<div class="navbar navbar-fixed-bottom">
					<div class="navbar-inner">
						<div class="container-fluid container">
							<div class="copyright">
								© 2014 COUCHBASE All rights reserved.
							</div>
						</div>
					</div>
					</div>
				</footer>

			</body>
		</html>
	</xsl:template>


	<xsl:template match="*" mode="chapterBody">
		<xsl:call-template name="generateBreadcrumbs" />
		<xsl:call-template name="gen-user-sidetoc" />
		<main class="span9">
			<xsl:apply-templates />
			<xsl:call-template name="gen-endnotes" />
		</main>
	</xsl:template>

	<xsl:template match="*" mode="gen-user-sidetoc">
		<nav class="span3">
			<!--xsl:apply-templates select="$input.map/*[contains(@class, ' map/map ')]" mode="toc-pull"/-->
			<div class="well">
				<ul class="nav nav-list">
					<xsl:apply-templates select="$current-topicrefs[1]" mode="toc-pull">
						<xsl:with-param name="pathFromMaplist" select="$PATH2PROJ" />
						<xsl:with-param name="children">
							<xsl:apply-templates
								select="$current-topicrefs[1]/*[contains(@class, ' map/topicref ')]"
								mode="toc">
								<xsl:with-param name="pathFromMaplist" select="$PATH2PROJ" />
							</xsl:apply-templates>
						</xsl:with-param>
					</xsl:apply-templates>
				</ul>
			</div>
		</nav>
	</xsl:template>


	<!-- Navigation -->

	<xsl:variable name="current-file"
		select="translate(if ($FILEDIR = '.') then $FILENAME else concat($FILEDIR, '/', $FILENAME), '\', '/')" />
	<xsl:variable name="current-topicrefs"
		select="$input.map//*[contains(@class, ' map/topicref ')][dita-ot:get-path($PATH2PROJ, .) = $current-file]" />
	<xsl:variable name="current-topicref" select="$current-topicrefs[1]" />

	<xsl:template match="*[contains(@class, ' map/map ')]" mode="toc-pull">
		<xsl:param name="pathFromMaplist" select="$PATH2PROJ" />
		<xsl:param name="children" select="/.." />
		<xsl:param name="parent" select="parent::*" />

		<xsl:copy-of select="$children" />
	</xsl:template>

	<xsl:template match="*" mode="toc-pull" priority="-10">
		<xsl:param name="pathFromMaplist" />
		<xsl:param name="children" select="/.." />
		<xsl:param name="parent" select="parent::*" />
		<xsl:apply-templates select="$parent" mode="toc-pull">
			<xsl:with-param name="pathFromMaplist" select="$pathFromMaplist" />
			<xsl:with-param name="children" select="$children" />
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template
		match="*[contains(@class, ' map/topicref ')]
                        [not(@toc = 'no')]
                        [not(@processing-role = 'resource-only')]"
		mode="toc-pull" priority="10">
		<xsl:param name="pathFromMaplist" />
		<xsl:param name="children" select="/.." />
		<xsl:param name="parent" select="parent::*" />
		<xsl:variable name="title">
			<xsl:apply-templates select="." mode="get-navtitle" />
		</xsl:variable>
		<xsl:apply-templates select="$parent" mode="toc-pull">
			<xsl:with-param name="pathFromMaplist" select="$pathFromMaplist" />
			<xsl:with-param name="children">
				<xsl:apply-templates select="preceding-sibling::*[contains(@class, ' map/topicref ')]"
					mode="toc">
					<xsl:with-param name="pathFromMaplist" select="$pathFromMaplist" />
				</xsl:apply-templates>
				<xsl:choose>
					<xsl:when test="normalize-space($title)">
						<li>
							<xsl:if test=". is $current-topicref">
								<xsl:attribute name="class">active</xsl:attribute>
							</xsl:if>
							<xsl:choose>
								<xsl:when test="normalize-space(@href)">
									<a>
										<xsl:attribute name="href">
											<xsl:if test="not(@scope = 'external')">
												<xsl:value-of select="$pathFromMaplist" />
											</xsl:if>
											<xsl:choose>
												<xsl:when
													test="@copy-to and not(contains(@chunk, 'to-content')) and
                                        (not(@format) or @format = 'dita' or @format = 'ditamap') ">
													<xsl:call-template name="replace-extension">
														<xsl:with-param name="filename" select="@copy-to" />
														<xsl:with-param name="extension" select="$OUTEXT" />
													</xsl:call-template>
													<xsl:if
														test="not(contains(@copy-to, '#')) and contains(@href, '#')">
														<xsl:value-of
															select="concat('#', substring-after(@href, '#'))" />
													</xsl:if>
												</xsl:when>
												<xsl:when
													test="not(@scope = 'external') and (not(@format) or @format = 'dita' or @format = 'ditamap')">
													<xsl:call-template name="replace-extension">
														<xsl:with-param name="filename" select="@href" />
														<xsl:with-param name="extension" select="$OUTEXT" />
													</xsl:call-template>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="@href" />
												</xsl:otherwise>
											</xsl:choose>
										</xsl:attribute>
										<xsl:value-of select="$title" />
									</a>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$title" />
								</xsl:otherwise>
							</xsl:choose>
							<xsl:if test="$children">
								<ul class="nav nav-list">
									<xsl:copy-of select="$children" />
								</ul>
							</xsl:if>
						</li>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="*[contains(@class, ' map/topicref ')]" mode="toc">
							<xsl:with-param name="pathFromMaplist" select="$pathFromMaplist" />
						</xsl:apply-templates>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:apply-templates select="following-sibling::*[contains(@class, ' map/topicref ')]"
					mode="toc">
					<xsl:with-param name="pathFromMaplist" select="$pathFromMaplist" />
				</xsl:apply-templates>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="*" mode="toc" priority="-10">
		<xsl:param name="pathFromMaplist" />
		<xsl:apply-templates select="*[contains(@class, ' map/topicref ')]" mode="toc">
			<xsl:with-param name="pathFromMaplist" select="$pathFromMaplist" />
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template
		match="*[contains(@class, ' map/topicref ')]
                        [not(@toc = 'no')]
                        [not(@processing-role = 'resource-only')]"
		mode="toc" priority="10">
		<xsl:param name="pathFromMaplist" />
		<xsl:variable name="title">
			<xsl:apply-templates select="." mode="get-navtitle" />
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="normalize-space($title)">
				<li>
					<xsl:choose>
						<xsl:when test="normalize-space(@href)">
							<a>
								<xsl:attribute name="href">
									<xsl:if test="not(@scope = 'external')">
										<xsl:value-of select="$pathFromMaplist" />
									</xsl:if>
									<xsl:choose>
										<xsl:when
											test="@copy-to and not(contains(@chunk, 'to-content')) and
                                      (not(@format) or @format = 'dita' or @format = 'ditamap') ">
											<xsl:call-template name="replace-extension">
												<xsl:with-param name="filename" select="@copy-to" />
												<xsl:with-param name="extension" select="$OUTEXT" />
											</xsl:call-template>
											<xsl:if
												test="not(contains(@copy-to, '#')) and contains(@href, '#')">
												<xsl:value-of select="concat('#', substring-after(@href, '#'))"
												 />
											</xsl:if>
										</xsl:when>
										<xsl:when
											test="not(@scope = 'external') and (not(@format) or @format = 'dita' or @format = 'ditamap')">
											<xsl:call-template name="replace-extension">
												<xsl:with-param name="filename" select="@href" />
												<xsl:with-param name="extension" select="$OUTEXT" />
											</xsl:call-template>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="@href" />
										</xsl:otherwise>
									</xsl:choose>
								</xsl:attribute>
								<xsl:value-of select="$title" />
							</a>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$title" />
						</xsl:otherwise>
					</xsl:choose>
				</li>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:function name="dita-ot:get-path">
		<xsl:param name="pathFromMaplist" />
		<xsl:param name="node" />
		<xsl:for-each select="$node[1]">
			<xsl:if test="not(@scope = 'external')">
				<xsl:call-template name="strip-leading-parent">
					<xsl:with-param name="path" select="$pathFromMaplist" />
				</xsl:call-template>
			</xsl:if>
			<xsl:choose>
				<xsl:when
					test="@copy-to and not(contains(@chunk, 'to-content')) and
                        (not(@format) or @format = 'dita' or @format = 'ditamap') ">
					<xsl:value-of select="@copy-to" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@href" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:function>

	<xsl:template name="strip-leading-parent">
		<xsl:param name="path" />
		<xsl:choose>
			<xsl:when test="starts-with($path, '../')">
				<xsl:call-template name="strip-leading-parent">
					<xsl:with-param name="path" select="substring($path, 4)" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$path" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
