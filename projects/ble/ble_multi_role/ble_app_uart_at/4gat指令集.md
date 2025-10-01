YunDTU AT 指令手册 

让设计更简单

深圳市飞思创电子科技有限公司 

**1** / **60** 

www.freestrong.com

**YunDTU AT** **指令手册**

**文档版本：****V1.2.0**

**Copyright © Freestrong. Ltd. All rights reserved.**YunDTU AT 指令手册 

让设计更简单

深圳市飞思创电子科技有限公司 

**2** / **60** 

www.freestrong.com

**更新历史**

版本 

更新内容 

更新时间 

编辑人 

审核人

V1.0.0 

第一次发布 

2023 年 11 月 08 日 

Barry 

Jerry

V1.0.1 

更正 Socket 通道描述 

2023 年 11 月 20 日 

Barry 

Jerry

V1.1.0 

新增上位机配置工具介绍 

2023 年 11 月 27 日 

Jerry 

Barry

V1.2.0 

修改 MQTT 指令格式，优化文档结构 

2024 年 6 月 12 日 

Breeze 

Barry

**版权声明**

Copyright © Freestrong S.Z. Ltd. All rights reserved.

联系邮箱：support@freestrong.com

更多信息，请登录：www.freestrong.comYunDTU AT 指令手册 

让设计更简单

深圳市飞思创电子科技有限公司 

**3** / **60** 

www.freestrong.com

**功能特点**

⚫ 网络优，搭载 CAT-1 网络，10Mbps 下载，5Mbps 上传，满足 80%的数据传输应用场景；

⚫ 延时低，4G 网络搭载，毫秒级延时体验；

⚫ 覆盖广，基于现有运营商 4G 网络，稳定性高；

⚫ 支持网络透传功能，串口数据直接传到网络端，简单可靠；

⚫ 支持 Keep-Alive 机制，可以保活连接，增强连接稳定性；

⚫ 支持注册包，心跳包数据；

⚫ 支持基站定位和 NTP 时间更新；

⚫ 多种参数设置方式：网络、串口 AT 指令和电脑端设置软件配置；

⚫ 具有安全机制，可设置指令模式登录密码；

⚫ 多种指示灯，状态判断方便准确；

⚫ 支持 FOTA 自升级，升级 YunDTU 自身固件。YunDTU AT 指令手册 

让设计更简单

深圳市飞思创电子科技有限公司 

**4** / **60** 

www.freestrong.com

目 录

更新历史 ....................................................................................................................................................................2

版权声明 ....................................................................................................................................................................2

功能特点 ....................................................................................................................................................................3

目 录........................................................................................................................................................................4

\1. 指令介绍.............................................................................................................................................................8

1.1. 

指令中问的格式....................................................................................................................................8

1.2. 

指令中答的格式....................................................................................................................................8

1.3. 

指令错误码...........................................................................................................................................9

1.4. 

完整指令说明 .......................................................................................................................................9

1.5. 

超级命令.............................................................................................................................................10

\2. AT 指令集 .........................................................................................................................................................11

\3. AT 指令详解......................................................................................................................................................14

3.1. 

通用指令.............................................................................................................................................14

3.1.1. 

AT 握手测试................................................................................................................................14

3.1.2. 

AT+Z 重启模组............................................................................................................................14

3.1.3. 

AT+S 保存配置并重启 ................................................................................................................14

3.1.4. 

AT+CLEAR 恢复出厂并重启.......................................................................................................14

3.1.5. 

AT+E 查询/设置回显使能............................................................................................................14

3.1.6. 

AT+ENTM 退出配置模式 ............................................................................................................15

3.1.7. 

AT+STMSG 查询/设置启动信息 .................................................................................................15

3.1.8. 

AT+RSTIM 查询/设置设备无数据重启时间.................................................................................16

3.1.9. 

AT+PARMSVER 查询/设置参数版本..........................................................................................16

3.1.10. AT+AUTH 查询/设置授权码........................................................................................................16

3.1.11. AT+DEBUG 查询/设置调试信息使能..........................................................................................17

3.1.12. AT+LINKDEBUG 查询/设置主动上报通道连接信息使能............................................................18

3.1.13. AT+APN 查询/ 设置 APN 信息...................................................................................................18

3.1.14. AT+FOTA 固件远程升级.............................................................................................................19

3.1.15. AT+SAFEATEN 查询/设置安全机制使能....................................................................................19

3.1.16. AT+SIGNINAT 查询/设置安全机制登录密码...............................................................................20

3.1.17. AT+CMDHD 查询/设置超级命令头.............................................................................................20

3.1.18. AT+SN 查询/设置 SN 码 .............................................................................................................21

3.1.19. AT+CACHEEN 查询/设置数据缓存使能.....................................................................................21

3.1.20. AT+SIMSWITCH 查询/设置 SIM 卡运行模式.............................................................................22

3.2. 

查询指令.............................................................................................................................................22

3.2.1. 

AT+CSQ 查询信号强度...............................................................................................................22

3.2.2. 

AT+VER 查询固件版本号 ...........................................................................................................23

3.2.3. 

AT+BUILD 查询固件编译时间.....................................................................................................23YunDTU AT 指令手册 

让设计更简单

深圳市飞思创电子科技有限公司 

**5** / **60** 

www.freestrong.com

3.2.4. 

AT+IMEI 查询 IMEI 码.................................................................................................................23

3.2.5. 

AT+ICCID 查询 ICCID 码............................................................................................................24

3.2.6. 

AT+CREG 查询网络注册状态.....................................................................................................24

3.2.7. 

AT+LBS 查询小区基站信息 ........................................................................................................24

3.2.8. 

AT+CCLK 查询时间....................................................................................................................24

3.2.9. 

AT+RUNST 查询模组运行状态...................................................................................................25

3.3. 

串口指令.............................................................................................................................................25

3.3.1. 

AT+UART 查询/设置串口的参数.................................................................................................25

3.3.2. 

AT+UARTFL 查询/设置串口的打包长度 .....................................................................................26

3.3.3. 

AT+UARTFT 查询/设置串口的打包时间.....................................................................................26

3.3.4. 

AT+UARTCMDEN 查询/设置串口的自动命令使能.....................................................................27

3.3.5. 

AT+UARTCMDTM 查询/设置串口的自动命令间隔.....................................................................27

3.3.6. 

AT+UARTCMDDT 查询/设置串口的自动命令 ............................................................................28

3.3.7. 

AT+UARTCMDNUM 查询/设置串口 1 的自动命令个数..............................................................28

3.4. 

通道参数指令 .....................................................................................................................................29

3.4.1. 

AT+WKMOD[CH]查询/设置通道 CH 的工作模式 .......................................................................29

3.4.2. 

AT+SDPEN 查询/设置通道区分.................................................................................................30

3.5. 

Socket 指令........................................................................................................................................30

3.5.1. 

AT+SOCK[CH]查询/设置通道 CH 的 Socket 参数......................................................................30

3.5.2. 

AT+SOCKSSL[CH]查询/设置通道 CH 的 SOCKET SSL 功能 ...................................................31

3.5.3. 

AT+SOCKLK[CH]查询通道 CH 的 SOCKET 连接状态...............................................................31

3.5.4. 

AT+SOCKSL[CH]查询/设置通道 CH 的 SOCKET 短连接功能...................................................32

3.5.5. 

AT+SHORTTM[CH]查询/设置通道 CH 的 SOCKET 短连接超时时间........................................32

3.5.6. 

AT+SOCKRSTIM[CH]查询/设置通道 CH 的 SOCKET 重连时间 ...............................................33

3.5.7. 

AT+SOCKRSNUM[CH]查询/设置通道 CH 的 SOCKET 最大重连次数......................................33

3.5.8. 

AT+REGEN[CH]查询/设置通道 CH 的 SOCKET 注册包使能 ....................................................34

3.5.9. 

AT+REGTP[CH]查询/设置通道 CH 的 SOCKET 注册包类型.....................................................34

3.5.10. AT+REGSND[CH]查询/设置通道 CH 的 SOCKET 注册包发送方式 ..........................................35

3.5.11. AT+REGDT[CH]查询/设置通道 CH 的 SOCKET 注册包数据.....................................................36

3.5.12. AT+HEARTEN[CH]查询/设置通道 CH 的 SOCKET 心跳包使能................................................36

3.5.13. AT+HEARTSORT[CH]查询/设置通道 CH 的 SOCKET 心跳包类型...........................................37

3.5.14. AT+HEARTTP[CH]查询/设置通道 CH 的 SOCKET 心跳包发送方式.........................................37

3.5.15. AT+HEARTTM[CH]查询/设置通道 CH 的 SOCKET 心跳包周期................................................38

3.5.16. AT+HEARTDT[CH]查询/设置通道 CH 的 SOCKET 心跳包数据 ................................................38

3.6. 

MQTT 指令............................................................................................................................................39

3.6.1. 

AT+MQTTSV[CH]查询/设置通道[CH]的 MQTT 服务器参数.......................................................39

3.6.2. 

AT+MQTTSSL[CH]查询/设置通道[CH]的 MQTT SSL 功能........................................................40

3.6.3. 

AT+MQTTCONN[CH]查询/设置通道[CH]的 MQTT 服务器连接参数 .........................................40

3.6.4. 

AT+MQTTMTPC[CH]查询/设置通道[CH]的 MQTT 多主题使能 .................................................41YunDTU AT 指令手册 

让设计更简单

深圳市飞思创电子科技有限公司 

**6** / **60** 

www.freestrong.com

3.6.5. 

AT+MQTTSUB[CH]查询/设置通道[CH]的 MQTT 订阅参数........................................................42

3.6.6. 

AT+MQTTPUB[CH]查询/设置通道[CH]的 MQTT 发布参数........................................................42

3.6.7. 

AT+MQTTWLEN[CH]查询/设置通道[CH]的 MQTT 遗嘱使能.....................................................43

3.6.8. 

AT+MQTTWLTP[CH]查询/设置通道[CH]的 MQTT 遗嘱主题 .....................................................44

3.6.9. 

AT+MQTTWLDT[CH]查询/设置通道[CH]的 MQTT 遗嘱消息.....................................................44

3.7. 

HTTP 指令............................................................................................................................................45

3.7.1. 

AT+HTPTP[CH]查询/设置通道[CH]的 HTTP 工作方式 ..............................................................45

3.7.2. 

AT+HTPURL[CH]查询/设置通道[CH]的 HTTP URL...................................................................45

3.7.3. 

AT+HTPHD[CH]查询/设置通道[CH]的 HTTP HEAD 信息..........................................................46

3.7.4. 

AT+HTPPK[CH]查询/设置通道[CH]的 HTTP 返回信息过滤......................................................47

3.7.5. 

AT+HTPTIM[CH]查询/设置通道[CH]的 HTTP 服务器响应超时时间..........................................47

3.7.6. 

AT+HTPDT[CH]查询/设置通道[CH]的 HTTP 串口数据类型.......................................................48

3.8. 

云平台指令.........................................................................................................................................48

3.8.1. 

AT+CLOUD[CH]查询/设置通道[CH]的云平台工作模式..............................................................48

3.8.2. 

AT+ONENETTP[CH]查询/设置通道[CH]的 ONENET 平台接入类型 .........................................49

3.8.3. 

AT+ONENETCN[CH]查询/设置通道[CH]的 ONENET 平台连接参数.........................................49

3.8.4. 

AT+ONENETMTPC[CH]查询/设置通道[CH]的 ONENET 平台多主题使能 ................................51

3.8.5. 

AT+ONENETSUB[CH]查询/设置通道[CH]的 ONENET 平台订阅参数.......................................51

3.8.6. 

AT+ONENETPUB[CH]查询/设置通道[CH]的 ONENET 平台发布参数.......................................52

3.8.7. 

AT+ALIYUNTP[CH]查询/设置通道[CH]的阿里云平台接入类型..................................................53

3.8.8. 

AT+ALIYUNCN[CH]查询/设置通道[CH]的阿里云平台连接参数.................................................53

3.8.9. 

AT+ALIYUNMTPC[CH]查询/设置通道[CH]的阿里云平台多主题使能 ........................................55

3.8.10. AT+ALIYUNSUB[CH]查询/设置通道[CH]的阿里云平台订阅参数...............................................56

3.8.11. AT+ALIYUNPUB[CH]查询/设置通道[CH]的阿里云平台发布参数...............................................56

3.8.12. AT+ALIYUNIID[CH]查询/设置通道[CH]的阿里云实例 ID............................................................57

3.9. 

GPS 指令 .............................................................................................................................................58

3.9.1. 

AT+GPSEN 查询/设置 GPS 使能 ...............................................................................................58

3.9.2. 

AT+GPS 查询 GPS 经纬度.........................................................................................................58

\4. 联系方式...........................................................................................................................................................60

\5. 免责声明...........................................................................................................................................................60YunDTU AT 指令手册 

让设计更简单

深圳市飞思创电子科技有限公司 

**7** / **60** 

www.freestrong.com

引言

本文档主要介绍 YunDTU 固件的配置指令，适用于 YunDTU_2.1.5 及以上版本的固件。YunDTU AT 指令手册 

让设计更简单

深圳市飞思创电子科技有限公司 

**8** / **60** 

www.freestrong.com

**1.** **指令介绍**

启动 DTU 并发出开机信息后，发送“+++”进入指令模式，DTU 将接收并处理 AT 指令。

AT 指令为“问答式”指令，分为“问”和“答”两部分。“问”是指设备向 YunDTU 发送 AT

指令，“答”是指 YunDTU 给设备回复信息。

表 1-1 符号说明

符号名称 

含义

<> 

被包括的内容为必需项

[] 

被包括的内容为非必需项

{} 

被包括的内容为此文档中特殊含义的字符串

~ 

参数范围，例 A~B，参数的范围是从 A 到 B

CMD 

表示指令码

OP 

表示操作符

PARA 

表示参数

CR 

表示 ASCII 码中的“回车符”，十六进制数表示为 0x0D

LF 

表示 ASCII 码中的“换行符”，十六进制数表示为 0x0A

**1.1. 指令中问的格式** 

指令串：<AT+><CMD>[OP][PARA]<CR>

表 1-2 符号说明

命令码 

含义 

是否是必要项

AT+ 

AT 命令头 

是

CMD 

指令的功能属性 

是

OP 

操作符，如=，?，=? 

否

PARA 

执行的参数 

否

CR 

回车，命令结束符 

是

表 1-3 指令格式

类型 

指令串格式 

说明

0 

<AT+><CMD>?<CR> 

执行该指令的动作或查询当前参数值

1 

<AT+><CMD><CR> 

执行该指令的动作或查询当前参数值

2 

<AT+><CMD>=?<CR> 

查询该指令中的参数的取值范围或类型

3 

<AT+><CMD>=<PARA><CR> 

设置该指令的参数值

**1.2. 指令中答的格式** 

指令的响应信息分为有回显和无回显两种。YunDTU AT 指令手册 

让设计更简单

深圳市飞思创电子科技有限公司 

**9** / **60** 

www.freestrong.com

回显：在输入指令的时候，YunDTU 会先把输入的内容返回来，然后再对该指令做出响应。

无回显：YunDTU 不会返回输入的内容，只对指令做出响应。在以下说明中，均以无回显模式为

例。

命令串：[CR][LF][+CMD][OP][PARA][CR][LF]<CR><LF>[OK]<CR><LF>

表 1-4 符号说明

命令码 

含义 

是否是必要项

CR 

回车符 

是

LF 

换行符 

是

+CMD 

响应头 

否

OP 

操作符，如=，?，=? 

否

PARA 

返回的参数 

否

CR 

回车符 

否

LF 

换行符 

否

CR 

回车符 

是

LF 

换行符 

是

OK 

表示操作成功 

否

CR 

回车符 

是

LF 

换行符 

是

**1.3. 指令错误码** 

表 1-5 错误码

取值 

含义

ERR:1 

命令格式无效，非 AT+<command>格式

ERR:2 

命令不存在

ERR:3 

命令类型错误

ERR:4 

参数错误，取值范围或者参数数量错误

ERR:5 

无效操作

ERR:6 

无操作权限，参数已锁定无法进行修改或读取

**1.4. 完整指令说明** 

所有 AT 指令均需以{CR}{LF} (即回车换行符) 结尾。为了提升文章的阅读性，文内的 AT 指令隐去了

{CR}{LF} (即回车换行符)。

表 1-6 完整指令说明

功能 

说明 

示例与备注YunDTU AT 指令手册 

让设计更简单

深圳市飞思创电子科技有限公司 

**10** / **60** 

www.freestrong.com

测试指令

AT+E=? {CR}{LF}

{CR}{LF}+E:<status> {CR}{LF}

{CR}{LF}OK{CR}{LF}

AT+E=?

+E:<ON,OFF>

OK

查询指令

AT+E{CR}{LF}或 AT+E? {CR}{LF}

{CR}{LF}+E:<status> {CR}{LF}

{CR}{LF}OK{CR}{LF}

AT+E

+E:ON

OK

设置指令

AT+E=<status> {CR}{LF}

{CR}{LF}OK{CR}{LF}

AT+E=ON

OK

参数

status

回显状态

ON：开启

OFF：关闭

默认值：ON

**1.5. 超级命令** 

在指令前面加 admin 可以实现在透传模式下直接执行 AT 指令，不需要进入指令模式。方便用户

在透传模式下执行查询或设置指令。命令头可通过“AT+CMDHD”指令自定义。

示例：

adminAT+CSQ?

+CSQ:27

OKYunDTU AT 指令手册 

让设计更简单

深圳市飞思创电子科技有限公司 

**11** / **60** 

www.freestrong.com

**2. AT** **指令集**

表 2-1 AT 指令集

指令 

功能描述

通用功能

AT 

测试

AT+Z 

重启模组

AT+S 

保存配置并重启

AT+CLEAR 

恢复出厂并重启

AT+E 

查询/设置回显使能

AT+ENTM 

退出配置模式

AT+STMSG 

查询/设置启动信息

AT+RSTIM 

查询/设置设备无数据重启时间

AT+PARMSVER 

查询/设置参数版本

AT+AUTH 

查询/设置授权码

AT+DEBUG 

查询/设置调试信息使能

AT+LINKDEBUG 

查询/设置主动上报通道连接信息使能

AT+APN 

查询/设置 APN 信息

AT+FOTA 

固件远程升级

AT+SAFEATEN 

查询/设置安全机制使能

AT+SIGNINAT 

查询/设置安全机制登录密码

AT+CMDHD 

查询/设置超级命令头

AT+SN 

查询/设置 SN 码

AT+CACHEEN 

查询/设置数据缓存使能

AT+SIMSWITCH 

查询/设置 SIM 卡运行模式

信息查询指令

AT+CSQ 

查询信号强度

AT+VER 

查询固件版本号

AT+BUILD 

查询固件编译时间

AT+IMEI 

查询 IMEI 码

AT+ICCID 

查询 ICCID 码

AT+CREG 

查询网络注册状态

AT+LBS 

查询小区基站信息

AT+CCLK 

查询时间

AT+RUNST 

查询模组运行状态

串口参数指令

AT+UART 

查询/设置串口 1 的参数YunDTU AT 指令手册 

让设计更简单

深圳市飞思创电子科技有限公司 

**12** / **60** 

www.freestrong.com

AT+UARTFL 

查询/设置串口 1 的打包长度

AT+UARTFT 

查询/设置串口 1 的打包时间

AT+UARTCMDEN 

查询/设置串口 1 的自动命令使能

AT+UARTCMDTM 

查询/设置串口 1 的自动命令间隔

AT+UARTCMDDT 

查询/设置串口 1 的自动命令

AT+UARTCMDNUM 

查询/设置串口 1 的自动命令个数

通道参数指令

AT+WKMOD[CH] 

查询/设置通道[CH]的工作模式

AT+SDPEN 

查询/设置通道区分

Socket 指令

AT+SOCK[CH] 

查询/设置通道[CH]的 Socket 参数

AT+SOCKSSL[CH] 

查询/设置通道[CH]的 Socket SSL 功能

AT+SOCKLK[CH] 

查询通道[CH]的 Socket 连接状态

AT+SOCKSL[CH] 

查询/设置通道[CH]的 Socket 短连接功能

AT+SHORTTM[CH] 

查询/设置通道[CH]的 Socket 短连接超时时间

AT+SOCKRSTIM[CH] 

查询/设置通道[CH]的 Socket 重连时间

AT+SOCKRSNUM[CH] 

查询/设置通道[CH]的 Socket 最大重连次数

AT+REGEN[CH] 

查询/设置通道[CH]的 Socket 注册包使能

AT+REGTP[CH] 

查询/设置通道[CH]的 Socket 注册包类型

AT+REGSND[CH] 

查询/设置通道[CH]的 Socket 注册包发送方式

AT+REGDT[CH] 

查询/设置通道[CH]的 Socket 注册包数据

AT+HEARTEN[CH] 

查询/设置通道[CH]的 Socket 心跳包使能

AT+HEARTSORT[CH] 

查询/设置通道[CH]的 Socket 心跳包类型

AT+HEARTTP[CH] 

查询/设置通道[CH]的 Socket 心跳包发送方式

AT+HEARTTM[CH] 

查询/设置通道[CH]的 Socket 心跳包周期

AT+HEARTDT[CH] 

查询/设置通道[CH]的 Socket 心跳包数据

MQTT 指令

AT+MQTTSV[CH] 

查询/设置通道[CH]的 MQTT 服务器参数

AT+MQTTSSL[CH] 

查询/设置通道[CH]的 MQTT SSL 功能

AT+MQTTCONN[CH] 

查询/设置通道[CH]的 MQTT 服务器连接参数

AT+MQTTMTPC[CH] 

查询/设置通道[CH]的 MQTT 多主题使能

AT+MQTTSUB[CH] 

查询/设置通道[CH]的 MQTT 订阅参数

AT+MQTTPUB[CH] 

查询/设置通道[CH]的 MQTT 发布参数

AT+MQTTWLEN[CH] 

查询/设置通道[CH]的 MQTT 遗嘱使能

AT+MQTTWLTP[CH] 

查询/设置通道[CH]的 MQTT 遗嘱主题

AT+MQTTWLDT[CH] 

查询/设置通道[CH]的 MQTT 遗嘱消息

HTTP 指令YunDTU AT 指令手册 

让设计更简单

深圳市飞思创电子科技有限公司 

**13** / **60** 

www.freestrong.com

AT+HTPTP[CH] 

查询/设置通道[CH]的 HTTP 工作方式

AT+HTPURL[CH] 

查询/设置通道[CH]的 HTTP URL

AT+HTPHD[CH] 

查询/设置通道[CH]的 HTTP HEAD 信息

AT+HTPPK[CH] 

查询/设置通道[CH]的 HTTP 返回信息过滤

AT+HTPTIM[CH] 

查询/设置通道[CH]的 HTTP 服务器响应超时时间

AT+HTPDT[CH] 

查询/设置通道[CH]的 HTTP 串口数据类型

云平台指令

AT+CLOUD[CH] 

查询/设置通道[CH]的云平台工作模式

ONENET 云平台指令

AT+ONENETTP[CH] 

查询/设置通道[CH]的 ONENET 平台接入类型

AT+ONENETCN[CH] 

查询/设置通道[CH]的 ONENET 平台连接参数

AT+ONENETMTPC[CH] 

查询/设置通道[CH]的 ONENET 平台多主题使能

AT+ONENETSUB[CH] 

查询/设置通道[CH]的 ONENET 平台订阅参数

AT+ONENETPUB[CH] 

查询/设置通道[CH]的 ONENET 平台发布参数

阿里云平台指令

AT+ALIYUNTP[CH] 

查询/设置通道[CH]的阿里云平台接入类型

AT+ALIYUNCN[CH] 

查询/设置通道[CH]的阿里云平台连接参数

AT+ALIYUNMTPC[CH] 

查询/设置通道[CH]的阿里云平台多主题使能

AT+ALIYUNSUB[CH] 

查询/设置通道[CH]的阿里云平台订阅参数

AT+ALIYUNPUB[CH] 

查询/设置通道[CH]的阿里云平台发布参数

AT+ALIYUNIID[CH] 

查询/设置通道[CH]的阿里云实例 ID

GPS 指令

AT+GPSEN 

查询/设置 GPS 使能

AT+GPS 

查询 GPS 经纬度YunDTU AT 指令手册 

让设计更简单

深圳市飞思创电子科技有限公司 

**14** / **60** 

www.freestrong.com

**3. AT** **指令详解**

**3.1. 通用指令** 

**3.1.1. AT** **握手测试**

功能 

说明 

示例与备注

执行指令

AT

OK

**3.1.2. AT+Z** **重启模组**

功能 

说明 

示例与备注

执行指令

AT+Z

OK

**3.1.3. AT+S** **保存配置并重启**

功能 

说明 

示例与备注

执行指令

AT+S

OK

**3.1.4. AT+CLEAR** **恢复出厂并重启**

功能 

说明 

示例与备注

执行指令

AT+CLEAR

OK

**3.1.5. AT+E** **查询****/****设置回显使能**

功能 

说明 

示例与备注

测试指令

AT+E=?

+E:<status>

OK

AT+E=?

+E:<ON,OFF>

OKYunDTU AT 指令手册 

让设计更简单

深圳市飞思创电子科技有限公司 

**15** / **60** 

www.freestrong.com

查询指令

AT+E 或 AT+E?

+E:<status>

OK

AT+E

+E:ON

OK

设置指令

AT+E=<status>

OK

AT+E=ON

OK

参数

status

回显状态

ON：开启

OFF：关闭

默认值：ON

**3.1.6. AT+ENTM** **退出配置模式**

功能 

说明 

示例与备注

执行指令

AT+ENTM

OK

**3.1.7. AT+STMSG** **查询****/****设置启动信息**

功能 

说明 

示例与备注

测试指令

AT+STMSG=?

+STMSG:<message>

OK

AT+STMSG=?

+STMSG:<0~20bytes>

OK

查询指令

AT+STMSG 或 AT+STMSG?

+STMSG:<message>

OK

AT+STMSG?

+STMSG:freestrong

OK

设置指令

AT+STMSG=<message>

OK

AT+STMSG=freestrong

OK

参数

message 

开机信息，范围：0~20 字节 

默认值：freestrongYunDTU AT 指令手册 

让设计更简单

深圳市飞思创电子科技有限公司 

**16** / **60** 

www.freestrong.com

**3.1.8. AT+RSTIM** **查询****/****设置设备无数据重启时间**

功能 

说明 

示例与备注

测试指令

AT+RSTIM=?

+RSTIM:<time>

OK

AT+RSTIM=?

+RSTIM:<0~65535>

OK

查询指令

AT+RSTIM 或 AT+RSTIM?

+RSTIM:<time>

OK

AT+RSTIM?

+RSTIM:1800

OK

设置指令

AT+RSTIM=<time>

OK

AT+RSTIM=1800

OK

参数

time 

无数据重启时间，范围：0，60~65535 分钟

默认值：0

设置为 0 为不启用

**3.1.9. AT+PARMSVER** **查询****/****设置参数版本**

功能 

说明 

示例与备注

测试指令

AT+PARMSVER=?

+PARMSVER:<number>

OK

AT+PARMSVER=?

+PARMSVER:<0~65535>

OK

查询指令

AT+PARMSVER 或 AT+PARMSVER?

+PARMSVER:<number>

OK

AT+PARMSVER?

+PARMSVER:0

OK

设置指令

AT+PARMSVER=<number>

OK

AT+PARMSVER=0

OK

参数

number 

参数版本，范围：0~65535 

默认值：0

**3.1.10. AT+AUTH** **查询****/****设置授权码**

功能 

说明 

示例与备注YunDTU AT 指令手册 

让设计更简单

深圳市飞思创电子科技有限公司 

**17** / **60** 

www.freestrong.com

测试指令

AT+AUTH=?

+AUTH:<authorization>

OK

查询指令

AT+AUTH 或 AT+AUTH?

+AUTH:<status>

OK

AT+AUTH?

+AUTH:0

OK

设置指令

AT+AUTH=<authorization>

OK

AT+AUTH=NjQ3M*******3QTU2

OK

参数

authorization 授权码

status

授权状态

0：未授权

1：已授权

**3.1.11. AT+DEBUG** **查询****/****设置调试信息使能**

功能 

说明 

示例与备注

测试指令

AT+DEBUG=?

+DEBUG:<status>

OK

AT+DEBUG=?

+DEBUG:<ON,OFF>

OK

查询指令

AT+DEBUG 或 AT+DEBUG?

+DEBUG:<status>

OK

AT+DEBUG?

+DEBUG:ON

OK

设置指令

AT+DEBUG=<status>

OK

AT+DEBUG=ON

OK

参数

status

调试信息

ON：开启

OFF：关闭

默认值：OFFYunDTU AT 指令手册 

让设计更简单

深圳市飞思创电子科技有限公司 

**18** / **60** 

www.freestrong.com

**3.1.12. AT+LINKDEBUG** **查询****/****设置主动上报通道连接信息使能**

功能 

说明 

示例与备注

测试指令

AT+LINKDEBUG=?

+LINKDEBUG:<status>

OK

AT+LINKDEBUG=?

+LINKDEBUG:<ON,OFF>

OK

查询指令

AT+LINKDEBUG 或 AT+LINKDEBUG?

+LINKDEBUG:<status>

OK

AT+LINKDEBUG?

+LINKDEBUG:ON

OK

设置指令

AT+LINKDEBUG=<status>

OK

AT+LINKDEBUG=ON

OK

参数

status

调试信息

ON：开启

OFF：关闭

默认值：ON

**3.1.13. AT+APN** **查询****/** **设置** **APN** **信息**

功能 

说明 

示例与备注

测试指令

AT+APN=?

+APN:<apn>,<username>,<password>,<auth_typ

e>

OK

AT+APN=?

+APN:<0~16bytes>,<0~16bytes>,<0~16bytes>,<0~

2>

OK

查询指令

AT+APN 或 AT+APN?

+APN:<apn>,<username>,<password>,<auth_typ

e>

OK

AT+APN

+APN:CMNET,,,0

OK

设置指令

AT+APN=<apn>,<username>,<password>,<auth

_type>

OK

AT+APN=CMNET,,,0

0

OK

参数

apn 

APN，范围：0~16 字节 

默认值：internetYunDTU AT 指令手册 

让设计更简单

深圳市飞思创电子科技有限公司 

**19** / **60** 

www.freestrong.com

username 

用户名，范围：0~16 字节

password 

密码，范围：0~16 字节

auth_type

鉴权类型

0：公网 APN

1：专网 APN，PAP 加密

2：专网 APN，CHAP 加密

默认值：0

**3.1.14. AT+FOTA** **固件远程升级**

功能 

说明 

示例与备注

执行指令

AT+FOTA

OK

AT+FOTA

OK

正常升级：

FOTA_UPDATE:356137,36395,10.219382%

FOTA_UPDATE:356137,71755,20.148145%

FOTA_UPDATE:356137,107115,30.076909%

……

FOTA_UPDATE:356137,356137,100.000000%

升级失败：

FOTA_UPDATE:fail

**3.1.15. AT+SAFEATEN** **查询****/****设置安全机制使能**

功能 

说明 

示例与备注

测试指令

AT+SAFEATEN=?

+SAFEATEN:<status>

OK

AT+SAFEATEN=?

+SAFEATEN:<ON,OFF>

OK

查询指令

AT+SAFEATEN 或 AT+SAFEATEN?

+SAFEATEN:<status>

OK

AT+SAFEATEN

+SAFEATEN:ON

OK

设置指令

AT+SAFEATEN=<status>

OK

AT+SAFEATEN=ON

OK

参数YunDTU AT 指令手册 

让设计更简单

深圳市飞思创电子科技有限公司 

**20** / **60** 

www.freestrong.com

status

安全机制使能状态

ON：开启

OFF：关闭

默认值：OFF

**3.1.16. AT+SIGNINAT** **查询****/****设置安全机制登录密码**

功能 

说明 

示例与备注

测试指令

AT+SIGNINAT=?

+SIGNINAT:<password>

OK

AT+SIGNINAT=?

+SIGNINAT:<0~10bytes>

OK

查询指令

AT+SIGNINAT 或 AT+SIGNINAT?

+SIGNINAT:<password>

OK

AT+SIGNINAT

+SIGNINAT:**********

OK

设置指令/

登录指令

AT+SIGNINAT=<password>

OK

AT+SIGNINAT=1234567890

OK

参数

password 

登录密码，范围：0~10 字节 

默认值：空

指令说明

登录前为登录指令，当 SAFEATEN 为开启时，读取或设置 DTU 参数前需要先登录才能进行操作。

登录后为修改登录密码指令。

**3.1.17. AT+CMDHD** **查询****/****设置超级命令头**

功能 

说明 

示例与备注

测试指令

AT+CMDHD=?

+CMDHD:<message>

OK

AT+CMDHD=?

+CMDHD:<1~10bytes>

OK

查询指令

AT+CMDHD 或 AT+CMDHD?

+CMDHD:<message>

OK

AT+CMDHD?

+CMDHD:admin

OK

设置指令

AT+CMDHD=<message>

OK

AT+CMDHD=admin

OK

参数YunDTU AT 指令手册 

让设计更简单

深圳市飞思创电子科技有限公司 

**21** / **60** 

www.freestrong.com

message 

超级命令头，范围：1~10 字节

**3.1.18. AT+SN** **查询****/****设置** **SN** **码**

功能 

说明 

示例与备注

测试指令

AT+SN=?

+SN:<code>

OK

AT+SN=?

+SN:<0~18bytes>

OK

查询指令

AT+SN 或 AT+SN?

+SN:<code>

OK

AT+SN

+SN:2022****3698

OK

设置指令

AT+SN=<code>

OK

AT+SN=2022****3698

参数

code 

SN 码，范围：0~18 字节

**3.1.19. AT+CACHEEN** **查询****/****设置数据缓存使能**

功能 

说明 

示例与备注

测试指令

AT+CACHEEN=?

+CACHEEN:<status>

OK

AT+CACHEEN=?

+CACHEEN:<ON,OFF>

OK

查询指令

AT+CACHEEN 或 AT+CACHEEN?

+CACHEEN:<status>

OK

AT+CACHEEN

+CACHEEN:ON

OK

设置指令

AT+CACHEEN=<status>

OK

AT+CACHEEN=ON

OK

参数

status

回显状态

ON：开启

OFF：关闭

默认值：ONYunDTU AT 指令手册 

让设计更简单

深圳市飞思创电子科技有限公司 

**22** / **60** 

www.freestrong.com

**3.1.20. AT+SIMSWITCH** **查询****/****设置** **SIM** **卡运行模式**

注：仅支持双卡单待的模组才支持该指令。

功能 

说明 

示例与备注

测试指令

AT+SIMSWITCH=?

+RUNST: <ctr1>,<simID>

OK

AT+SIMSWITCH=?

+SIMSWITCH:<0,1,2>,<0,1>

OK

查询指令

AT+SIMSWITCH 或 AT+SIMSWITCH?

+RUNST: <ctr1>,<simID>

OK

AT+SIMSWITCH?

+RUNST:1,0

OK

设置指令

AT+SIMSWITCH= <ctr1>,<simID>

OK

AT+SIMSWITCH= <ctr1>,<simID>

OK

参数

Ctr1

模式选择

0：锁定卡模式,锁定单卡，关闭 SIM 卡检测和切换，

可测试时使用。

1：主卡优先模式，插上主卡则使用主卡；不插主卡则

使用副卡。

2：自动切换模式，主卡和副卡都启用，当某一张卡连

不上服务器或注册不上网络时，自动切换到另一张卡，

确保设备能够正常连接服务器。

默认主卡优先模式

SimID

0：主卡

1：副卡

当选择主卡优先模式时，此参数不生效

**3.2. 查询指令** 

**3.2.1. AT+CSQ** **查询信号强度**

功能 

说明 

示例与备注

查询指令

AT+CSQ 或 AT+CSQ?

+CSQ:<csq>

OK

AT+CSQ?

+CSQ:27

OK

参数YunDTU AT 指令手册 

让设计更简单

深圳市飞思创电子科技有限公司 

**23** / **60** 

www.freestrong.com

csq

0：-113 dBm 及以下

1：-111 dBm

2…30：-109…-53 dBm

31：-51 dBm 及以上

99：未知或未检出到

**3.2.2. AT+VER** **查询固件版本号**

功能 

说明 

示例与备注

查询指令

AT+VER 或 AT+VER?

+VER:<version>

OK

AT+VER

+VER:V1.0.0

OK

参数

version 

固件版本

**3.2.3. AT+BUILD** **查询固件编译时间**

功能 

说明 

示例与备注

查询指令

AT+BUILD 或 AT+BUILD?

+BUILD:<time>

OK

AT+BUILD

+BUILD:Apr 18 2022 18:15:49

OK

参数

time 

固件编译时间

**3.2.4. AT+IMEI** **查询** **IMEI** **码**

功能 

说明 

示例与备注

查询指令

AT+IMEI 或 AT+IMEI?

+IMEI:<code>

OK

AT+IMEI

+IMEI:86433******2457

OK

参数

code 

IMEI 码YunDTU AT 指令手册 

让设计更简单

深圳市飞思创电子科技有限公司 

**24** / **60** 

www.freestrong.com

**3.2.5. AT+ICCID** **查询** **ICCID** **码**

功能 

说明 

示例与备注

查询指令

AT+ICCID 或 AT+ICCID?

+ICCID:<code>

OK

AT+ICCID

+ICCID:89860***********1314

OK

参数

code 

ICCID 码，如果未识别到 SIM 卡返回 SIM not inserted

**3.2.6. AT+CREG** **查询网络注册状态**

功能 

说明 

示例与备注

查询指令

AT+CREG 或 AT+CREG?

+CREG:<creg>

OK

AT+CREG

+CREG:1

OK

参数

creg

网络注册状态

0：未注册

1：已注册

**3.2.7. AT+LBS** **查询小区基站信息**

功能 

说明 

示例与备注

查询指令

AT+LBS 或 AT+LBS?

+LBS:<LAC>,<CID>

OK

AT+LBS

+LBS:9724,233156931

OK

参数

LAC 

位置区 ID

CID 

小区 ID

**3.2.8. AT+CCLK** **查询时间**

功能 

说明 示例与备注YunDTU AT 指令手册 

让设计更简单

深圳市飞思创电子科技有限公司 

**25** / **60** 

www.freestrong.com

查询指令

AT+CCLK 或 AT+CCLK?

+CCLK:<data>,<time>

OK

AT+CCLK?

+CCLK:2022/06/19,20:05:19

OK

**3.2.9. AT+RUNST** **查询模组运行状态**

功能 

说明 

示例与备注

查询指令

AT+RUNST 或 AT+RUNST?

+RUNST: <status>

OK

AT+RUNST?

+RUNST:FS@CREG READY

OK

参数

status 

模组当前状态，可参考运行状态信息章节

**3.3. 串口指令** 

**3.3.1. AT+UART** **查询****/****设置串口的参数**

功能 

说明 

示例与备注

测试指令

AT+UART=?

+UART:<baud>,<data>,<stop>,<parity>,<flow>

OK

AT+UART=?

+UART:<300~921600>,<8>,<1,2>,<NONE,ODD,E

VEN>,<NONE>

OK

查询指令

AT+UART 或 AT+UART?

+UART:<baud>,<data>,<stop>,<parity>,<flow>

OK

AT+UART?

+UART:115200,8,1,NONE,NONE

OK

设置指令

AT+UART=<baud>,<data>,<stop>,<parity>,<flo

w>

OK

AT+UART=115200,8,1,NONE,NONE

OK

参数

baud

波特率

300,1200,2400,4800,9600,14400,19200,28800,38

400,57600,115200,230400,460800,921600

默认值：115200

data 

数据位 

默认值：8YunDTU AT 指令手册 

让设计更简单

深圳市飞思创电子科技有限公司 

**26** / **60** 

www.freestrong.com

7：7 位数据位

8：8 位数据位

stop

停止位

1：1 位停止位

2：2 位停止位

默认值：1

parity

检验方式

NONE：无校验

ODD：奇校验

EVEN：偶检验

默认值：NONE

flow

流控

NONE：无流控

默认值：NONE

**3.3.2. AT+UARTFL** **查询****/****设置串口的打包长度**

功能 

说明 

示例与备注

测试指令

AT+UARTFL=?

+UARTFL:<length>

OK

AT+UARTFL=?

+UARTFL:<5~4096>

OK

查询指令

AT+UARTFL 或 AT+UARTFL?

+UARTFL:<length>

OK

AT+UARTFL

+UARTFL:0

OK

设置指令

AT+UARTFL=<length>

OK

AT+UARTFL=1024

OK

参数

length 

打包长度，范围：5~4096 字节 

默认值：4096

**3.3.3. AT+UARTFT** **查询****/****设置串口的打包时间**

功能 

说明 

示例与备注

测试指令

AT+UARTFT=?

+UARTFT:<time>

OK

AT+UARTFT=?

+UARTFT:<10~2000>

OK

查询指令

AT+UARTFT 或 AT+UARTFT?

+UARTFT:<time>

AT+UARTFT

+UARTFT:30YunDTU AT 指令手册 

让设计更简单

深圳市飞思创电子科技有限公司 

**27** / **60** 

www.freestrong.com

OK 

OK

设置指令

AT+UARTFT=<time>

OK

AT+UARTFT=30

OK

参数

time 

串口空闲打包时间，范围：10~2000 毫秒 

默认值：200

**3.3.4. AT+UARTCMDEN** **查询****/****设置串口的自动命令使能**

功能 

说明 

示例与备注

测试指令

AT+UARTCMDEN=?

+UARTCMDEN:<status>

OK

AT+UARTCMDEN=?

+UARTCMDEN:<ON,OFF>

OK

查询指令

AT+UARTCMDEN 或 AT+UARTCMDEN?

+UARTCMDEN:<status>

OK

AT+UARTCMDEN?

+UARTCMDEN:ON

OK

设置指令

AT+UARTCMDEN=<status>

OK

AT+UARTCMDEN=ON

OK

参数

status

调试信息

ON：开启

OFF：关闭

默认值：OFF

**3.3.5. AT+UARTCMDTM** **查询****/****设置串口的自动命令间隔**

功能 

说明 

示例与备注

测试指令

AT+UARTCMDTM=?

+UARTCMDTM:<cmd_interval>,<task_interval>

OK

AT+UARTCMDTM=?

+UARTCMDTM:<50~65535>,<5~65535>

OK

查询指令

AT+UARTCMDTM 或 AT+UARTCMDTM?

+UARTCMDTM:<cmd_interval>,<task_interval>

OK

AT+UARTCMDTM?

+UARTCMDTM:1000,5

OKYunDTU AT 指令手册 

让设计更简单

深圳市飞思创电子科技有限公司 

**28** / **60** 

www.freestrong.com

设置指令

AT+UARTCMDTM=<cmd_interval>,<task_inter

val>

OK

AT+UARTCMDTM=1000,5

OK

参数

cmd_interva

l

命令间隔时间，范围：50~65535 毫秒 

默认值：1000

task_interval 任务间隔时间，范围：5~65535 秒 

默认值：5

**3.3.6. AT+UARTCMDDT** **查询****/****设置串口的自动命令**

功能 

说明 

示例与备注

测试指令

AT+UARTCMDDT=?

+UARTCMDDT:<number>[,format,<data>]

OK

AT+UARTCMDDT=?

+UARTCMDDT:<1~20>[,<ASCII,HEX>,<0~256by

tes>]

OK

查询指令

AT+UARTCMDDT=<number>

+UARTCMDDT:<number>,<format>,<data>

OK

AT+UARTCMDDT=1

+UARTCMDDT:1,ASCII,1234567890

OK

设置指令

AT+UARTCMDDT=<number>,<format>,<data>

OK

AT+UARTCMDDT=1,ASCII,1234567890

OK

参数

number 

命令 ID，范围：1~20

format

自动命令数据格式

ASCII：ASCII 码

HEX：16 进制

data 

自动命令数据，范围：0~256 字节

**3.3.7. AT+UARTCMDNUM** **查询****/****设置串口** **1** **的自动命令个数**

功能 

说明 

示例与备注

测试指令

AT+UARTCMDNUM=?

+UARTCMDNUM:<number>

OK

AT+UARTCMDNUM=?

+UARTCMDNUM:<0~20>

OKYunDTU AT 指令手册 

让设计更简单

深圳市飞思创电子科技有限公司 

**29** / **60** 

www.freestrong.com

查询指令

AT+UARTCMDNUM 或 AT+UARTCMDNUM?

+UARTCMDNUM:<number>

OK

AT+UARTCMDNUM?

+UARTCMDNUM:20

OK

设置指令

AT+UARTCMDNUM=<number>

OK

AT+UARTCMDNUM=20

OK

参数

number 

命令个数，范围：0~20 

默认值：0

**3.4. 通道参数指令** 

**3.4.1. AT+WKMOD[CH]****查询****/****设置通道** **CH** **的工作模式**

功能 

说明 

示例与备注

测试指令

AT+WKMOD[CH]=?

+WKMOD[CH]:<mode>

OK

AT+WKMOD1=?

+WKMOD1:<OFF,NET,HTTP,MQTT,CLOU

D>

OK

查询指令

AT+WKMOD[CH]或 AT+WKMOD[CH]?

+WKMOD[CH]:<mode>

OK

AT+WKMOD1

+WKMOD1:NET

OK

设置指令

AT+WKMOD[CH]=<mode>

OK

AT+WKMOD1=NET

OK

参数

CH

通道号

1~4：通道号

mode

工作模式

OFF：关闭

NET：网络透传模式

HTTP：HTTP 模式

MQTT：MQTT 模式

CLOUD：连云模式

默认值：OFFYunDTU AT 指令手册 

让设计更简单

深圳市飞思创电子科技有限公司 

**30** / **60** 

www.freestrong.com

**3.4.2. AT+SDPEN** **查询****/****设置通道区分**

功能 

说明 

示例与备注

测试指令

AT+SDPEN=?

+SDPEN:<status>

OK

AT+SDPEN=?

+SDPEN:<ON,OFF>

OK

查询指令

AT+SDPEN?或 AT+SDPEN

+SDPEN: <status>

OK

AT+SDPEN

+SDPEN:ON

OK

设置指令

AT+SDPEN=<status>

OK

AT+SDPEN=ON

OK

参数

status

ON：开启

OFF：关闭

**3.5. Socket 指令** 

**3.5.1. AT+SOCK[CH]****查询****/****设置通道** **CH** **的** **Socket** **参数**

功能 

说明 

示例与备注

测试指令

AT+SOCK[CH]=?

+SOCK[CH]: <protocol>,<address>,<port>

OK

AT+SOCK1=?

+SOCK1: <TCP,UDP>,<1~64bytes>,<1~65535>

OK

查询指令

AT+SOCK[CH]或 AT+SOCK[CH]?

+SOCK[CH]:<protocol>,<address>,<port>

OK

AT+SOCK1

+SOCK1:TCP,www.freestrong.com,5000

OK

设置指令

AT+SOCK[CH]=<protocol>,<address>,<port>

OK

AT+SOCK1=TCP,www.freestrong.com,5000

OK

参数

CH

通道号

1~4：通道号

protocol

通信协议

TCP：TCP 协议

默认值：TCPYunDTU AT 指令手册 

让设计更简单

深圳市飞思创电子科技有限公司 

**31** / **60** 

www.freestrong.com

UDP：UDP 协议

address 

目标地址，支持域名，范围：1~100 字节 

默认值：www.freestrong.com

port 

目标端口，范围：1~65535 

默认值：8080

**3.5.2. AT+SOCKSSL[CH]****查询****/****设置通道** **CH** **的** **SOCKET SSL** **功能**

功能 

说明 

示例与备注

测试指令

AT+SOCKSSL[CH]=?

+SOCKSSL[CH]:<status>

OK

AT+SOCKSSL1=?

+SOCKSSL1:<ON,OFF>

OK

查询指令

AT+SOCKSSL[CH] 或 AT+SOCKSSL[CH]? 

+SOCKSSL[CH]:<status> 

OK

AT+SOCKSSL1

+SOCKSSL1:ON 

OK

设置指令

AT+SOCKSSL[CH]=<status> 

OK

AT+SOCKSSL1=ON 

OK

参数

CH

通道号

1~4：通道号

status

SOCKET SSL 开启

ON：开启

OFF：关闭

默认值：OFF

**3.5.3. AT+SOCKLK[CH]****查询通道** **CH** **的** **SOCKET** **连接状态**

功能 

说明 

示例与备注

查询指令

AT+SOCKLK[CH] 或 AT+SOCKLK[CH]? 

+SOCKLK[CH]:<status> 

OK 

AT+SOCKLK1

+SOCKLK1:Connected 

OK

参数

CH

通道号

1~4：通道号

status

SOCKET 连接状态

Connected：已连接

Disconnected：未连接YunDTU AT 指令手册 

让设计更简单

深圳市飞思创电子科技有限公司 

**32** / **60** 

www.freestrong.com

**3.5.4. AT+SOCKSL[CH]****查询****/****设置通道** **CH** **的** **SOCKET** **短连接功能**

功能 

说明 

示例与备注

测试指令

AT+SOCKSL[CH]=? 

+SOCKSL[CH]:<status> 

OK 

AT+SOCKSL1=? 

+SOCKSL1:<LONG,SHORT>

OK 

查询指令

AT+SOCKSL[CH] 或 AT+SOCKSL[CH]? 

+SOCKSL[CH]:<status> 

OK

AT+SOCKSL1

+SOCKSL1:SHORT

OK

设置指令

AT+SOCKSL[CH]=<status> 

OK

AT+SOCKSL1=SHORT

OK

参数

CH

通道号

1~4：通道号

status

SOCKET 连接方式

LONG：长连接

SHORT：短连接

默认值：LONG

**3.5.5. AT+SHORTTM[CH]****查询****/****设置通道** **CH** **的** **SOCKET** **短连接超时时间**

功能 

说明 

示例与备注

测试指令

AT+SHORTTM[CH]=? 

+SHORTTM[CH]:<time> 

OK

AT+SHORTTM1=?

+SHORTTM1:<1~65535>

OK

查询指令

AT+SHORTTM[CH] 或 AT+SHORTTM[CH]? 

+SHORTTM[CH]:<time>

OK

AT+SHORTTM1

+SHORTTM1:10 

OK

设置指令

AT+SHORTTM[CH]=<time> 

OK

AT+SHORTTM1=10

OK

参数YunDTU AT 指令手册 

让设计更简单

深圳市飞思创电子科技有限公司 

**33** / **60** 

www.freestrong.com

CH

通道号

1~4：通道号

time

SOCKET 短连接超时时间，范围：1~65535，

单位：秒

默认值：10

**3.5.6. AT+SOCKRSTIM[CH]****查询****/****设置通道** **CH** **的** **SOCKET** **重连时间**

功能 

说明 

示例与备注

测试指令

AT+SOCKRSTIM[CH]=? 

+SOCKRSTIM[CH]:<time> 

OK

AT+SOCKRSTIM1 =? 

+SOCKRSTIM1:<1~65535> 

OK

查询指令

AT+SOCKRSTIM[CH] 或

AT+SOCKRSTIM[CH]? 

+SOCKRSTIM[CH]:<time> 

OK

AT+SOCKRSTIM1

+SOCKRSTIM1:5 

OK

设置指令

AT+SOCKRSTIM[CH]=<time> 

OK

AT+SOCKRSTIM1=5 

OK

参数

CH

通道号

1~4：通道号

time

SOCKET 连接重连时间间隔，范围：1~65535，

单位：秒

默认值：5

**3.5.7. AT+SOCKRSNUM[CH]****查询****/****设置通道** **CH** **的** **SOCKET** **最大重连次数**

功能 

说明 

示例与备注

测试指令

AT+SOCKRSNUM[CH]=? 

+SOCKRSNUM[CH]:<number>

OK

AT+SOCKRSNUM1=? 

+SOCKRSNUM1:<0~65535> 

OK

查询指令

AT+SOCKRSNUM[CH] 或

AT+SOCKRSNUM[CH]? 

+SOCKRSNUM[CH]:<number> 

OK

AT+SOCKRSNUM1

+SOCKRSNUM1:60 

OKYunDTU AT 指令手册 

让设计更简单

深圳市飞思创电子科技有限公司 

**34** / **60** 

www.freestrong.com

设置指令

AT+SOCKRSNUM[CH]=<number> 

OK

AT+SOCKRSNUM1=60 

OK

参数

CH

通道号

1~4：通道号

number 

SOCKET 最大重连次数，范围：0~65535 

默认值：60

**3.5.8. AT+REGEN[CH]****查询****/****设置通道** **CH** **的** **SOCKET** **注册包使能**

功能 

说明 

示例与备注

测试指令

AT+REGEN[CH]=? 

+REGEN[CH]:<status> 

OK

AT+REGEN1=? 

+REGEN1:<ON,OFF> 

OK

查询指令

AT+REGEN[CH] 或 AT+REGEN[CH]? 

+REGEN[CH]:<status> 

OK

AT+REGEN1

+REGEN1:ON 

OK

设置指令

AT+REGEN[CH]=<status> 

OK

AT+REGEN1=ON 

OK

参数

CH

通道号

1~4：通道号

status

SOCKET 注册包使能

ON：开启

OFF：关闭

默认值：OFF

**3.5.9. AT+REGTP[CH]****查询****/****设置通道** **CH** **的** **SOCKET** **注册包类型**

功能 

说明 

示例与备注

测试指令

AT+REGTP[CH]=? 

+REGTP[CH]:<type> 

OK

AT+REGTP1=? 

+REGTP1:<USER,IMEI,ICCID,SN>

OK

查询指令

AT+REGTP[CH] 或 AT+REGTP[CH]? 

+REGTCP1:<type>

AT+REGTP1

+REGTP1:IMEIYunDTU AT 指令手册 

让设计更简单

深圳市飞思创电子科技有限公司 

**35** / **60** 

www.freestrong.com

OK 

OK

设置指令

AT+REGTP[CH]=<status> 

OK

AT+REGTP1=IMEI 

OK

参数

CH

通道号

1~4：通道号

type

SOCKET 注册包类型

USER：自定义数据

IMEI：IMEI 码

ICCID：ICCID 码

SN：SN 码

默认值：IMEI

**3.5.10. AT+REGSND[CH]****查询****/****设置通道** **CH** **的** **SOCKET** **注册包发送方式**

功能 

说明 

示例与备注

测试指令

AT+REGSND[CH]=? 

+REGSND[CH]: <type> 

OK

AT+REGSND1=? 

+REGSND1:<LINK,DATA,LINK&DATA> 

OK

查询指令

AT+REGSND[CH] 或 AT+REGSND[CH]? 

+REGSND[CH]:<type> 

OK 

AT+REGSND1

+REGSND:LINK 

OK 

设置指令

AT+REGSND[CH]=<type> 

OK

AT+REGSND1=LINK 

OK

参数

CH

通道号

1~4：通道号

type

SOCKET 注册包发送方式

LINK：连接发送注册包

DATA：数据携带注册包

LINK&DATA：同时支持链接发送和数据携带

默认值：LINKYunDTU AT 指令手册 

让设计更简单

深圳市飞思创电子科技有限公司 

**36** / **60** 

www.freestrong.com

**3.5.11. AT+REGDT[CH]****查询****/****设置通道** **CH** **的** **SOCKET** **注册包数据**

功能 

说明 

示例与备注

测试指令

AT+REGDT[CH]=? 

+REGDT[CH]:<format>,<data> 

OK

AT+REGDT1=? 

+REGDT1:<ASCII,HEX>,<1~256bytes> 

OK

查询指令

AT+REGDT[CH] 或 AT+REGDT[CH]?

+REGDT[CH]:<format>,<data> 

OK

AT+REGDT1

+REGDT1:ASCII,freestrong 

OK

设置指令

AT+REGDT[CH]=<format>,<data> 

OK

AT+REGDT1=ASCII,freestrong 

OK

参数

CH

通道号

1~4：通道号

format

SOCKET 自定义注册包数据格式

ASCII：ASCII 码

HEX：16 进制

默认值：ASCII

data

SOCKET 自定义注册包数据，范围：1~256 字

节

默认值：freestrong

**3.5.12. AT+HEARTEN[CH]****查询****/****设置通道** **CH** **的** **SOCKET** **心跳包使能**

功能 

说明 

示例与备注

测试指令

AT+HEARTEN[CH]=?

+HEARTEN[CH]:<status>

OK

AT+HEARTEN1=?

+HEARTEN1:<ON,OFF>

OK

查询指令

AT+HEARTEN[CH] 或 AT+HEARTEN[CH]?

+HEARTEN[CH]:<status>

OK

AT+HEARTEN1

+HEARTEN1:ON

OK

设置指令

AT+HEARTEN[CH]=<status>

OK

AT+HEARTEN1=ON

OK

参数YunDTU AT 指令手册 

让设计更简单

深圳市飞思创电子科技有限公司 

**37** / **60** 

www.freestrong.com

CH

通道号

1~4：通道号

status

SOCKET 心跳包使能状态

ON：使能

OFF：禁用

默认值：OFF

**3.5.13. AT+HEARTSORT[CH]****查询****/****设置通道** **CH** **的** **SOCKET** **心跳包类型**

功能 

说明 

示例与备注

测试指令

AT+HEARTSORT[CH]=? 

+HEARTSORT[CH]:<type>

OK

AT+HEARTSORT1=?

+HEARTSORT1:<USER,IMEI,ICCID,SN>

OK

查询指令

AT+HEARTSORT[CH] 或

AT+HEARTSORT[CH]? 

+HEARTSORT[CH]: <type>

OK

AT+HEARTSORT1

+HEARTSORT1:IMEI

OK

设置指令

AT+HEARTSORT[CH]=<type> 

OK 

AT+HEARTSORT1=IMEI

OK

参数

CH

通道号

1~4：通道号

type

SOCKET 心跳包类型

USER：自定义数据

IMEI：IMEI 码

ICCID：ICCID 码

SN：SN 码

默认值：IMEI

**3.5.14. AT+HEARTTP[CH]****查询****/****设置通道** **CH** **的** **SOCKET** **心跳包发送方式**

功能 

说明 

示例与备注

测试指令

AT+HEARTTP[CH]=?

+HEARTTP[CH]:<type>

OK

AT+HEARTTP1=?

+HEARTTP1:<NET,COM>

OK

查询指令 

AT+HEARTTP[CH] 或 AT+HEARTTP[CH]? 

AT+HEARTTP1YunDTU AT 指令手册 

让设计更简单

深圳市飞思创电子科技有限公司 

**38** / **60** 

www.freestrong.com

+HEARTTP[CH]:<type>

OK

+HEARTTP1:NET

OK

设置指令

AT+HEARTTP[CH]=<type> 

OK

AT+HEARTTP1=NET 

OK

参数

CH

通道号

1~4：通道号

type

SOCKET 心跳包发送方式

COM：心跳包发向串口

NET：心跳包发向网络

默认值：NET

**3.5.15. AT+HEARTTM[CH]****查询****/****设置通道** **CH** **的** **SOCKET** **心跳包周期**

功能 

说明 

示例与备注

测试指令

AT+HEARTTM[CH]=?

+HEARTTM[CH]:<time>

OK

AT+HEARTTM1=?

+HEARTTM1:<1~65535>

OK

查询指令

AT+HEARTTM[CH] 或 AT+HEARTTM[CH]?

+HEARTTM[CH]:<time>

OK

AT+HEARTTM1

+HEARTTM1:30 

OK

设置指令

AT+HEARTTM[CH]=<time> 

OK 

AT+HEARTTM1=30 

OK

参数

CH

通道号

1~4：通道号

time

SOCKET 心跳包周期，范围：1~65535，单位：

秒

默认值：30

**3.5.16. AT+HEARTDT[CH]****查询****/****设置通道** **CH** **的** **SOCKET** **心跳包数据**

功能 

说明 

示例与备注YunDTU AT 指令手册 

让设计更简单

深圳市飞思创电子科技有限公司 

**39** / **60** 

www.freestrong.com

测试指令

AT+HEARTDT[CH]=?

+HEARTDT[CH]:<format>,<data>

OK

AT+HEARTDT1=?

+HEARTDT1:<ASCII,HEX>,<1~256bytes> 

OK

查询指令

AT+HEARTDT[CH] 或 AT+HEARTDT[CH]?

+HEARTDT[CH]:<format>,<data> 

OK 

AT+HEARTDT1

+HEARTDT1:ASCII,freestrong 

OK

设置指令

AT+HEARTDT[CH]=<format>,<data>

OK

AT+HEARTDT1=ASCII,freestrong

OK

参数

CH

通道号

1~4：通道号

format

SOCKET 自定义心跳包数据格式

ASCII：ASCII 码

HEX：16 进制

默认值：ASCII

data 

SOCKET 自定义心跳包数据,范围：1~256 字节 默认值：freestrong

**3.6. MQTT 指令** 

**3.6.1. AT+MQTTSV[CH]****查询****/****设置通道****[CH]****的** **MQTT** **服务器参数**

功能 

说明 

示例与备注

测试指令

AT+MQTTSV[CH]=? 

+MQTTSV[CH]:<address>,<port>

OK

AT+MQTTSV1=? 

+MQTTSV1:<1~64bytes>,<1~65535>

OK

查询指令

AT+MQTTSV[CH] 或 AT+MQTTSV[CH]? 

+MQTTSV[CH]:<address>,<port>

OK

AT+MQTTSV1

+MQTTSV1:www.freestrong.com,1883

OK

设置指令

AT+MQTTSV[CH]=<address>,<port> 

OK

AT+MQTTSV1=www.freestrong.com,1883

OK

参数

CH

通道号

1~4：通道号YunDTU AT 指令手册 

让设计更简单

深圳市飞思创电子科技有限公司 

**40** / **60** 

www.freestrong.com

address 

目标地址: 支持域名，范围：1~64 字节 

默认值：www.freestrong.com

port 

目标端口: 范围：1~65535 

默认值：1883

**3.6.2. AT+MQTTSSL[CH]****查询****/****设置通道****[CH]****的** **MQTT SSL** **功能**

功能 

说明 

示例与备注

测试指令

AT+MQTTSSL[CH]=? 

+MQTTSSL1:<status> 

OK

AT+MQTTSSL1=? 

+MQTTSSL1: <ON,OFF> 

OK

查询指令

AT+MQTTSSL[CH] 或 AT+MQTTSSL[CH]?

+MQTTSSL[CH]:<status> 

OK

AT+MQTTSSL1

+MQTTSSL1:OFF

OK

设置指令

AT+MQTTSSL[CH]=<status> 

OK

AT+MQTTSSL1=OFF 

OK

参数

CH

通道号

1~4：通道号

status

MQTT SSL 使能状态

ON：使能

OFF：禁止

默认值：OFF

**3.6.3. AT+MQTTCONN[CH]****查询****/****设置通道****[CH]****的** **MQTT** **服务器连接参数**

功能 

说明 

示例与备注

测试指令

AT+MQTTCONN[CH]=? 

+MQTTCONN[CH]:<clientid>,<username>,<pas

sword>,<keepalive>,<clean> 

OK 

AT+MQTTCONN1=? 

+MQTTCONN1:<0~256bytes>,<0~256bytes>,<0 

~256bytes>,<1~65535>,<0,1> 

OK

查询指令

AT+MQTTCONN[CH] 或

AT+MQTTCONN[CH]? 

+MQTTCONN[CH]:<clientid>,<username>,<pas

sword>,<keepalive>,<clean>

OK

AT+MQTTCONN1

+MQTTCONN1:freestrong,username,password,60 ,1 

OKYunDTU AT 指令手册 

让设计更简单

深圳市飞思创电子科技有限公司 

**41** / **60** 

www.freestrong.com

设置指令

AT+MQTTCONN[CH]=<clientid>,<username>,

<password>,<keepalive>,<clean> 

OK

AT+MQTTCONN1=freestrong,username,password,

60,1

OK

参数

CH

通道号

1~4：通道号

clientid 

客户端身份的唯一识别，范围：0~256 字节

username 

用户名，范围：0-256 字节

password 

密码，范围：0~256 字节

keepalive 

保持连接时间间隔，范围：1~65535，单位：秒 默认值：180

clean

清零会话标志

0：保存会话

1：清理会话

默认值：1

**3.6.4. AT+MQTTMTPC[CH]****查询****/****设置通道****[CH]****的** **MQTT** **多主题使能**

功能 

说明 

示例与备注

测试指令

AT+MQTTMTPC[CH]=? 

+MQTTMTPC[CH]:<status>

OK

AT+MQTTMTPC1=? 

+MQTTMTPC1:<ON,OFF> 

OK

查询指令

AT+MQTTMTPC[CH] 或

AT+MQTTMTPC[CH]? 

+MQTTMTPC[CH]:<status> 

OK

AT+MQTTMTPC1

+MQTTMTPC1:ON 

OK

设置指令

AT+MQTTMTPC[CH]=<status>

OK

AT+MQTTMTPC1=ON

OK

参数

CH

通道号

1~4：通道号

status

MQTT 多主题使能状态

ON：使能

OFF：禁用

默认值：OFFYunDTU AT 指令手册 

让设计更简单

深圳市飞思创电子科技有限公司 

**42** / **60** 

www.freestrong.com

**3.6.5. AT+MQTTSUB[CH]****查询****/****设置通道****[CH]****的** **MQTT** **订阅参数**

功能 

说明 

示例与备注

测试指令

AT+MQTTSUB[CH]=? 

+MQTTSUB[CH]:<topic1>,<qos1>[,<topic2>,<q

os2>][,<topic3>,<qos3>]

OK

AT+MQTTSUB1=? 

+MQTTSUB1:<0~128bytes>,<0~2>[,<0~12 

8bytes>,<0~2>][,<0~128bytes>,<0~2>]

OK 

查询指令

AT+MQTTSUB[CH] 或 AT+MQTTSUB[CH]? 

+MQTTSUB[CH]:,<topic1>,<qos1>,<topic2>,<q

os2>,<topic3>,<qos3> 

OK

AT+MQTTSUB1

+MQTTSUB1:,0,,0,,0

OK 

设置指令

AT+MQTTSUB[CH]=<topic1>,<qos1>[,<topic2

\>,<qos2>][,<topic3>,<qos3>]

OK

AT+MQTTSUB1=freestrong,0 

OK 

参数

CH

通道号

1~4：通道号

topic 

订阅的主题名，范围：0~128 字节

qos 

订阅主题的服务质量等级

0：最多分发一次

1：至少分发一次

2：只分发一次

默认值：0

**3.6.6. AT+MQTTPUB[CH]****查询****/****设置通道****[CH]****的** **MQTT** **发布参数**

功能 

说明 

示例与备注

测试指令

AT+MQTTPUB[CH]=? 

+MQTTPUB[CH]:<topic>,<qos>,<retain> 

OK

AT+MQTTPUB1=? 

+MQTTPUB1:<0~128bytes>,<0~2>,<0,1> 

OK

查询指令

AT+MQTTPUB[CH] 或 AT+MQTTPUB[CH]? 

+MQTTPUB[CH]:<topic>,<qos>,<retain> 

OK

AT+MQTTPUB1

+MQTTPUB1:freestrong,0,0 

OK

设置指令 

AT+MQTTPUB[CH]=<topic>,<qos>,<retain> 

AT+MQTTPUB1=freestrong,0,0 YunDTU AT 指令手册 

让设计更简单

深圳市飞思创电子科技有限公司 

**43** / **60** 

www.freestrong.com

OK 

OK

参数

CH

通道号

1~4：通道号

topic 

订阅的主题名，范围：0~128 字节

qos 

订阅主题的服务质量等级

0：最多分发一次

1：至少分发一次

2：只分发一次

默认值：0 

retain

报文保留标志位

0：不保留

1：保留

默认值：0 

**3.6.7. AT+MQTTWLEN[CH]****查询****/****设置通道****[CH]****的** **MQTT** **遗嘱使能**

功能 

说明 

示例与备注

测试指令

AT+MQTTWLEN[CH]=? 

+MQTTWLEN[CH]:<status> 

OK

AT+MQTTWLEN1=? 

+MQTTWLEN1:<ON,OFF> 

OK

查询指令

AT+MQTTWLEN[CH] 或

AT+MQTTWLEN[CH]?

+MQTTWLEN[CH]:<status> 

OK

AT+MQTTWLEN1

+MQTTWLEN1:ON

OK

设置指令

AT+MQTTWLEN[CH]=<status> 

OK

AT+MQTTWLEN1=ON

OK

参数

CH

通道号

1~4：通道号

status

MQTT 遗嘱使能状态

ON：使能

OFF：禁用

默认值：OFFYunDTU AT 指令手册 

让设计更简单

深圳市飞思创电子科技有限公司 

**44** / **60** 

www.freestrong.com

**3.6.8. AT+MQTTWLTP[CH]****查询****/****设置通道****[CH]****的** **MQTT** **遗嘱主题**

功能 

说明 

示例与备注

测试指令

AT+MQTTWLTP[CH]=?

+MQTTWLTP[CH]:<topic>,<qos>,<retain> 

OK

AT+MQTTWLTP1=? 

+MQTTWLTP1:<0~128bytes>,<0~2>,<0,1> 

OK

查询指令

AT+MQTTWLTP[CH] 或

AT+MQTTWLTP[CH]? 

+MQTTWLTP[CH]:<topic>,<qos>,<retain> 

OK

AT+MQTTWLTP1

+MQTTWLTP1:,0,0 

OK

设置指令

AT+MQTTWLTP[CH]=<topic>,<qos>,<retain> 

OK 

AT+MQTTWLTP1=,0,0 

OK

参数

CH

通道号

1~4：通道号

topic 

MQTT 遗嘱消息主题，范围：0~64 字节

qos

发布主题的服务质量等级

0：最多分发一次

1：至少分发一次

2：只分发一次

默认值：0 

retain

报文保留标志位

0：不保留

1：保留

默认值：0

**3.6.9. AT+MQTTWLDT[CH]****查询****/****设置通道****[CH]****的** **MQTT** **遗嘱消息**

功能 

说明 

示例与备注

测试指令

AT+MQTTWLDT[CH]=? 

+MQTTWLDT[CH]:<data> 

OK

AT+MQTTWLDT1=? 

+MQTTWLDT1:<0~1024bytes> 

OK

查询指令

AT+MQTTWLDT[CH] 或

AT+MQTTWLDT[CH]? 

+MQTTWLDT[CH]:<data> 

AT+MQTTWLDT1

+MQTTWLDT1:YunDTU AT 指令手册 

让设计更简单

深圳市飞思创电子科技有限公司 

**45** / **60** 

www.freestrong.com

OK

OK

设置指令

AT+MQTTWLDT[CH]=<data> 

OK

AT+MQTTWLDT1=freestrong 

OK

参数

CH

通道号

1~4：通道号

data

MQTT 遗嘱消息，格式为 ASCII,范围：0~1024

字节

**3.7. HTTP 指令** 

**3.7.1. AT+HTPTP[CH]****查询****/****设置通道****[CH]****的** **HTTP** **工作方式**

功能 

说明 

示例与备注

测试指令

AT+HTPTP[CH]=? 

+HTPTP[CH]:<type> 

OK

AT+HTPTP1=? 

+HTPTP1:<GET,POST> 

OK

查询指令

AT+HTPTP[CH] 或 AT+HTPTP[CH]? 

+HTPTP[CH]:<type> 

OK

AT+HTPTP1

+HTPTP1:GET 

OK

设置指令

AT+HTPTP[CH]=<type>

OK 

AT+HTPTP1=GET 

OK

参数

CH

通道号

1~4：通道号

type

HTTP 请求方式

GET：GET 方式

POST：POST 方式

默认值：GET

**3.7.2. AT+HTPURL[CH]****查询****/****设置通道****[CH]****的** **HTTP URL**

功能 

说明 

示例与备注YunDTU AT 指令手册 

让设计更简单

深圳市飞思创电子科技有限公司 

**46** / **60** 

www.freestrong.com

测试指令

AT+HTPURL[CH]=? 

+HTPURL[CH]:<type> 

OK

AT+HTPURL1=? 

+HTPURL1:<0~256bytes> 

OK

查询指令

AT+HTPURL[CH] 或 AT+HTPURL[CH]? 

+HTPURL[CH]: < type >

OK

AT+HTPURL1

+HTPURL1:http://www.freestrong.com/

OK

设置指令

AT+HTPURL[CH]=< type > 

OK

AT+HTPURL1=http://www.freestrong.com 

OK

参数

CH

通道号

1~4：通道号

type 

HTTP 请求的 URL，范围：0~256 字节 

默认值：http://www.freestrong.com 

**3.7.3. AT+HTPHD[CH]****查询****/****设置通道****[CH]****的** **HTTP HEAD** **信息**

功能 

说明 

示例与备注

测试指令

AT+HTPHD[CH]=? 

+HTPHD[CH]:<head> 

OK 

AT+HTPHD1=? 

+HTPHD1:<0~256bytes> 

OK

查询指令

AT+HTPHD[CH] 或 AT+HTPHD[CH]? 

+HTPHD[CH]:<head> 

OK

AT+HTPHD1

+HTPHD1:

OK

设置指令

AT+HTPHD[CH]=<head> 

OK 

AT+HTPHD1=text/plain: */*[0D][0A] 

OK

参数

CH

通道号

1~4：通道号

head 

HTTP 请求头，范围：0~256 字节 YunDTU AT 指令手册 

让设计更简单

深圳市飞思创电子科技有限公司 

**47** / **60** 

www.freestrong.com

**3.7.4. AT+HTPPK[CH]****查询****/****设置通道****[CH]****的** **HTTP** **返回信息过滤**

功能 

说明 

示例与备注

测试指令

AT+HTPPK[CH]=? 

+HTPPK[CH]:<status> 

OK 

AT+HTPPK1=? 

+HTPPK1:<0~7>

OK

查询指令

AT+HTPPK[CH] 或 AT+HTPPK[CH]? 

+HTPPK[CH]:<status> 

OK 

AT+HTPPK1

+HTPPK1:4

OK

设置指令

AT+HTPPK[CH]=<status> 

OK

AT+HTPPK1=4

OK

参数

CH

通道号

1~4：通道号

status

信息过滤

0x01：保留 code

0x02：保留 head

0x04：保留 body

默认值：0x04

**3.7.5. AT+HTPTIM[CH]****查询****/****设置通道****[CH]****的** **HTTP** **服务器响应超时时间**

功能 

说明 

示例与备注

测试指令

AT+HTPTIM[CH]=? 

+HTPTIM[CH]:<time> 

OK 

AT+HTPTIM1=? 

+HTPTIM1:<1~65535> 

OK

查询指令

AT+HTPTIM[CH] 或 AT+HTPTIM[CH]? 

+HTPTIM[CH]:<time> 

OK

AT+HTPTIM1

+HTPTIM1:10 

OK

设置指令

AT+HTPTIM[CH]=<time> 

OK 

AT+HTPTIM1=10 

OK

参数YunDTU AT 指令手册 

让设计更简单

深圳市飞思创电子科技有限公司 

**48** / **60** 

www.freestrong.com

CH

通道号

1~4：通道号

time 

请求超时时间，范围：1~65535，单位：秒 

默认值：10

**3.7.6. AT+HTPDT[CH]****查询****/****设置通道****[CH]****的** **HTTP** **串口数据类型**

功能 

说明 

示例与备注

测试指令

AT+HTPDT[CH]=? 

+HTPDT[CH]:<type> 

OK 

AT+HTPDT1=?

+HTPDT1:<BODY,QUERY>

OK

查询指令

AT+HTPDT[CH]或 AT+HTPDT[CH]? 

+HTPDT[CH]:<type> 

OK

AT+HTPDT1?

+HTPDT1:BODY

OK

设置指令

AT+HTPDT[CH]=<type> 

OK

AT+HTPDT1=BODY

OK

参数

CH

通道号

1~4：通道号

type

串口数据类型

BODY

QUERYF

默认值：BODY

**3.8. 云平台指令** 

**3.8.1. AT+CLOUD[CH]****查询****/****设置通道****[CH]****的云平台工作模式**

功能 

说明 

示例与备注

测试指令

AT+CLOUD[CH]=? 

+CLOUD[CH]:<mode> 

OK 

AT+CLOUD1=?

+CLOUD1:<ONENET,ALIYUN>

OK

查询指令

AT+CLOUD[CH]或 AT+CLOUD[CH]? 

+CLOUD[CH]:<mode> 

AT+CLOUD1?

+CLOUD1:ONENETYunDTU AT 指令手册 

让设计更简单

深圳市飞思创电子科技有限公司 

**49** / **60** 

www.freestrong.com

OK 

OK

设置指令

AT+CLOUD[CH]=<mode> 

OK

AT+CLOUD1=ONENET

OK

参数

CH

通道号

1~4：通道号

**mode**

云平台工作模式

ONENET：ONENET 云平台

ALIYUN：阿里云平台

默认值：ONENET

**3.8.2. AT+ONENETTP[CH]****查询****/****设置通道****[CH]****的** **ONENET** **平台接入类型**

功能 

说明 

示例与备注

测试指令

AT+ONENETTP[CH]=? 

+ONENETTP[CH]:<type> 

OK 

AT+ONENETTP1=?

+ONENETTP1:<USER,AUTO>

OK

查询指令

AT+ONENETTP[CH]或 AT+ONENETTP[CH]? 

+ONENETTP[CH]:<type> 

OK

AT+ONENETTP1?

+ONENETTP1:USER

OK

设置指令

AT+ONENETTP[CH]=<type> 

OK

AT+ONENETTP1=USER

OK

参数

CH

通道号

1~4：通道号

**type**

接入类型

USER：用户接入

AUTO：自动接入

默认值：USER

**3.8.3. AT+ONENETCN[CH]****查询****/****设置通道****[CH]****的** **ONENET** **平台连接参数**

功能 

说明 

示例与备注YunDTU AT 指令手册 

让设计更简单

深圳市飞思创电子科技有限公司 

**50** / **60** 

www.freestrong.com

测试指令

AT+ONENETCN[CH]=?

+ONENETCN[CH]:<product_id>,<device_name

\>[,<key>][,<accesskey>],<keepalive>,<clean>

OK 

AT+ONENETCN1=?

+ONENETCN1:<0~16bytes>,<0~32bytes>[,<0~64b

ytes>][,<0~128bytes>],<0~65535>,<0,1>

OK

查询指令

用户注册：

AT+ONENETCN[CH] 或 AT+ONENETCN[CH]?

+ONENETCN[CH]:<product_id>,<device_name>,<key>,<keepalive>,<clean>

OK

自动注册：

AT+ONENETCN[CH] 或 AT+ONENETCN[CH]?

+ONENETCN[CH]:<product_id>,<device_name>,<accesskey>,<keepalive>,<clean>

OK

设置指令

用户注册：

AT+ONENETCN[CH]=<product_id>,<device_name>,<key>,<keepalive>,<clean>

OK

自动注册：

AT+ONENETCN[CH]=<product_id>,<device_name>,<accesskey>,<keepalive>,<clean>

OK 

参数

CH

通道号

1~4：通道号

product_id 

范围：0~16 字节

device_nam

e

范围：0~32 字节

key 

范围：0~64 字节

accesskey 

范围：0~128 字节

keepalive 

保持连接时间间隔，范围：0~65535，单位：秒 默认值：180

clean

清零会话标志

0：保存会话

1：清理会话

默认值：1YunDTU AT 指令手册 

让设计更简单

深圳市飞思创电子科技有限公司 

**51** / **60** 

www.freestrong.com

**3.8.4. AT+ONENETMTPC[CH]****查询****/****设置通道****[CH]****的** **ONENET** **平台多主题使能**

功能 

说明 

示例与备注

测试指令

AT+ONENETMTPC[CH]=? 

+ONENETMTPC[CH]:<status>

OK 

AT+ONENETMTPC1=?

+ONENETMTPC1:<ON,OFF>

OK

查询指令

AT+ONENETMTPC[CH]或

AT+ONENETMTPC[CH]? 

+ONENETMTPC[CH]:<status> 

OK

AT+ONENETMTPC1

+ONENETMTPC1:OFF

OK

设置指令

AT+ONENETMTPC[CH]=<status> 

OK

AT+ONENETMTPC1=OFF

OK

参数

CH

通道号

1~4：通道号

**status**

ONENET 多主题模式

ON:开启

OFF:关闭

默认值：OFF

**3.8.5. AT+ONENETSUB[CH]****查询****/****设置通道****[CH]****的** **ONENET** **平台订阅参数**

功能 

说明 

示例与备注

测试指令

AT+ONENETSUB[CH]=?

+ONENETSUB[CH]:<topic1>,<qos1>[,<topic2>,

<qos2>][,<topic3>,<qos3>]

OK

AT+ONENETSUB1=?

+ONENETSUB1:<0~128bytes>,<0~2>[,<0~128byte

s>,<0~2>][,<0~128bytes>,<0~2>]

OK

查询指令

AT+ONENETSUB[CH]或

AT+ONENETSUB[CH]? 

+ONENETSUB[CH]:<topic1>,<qos1>,<topic2>,

<qos2>,<topic3>,<qos3>

AT+ONENETSUB1

+ONENETSUB1:,0,,0,,0

OKYunDTU AT 指令手册 

让设计更简单

深圳市飞思创电子科技有限公司 

**52** / **60** 

www.freestrong.com

OK

设置指令

AT+ONENETSUB[CH]=<topic1>,<qos1>[,<topi

c2>,<qos2>][,<topic3>,<qos3>]

OK

AT+ONENETSUB1=$sys/18erHQ9d68/testdevice1/

ota/inform,0

OK

参数

**CH**

通道号

1-4：通道号

**topic** 

ONENET 订阅主题，范围：0~128 字节

**qos**

ONENET 订阅主题 QOS

0：QOS0

1：QOS1

2：QOS2

默认值：0

**3.8.6. AT+ONENETPUB[CH]****查询****/****设置通道****[CH]****的** **ONENET** **平台发布参数**

功能 

说明 

示例与备注

测试指令

AT+ONENETPUB[CH]=?

+ONENETPUB[CH]:<topic>,<qos>,<retained>

OK

AT+ONENETPUB1=?

+ONENETPUB1:<0~128bytes>,<0~2>,<0,1>

OK

查询指令

AT+ONENETPUB[CH]或

AT+ONENETPUB[CH]? 

+ONENETPUB[CH]:<topic>,<qos>,<retained>

OK

AT+ONENETPUB1?

+ONENETPUB1:,0,0

OK

设置指令

AT+ONENETPUB[CH]=<topic>,<qos>,<retaine

d>

OK

AT+ONENETPUB1=$sys/18erHQ9d68/testdevice1/

ota/inform_reply,0,0

OK

参数

CH

通道号

1~4：通道号

**topic** 

ONENET 订阅主题，范围：0~128 字节

**qos**

ONENET 订阅主题 QOS

0：QOS0

1：QOS1

默认值：0YunDTU AT 指令手册 

让设计更简单

深圳市飞思创电子科技有限公司 

**53** / **60** 

www.freestrong.com

2：QOS2

**retained**

ONENET 发布主题数据保留

0：不保留

1：保留

默认值：0

**3.8.7. AT+ALIYUNTP[CH]****查询****/****设置通道****[CH]****的阿里云平台接入类型**

功能 

说明 

示例与备注

测试指令

AT+ALIYUNTP[CH]=? 

+ALIYUNTP[CH]:<type> 

OK 

AT+ALIYUNTP1=?

+ALIYUNTP1:<ONE_MACHINE,ONE_TYPE,AU

TO>

OK

查询指令

AT+ALIYUNTP[CH]或 AT+ALIYUNTP[CH]? 

+ALIYUNTP[CH]:<type> 

OK

AT+ALIYUNTP1

+ALIYUNTP1:ONE_MACHINE

OK

设置指令

AT+ALIYUNTP[CH]=<type> 

OK

AT+ALIYUNTP1=ONE_MACHINE

OK

参数

CH

通道号

1~4：通道号

type

平台接入类型

ONE_MACHINE：一机一密

ONE_TYPE：一型一密

AUTO：自动注册

默认值：ONE_MACHINE

**3.8.8. AT+ALIYUNCN[CH]****查询****/****设置通道****[CH]****的阿里云平台连接参数**

功能 

说明 

示例与备注YunDTU AT 指令手册 

让设计更简单

深圳市飞思创电子科技有限公司 

**54** / **60** 

www.freestrong.com

测试指令

AT+ALIYUNCN[CH]=?

+ALIYUNCN[CH]:<region_id>,<product_key>,

<device_name>[,<device_secret>][,<product_secr

et>][,<accesskey_id>,<accesskey_secret>],<keep

alive>,<clean>

OK 

AT+ALIYUNCN1=?

+ALIYUNCN1:<0~16bytes>,<0~16bytes>,<0~32by

tes>[,<0~32bytes>][,<0~32bytes>][,<0~32bytes>,<0

~48bytes>],<0~65535>,<0,1>

OK

查询指令

一机一密：

AT+ALIYUNCN[CH] 或 AT+ALIYUNCN[CH]?

+ALIYUNCN[CH]:<region_id>,<product_key>,<device_name>,<device_secret>,<keepalive>,<clean>

OK

一型一密：

AT+ALIYUNCN[CH] 或 AT+ALIYUNCN[CH]?

+ALIYUNCN[CH]:<region_id>,<product_key>,<device_name>,<product_secret>,<keepalive>,<clean>

OK

自动注册：

AT+ALIYUNCN[CH] 或 AT+ALIYUNCN[CH]?

+ALIYUNCN[CH]:<region_id>,<product_key>,<device_name>,<accesskey_id>,<accesskey_secret>,<k

eepalive>,<clean>

OK

设置指令

一机一密：

AT+ALIYUNCN[CH]=<region_id>,<product_key>,<device_name>,<device_secret>,<keepalive>,<clean

\>

OK

一型一密：

AT+ALIYUNCN[CH]=<region_id>,<product_key>,<device_name>,<product_secret>,<keepalive>,<clea

n>

OK 

自动注册：

AT+ALIYUNCN[CH]=<region_id>,<product_key>,<device_name>,<accesskey_id>,<accesskey_secret>

,<keepalive>,<clean>YunDTU AT 指令手册 

让设计更简单

深圳市飞思创电子科技有限公司 

**55** / **60** 

www.freestrong.com

OK 

参数

CH

通道号

1~4：通道号

region_id 

范围：0~16 字节

product_key 范围：0~16 字节

device_nam

e

范围：0~32 字节

device_secre

t

范围：0~48 字节

**product_sec**

**ret**

范围：0~32 字节

**accesskey_i**

**d**

范围：0~32 字节

**accesskey_s**

**ecret**

范围：0~32 字节

keepalive 

保持连接时间间隔，范围：0~65535，单位：秒 默认值：180

clean

清零会话标志

0：保存会话

1：清理会话

默认值：1

**3.8.9. AT+ALIYUNMTPC[CH]****查询****/****设置通道****[CH]****的阿里云平台多主题使能**

功能 

说明 

示例与备注

测试指令

AT+ALIYUNMTPC[CH]=?

+ALIYUNMTPC[CH]:<status>

OK

AT+ALIYUNMTPC1=?

+ALIYUNMTPC1:<ON,OFF>

OK

查询指令

AT+ALIYUNMTPC[CH]或

AT+ALIYUNMTPC[CH]？

+ALIYUNMTPC[CH]:<status>

OK

AT+ALIYUNMTPC1

+ALIYUNMTPC1:ON

OK

设置指令

AT+ALIYUNMTPC[CH]=<status>

OK

AT+ALIYUNMTPC1=ON

OKYunDTU AT 指令手册 

让设计更简单

深圳市飞思创电子科技有限公司 

**56** / **60** 

www.freestrong.com

参数

CH

通道号

1~4：通道号

status

阿里云多主题模式

ON：开启

OFF：关闭

默认：OFF

**3.8.10. AT+ALIYUNSUB[CH]****查询****/****设置通道****[CH]****的阿里云平台订阅参数**

功能 

说明 

示例与备注

测试指令

AT+ALIYUNSUB[CH]=?

+ALIYUNSUB[CH]:<topic1>,<qos1>[,<topic2>,

<qos2>][,<topic3>,<qos3>]

OK

AT+ALIYUNSUB1=?

+ALIYUNSUB1:<0~128bytes>,<0~2>[,<0~128byte

s>,<0~2>][,<0~128bytes>,<0~2>]

OK

查询指令

AT+ALIYUNSUB[CH] 或

AT+ALIYUNSUB[CH]?

+ALIYUNSUB[CH]:<topic1>,<qos1>,<topic2>,

<qos2>,<topic3>,<qos3>

OK

AT+ALIYUNSUB1?

+ALIYUNSUB1:/sys/gto7C5Ld3ix/FS800E/thing/ev

ent/property/post,0,,0,,0

OK

设置指令

AT+ALIYUNSUB[CH]=<topic1>,<qos1>[,<topic

2>,<qos2>][,<topic3>,<qos3>]

OK

AT+ALIYUNSUB1=/k05c08xxoUK/test1/user/testfr

eestrong,0

参数

CH

通道号

1~4：通道号

topic 

阿里云订阅主题，范围：1~128 字节

qos

阿里云订阅主题 QOS

0：QOS0

1：QOS1

2：QOS2

默认值：0

**3.8.11. AT+ALIYUNPUB[CH]****查询****/****设置通道****[CH]****的阿里云平台发布参数**

功能 

说明 

示例与备注YunDTU AT 指令手册 

让设计更简单

深圳市飞思创电子科技有限公司 

**57** / **60** 

www.freestrong.com

测试指令

AT+ALIYUNPUB[CH]=?

+ALIYUNPUB[CH]:<topic>,<qos>,<retained>

OK

AT+ALIYUNPUB1=?

+ALIYUNPUB1:<0~128bytes>,<0~2>,<0,1>

OK

查询指令

AT+ALIYUNPUB[CH] 或

AT+ALIYUNPUB[CH]?

+ALIYUNPUB[CH]:<topic>,<qos>,<retained>

OK

AT+ALIYUNPUB1

+ALIYUNPUB1:/sys/gto7C5Ld3ix/FS800E/thing/ev

ent/property/post,0,0

OK

设置指令

AT+ALIYUNPUB[CH]=<topic>,<qos>,<retained

\>

OK

AT+ALIYUNPUB1=/k05c08xxoUK/test1/user/testfr

eestrong,0,0

参数

CH

通道号

1~4：通道号

topic 

阿里云发布主题，范围：1~128 字节

qos

阿里云发布主题 QOS

0：QOS0

1：QOS1

2：QOS2

默认值：0

retained

阿里云发布主题数据保留

0：不保留

1：保留

默认值：0

**3.8.12. AT+ALIYUNIID[CH]****查询****/****设置通道****[CH]****的阿里云实例** **ID**

功能 

说明 

示例与备注

测试指令

AT+ALIYUNIID[CH]=?

+ALIYUNIID[CH]:<instance id>

OK

AT+ALIYUNIID1=?

+ALIYUNIID1:<0~32bytes>

OK

查询指令

AT+ALIYUNIID[CH] 或

AT+ALIYUNIID[CH]?

+ALIYUNIID[CH]:<instance id>

AT+ALIYUNIID1

+ALIYUNIID1:iot-06z00hatiltwupzYunDTU AT 指令手册 

让设计更简单

深圳市飞思创电子科技有限公司 

**58** / **60** 

www.freestrong.com

OK

OK

设置指令

AT+ALIYUNIID[CH]=<instance id>

OK

AT+ALIYUNIID1=iot-06z00hatiltwupz

参数

CH

通道号

1~4：通道号

instance id 

阿里云实例 ID，范围：0-32 字节

**3.9. GPS 指令** 

模块采用国际标准 WGS-84 坐标系，如果用户采用国内常见地图时，需要对模块输出的经纬度进

行纠偏处理，否则可能与实际位置有几十米的误差。

注：仅支持 GPS 定位的模组才支持该指令。GPS 定位时，必须将天线放置在空旷的室外。

**3.9.1. AT+GPSEN** **查询****/****设置** **GPS** **使能**

功能 

说明 

示例与备注

测试指令

AT+GPSEN=?

+GPSEN: <status>

OK

AT+GPSEN=?

+GPSEN:<ON,OFF>

OK

设置指令

AT+GPSEN=<status>

OK

AT+GPSEN=OFF

OK

参数

status

ON：使能

OFF：禁止

默认值：ON

**3.9.2. AT+GPS** **查询** **GPS** **经纬度**

功能 

说明 

示例与备注

查询指令

AT+GPS 或 AT+GPS?

+GPS: < LON>,< LAT>

OK

AT+GPS

+GPS:22.65324,114.00046

OK

参数YunDTU AT 指令手册 

让设计更简单

深圳市飞思创电子科技有限公司 

**59** / **60** 

www.freestrong.com

LAT 

GPS 的经度，dd.dddd 格式 

未定位成功时，输出为空。

LON 

GPS 的纬度，dd.dddd 格式 

未定位成功时，输出为空。YunDTU AT 指令手册 

让设计更简单

深圳市飞思创电子科技有限公司 

**60** / **60** 

www.freestrong.com

**4.** **联系方式**

公司：深圳市飞思创电子科技有限公司

网址：www.freestrong.com

邮箱：support@freestrong.com

电话：0755-86528386

**5.** **免责声明**

本文档提供有关 YunDTU 产品的信息，本文档未授予任何知识产权的许可，并未以明示或暗示，

或以禁止发言或其它方式授予任何知识产权许可。除在其产品的销售条款和条件声明的责任之外，我

公司概不承担任何其它责任。并且，我公司对本产品的销售和使用不作任何明示或暗示的担保，包括

对产品的特定用途适用性，适销性或对任何专利权，版权或其它知识产权的侵权责任等均不作担保。

本公司可能随时对产品规格及产品描述做出修改，恕不另行通知。