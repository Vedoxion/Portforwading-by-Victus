#!/bin/bash
# VictusCloud Ultimate User Manager v2.0

# Colors
RED="\e[31m"; GREEN="\e[32m"; BLUE="\e[34m"; YELLOW="\e[33m"; RESET="\e[0m"

# Check if script is run as root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}[!] Please run as root (sudo).${RESET}"
    exit 1
fi

# Log file
LOGFILE="/var/log/victus_usermgr.log"
touch $LOGFILE

# Function to generate random password
gen_pass() {
    < /dev/urandom tr -dc A-Za-z0-9 | head -c 12; echo
}

while true; do
    clear
    echo -e "${BLUE}"
    echo "====================================="
    echo "      VictusCloud User Manager MAX"
    echo "====================================="
    echo -e "${RESET}"
    echo -e "${YELLOW}1) Create New User (auto/generate password)${RESET}"
    echo -e "${YELLOW}2) Delete User${RESET}"
    echo -e "${YELLOW}3) List Users${RESET}"
    echo -e "${YELLOW}4) Change Password${RESET}"
    echo -e "${YELLOW}5) Lock User${RESET}"
    echo -e "${YELLOW}6) Unlock User${RESET}"
    echo -e "${YELLOW}7) Toggle Sudo Privileges${RESET}"
    echo -e "${YELLOW}8) Export Users to CSV${RESET}"
    echo -e "${YELLOW}9) Exit${RESET}"
    echo "====================================="
    read -p "Choose an option: " choice

    case $choice in
        1)
            read -p "Enter username: " username
            read -p "Generate random password? (y/n): " gen
            if [[ $gen =~ ^[Yy]$ ]]; then
                pass=$(gen_pass)
            else
                read -sp "Enter password: " pass
                echo
            fi
            adduser --quiet --disabled-password --gecos "" $username
            echo "$username:$pass" | chpasswd
            echo -e "${GREEN}[+] User $username created with password: $pass${RESET}"
            echo "$(date) - Created user $username" >> $LOGFILE
            ;;
        2)
            read -p "Enter username to delete: " username
            read -p "Are you sure? This will delete all files too! (y/n): " confirm
            if [[ $confirm =~ ^[Yy]$ ]]; then
                deluser --remove-home $username
                echo -e "${RED}[-] User $username deleted${RESET}"
                echo "$(date) - Deleted user $username" >> $LOGFILE
            fi
            ;;
        3)
            echo -e "${GREEN}System Users:${RESET}"
            cut -d: -f1 /etc/passwd
            ;;
        4)
            read -p "Enter username: " username
            passwd $username
            echo "$(date) - Changed password for $username" >> $LOGFILE
            ;;
        5)
            read -p "Enter username to lock: " username
            usermod -L $username
            echo -e "${RED}[!] $username locked${RESET}"
            echo "$(date) - Locked $username" >> $LOGFILE
            ;;
        6)
            read -p "Enter username to unlock: " username
            usermod -U $username
            echo -e "${GREEN}[+] $username unlocked${RESET}"
            echo "$(date) - Unlocked $username" >> $LOGFILE
            ;;
        7)
            read -p "Enter username: " username
            if groups $username | grep &>/dev/null "\bSUDO\b"; then
                deluser $username sudo
                echo -e "${RED}[-] $username removed from sudo${RESET}"
                echo "$(date) - Removed sudo from $username" >> $LOGFILE
            else
                usermod -aG sudo $username
                echo -e "${GREEN}[+] $username added to sudo${RESET}"
                echo "$(date) - Added sudo to $username" >> $LOGFILE
            fi
            ;;
        8)
            out="users_$(date +%F).csv"
            cut -d: -f1 /etc/passwd > $out
            echo -e "${GREEN}[+] Users exported to $out${RESET}"
            echo "$(date) - Exported users to $out" >> $LOGFILE
            ;;
        9)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo -e "${RED}[!] Invalid option${RESET}"
            ;;
    esac
    read -p "Press Enter to continue..."
done
