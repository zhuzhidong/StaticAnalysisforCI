#!/usr/bin/env python3
# -*- coding: utf-8 -*-

__author__ = "zhuzhidong"

import sys
import os
import re
import logging
import time
import subprocess
import zipfile
from klocwork.update_role_assignment import update_role_assignment


def main():
    if len(sys.argv) != 28:
        print("==========analysis.py: "
              "Parameter missing, ParameterCount != 28!", flush=True)
        sys.exit(1)

    # Global Variables Definition #
    global JenkinsServerName
    global SCM
    global KlocworkProjectServerHost
    global KlocworkProjectServerPort
    global KlocworkLicenseServerHost
    global KlocworkLicenseServerPort
    global EmailDomain
    global EmailSmtp
    global EmailSender
    global EmailAuthUserID
    global EmailAuthUserPassword
    global RunningMode
    global JobNumber
    global ProjectName
    global ProjectDescription
    global KlocworkProjectName
    global KlocworkScriptsPath
    global ProjectPath
    global SourcePath
    global SourceLanguage
    global SourceEncoding
    global CleanCommand
    global KlocworkMakeCommand
    global CCEmailAddress
    global RejectEmailName
    global KlocworkProjectsRoot

    global KlocworkTablesPath
    # Variables from ParameterArray #
    JenkinsServerName = sys.argv[1]
    SCM = sys.argv[2]
    KlocworkProjectServerHost = sys.argv[3]
    KlocworkProjectServerPort = sys.argv[4]  # str or int
    KlocworkLicenseServerHost = sys.argv[5]
    KlocworkLicenseServerPort = sys.argv[6]
    EmailDomain = sys.argv[7]
    EmailSmtp = sys.argv[8]
    EmailSender = sys.argv[9]
    EmailAuthUserID = sys.argv[10]
    EmailAuthUserPassword = sys.argv[11]
    RunningMode = sys.argv[12]
    JobNumber = sys.argv[13]
    ProjectName = sys.argv[14]
    ProjectDescription = sys.argv[15]
    KlocworkProjectName = sys.argv[16]
    KlocworkScriptsPath = sys.argv[17]
    ProjectPath = sys.argv[18]
    SourcePath = sys.argv[19]
    SourceLanguage = sys.argv[20]
    # UTF-8, GBK, GB2312, US-ASCII, ISO-8859-1 (capital)
    # prefer --encoding to --source-encoding
    SourceEncoding = sys.argv[21]
    # escape single quotation mark into double quotation mark
    # can not solve pipe operator when using backslash for escaping
    CleanCommand = sys.argv[22].replace('\'', '\"')
    KlocworkMakeCommand = sys.argv[23].replace('\'', '\"')
    CCEmailAddress = sys.argv[24]
    RejectEmailName = sys.argv[25]
    KlocworkProjectsRoot = sys.argv[26]

    KlocworkTablesPath = os.path.join(ProjectPath, 'tables')
    # Print Variables #
    for i in range(0, 28):
        print("==========analysis.py: "
              "ParameterArray[%s] = %s" % (str(i), sys.argv[i]), flush=True)
    print("*********************Tables*****************", flush=True)
    print(KlocworkTablesPath, flush=True)
    print("********************************************", flush=True)
    # End Variables #

    LogFilePath = os.path.join(ProjectPath, 'analysis.log')
    logging.basicConfig(filename=LogFilePath, filemode='w',
                        level=logging.DEBUG,
                        format='==========%(asctime)s [%(funcName)s]'
                        '[%(lineno)d] [%(levelname)s]:%(message)s',
                        datefmt='%Y-%d-%m %I:%M:%S %p')
    console = logging.StreamHandler()
    console.setLevel(logging.DEBUG)
    formatter = logging.Formatter(fmt='==========%(asctime)s [%(funcName)s]'
                                  '[%(lineno)d] [%(levelname)s]:%(message)s',
                                  datefmt='%Y-%d-%m %I:%M:%S %p')
    console.setFormatter(formatter)
    logging.getLogger('').addHandler(console)


def init():
    if re.match(r'\w*[\u4e00-\u9fa5]+', KlocworkProjectName):
        logging.error("Project Name \"%s\" has Chinese character(s)!" %
                      KlocworkProjectName)
        sys.exit(1)
    global CreateProjectCommand, BuildProjectCommand
    global BuildTime, BuildTime_ForKW, LoadDatabaseCommand
    CreateProjectCommand = (
        "kwadmin --host %s --port %s "
        "create-project %s --language %s --encoding %s")\
        % (KlocworkProjectServerHost,
           KlocworkProjectServerPort,
           KlocworkProjectName,
           SourceLanguage,
           SourceEncoding, )
    BuildProjectCommand = (
        "kwbuildproject --host %s --port %s "
        "--license-host %s --license-port %s --project %s --encoding %s "
        "--incremental --jobs-num %s --tables-directory %s %s")\
        % (KlocworkProjectServerHost, KlocworkProjectServerPort,
           KlocworkLicenseServerHost, KlocworkLicenseServerPort,
           KlocworkProjectName, SourceEncoding, JobNumber,
           KlocworkTablesPath, os.path.join(SourcePath, 'kwinject.out'), )
    BuildTime_ForKW = time.strftime('%Y%m%d_%H%M%S', time.localtime())
    BuildTime = time.strftime('%Y-%m-%d %H:%M:%S', time.localtime())
    LoadDatabaseCommand = "kwadmin --host %s --port %s load %s %s --name %s"\
        % (KlocworkProjectServerHost, KlocworkProjectServerPort,
           KlocworkProjectName, KlocworkTablesPath, BuildTime_ForKW, )
    logging.debug('CleanCommand = %s' % CleanCommand)
    logging.debug('KlocworkMakeCommand = %s' % KlocworkMakeCommand)
    logging.debug('CreateProjectCommand = %s' % CreateProjectCommand)
    logging.debug('BuildProjectCommand = %s' % BuildProjectCommand)
    logging.debug('LoadDatabaseCommand = %s' % LoadDatabaseCommand)


def genOUT():
    logging.info("Generating build-specification file...")

    if '' != CleanCommand:
        # devenv return code:
        # 0 - Success
        # 1 - Partial success
        # 2 - Unrecognized command
        # 100 - Nothing succeeded
        # msdev return code: Not clear
        # By convention, command line execution should return:
        # zero when execution succeeds
        # non-zero when execution fails.
        # Warning messages typically don't effect the return code.

        # when multiple double quotation mark, os.system() fails.
        # blame the low level C function system().
        # note that devenv.com should be used not devenv.exe
        p_cc = subprocess.Popen(CleanCommand)
        p_cc.wait()
        if p_cc.returncode != 0:
            logging.error("Clean failed: %d" % p_cc.returncode)
            sys.exit(1)
        else:
            logging.info("Cleaning stage completed!")
    else:
        logging.info("CleanCommand not set. Cleaning stage skipped!")

    if '' != KlocworkMakeCommand:
        p_kmc = subprocess.Popen(KlocworkMakeCommand)
        p_kmc.wait()
        if p_kmc.returncode != 0:
            logging.error('Generate build-spec failed: %d' % p_kmc.returncode)
            sys.exit(1)
        else:
            logging.info("Generate build-specification file success!")
    else:
        logging.warning("KlocworkMakeCommand not set. "
                        "Attention! kwinject.out may not exist!")


def createPrj():
    isExist = False
    ListProjectCommand = (
        "kwadmin --host %s --port %s list-projects")\
        % (KlocworkProjectServerHost, KlocworkProjectServerPort, )
    output = os.popen(ListProjectCommand)  # implemented using subprocess.Popen
    for project in output.readlines():
        if KlocworkProjectName == project.strip():
            isExist = True
            logging.info("Project %s exist!" % KlocworkProjectName)
            break

    if not isExist:
        logging.info("Project %s doesn't exist! Create the project!"
                     % KlocworkProjectName)
        p_cpc = subprocess.Popen(CreateProjectCommand)
        p_cpc.wait()
        if p_cpc.returncode != 0:
            logging.error("Create project %s failed: %d!" %
                          (KlocworkProjectName, p_cpc.returncode, ))
            sys.exit(1)
        else:
            user = "Administrator"
            role_name = "Developer"
            group = "false"
            remove = "false"
            logging.info("Create project %s successfully!" %
                         KlocworkProjectName)
            if re.match(r'^([A-Z]{2}|\d{1,2}B)_.*', KlocworkProjectName):
                account = 'group-' + KlocworkProjectName.strip().split('_')[0]
                update_role_assignment(
                    KlocworkProjectServerHost,
                    KlocworkProjectServerPort,
                    user, role_name, account,
                    group, project, remove)
                # host name vs IP address
            else:
                logging.info("Permission of project %s not set. skipped!"
                             % KlocworkProjectName)
    else:
        logging.info("Project %s ready!" % KlocworkProjectName)


def genSOWFromSVN():
    os.system("svn update")
    GenXmlCommand = "svn info -R --xml %s > %s" % (
        SourcePath, os.path.join(ProjectPath, 'owner.xml'), )
    p_gxc = subprocess.Popen(GenXmlCommand)
    p_gxc.wait()

    ExtractSowCmd = "java -jar %s -s:%s -xsl:%s -o:%s"\
        % (os.path.join(KlocworkScriptsPath, 'saxon9he.jar'),
           os.path.join(ProjectPath, 'owner.xml'),
           os.path.join(KlocworkScriptsPath, 'extract-svn-owners.xsl'),
           os.path.join(ProjectPath, '%s.sow' % KlocworkProjectName), )
    p_esc = subprocess.Popen(ExtractSowCmd)
    p_esc.wait()
    logging.info("SOW file ready!")


def genSOW():
    if 'svn' == SCM:
        genSOWFromSVN()


def importSOW():
    if os.path.exists(os.path.join(ProjectPath,
                                   '%s.sow' % KlocworkProjectName)):
        ImportSowCmd = "kwadmin --host %s --port %s import-config %s %s" \
                       % (KlocworkProjectServerHost,
                          KlocworkProjectServerPort,
                          KlocworkProjectName,
                          os.path.join(ProjectPath,
                                       '%s.sow' % KlocworkProjectName), )
        p_isc = subprocess.Popen(ImportSowCmd)
        p_isc.wait()
        if p_isc.returncode != 0:
            logging.error("Can NOT import %s.sow: %d" %
                          (KlocworkProjectName, p_isc.returncode, ))
            sys.exit(1)
        else:
            logging.info("Import %s.sow success!" % KlocworkProjectName)
    else:
        logging.info("Can NOT find $KlocworkProjectName.sow, skip sow info!")


def buildPrj():
    global ReportPath, JarPath
    ReportPath = os.path.join(
        ProjectPath, os.path.join('report', BuildTime_ForKW))
    JarPath = os.path.join(KlocworkScriptsPath, 'jar')
    if not os.path.exists(ReportPath):
        os.makedirs(ReportPath, mode=0o777)
    BuildSpecificationPath = os.path.join(SourcePath, 'kwinject.out')
    if os.path.exists(BuildSpecificationPath):
        # error code:
        # 0 - success
        # 1 - something went wrong but no tables were generated
        # 2 - tables were generated
        # but there was a critical error during the build
        # such as missing includes and compiler failures
        p_bpc = subprocess.Popen(BuildProjectCommand)
        p_bpc.wait()
        if p_bpc.returncode != 0:
            logging.error("Build project failed: %d" % p_bpc.returncode)
            sys.exit(1)
        else:
            logging.info("Build project %s complete!" % KlocworkProjectName)

        p_ldc = subprocess.Popen(LoadDatabaseCommand)
        p_ldc.wait()
        if p_ldc.returncode != 0:
            logging.error("Load project failed: %d" % p_bpc.returncode)
        else:
            logging.info("Load project %s complete!" % KlocworkProjectName)

        query = "status:+Analyze,+Fix grouping:off"
        issuesExportCommand = (
            "java -jar %s --project %s --klocworkhost %s --klocworkPort  %s "
            "--license-host %s --license-port %s --build %s --query \"%s\" "
            "--outputXmlFile \"%s\" --projects_root \"%s\"")\
            % (os.path.join(JarPath, 'KWInspectReport.jar'),
               KlocworkProjectName,
               KlocworkProjectServerHost, KlocworkProjectServerPort,
               KlocworkLicenseServerHost, KlocworkLicenseServerPort,
               BuildTime_ForKW, query, os.path.join(ReportPath, 'issues.xml'),
               KlocworkProjectsRoot, )

        logging.debug('issuesExportCommand = %s' % issuesExportCommand)

        p_iec = subprocess.Popen(issuesExportCommand)
        p_iec.wait()
        if p_iec.returncode != 0:
            logging.error("Export issues failed: %d" % p_iec.returncode)
            sys.exit(1)
        else:
            logging.info("Export project %s complete!" % KlocworkProjectName)
    else:
        logging.error("Specification file %s does not exist!" %
                      BuildSpecificationPath)
        sys.exit(1)


def getUsers():
    global MailList
    MailList = []
    re_owner = re.compile(r'^[ \t\r\n]*<owner>(.+)</owner>')
    with open(os.path.join(ReportPath, 'issues.xml'), 'r') as xml:
        for line in xml.readlines:
            if re_owner.match(line):
                owner_name = re_owner.match(line).group(1)
                if owner_name not in RejectEmailName:
                    MailList.append(owner_name + '@' + EmailDomain)
    logging.debug("MailList = %s" % ','.join(MailList))
    logging.info("Get %s Users success!" % KlocworkProjectName)


def genHTML():
    global XsltPath
    XsltPath = os.path.join(KlocworkScriptsPath, 'xslt')
    genReportCommand = (
        "java -cp %s net.sf.saxon.Transform -s:%s -xsl:%s "
        "-o:%s projectName=\"%s\" projectDescription=\"%s\" buildTime=\"%s\"")\
        % (os.path.join(JarPath, 'saxon9he.jar'),
           os.path.join(ReportPath, 'issues.xml'),
           os.path.join(XsltPath, 'report.xslt'),
           os.path.join(ReportPath, 'report.html'),
           KlocworkProjectName,
           ProjectDescription,
           BuildTime, )
    genIssuesCommand = (
        "java -cp %s net.sf.saxon.Transform -s:%s -xsl:%s "
        "-o:%s projectName=\"%s\" projectDescription=\"%s\" buildTime=\"%s\"")\
        % (os.path.join(JarPath, 'saxon9he.jar'),
           os.path.join(ReportPath, 'issues.xml'),
           os.path.join(XsltPath, 'issues.xslt'),
           os.path.join(ReportPath, 'issues.html'),
           KlocworkProjectName,
           ProjectDescription,
           BuildTime, )
    p_grc = subprocess.Popen(genReportCommand)
    p_grc.wait()
    if p_grc.returncode != 0:
        logging.error("Gen report.html failed: %d" % p_grc.returncode)
        sys.exit(1)
    else:
        logging.info("Gen project %s report complete!" % KlocworkProjectName)
    p_gic = subprocess.Popen(genIssuesCommand)
    p_gic.wait()
    if p_gic.returncode != 0:
        logging.error("Gen issues.html failed: %d" % p_gic.returncode)
        sys.exit(1)
    else:
        logging.info("Gen project %s issues complete!" % KlocworkProjectName)


def mail():
    if int(RunningMode) <= 1:
        subject = "%s:Klocwork %s %s"\
                  % (JenkinsServerName, ProjectDescription, BuildTime)
        mailtxt = os.path.join(ReportPath, 'report.html')
        attachmentCtype = "text/html"
        attachmentFilename = "issues.html"
        attach = os.path.join(ReportPath, attachmentFilename)
        if os.path.getsize(attach) >= 2048000:
            attachmentCtype = "application/zip"
            attachmentFilename = "issues.zip"
            zipFile(attach)
            attach = os.path.join(ReportPath, attachmentFilename)
        logging.debug("attachmentCtype = %s; "
                      "attachmentFilename = %s; "
                      "attach = %s"
                      % (attachmentCtype, attachmentFilename, attach))
        if RunningMode == 0:
            mailTo = ','.join(MailList)
            if '' == mailTo or '*' == RejectEmailName:
                mailTo = CCEmailAddress
        elif RunningMode == 1:
            mailTo = CCEmailAddress
        sendMail(subject, mailtxt, attachmentCtype,
                 attachmentFilename, attach, mailTo)


def zipFile(attach):
    (filepath, filename) = os.path.split(os.path.abspath(attach))
    zipfilename = os.path.splitext(filename)[0] + '.zip'
    with zipfile.ZipFile(os.path.join(filepath, zipfilename), 'w') as zipped:
        zipped.write(attach)


def sendMail():
    pass


if __name__ == "__main__":
    main()
    init()
    genOUT()
    createPrj()
    genSOW()
    importSOW()
    buildPrj()
    getUsers()
    genHTML()
    mail()
