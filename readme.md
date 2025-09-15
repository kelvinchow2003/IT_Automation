# 🖥️ Pre-Domain Configuration Automation

## 📋 Project Overview
This project automates the **pre-domain setup** process for new desktops and laptops. It streamlines essential configuration tasks to prepare devices for domain joining and deployment.

## ⚙️ Features & Tasks Performed

1. **Disable Auto-Lock** – Prevents the system from locking automatically.
2. **Enable Local Administrator Account**  
   - Prompts for username and password.
3. **Auto-Connect to Wi-Fi** – Joins a predefined wireless network.
4. **Time Sync & Time Zone Configuration**  
   - Syncs system time and sets it to Eastern Time.
5. **Disable All Firewalls** – Turns off Windows Defender Firewall across all profiles.
6. **Run Windows Updates** – Installs all available updates and handles reboots.
7. **Run Lenovo Vantage Updates**  
   - Skips if not a Lenovo device.  
   - Continues even if update fails.
8. **Install Symantec Antivirus**
9. **Rename Computer** – Prompts for new device name.
10. **Remove Temporary Remote User**
11. **Copy Applications to Target Directory**

## 🖥️ System Requirements
- Device needs to be connected to power
- Requires: Set-ExecutionPolicy RemoteSigned
- **Operating System**: Windows 11
- **Device Type**:
  - 💻 **Laptop**: Run `LaptopSetup.ps1`
  - 🖥️ **Desktop**: Run `DesktopSetup.ps1`


