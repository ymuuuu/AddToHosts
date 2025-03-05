# AddToHosts

A PowerShell script to simplify adding entries to **Windows** and **WSL (Kali Linux)** hosts files, with automatic backups and duplicate checks. Perfect for CTF setups, local development, or network testing.

The idea came when I was trying to play HTB or THM Machines using WSL2, I have my wsl2 in mirror mode so they can capture the same traffic, but since each one has its own hosts file, I needed to update both manually, so I said why not script it ? 

![Demo](https://img.shields.io/badge/Platform-Windows%20%7C%20WSL%20(Kali)-blue) 
![License](https://img.shields.io/badge/License-MIT-green)

## Features ✨
- **Cross-Platform Support**: Updates hosts files for both Windows and WSL (Kali Linux) (See below if you want other distros).
- **Automatic Backups**: Creates `hosts.bak` on first run for easy recovery.
- **Duplicate Prevention**: Skips existing entries to avoid clutter.
- **Admin-Friendly**: Auto-elevates to admin rights when needed.


## Installation 📥
1. **Prerequisites**:
   - Windows 10/11 with PowerShell 5.1+.
   - WSL with Kali Linux installed (default distro name: `kali-linux`).

2. **Clone the Repository**:
   ```powershell
   git clone https://github.com/ymuuuu/AddToHosts.git
   cd AddToHosts
   ```

## Usage 🚀
Run the script as **Administrator**:
```powershell
.\AddTo-Hosts.ps1
```

**Example Workflow**:
```
Enter IP (e.g., 10.10.11.55): 10.10.11.123
Enter hostname (e.g., titanic.htb): ctf-target.htb

[*] Windows backup already exists: C:\Windows\System32\drivers\etc\hosts.bak
[*] WSL backup already exists: /etc/hosts.bak

[+] Windows hosts: Added '10.10.11.123 ctf-target.htb'
[+] Added to WSL Kali hosts: 10.10.11.123 ctf-target.htb

Press any key to exit...
```

## Restore Backups 🔄
### Windows
```powershell
Copy-Item "$env:SystemRoot\System32\drivers\etc\hosts.bak" "$env:SystemRoot\System32\drivers\etc\hosts" -Force
```

### WSL (Kali Linux)
```bash
sudo cp /etc/hosts.bak /etc/hosts
```
## Will It Work with Other WSL Distributions?
Yes! You can easily modify it to work with any WSL distribution (e.g., Ubuntu, Debian). Here’s how:

1. Check Your WSL Distribution Name
Run this in PowerShell to list installed WSL distros:

```powershell
wsl -l -q
```
Example output:
```
Ubuntu
kali-linux
Debian
```
2. Update the Script
Replace kali-linux in the script with your distribution name. For example:

```powershell
# For Ubuntu
wsl -d Ubuntu -u root bash -c ...

# For Debian
wsl -d Debian -u root bash -c ...
```

## Security Note 🔒
- Requires admin rights to modify system files.
- Backups are created **only once** to prevent accidental overwrites.
- Script exits immediately on cancellation.

## License 📄
MIT License - See [LICENSE](LICENSE).

**Happy Hacking!** 🎮🔍  
*Feel free to contribute or report issues!*
