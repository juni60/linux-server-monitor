#!/bin/bash

# ==========================================
# Linux Server Monitoring System
# ==========================================

LOG_FILE="/mnt/c/Users/TNC STORE.PK/Documents/linux-server-monitor/logs/monitor.log"

echo "======================================"
echo "       LINUX SERVER MONITOR"
echo "======================================"

echo ""
echo "Date & Time:"
date

echo ""
echo "Hostname:"
hostname

echo ""
echo "Uptime:"
uptime -p

echo ""
echo "Load Average:"
uptime | awk -F'load average:' '{ print $2 }'

# ==========================================
# CPU MONITORING
# ==========================================

CPU_USAGE=$(top -bn1 | awk '/Cpu\(s\)/ {print 100 - $8}')

echo ""
echo "CPU Usage:"
printf "%.2f%%\n" "$CPU_USAGE"

# ==========================================
# MEMORY MONITORING
# ==========================================

MEMORY_USAGE=$(free | awk '/Mem:/ {printf "%.0f", ($3/$2)*100}')

echo ""
echo "Memory Usage:"
free -h

echo ""
echo "Memory Usage Percentage:"
echo "$MEMORY_USAGE%"

# ==========================================
# DISK MONITORING
# ==========================================

DISK_USAGE=$(df / | awk 'NR==2 {gsub("%","",$5); print $5}')

echo ""
echo "Disk Usage:"
df -h /

echo ""
echo "Disk Usage Percentage:"
echo "$DISK_USAGE%"

# ==========================================
# HEALTH CHECK
# ==========================================

echo ""
echo "======================================"
echo "          HEALTH CHECK"
echo "======================================"

if (( $(echo "$CPU_USAGE > 80" | bc -l) )); then
    echo "[WARNING] CPU usage is above 80%"
else
    echo "[OK] CPU usage is normal"
fi

if [ "$MEMORY_USAGE" -gt 80 ]; then
    echo "[WARNING] Memory usage is above 80%"
else
    echo "[OK] Memory usage is normal"
fi

if [ "$DISK_USAGE" -gt 80 ]; then
    echo "[WARNING] Disk usage is above 80%"
else
    echo "[OK] Disk usage is normal"
fi

# ==========================================
# LOGGING
# ==========================================

{
    echo "======================================"
    echo "Linux Server Health Check"
    echo "Date: $(date)"
    echo "Hostname: $(hostname)"
    echo "CPU Usage: $CPU_USAGE%"
    echo "Memory Usage: $MEMORY_USAGE%"
    echo "Disk Usage: $DISK_USAGE%"
    echo "======================================"
} >> "$LOG_FILE"

echo ""
echo "Health information saved to:"
echo "$LOG_FILE"

echo ""
echo "======================================"
echo "       MONITORING COMPLETE"
echo "======================================"
