# StaticAnalysisforCI
持续集成中Klocwork静态分析驱动模块
****
## 目录
* [介绍](#介绍)
* [功能](#功能)
* [用法](#用法)
* [Jenkins插件](#Jenkins插件)

### 介绍
----
StaticAnalysisforCI脚本用于在[Jenkins](https://jenkins.io/index.html)等持续集成（CI）工具中驱动[Klocwork](https://www.klocwork.com/)进行代码静态分析。

### 功能
----
StaticAnalysisforCI脚本主要功能：

    * 项目编译构建
    * 项目建立与分配权限
    * 缺陷检测规则选取
    * 生成.out文件
    * 执行代码静态扫描
    * 缺陷定位引入者
    * 缺陷结果邮件推送

### 用法
----
配置好analysis.bat/analysis.sh文件，放入配置管理库，在Jenkins中选择增加构建步骤Execute Windows batch command/Execute shell，执行脚本。

### Jenkins插件
----
Jenkins具有类似功能的插件[Klocwork Community](https://plugins.jenkins.io/klocwork)。
Klocwork Community插件+Pipeline才是持续集成静态分析的正确打开方式。