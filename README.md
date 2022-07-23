# Ninja [![version-shield]][ninja-release] [![cross-platform-shield]](#platforms)

> A general-purpose fully customizable software to control a remote computer behind any NAT, Firewall and proxy. Providing secure shell access, file transfer and shell stream (stream shell output from remote to a local file). Ninja has no prerequisites, you can just [download the release][ninja-release] and use it right away!

**Please note that Ninja is the host and executor of commands; So it will be running on target (remote) computer. You would need [Jonin][jonin] on controller (commander) computer to connect to your Ninjas and command them**

![logo]

# [Download][ninja-release]

You can download latest release from [here][ninja-release]

# Features

- Secure shell access to remote ([Ninja][ninja]) computer
- File upload/download (Multiple files at once) to/from remote ([Ninja][ninja])
- Shell stream, run command on remote ([Ninja][ninja]) and stream output to a file on local ([Jonin][jonin])

# Demo

![ninja](https://user-images.githubusercontent.com/46329768/179629380-9e3e8f87-469c-4e2b-a4ec-0c6027ed7da8.gif)

https://user-images.githubusercontent.com/46329768/179628114-5f6d4307-4bd8-419f-8c85-873e790e440f.mp4

# Platforms

| ![windows]   | ![macos]            | ![linux]           |
| ------------ | ------------------- | ------------------ |
| Windows 10 ✔ | macOS 12 Monterey ✔ | Parrot OS 4.11.2 ✔ |

# Overview

Ninja is a portable remote computer control software. Once it's ran on a remote computer, it will provide you shell access, file transfer (upload/download) and shell stream.
There's no need to open ports on the remote computer, even if it uses a cellular data network and is behind proxies, there will be no problem in connection since Ninja wont listen on a port for conenctions and instead will ask the controller or the **[Jonin][jonin]** computer for connection (WebSocket if available, otherwise xhr polling). So the controller computer should be running **[Jonin][jonin]** and have the required port open.

- [Download](#download)
- [Features](#features)
- [Platforms](#platforms)
- [Overview](#overview)
- [Jonin](#jonin)
- [Setup](#setup)
  - [Getting `No Ninjas`](#getting-no-ninjas)
- [Single Click Installer](#single-click-installer)
- [Configuration File](#configuration-file)
- [Host Setup](#host-setup)
  - [Dynamic DNS](#dynamic-dns)
  - [VPS](#vps)
  - [Static IP Address](#static-ip-address)
  - [Domain Name](#domain-name)
- [Use As Spyware](#use-as-spyware)

# [Jonin][jonin]

Jonin is the pair for Ninja which can control (order!) multiple **Ninja** instances. You'll need to use it on the controller computer in order to communicate with a Ninja

# Setup

Follow these steps to setup Jonin and Ninja:

- Download **[Jonin Release][jonin-release]** and **[Ninja Release][ninja-release]**
- Change **PORT** in `config/constants.json` for both Ninja and Jonin, the ports should be the same. Please read [This Guide](#host-setup) about how to setup **HOST** to never lose access to Ninja
- Forward configured port on **Jonin**'s router. There are lots of guides out there for port forwarding. [This one][noio-port-forwarding] from noip is a nice one
- Done! Now run **[Ninja][ninja]** on the target/remote computer, run Jonin on controller/local computer and wait for some report from your **[Ninja][ninja]** !

**For usage guide and list of commands, [check here][jonin-usage]**

**Note: `NO_LOG` in config file SHOULD be set to `true` when you want to use Ninja as a service, otherwise, the log file might grow larger forever (up to the limit)**

### Getting `No Ninjas`

If you did all above and got `No Ninjas`, then the chances are your ISP is putting you behind a NAT. To check this, you can find your router's WAN IP address (can be found on router's homepage) and then compare it to the actual IP address that you have on the internet (can be found by searching `my ip` on google); If these IP addresses were NOT identical, then your router is behind a NAT. To fix this, you should ask your ISP to change your NAT type to `OPEN`

# Single Click Installer

You can use this single click installer (which uses [Servicifier][servicifier]) on windows:

[windows single click installer][windows-single-click-installer]

**Please note that you should still change HOST and PORT in [Ninja config file](#configuration-file) as explained in [Setup & Usage](#setup--usage) (for this installer, it will be in `files/config/constants.json`), before you use the installer. Also note that this installer, will install Ninja in `C:/Ninja` and name the service `ninja.exe`. To customize this, you can change installation config file in `config/installation-config.json` (check [here][servicifier-install-config] for installation config format). Also to make installer ask for installation config values when you run it, instead of automatically using config file, you can simply remove installation config file**

# Configuration File

You can find this file in `config/constants.json`:

```jsonc
{
  // connection port
  "PORTS": {
    "DATA": 3707
  },

  // name to identify Ninja on Jonin when working with multiple Ninjas
  "NAME": "Ninja's Name",

  // Jonin computer's address
  "HOST": "domain.com",

  // connection config. any valid Socket.io option
  "CONNECTION": {
    "RECONNECTION_DELAY_MAX": 5000,
    "RECONNECTION_DELAY": 1000,
    "TIMEOUT": 20000,

    "rejectUnauthorized": false
  },

  // interval in which file receiver party will send ack to sender
  "FILE_TRANSFER": {
    "ACK_INTERVAL": 2000
  },

  // stop logging, this SHOULD be set to true when you want to use Ninja
  // as a service; otherwise, the log file might grow larger forever
  // (or up to the limit)
  "NO_LOG": false,

  "PROGRESS_BAR": {
    // progress bar colors
    "COLOR_MAP": {
      "FAILED": ["red", "red"],
      "INVALID": ["red", "red"],
      "DONE": ["gray", "green"],
      "IN_PROGRESS": ["gray", "cyan"]
    },
    // progress bar name/label maximum length
    "MAX_NAME_LENGTH": 10
  }
}
```

# Host Setup

When configuring **[Ninja][ninja]**, you should use a **HOST** that points to **[Jonin][jonin]** computer and also will always be available. So you'll have to use one of the following options:

### Dynamic DNS

This is the best way I can suggest since It's free and easy. you just need to create an account in one of DDNS services (like [Duck DNS][duckdns] and [No-Ip][noip]), create a domain name and set it to point to your dynamic IP address. If your ISP changed your IP, then just simply change it on DDNS website or install a Dynamic Update Client (DUC) to do this for you automatically.

### VPS

You can purchase a VPS and use its IP or hostname as **HOST** in config file. However you'll always have to control your Ninjas from this VPS. Another downside is that this is paid.

### Static IP Address

You can use an IP address for your Jonin and set this IP in **[Ninja][ninja]**'s configuration. This is not recommended since you'll have to spend money while there are easy free ways, unless you have a static IP already

### Domain Name

Just like static IP, you can use a domain name for your Jonin and set this name in **[Ninja][ninja]**'s configuration. For same reason as static IP, this also is not a recommended way

# Use As Spyware

Please note that Ninja can be easily used as a spyware, especially when installed as a service, it will open full access to the target computer for the **[Jonin][jonin]** controlling it. So use it carefully and don't leave the **Ninja** process running on a computer that is connected to the internet

# Source Code

Source code will be open soon, after some refactoring and improvements

[version-shield]: https://img.shields.io/badge/Version-1.2.1-blue?style=flat-square
[cross-platform-shield]: https://img.shields.io/badge/Cross-Platform-brightgreen?style=flat-square
[logo]: https://user-images.githubusercontent.com/46329768/120117984-597c1200-c1a5-11eb-8190-2dac8b7cbe8d.jpg
[ninja]: https://github.com/ErAz7/Ninja
[jonin]: https://github.com/ErAz7/Jonin
[servicifier]: https://github.com/ErAz7/servicifier
[servicifier-install-config]: https://github.com/ErAz7/servicifier#installation-config
[ninja-release]: https://github.com/ErAz7/Ninja/releases
[jonin-release]: https://github.com/ErAz7/Jonin/releases
[host-setup]: #host-setup
[jonin-usage]: https://github.com/ErAz7/Jonin#usage
[noip]: https://www.noip.com
[duckdns]: https://www.duckdns.org
[windows]: https://user-images.githubusercontent.com/46329768/141021000-3fe223be-f648-4aaf-8a2a-3a5d84f95d50.png
[macos]: https://user-images.githubusercontent.com/46329768/141021007-c2075401-e0e0-4451-8668-77da557bbe9b.png
[linux]: https://user-images.githubusercontent.com/46329768/142761409-badaec5e-7f02-4280-9dfb-294adc305f56.png
[windows-single-click-installer]: https://github.com/ErAz7/Ninja/raw/8be84ead24f5a25248a36f6e704f5acd5d0c5052/Ninja-v1.2.1-win-single-click-installer.zip
