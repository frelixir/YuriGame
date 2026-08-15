# YuriGame-iOS视觉小说模拟器

## 项目介绍
**YuriGame 模拟器**是一款iOS平台上的轻量级GalGame模拟器，玩家可以通过模拟器在上面畅玩 galgame。

App 内置了三款游戏引擎，包含以下引擎支持：
*   **ONScripter**
*   **KiriKiri**
*   **Artemis**

 **注意**：当前版本尚在测试中，急需相关测试人员以及开发者加入。

##  系统要求与构建
*   **支持架构**：该版本针对 `Arm64-Arm64e`
*   **系统版本**：最低支持 `iOS 14.0` 运行
*   **构建工具**：您可以使用 [Theos](https://theos.dev/docs/) 编译此项目

## 它是如何运行的？：
*   修补iOS应用程序的可执行文件使其作为动态库运行。
*   修补__PAGEZERO
*   vmaddr-0xFFFFC000 (0x100000000 - 0x4000)
*   vmsize-0x4000
*   MH_EXECUTE-MH_DYLIB
*   设置沙箱环境变量、创建缓存目录、修改进程路径、dlopen动态加载子应用二进制、修改dyld映像路径、交换NSBundle.mainBundle方法、修改进程参数和名称、调用子应用的main函数、调用主应用URL调用成功退出。

##  项目结构：
```text
YuriGame/
├── APP_Patch/                # 游戏引擎内核的补丁源码
├── control
├── entitlements.xml          # 权限配置文件
├── main.m                    # 主程序源代码
├── Makefile                  # 编译配置文件
├── Resources/                # 资源文件夹
├── Resources/Frameworks/     # 已编译的内核补丁
├── Resources/PlugIns/        # 已修补的游戏引擎内核
└── YuriGameUI/               # UI界面源码
```

注意：操作界面以及启动游戏的逻辑只需修改YuriGameUI即可。
注意：YuriGameUI编译为YuriGameUI.dylib放置在Frameworks中
##  测试说明
**设备测试情况**：

| 系统版本 | 设备型号 | 安装方式 | 测试结果 |
| :--- | :--- | :--- | :--- |
| 14.3 | iPhone 8 | 巨魔 | ✅ 正常 |
| 14.5 | iPhone 12 | 巨魔 | ✅ 正常 |
| 17.4.1 | iPad mini 5 | 自签 | ✅ 正常 |
| 18.5 | iPad mini 7 | 自签 | ✅ 正常 |
|  | iPhone 15 | 自签 | ✅ 正常 |
| 26 | 全系列设备 | 自签 | ✅ 正常 |

##  致谢 / Credits
特别感谢此项目：
https://github.com/LiveContainer/LiveContainer

##  联系方式
本项目仅为代托管。如果您对该项目感兴趣，可以联系项目作者：

*   **QQ**：`3142499905`
