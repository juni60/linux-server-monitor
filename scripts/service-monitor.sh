#!/bin/bash

# ==========================================
# Linux Service Monitor & Auto-Healing
# ==========================================

LOG_FILE="/mnt/c/Users/TNC STORE.PK/Documents/linux-server-monitor/logs/monitor.log"
SERVICE="nginx"

echo "======================================"
echo "       SERVICE MONITOR"
echo "======================================"

echo ""
echo "Checking service: $SERVICE"

# Check whether service is running
if systemctl is-active --quiet "$SERVICE"; then

    echo "[OK] $SERVICE is running"

    {
        echo "[$(date)] [OK] $SERVICE is running"
    } >> "$LOG_FILE"

else

    echo "[WARNING] $SERVICE is DOWN"

    {
        echo "[$(date)] [WARNING] $SERVICE is DOWN"
    } >> "$LOG_FILE"

    echo "[ACTION] Attempting to restart $SERVICE"

    # Restart service
     systemctl restart "$SERVICE"

    # Verify restart
    if systemctl is-active --quiet "$SERVICE"; then

        echo "[SUCCESS] $SERVICE restarted successfully"

        {
            echo "[$(date)] [SUCCESS] $SERVICE restarted successfully"
        } >> "$LOG_FILE"

    else

        echo "[CRITICAL] Failed to restart $SERVICE"

        {
            echo "[$(date)] [CRITICAL] Failed to restart $SERVICE"
        } >> "$LOG_FILE"

    fi

fi

echo ""
echo "======================================"
echo "       SERVICE CHECK COMPLETE"
echo "======================================"
