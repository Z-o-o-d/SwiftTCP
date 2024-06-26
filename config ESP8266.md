
config ESP8266

// 正常操作

AT+RST\r\n                     // 重启设备

AT+CWMODE=2\r\n                // 设置设备为接入点模式

AT+CIPAP="192.168.15.1"\r\n    // 设置设备的IP地址

AT+CWMODE=3\r\n                // 设置设备为同时连接模式

AT+CWSAP="HarmonyNextIOT","password",1,3\r\n   // 设置WiFi接入点名称、密码、加密方式

AT+CWJAP="your_wifi_ssid","your_wifi_paasword"\r\n          // 连接到指定WiFi网络

AT+CWJAP?\r\n                  // 查询当前连接的WiFi网络信息

AT+CIFSR\r\n                   // 获取设备的IP地址

AT+CIPMUX=1\r\n                // 启用多路连接模式

AT+CIPSERVER=1,8888\r\n        // 开启TCP服务器，端口号8888

// 正常操作

/// 断开全部连接

AT+CIPSERVER=0\r\n             // 关闭所有TCP服务器

AT+CIPSERVER=1,8888\r\n        // 重新开启TCP服务器，端口号8888

/// 断开全部连接

// 发送数据

AT+CIPSEND=0,19\r\n            // 发送数据给连接编号为0的客户端，数据长度为19

DATA:123,456,789,012           // 实际发送的数据内容

// 发送数据

// 恢复出厂设置

AT+RESTORE\r\n                 // 恢复设备到出厂设置

AT+RST\r\n                     // 重启设备

// 恢复出厂设置
