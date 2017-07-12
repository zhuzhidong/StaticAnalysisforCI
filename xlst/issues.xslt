<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xdt="http://www.w3.org/2005/xpath-datatypes">
	<xsl:output method="html" version="4.0" encoding="GBK" indent="yes"/>
	<xsl:include href="global.xslt"/>
	<!--================ template / ================-->
	<xsl:template match="/">
		<html>
			<head>
				<title>Klocwork源代码分析结果</title>
			</head>
			<body>
				<xsl:call-template name="css"/>
				<table>
					<tr>
						<td class="title" colspan="10">Klocwork源代码分析结果</td>
					</tr>
					<tr>
						<td class="subtitle" colspan="10">
							[项目名称]：<xsl:value-of select="$projectName"/>
							<xsl:text disable-output-escaping="yes">&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;</xsl:text>
							[项目说明]：<xsl:value-of select="$projectDescription"/>
							<xsl:text disable-output-escaping="yes">&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;</xsl:text>
							[分析时间]：<xsl:value-of select="$buildTime"/></td>
					</tr>
					<tr>
						<th>序号</th>
						<th>所有者</th>
						<th>严重等级</th>
						<th>存在状态</th>
						<th>处理状态</th>
						<th>问题代码</th>
						<th>问题ID</th>
						<th>问题描述</th>
						<th>问题位置</th>
						<th>问题路径</th>
					</tr>
					<xsl:for-each select="errorList/problem">
						<xsl:sort select="owner"/>
						<xsl:sort select="number(severitylevel)"/>
						<xsl:sort select="state"/>
						<xsl:sort select="citingStatus"/>
						<xsl:sort select="code"/>
						<xsl:sort select="problemID"/>
						<tr>
							<td class="center">
								<xsl:number value="position()"/>
							</td>
							<td>
								<xsl:value-of select="owner"/>
							</td>
							<xsl:if test="displayAs = 'Error'">
								<td class="emphasis">
									<xsl:value-of select="severity"/> (<xsl:value-of select="severitylevel"/>)
								</td>
							</xsl:if>
							<xsl:if test="displayAs = 'Warning'">
								<td class="center">
									<xsl:value-of select="severity"/> (<xsl:value-of select="severitylevel"/>)
								</td>
							</xsl:if>
							<td>
								<xsl:value-of select="state"/>
							</td>
							<td>
								<xsl:value-of select="citingStatus"/>
							</td>
							<td>
								<xsl:value-of select="code"/>
							</td>
							<td class="center">
								<xsl:value-of select="problemID"/>
							</td>
							<td>
								<a>
									<xsl:attribute name="href"><xsl:value-of select="url"/></xsl:attribute>
									<xsl:attribute name="target">_blank</xsl:attribute>
									<xsl:value-of select="message"/>
								</a>
							</td>
							<td>
								<strong>[File]: </strong>
								<xsl:value-of select="file"/>
								<br/>
								<strong>[Method]: </strong>
								<xsl:value-of select="method"/>
								<br/>
								<strong>[Code Line]: </strong>
								<xsl:value-of select="line"/>
								<br/>
								<strong>[Code Column]: </strong>
								<xsl:value-of select="column"/>
							</td>
							<td>
								<xsl:apply-templates select="./trace/traceBlock[@id = 0]"/>
							</td>
						</tr>
					</xsl:for-each>
				</table>
			</body>
		</html>
	</xsl:template>
	<!--================ template traceBlock ================-->
	<xsl:template name="traceBlock" match="traceBlock">
		<dl>
			<xsl:for-each select="traceLine">
				<xsl:choose>
					<!-- type of "E"-->
					<xsl:when test="current()/@type = 'E'">
						<dt class="error">
							<xsl:analyze-string select="../@file" regex="[^\\|/]*.$">
						    <xsl:matching-substring>
						      <xsl:value-of select="regex-group(0)" />: 
						    </xsl:matching-substring>
						  </xsl:analyze-string>
							<xsl:value-of select="current()/@line"/>: <xsl:value-of select="@text"/>
							<xsl:if test="current()/@refId != ''">
								<xsl:apply-templates select="../../traceBlock[@id = current()/@refId]"/>
							</xsl:if>
						</dt>
					</xsl:when>
					<!-- type of "C"-->
					<xsl:otherwise>
						<dt>
							<xsl:analyze-string select="../@file" regex="[^\\|/]*.$">
						    <xsl:matching-substring>
						      <xsl:value-of select="regex-group(0)" />: 
						    </xsl:matching-substring>
						  </xsl:analyze-string>
							<xsl:value-of select="@line"/>: <xsl:value-of select="@text"/>
							<xsl:if test="@refId != ''">
								<!-- The following won't be reach for this type of traceline will not be "Error" traceline -->
								<xsl:apply-templates select="traceBlock">
									<xsl:with-param name="traceBlockID" select="@refId"/>
								</xsl:apply-templates>
							</xsl:if>
						</dt>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</dl>
	</xsl:template>
</xsl:stylesheet>
