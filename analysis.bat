REM #################### Universal Environment Settings ####################
REM #
REM #  这部分内容，各个项目相同，一般情况下不需修改
REM #
REM ########################################################################

REM ## Jenkins Server
set JenkinsServerName=

REM ## Klocwork server
set KlocworkProjectServerHost=

REM ## Klocwork ProjectServer Port
set KlocworkProjectServerPort=

REM ## Klocwork LicenseServer Host
set KlocworkLicenseServerHost=

REM ## Klocwork LicenseServer Port
set KlocworkLicenseServerPort=

REM ## Klocwork projects_root dir
set KlocworkProjectsRoot=

REM ## Klocwork Script Path
set KlocworkScriptsPath=

REM ## Jenkins执行时，项目目录，一般是workspace目录的上一级(workspace下放源代码)。避免将项目目录作为源代码编译的目录，因为项目目录下会存放新生成的报告文件，从而引起代码变更。
set ProjectPath=%WORKSPACE%

REM ## Jenkins中job的名称，一般不修改。
set ProjectName=%JOB_NAME%

REM ########################### Project Settings ###########################
REM #
REM #  设置项目的运行模式和属性。Set 
REM #
REM ########################################################################


REM ## SCM 的类型，取值 svn，或者git
set SCM=svn

REM ## Jenkins执行时，build和Klocwork分析在此目录下执行
set SourcePath=%WORKSPACE%

REM ## Jenkins 项目的说明，可包括中文、符号等任意字符
set ProjectDescription=

REM ## 项目运行模式：0=正常运行；1=只发邮件给抄送者；2=不发邮件
set RunningMode=

REM ## Klocwork 分析时采用的并发线程数量(cpu core/thread) 1==>10
set JobNumber=

REM ## Klocwork项目名称：默认为与Jenkins项目的项目名相同，不能包含中文，符号仅支持下划线 -->
set KlocworkProjectName=%ProjectName%

REM ## Klocwork: Source Language: c,cxx,java,csharp
set SourceLanguage=

REM ## Klocwork: Source Encoding: UTF-8, GBK, GB2312, US-ASCII, ISO-8859-1
set SourceEncoding=UTF-8

REM ## Klocwork Clean Command
set CleanCommand=

REM ## Klocwork Make Command: 双引号(")转译：python脚本自动将单引号(')替换为双引号
set KlocworkMakeCommand=

REM ###################### Email Notification Setting ######################
REM #
REM #  Set Email 
REM #
REM ########################################################################

REM ## Email Domain
set EmailDomain=
REM ## Email Smtp server
set EmailSmtp=
REM ## EmailSender
set EmailSender=
REM ## EmailAuthUserID
set EmailAuthUserID=
REM ## EmailAuthUserPassword
set EmailAuthUserPassword=

REM ## 邮件抄送地址：为带邮件域名的完整邮件地址，用英文逗号(,)分隔，脚本不对抄送地址做任何处理
set CCEmailAddress=
REM ## 邮件拒绝用户名：为不带邮件域名的用英文逗号(",")分隔的用户名，"*"表示全部用户名。脚本据此会对邮件收件人（来自于源代码的Owner）进行过滤处理
set RejectEmailName=

python "%KlocworkScriptsPath%\analysis.py" %JenkinsServerName% %SCM% %KlocworkProjectServerHost% %KlocworkProjectServerPort% %KlocworkLicenseServerHost% %KlocworkLicenseServerPort% %EmailDomain% %EmailSmtp% %EmailSender% %EmailAuthUserID% %EmailAuthUserPassword% %RunningMode% %JobNumber% %ProjectName% %ProjectDescription% %KlocworkProjectName% %KlocworkScriptsPath% %ProjectPath% %SourcePath% %SourceLanguage% %SourceEncoding% %CleanCommand% %KlocworkMakeCommand% %CCEmailAddress% %RejectEmailName% %KlocworkProjectsRoot% END
