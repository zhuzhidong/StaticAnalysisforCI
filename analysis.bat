REM #################### Universal Environment Settings ####################
REM #
REM #  �ⲿ�����ݣ�������Ŀ��ͬ��һ������²����޸�
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

REM ## Jenkinsִ��ʱ����ĿĿ¼��һ����workspaceĿ¼����һ��(workspace�·�Դ����)�����⽫��ĿĿ¼��ΪԴ��������Ŀ¼����Ϊ��ĿĿ¼�»��������ɵı����ļ����Ӷ������������
set ProjectPath=%WORKSPACE%

REM ## Jenkins��job�����ƣ�һ�㲻�޸ġ�
set ProjectName=%JOB_NAME%

REM ########################### Project Settings ###########################
REM #
REM #  ������Ŀ������ģʽ�����ԡ�Set 
REM #
REM ########################################################################


REM ## SCM �����ͣ�ȡֵ svn������git
set SCM=svn

REM ## Jenkinsִ��ʱ��build��Klocwork�����ڴ�Ŀ¼��ִ��
set SourcePath=%WORKSPACE%

REM ## Jenkins ��Ŀ��˵�����ɰ������ġ����ŵ������ַ�
set ProjectDescription=

REM ## ��Ŀ����ģʽ��0=�������У�1=ֻ���ʼ��������ߣ�2=�����ʼ�
set RunningMode=

REM ## Klocwork ����ʱ���õĲ����߳�����(cpu core/thread) 1==>10
set JobNumber=

REM ## Klocwork��Ŀ���ƣ�Ĭ��Ϊ��Jenkins��Ŀ����Ŀ����ͬ�����ܰ������ģ����Ž�֧���»��� -->
set KlocworkProjectName=%ProjectName%

REM ## Klocwork: Source Language: c,cxx,java,csharp
set SourceLanguage=

REM ## Klocwork: Source Encoding: UTF-8, GBK, GB2312, US-ASCII, ISO-8859-1
set SourceEncoding=UTF-8

REM ## Klocwork Clean Command
set CleanCommand=

REM ## Klocwork Make Command: ˫����(")ת�룺python�ű��Զ���������(')�滻Ϊ˫����
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

REM ## �ʼ����͵�ַ��Ϊ���ʼ������������ʼ���ַ����Ӣ�Ķ���(,)�ָ����ű����Գ��͵�ַ���κδ���
set CCEmailAddress=
REM ## �ʼ��ܾ��û�����Ϊ�����ʼ���������Ӣ�Ķ���(",")�ָ����û�����"*"��ʾȫ���û������ű��ݴ˻���ʼ��ռ��ˣ�������Դ�����Owner�����й��˴���
set RejectEmailName=

python "%KlocworkScriptsPath%\analysis.py" %JenkinsServerName% %SCM% %KlocworkProjectServerHost% %KlocworkProjectServerPort% %KlocworkLicenseServerHost% %KlocworkLicenseServerPort% %EmailDomain% %EmailSmtp% %EmailSender% %EmailAuthUserID% %EmailAuthUserPassword% %RunningMode% %JobNumber% %ProjectName% %ProjectDescription% %KlocworkProjectName% %KlocworkScriptsPath% %ProjectPath% %SourcePath% %SourceLanguage% %SourceEncoding% %CleanCommand% %KlocworkMakeCommand% %CCEmailAddress% %RejectEmailName% %KlocworkProjectsRoot% END
