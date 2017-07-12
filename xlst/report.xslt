<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xdt="http://www.w3.org/2005/xpath-datatypes">
	<xsl:output method="html" version="4.0" encoding="GBK" indent="yes"/>
	<xsl:include href="global.xslt"/>
	<!--================ template / ================-->
	<xsl:template match="/">
		<html>
			<head>
				<title>Klocwork源代码分析报告</title>
			</head>
			<body>
				<xsl:call-template name="css"/>
				<table>
					<tr>
						<td class="title" colspan="18">Klocwork源代码分析报告</td>
					</tr>
					<tr>
						<td class="subtitle" colspan="18">
							[项目名称]：<xsl:value-of select="$projectName"/>
							<xsl:text disable-output-escaping="yes">&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;</xsl:text>
							[项目说明]：<xsl:value-of select="$projectDescription"/>
							<xsl:text disable-output-escaping="yes">&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;</xsl:text>
							[分析时间]：<xsl:value-of select="$buildTime"/>
							<xsl:text disable-output-escaping="yes">&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;</xsl:text>
							[需修复\分析错误]：<xsl:value-of select="count(//problem[number(./severitylevel) &lt; 6 and ./citingStatus!='Defer'])"/>
						</td>
					</tr>
					<tr>
						<th rowspan="3">所有者<br/>Owner</th>
						<th rowspan="3">问题总数<br/>Total</th>
						<th colspan="10">严重等级 Severity Level</th>
						<th rowspan="2" colspan="3">存在状态<br/>Exist Status</th>
						<th rowspan="2" colspan="3">处理状态<br/>Process Status</th>
					</tr>
					<tr>
						<th colspan="2">错误 Error</th>
						<th colspan="8">警告 Warning</th>
					</tr>
					<tr>
						<th>1 级<br/>Critical</th>
						<th>2 级<br/>Severe</th>
						<th>3 级<br/>Error</th>
						<th>4 级<br/>Unexpected</th>
						<th>5 级<br/>Investigate</th>
						<th>6 级<br/>Warning</th>
						<th>7 级<br/>Suggestion</th>
						<th>8 级<br/>Style</th>
						<th>9 级<br/>Review</th>
						<th>10级<br/>Info</th>
						<th>新发现<br/>New</th>
						<th>再次发现<br/>Recurred</th>
						<th>已经存在<br/>Existing</th>
						<th>需修复<br/>Fix</th>
						<th>需分析<br/>Analyze</th>
						<th>延迟处理<br/>Defer</th>
					</tr>
					<!--================ 总计 total ================-->
					<tr>
						<td class="total">总计</td>
						<xsl:call-template name="num-total">
							<xsl:with-param name="num" select="count(//problem)"/>
						</xsl:call-template>
						<!--================ 严重等级 severitylevel ================-->
						<xsl:call-template name="num-emphasis">
							<xsl:with-param name="num" select="count(//problem[number(./severitylevel)=1])"/>
						</xsl:call-template>
						<xsl:call-template name="num-emphasis">
							<xsl:with-param name="num" select="count(//problem[number(./severitylevel)=2])"/>
						</xsl:call-template>
						<xsl:call-template name="num-emphasis">
							<xsl:with-param name="num" select="count(//problem[number(./severitylevel)=3])"/>
						</xsl:call-template>
						<xsl:call-template name="num-emphasis">
							<xsl:with-param name="num" select="count(//problem[number(./severitylevel)=4])"/>
						</xsl:call-template>
						<xsl:call-template name="num-emphasis">
							<xsl:with-param name="num" select="count(//problem[number(./severitylevel)=5])"/>
						</xsl:call-template>
						<xsl:call-template name="num-emphasis">
							<xsl:with-param name="num" select="count(//problem[number(./severitylevel)=6])"/>
						</xsl:call-template>
						<xsl:call-template name="num-emphasis">
							<xsl:with-param name="num" select="count(//problem[number(./severitylevel)=7])"/>
						</xsl:call-template>
						<xsl:call-template name="num-emphasis">
							<xsl:with-param name="num" select="count(//problem[number(./severitylevel)=8])"/>
						</xsl:call-template>
						<xsl:call-template name="num-emphasis">
							<xsl:with-param name="num" select="count(//problem[number(./severitylevel)=9])"/>
						</xsl:call-template>
						<xsl:call-template name="num-emphasis">
							<xsl:with-param name="num" select="count(//problem[number(./severitylevel)=10])"/>
						</xsl:call-template>
						<!--================ 存在状态 state ================-->
						<xsl:call-template name="num-emphasis">
							<xsl:with-param name="num" select="count(//problem[./state='New'])"/>
						</xsl:call-template>
						<xsl:call-template name="num-emphasis">
							<xsl:with-param name="num" select="count(//problem[./state='Recurred'])"/>
						</xsl:call-template>
						<xsl:call-template name="num-emphasis">
							<xsl:with-param name="num" select="count(//problem[./state='Existing'])"/>
						</xsl:call-template>
						<!--================ 处理状态 citingStatus ================-->
						<xsl:call-template name="num-emphasis">
							<xsl:with-param name="num" select="count(//problem[./citingStatus='Fix'])"/>
						</xsl:call-template>
						<xsl:call-template name="num-emphasis">
							<xsl:with-param name="num" select="count(//problem[./citingStatus='Analyze'])"/>
						</xsl:call-template>
						<xsl:call-template name="num-emphasis">
							<xsl:with-param name="num" select="count(//problem[./citingStatus='Defer'])"/>
						</xsl:call-template>
					</tr>
					<!--================ 每个人 owner ================-->
					<xsl:for-each-group select="/errorList/problem" group-by="./owner">
						<xsl:sort select="owner"/>
						<tr>
							<td class="total">
								<xsl:value-of select="current-grouping-key()"/>
							</td>
							<td class="total">
								<xsl:value-of select="count(current-group()/owner)"/>
							</td>
							<!--================ 严重等级 severitylevel ================-->
							<xsl:call-template name="num-emphasis">
								<xsl:with-param name="num" select="count(current-group()[number(./severitylevel)=1])"/>
							</xsl:call-template>
							<xsl:call-template name="num-emphasis">
								<xsl:with-param name="num" select="count(current-group()[number(./severitylevel)=2])"/>
							</xsl:call-template>
							<xsl:call-template name="num-emphasis">
								<xsl:with-param name="num" select="count(current-group()[number(./severitylevel)=3])"/>
							</xsl:call-template>
							<xsl:call-template name="num-emphasis">
								<xsl:with-param name="num" select="count(current-group()[number(./severitylevel)=4])"/>
							</xsl:call-template>
							<xsl:call-template name="num-emphasis">
								<xsl:with-param name="num" select="count(current-group()[number(./severitylevel)=5])"/>
							</xsl:call-template>
							<xsl:call-template name="num-emphasis">
								<xsl:with-param name="num" select="count(current-group()[number(./severitylevel)=6])"/>
							</xsl:call-template>
							<xsl:call-template name="num-emphasis">
								<xsl:with-param name="num" select="count(current-group()[number(./severitylevel)=7])"/>
							</xsl:call-template>
							<xsl:call-template name="num-emphasis">
								<xsl:with-param name="num" select="count(current-group()[number(./severitylevel)=8])"/>
							</xsl:call-template>
							<xsl:call-template name="num-emphasis">
								<xsl:with-param name="num" select="count(current-group()[number(./severitylevel)=9])"/>
							</xsl:call-template>
							<xsl:call-template name="num-emphasis">
								<xsl:with-param name="num" select="count(current-group()[number(./severitylevel)=10])"/>
							</xsl:call-template>
							<!--================ 存在状态 state ================-->
							<xsl:call-template name="num-emphasis">
								<xsl:with-param name="num" select="count(current-group()[./state='New'])"/>
							</xsl:call-template>
							<xsl:call-template name="num-emphasis">
								<xsl:with-param name="num" select="count(current-group()[./state='Recurred'])"/>
							</xsl:call-template>
							<xsl:call-template name="num-emphasis">
								<xsl:with-param name="num" select="count(current-group()[./state='Existing'])"/>
							</xsl:call-template>
							<!--================ 处理状态 citingStatus ================-->
							<xsl:call-template name="num-emphasis">
								<xsl:with-param name="num" select="count(current-group()[./citingStatus='Fix'])"/>
							</xsl:call-template>
							<xsl:call-template name="num-emphasis">
								<xsl:with-param name="num" select="count(current-group()[./citingStatus='Analyze'])"/>
							</xsl:call-template>
							<xsl:call-template name="num-emphasis">
								<xsl:with-param name="num" select="count(current-group()[./citingStatus='Defer'])"/>
							</xsl:call-template>
						</tr>
					</xsl:for-each-group>
				</table>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>
