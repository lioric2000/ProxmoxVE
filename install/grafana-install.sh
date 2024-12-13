#!/usr/bin/env bash

# Copyright (c) 2021-2024 tteck
# Author: tteck (tteckster)
# License: MIT
# https://github.com/community-scripts/ProxmoxVE/raw/main/LICENSE

source /dev/stdin <<< "$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing Dependencies"
$STD apt-get install -y curl
$STD apt-get install -y sudo
$STD apt-get install -y mc
$STD apt-get install -y gnupg
$STD apt-get install -y apt-transport-https
$STD apt-get install -y software-properties-common

msg_ok "Installed Dependencies"

# msg_info "Setting up Grafana Repository"
# wget -q -O /usr/share/keyrings/grafana.key https://apt.grafana.com/gpg.key
# sh -c 'echo "deb [signed-by=/usr/share/keyrings/grafana.key] https://apt.grafana.com stable main" > /etc/apt/sources.list.d/grafana.list'
# msg_ok "Set up Grafana Repository"

# Function to prompt for confirmation
myconfirm() {
    local message="$1"
    local max_attempts=3
    local current_attempt=1

    while true; do
        read -p "$message (y=yes, q=quit): " choice
        
        case "$choice" in
            y|Y )
                echo "Continuing with the script..."
                return 0
                ;;
            q|Q )
                echo "Script aborted. Exiting."
                exit 1
                ;;
            * )
                if [ "$current_attempt" -lt "$max_attempts" ]; then
                    echo "Invalid input. Please try again ($current_attempt/$max_attempts)."
                    ((current_attempt++))
                else
                    echo "Too many invalid attempts. Script exiting."
                    exit 1
                fi
                ;;
        esac
    done
}

msg_info "Installing Grafana"
#wget -q -O /tmp/grafana_11.1.3_amd64.deb https://dl.grafana.com/oss/release/grafana_11.1.3_amd64.deb
#$STD dpkg -i /tmp/grafana_11.1.3_amd64.deb

echo "Please perform the following manual steps:"
echo "Step 1: sudo apt-get install -y adduser libfontconfig1 musl"
echo "Step 2: wget https://dl.grafana.com/oss/release/grafana_11.1.3_amd64.deb"
echo "Step 3: sudo dpkg -i grafana_11.1.3_amd64.deb"

confirm "Have you completed all manual steps?"

# Rest of your script logic goes here
echo "Script continues..."

systemctl start grafana-server
systemctl enable --now -q grafana-server.service
msg_ok "Installed Grafana"

motd_ssh
customize

msg_info "Cleaning up"
$STD apt-get -y autoremove
$STD apt-get -y autoclean
msg_ok "Cleaned"
