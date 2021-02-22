<p align=center>
Offensive Wifi Toolkit (owt) created by Brennan Mccown (clu3bot)

<img src=img/img6.png align=center alt=banner />

</p>
<p align="center">
    <a href="">
      <img src="https://img.shields.io/maintenance/yes/2021" />
    </a>
    <a href="">
      <img src="https://img.shields.io/github/issues/clu3bot/owt" />
    </a>
    <a href="">
      <img src="https://img.shields.io/github/license/clu3bot/owt" />
    </a>
    <a href="">
      <img src="https://img.shields.io/github/stars/clu3bot/owt" />
    </a>
    <a href="">
      <img src="https://img.shields.io/github/forks/clu3bot/owt" />
    </a>  
    <a href="">
      <img src="https://img.shields.io/github/repo-size/clu3bot/owt" />
    </a>
<p align="center">  
This tool compiles 4 different attack modes for basic Wireless Network hacking combined with a U.I. for easy use.
</p>
    
   <p align="center">
    <a href="">
    <img src="https://img.shields.io/badge/OWT-version%201.10-orange?style=for-the-badge&logo=appveyor?logo=data:none" />
    </a>
   </p> 
   
   
   
   
   
   
# Installation & Running the script
```
~ $ git clone https://github.com/clu3bot/OWT.git
~ $ cd owt
~ $ sudo bash owt.sh
```
**Note: OWT requires root privileges**

# Useage
> When the script is run the first thing the user will see is the Intro page. It will prompt the user to press Enter which will then automatically check for dependant packages. 

![img1](img/img1.png)

> Then the script will check if the user is in Monitor or Managed mode and then prompt the user to put device in Monitor mode if need be.

![img2](img/img2.png)

> Next the script will print the Main Menu page where the user can select from 6 options.

![img3](img/img3.png)

> From the Main Menu page the user can then scan for a Network to attack (This is required for WIDS/WIPS confusion & AP Probe attack. If you don't scan networks before using either of those attacks the script will prompt you to do so when trying to use them.)

![img4](img/img4.png)

> Option 5 on the Main Menu is Wifi Attacks. Selecting this will bring the user to the Wifi attacks menu.

![img5](img/img5.png)

# Dependencies 
* aircrack-ng 
* mdk3
* ***OWT tool will prompt the user to download these dependencies if they arent installed.***

# In The Works
owt currently has complications when it comes to using USB WiFi adapters. This will be fixed in owt v. 1.2.0.
v 1.2.0 will also include numerous U.I. changes, further making the utility more user friendly. 


# History
**owt version history can be found here**
* [Versions](https://github.com/clu3bot/owt/wiki/Versions)

# Notice

This script is intended to be used on networks you own. Don't use this script maliciously. You are responsible for your own actions.

