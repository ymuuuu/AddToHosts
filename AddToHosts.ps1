# AddTo-Hosts.ps1

# Display ASCII Art
Write-Host @"
              _     _ _______    _    _           _       
     /\      | |   | |__   __|  | |  | |         | |      
    /  \   __| | __| |  | | ___ | |__| | ___  ___| |_ ___ 
   / /\ \ / _` |/ _` |  | |/ _ \|  __  |/ _ \/ __| __/ __|
  / ____ \ (_| | (_| |  | | (_) | |  | | (_) \__ \ |_\__ \
 /_/    \_\__,_|\__,_|  |_|\___/|_|  |_|\___/|___/\__|___/
"@ -ForegroundColor Yellow
Write-Host @"
			Gɪᴛʜᴜʙ.ᴄᴏᴍ/ʏᴍᴜᴜᴜᴜ
"@ -ForegroundColor Red


# Check admin privileges
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# Backup function
function Backup-Hosts {
    param(
        [string]$SystemType,
        [string]$SourcePath,
        [string]$BackupPath
    )

    if ($SystemType -eq "Windows") {
        # Check Windows backup
        if (-not (Test-Path $BackupPath -ErrorAction SilentlyContinue)) {
            Copy-Item -Path $SourcePath -Destination $BackupPath -Force
            Write-Host "[*] Created Windows backup: $BackupPath" -ForegroundColor Cyan
        } else {
            Write-Host "[*] Windows backup already exists: $BackupPath" -ForegroundColor Cyan
        }
    }
    else {
        # Check WSL backup
        $checkCmd = "if [ -f '$BackupPath' ]; then exit 0; else exit 1; fi"
        wsl -d kali-linux -u root bash -c $checkCmd
        if ($LASTEXITCODE -eq 1) {
            # Create WSL backup
            $backupCmd = "sudo cp '$SourcePath' '$BackupPath'"
            wsl -d kali-linux -u root bash -c $backupCmd
            Write-Host "[*] Created WSL backup: $BackupPath" -ForegroundColor Cyan
        } else {
            Write-Host "[*] WSL backup already exists: $BackupPath" -ForegroundColor Cyan
        }
    }
}

# Backup Windows hosts
$winHosts = "$env:SystemRoot\System32\drivers\etc\hosts"
$winBackup = "$winHosts.bak"
Backup-Hosts -SystemType "Windows" -SourcePath $winHosts -BackupPath $winBackup

# Backup WSL hosts
$wslHosts = "/etc/hosts"
$wslBackup = "$wslHosts.bak"
Backup-Hosts -SystemType "WSL" -SourcePath $wslHosts -BackupPath $wslBackup

# Get input
$ip = Read-Host "Enter IP (e.g., 10.10.11.55)"
$hostname = Read-Host "Enter hostname (e.g., titanic.htb)"
$entry = "$ip $hostname"

# Windows hosts modification
if (-not (Select-String -Path $winHosts -Pattern "^\s*$ip\s+$hostname" -Quiet)) {
    Add-Content -Path $winHosts -Value "`n$entry" -Force
    Write-Host "`n[+] Windows hosts: Added '$entry'" -ForegroundColor Green
} else {
    Write-Host "`n[!] Windows hosts: Entry already exists" -ForegroundColor Yellow
}

# WSL hosts modification
$wslCmd = "if ! grep -q '$hostname' $wslHosts; then echo '$entry' | sudo tee -a $wslHosts >/dev/null; echo '[+] Added to WSL Kali hosts: $entry'; else echo '[!] Entry already exists in WSL Kali hosts'; fi"
wsl -d kali-linux -u root bash -c $wslCmd

# Keep window open
Write-Host "`nPress any key to exit..."
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
