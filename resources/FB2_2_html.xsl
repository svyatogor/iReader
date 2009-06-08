<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:fb="http://www.gribuser.ru/xml/fictionbook/2.0">
	<xsl:output method="html" encoding="UTF-8"/>
	<xsl:param name="tocdepth" select="3"/>
	<xsl:param name="toccut" select="1"/>
	<xsl:param name="skipannotation" select="1"/>
	<xsl:param name="cssfile" />		
	<xsl:param name="NotesTitle" select="'Сноски'"/>
	<xsl:key name="note-link" match="fb:section" use="@id"/>
	
	<!-- author -->
	<xsl:template name="author">
		<div class="author">
			<xsl:value-of select="fb:first-name"/>
			<xsl:text disable-output-escaping="no">&#032;</xsl:text>
			<xsl:value-of select="fb:middle-name"/>&#032;
					 <xsl:text disable-output-escaping="no">&#032;</xsl:text>
			<xsl:value-of select="fb:last-name"/>
		</div>
	</xsl:template>

	<!-- TODO secuence -->
	<xsl:template name="sequence">
		<LI/>
		<xsl:value-of select="@name"/>
		<xsl:if test="@number">
			<xsl:text disable-output-escaping="no">,&#032;#</xsl:text>
			<xsl:value-of select="@number"/>
		</xsl:if>
		<xsl:if test="fb:sequence">
			<UL>
				<xsl:for-each select="fb:sequence">
					<xsl:call-template name="sequence"/>
				</xsl:for-each>
			</UL>
		</xsl:if>
		<!--      <xsl:text disable-output-escaping="yes">&lt;br&gt;</xsl:text> -->
	</xsl:template>

	<!-- description -->
	<xsl:template match="fb:description">
		<xsl:apply-templates/>
	</xsl:template>
	
	<!-- section -->
	<xsl:template match="fb:section">
		<xsl:call-template name="preexisting_id"/>
		<div class="section">
			<xsl:attribute name="id">section-<xsl:number level="any" /></xsl:attribute>
			<xsl:apply-templates select="fb:title"/>
			<xsl:apply-templates select="fb:*[name()!='title']"/>
		</div>
	</xsl:template>
	
	<!-- title -->
	<xsl:template match="fb:section/fb:title|fb:poem/fb:title">
		<xsl:choose>
			<!-- TODO this is the case with notes section -->
			<xsl:when test="ancestor::fb:body/@name = 'notes' and not(following-sibling::fb:section)">
						<xsl:call-template name="preexisting_id"/>
						<xsl:for-each select="parent::fb:section">
							<xsl:call-template name="preexisting_id"/>
						</xsl:for-each><strong><xsl:apply-templates/></strong>
			</xsl:when>
			
			<!-- generic section title -->
			<xsl:otherwise>
				<div>
					<xsl:attribute name="class">title title-<xsl:value-of select="count(ancestor::node())-3" /></xsl:attribute>
					<xsl:call-template name="preexisting_id"/>
					<xsl:apply-templates/>
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- body/title -->
	<xsl:template match="fb:body/fb:title">
		<div class="title"><xsl:apply-templates/></div>
	</xsl:template>

	<!-- title/p and the like -->
	<xsl:template match="fb:title/fb:p|fb:title-info/fb:book-title">
		<xsl:apply-templates/>
		<xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
	</xsl:template>
	
	<!-- subtitle -->
	<xsl:template match="fb:subtitle">
		<xsl:call-template name="preexisting_id"/>
		<div class="subtitle">
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	
	<!-- p -->
	<xsl:template match="fb:p">
		<p>
			<xsl:call-template name="preexisting_id"/>
			<xsl:apply-templates/>
		</p>
	</xsl:template>

	<!-- strong -->
	<xsl:template match="fb:strong">
		<b><xsl:apply-templates/></b>
	</xsl:template>
	
	<!-- emphasis -->
	<xsl:template match="fb:emphasis">
		<i><xsl:apply-templates/></i>
	</xsl:template>
	
	<!-- style -->
	<xsl:template match="fb:style">
		<span class="{@name}"><xsl:apply-templates/></span>
	</xsl:template>
	
	<!-- empty-line -->
	<xsl:template match="fb:empty-line">
		&#160;<xsl:text disable-output-escaping="yes">&lt;br&gt;</xsl:text>
	</xsl:template>
	
	<!-- TODO link -->
	<xsl:template match="fb:a">
		<xsl:element name="a">
			<xsl:attribute name="href"><xsl:value-of select="@xlink:href"/></xsl:attribute>
			<xsl:attribute name="title">
				<xsl:choose>
					<xsl:when test="starts-with(@xlink:href,'#')"><xsl:value-of select="key('note-link',substring-after(@xlink:href,'#'))/fb:p"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="key('note-link',@xlink:href)/fb:p"/></xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:choose>
				<xsl:when test="(@type) = 'note'">
					<sup>
						<xsl:apply-templates/>
					</sup>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	
	<!-- annotation -->
	<xsl:template name="annotation">
		<div class="annotation">
			<xsl:call-template name="preexisting_id"/>
			<div class="title">Annotation</div>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	
	<!-- epigraph -->
	<xsl:template match="fb:epigraph">
		<div class="epigraph">
			<xsl:call-template name="preexisting_id"/>
			<xsl:apply-templates/>
		</div>
		<xsl:if test="name(./following-sibling::node()) = 'epigraph'"><br/></xsl:if>
		<br/>
	</xsl:template>
	
	<!-- epigraph/text-author -->
	<xsl:template match="fb:epigraph/fb:text-author">
		<div class="text-author">
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	
	<!-- cite -->
	<xsl:template match="fb:cite">
		<div class="cite">
			<xsl:call-template name="preexisting_id"/>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	
	<!-- cite/text-author -->
	<xsl:template match="fb:text-author">
		<div class="text-author">
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	
	<!-- date -->
	<xsl:template match="fb:date">
		<xsl:choose>
			<xsl:when test="not(@value)">
				&#160;&#160;&#160;<xsl:apply-templates/>
				<xsl:text disable-output-escaping="yes">&lt;br&gt;</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				&#160;&#160;&#160;<xsl:value-of select="@value"/>
				<xsl:text disable-output-escaping="yes">&lt;br&gt;</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- poem -->
	<xsl:template match="fb:poem">
		<div class="poem">
			<xsl:call-template name="preexisting_id"/>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	
	<!-- stanza -->
	<xsl:template match="fb:stanza">
		&#160;<xsl:text disable-output-escaping="yes">&lt;br&gt;</xsl:text>
		<xsl:apply-templates/>
		&#160;<xsl:text disable-output-escaping="yes">&lt;br&gt;</xsl:text>
	</xsl:template>

	<!-- v -->
	<xsl:template match="fb:v">
		<xsl:call-template name="preexisting_id"/>
		<xsl:apply-templates/><xsl:text disable-output-escaping="yes">&lt;br&gt;</xsl:text>
	</xsl:template>

	<!-- image - inline -->
	<xsl:template match="fb:p/fb:image|fb:v/fb:image|fb:td/fb:image|fb:subtitle/fb:image">
		<img class="inline">
			<xsl:choose>
				<xsl:when test="starts-with(@xlink:href,'#')">
					<xsl:attribute name="src">url(data:<xsl:value-of select="//fb:binary[@id=$i]/@content-type" />;base64,<xsl:value-of select="//fb:binary[@id=$i]"/>)</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="src"><xsl:value-of select="@xlink:href"/></xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
		</img>
	</xsl:template>
	
	<!-- image - block -->
	<xsl:template match="fb:image">
		<img class="block">
			<xsl:choose>
				<xsl:when test="starts-with(@xlink:href,'#')">
					<xsl:variable name="i" select="substring-after(@xlink:href,'#')" />							
					<xsl:attribute name="src">url(data:<xsl:value-of select="//fb:binary[@id=$i]/@content-type" />;base64,<xsl:value-of select="//fb:binary[@id=$i]"/>)</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="src"><xsl:value-of select="@xlink:href"/></xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
		</img>
	</xsl:template>
	
	<!-- strikethrough-sub-sup -->
	<xsl:template match="fb:strikethrough">
		<strike>
			<xsl:apply-templates/>			
		</strike>
	</xsl:template>
	
	<xsl:template match="fb:sup">
		<sup>
			<xsl:apply-templates/>			
		</sup>
	</xsl:template>
	
	<xsl:template match="fb:sub">
		<sub>
			<xsl:apply-templates/>			
		</sub>
	</xsl:template>

	<!--Table-->
	<xsl:template match="fb:table">
		<table>
			<xsl:apply-templates/>
		</table>
	</xsl:template>
	
	<xsl:template match="fb:tr">
		<tr>
			<xsl:apply-templates/>
		</tr>
	</xsl:template>
	
	<xsl:template match="fb:td|fb:th">
		<xsl:element name="{name()}">
			<xsl:for-each select="@*">
				<xsl:attribute name="{name()}">
					<xsl:value-of select="."/>
				</xsl:attribute>	
			</xsl:for-each>
			<xsl:apply-templates/>			
		</xsl:element>
	</xsl:template>

	<!-- we preserve used ID's and drop unused ones -->
	<xsl:template name="preexisting_id">
		<xsl:variable name="i" select="@id"/>
		<xsl:if test="@id and //fb:a[@xlink:href=concat('#',$i)]"><a name="{@id}"/></xsl:if>
	</xsl:template>
	
	<!-- book generator -->
	<xsl:template name="DocGen">
		<xsl:for-each select="fb:body">
			<div class="chapter">
				<xsl:attribute name="id">chapter-<xsl:number level="any" /></xsl:attribute>
				<xsl:if test="position()!=1">
					<hr/>
				</xsl:if>
				<xsl:choose>
					<xsl:when test="@name = 'notes'">
						<a name="#TOC_notes_{generate-id()}" id="notes"/><xsl:value-of select="$NotesTitle"/>
					</xsl:when>
					<xsl:when test="@name">
						<xsl:value-of select="@name"/>
					</xsl:when>
				</xsl:choose>
				<!-- <xsl:apply-templates /> -->
				<xsl:apply-templates/>
			</div>
		</xsl:for-each>
	</xsl:template>	
	
	
	<xsl:template match="/*">			
		<html>
			<head>
				<title>
					<xsl:value-of select="fb:description/fb:title-info/fb:book-title"/>
				</title>
				<xsl:element name="link">			
					<xsl:attribute name="href"><xsl:value-of select="$cssfile" /></xsl:attribute>
					<xsl:attribute name="rel">stylesheet</xsl:attribute>					
					<xsl:attribute name="type">text/css</xsl:attribute>										
				</xsl:element>
			</head>
			<body>
				<xsl:apply-templates select="fb:description/fb:title-info/fb:coverpage/fb:image"/>
				<div class="title">
					<xsl:apply-templates select="fb:description/fb:title-info/fb:book-title"/>
				</div>
				<h2>
						<xsl:for-each select="fb:description/fb:title-info/fb:author">
								<b>
									<xsl:call-template name="author"/>
								</b>
						</xsl:for-each>
				</h2>
				<!--
//				<xsl:if test="fb:description/fb:title-info/fb:sequence">
//					<p>
//						<xsl:for-each select="fb:description/fb:title-info/fb:sequence">
//							<xsl:call-template name="sequence"/><xsl:text disable-output-escaping="yes">&lt;br&gt;</xsl:text>
//						</xsl:for-each>
//					</p>
//				</xsl:if>
				-->
				<xsl:for-each select="fb:description/fb:title-info/fb:annotation">
					<div>
						<xsl:call-template name="annotation"/>
					</div>
					<hr/>
				</xsl:for-each>
				
				<!-- BUILD BOOK -->
				<xsl:call-template name="DocGen"/>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>