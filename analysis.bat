REM ####################### Universal Environment Settings #######################
REM ## Jenkins Server
set JenkinsServerName=

REM ## Klocwork Server
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

REM ## Jenkins Project Path, usually %WORKSPACE%/../
set ProjectPath=%WORKSPACE%/../

REM ## Jenkins Job Name
set ProjectName=%JOB_NAME%

REM ############################## Project Settings ##############################
REM ## SCM tool: svn or git
set SCM=svn

REM ## the path Jenkins stores the source code
set SourcePath=%WORKSPACE%

REM ## Jenkins project description, Chinese characters are acceptable
set ProjectDescription=

REM ## running mode£º0 Normal Mode; 1 send mail to CCList; 2 don't send mail
set RunningMode=

REM ## Klocwork cpu core/thread number
set JobNumber=

REM ## Klocwork project name, usually same with jenkins job name, Chinese characters and hyphens are not allowed
set KlocworkProjectName=%ProjectName%

REM ## Klocwork: Source Language: c,cxx,java,csharp
set SourceLanguage=

REM ## Klocwork: Source Encoding: UTF-8, GBK, GB2312, US-ASCII, ISO-8859-1
set SourceEncoding=UTF-8

REM ## Klocwork Clean Command, replace double quotation mark with single quotation mark
set CleanCommand=

REM ## Klocwork Make Command, replace double quotation mark with single quotation mark
set KlocworkMakeCommand=

REM ######################### Email Notification Setting #########################
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

REM ## CCList.EmailAddresses with Email domain, separated with comma(,)
set CCEmailAddress=
REM ## Email reject name list without Email domain, separated with comma(,). Asterisk mark(*) represents whole user names.
set RejectEmailName=

python "%KlocworkScriptsPath%\analysis.py" %JenkinsServerName% %SCM% %KlocworkProjectServerHost% %KlocworkProjectServerPort% %KlocworkLicenseServerHost% %KlocworkLicenseServerPort% %EmailDomain% %EmailSmtp% %EmailSender% %EmailAuthUserID% %EmailAuthUserPassword% %RunningMode% %JobNumber% %ProjectName% %ProjectDescription% %KlocworkProjectName% %KlocworkScriptsPath% %ProjectPath% %SourcePath% %SourceLanguage% %SourceEncoding% %CleanCommand% %KlocworkMakeCommand% %CCEmailAddress% %RejectEmailName% %KlocworkProjectsRoot% END
