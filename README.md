# Linux Server Monitoring & Auto-Healing System

A Linux server monitoring and auto-healing system built with **Bash and systemd**.

The project monitors CPU, memory, disk usage, uptime, and load average. It also monitors the **Nginx** service and automatically restarts it if it goes down.

## Architecture

```text
                systemd Timer
                     |
                     | Every 1 minute
                     v
             linux-monitor.service
                     |
             +-------+-------+
             |               |
             v               v
    system-monitor.sh   service-monitor.sh
             |               |
             v               v
      CPU / RAM / Disk      Nginx
      Uptime / Load           |
             |                |
             +-------+--------+
                     |
                     v
                monitor.log
```

## Features

* CPU usage monitoring
* Memory usage monitoring
* Disk usage monitoring
* Load average monitoring
* System uptime monitoring
* Resource threshold health checks
* Nginx service monitoring
* Automatic Nginx restart
* Auto-healing verification
* Monitoring logs
* systemd service
* systemd timer
* Automatic execution every minute

## Project Structure

```text
linux-server-monitor/
├── config/
│   └── .gitkeep
├── logs/
│   └── monitor.log
├── scripts/
│   ├── system-monitor.sh
│   └── service-monitor.sh
├── systemd/
│   ├── linux-monitor.service
│   └── linux-monitor.timer
├── .gitignore
└── README.md
```

## System Monitoring

The `system-monitor.sh` script collects important Linux server health information:

* CPU usage
* Memory usage
* Disk usage
* System uptime
* Load average

It also performs basic health checks using resource thresholds.

Example:

```text
CPU Usage: 5.6%
Memory Usage: 32%
Disk Usage: 1%

[OK] CPU usage is normal
[OK] Memory usage is normal
[OK] Disk usage is normal
```

### CPU Health Check

If CPU usage goes above 80%, the script reports a warning:

```text
[WARNING] CPU usage is above 80%
```

Otherwise:

```text
[OK] CPU usage is normal
```

### Memory Health Check

If memory usage goes above 80%, the script reports:

```text
[WARNING] Memory usage is above 80%
```

### Disk Health Check

If disk usage goes above 80%, the script reports:

```text
[WARNING] Disk usage is above 80%
```

## Service Monitoring & Auto-Healing

The `service-monitor.sh` script monitors the Nginx service using `systemctl`.

When Nginx is running:

```text
[OK] nginx is running
```

If Nginx is down:

```text
[WARNING] nginx is DOWN
```

The monitoring system then attempts to restart Nginx:

```bash
systemctl restart nginx
```

After restarting, the script verifies the service status.

Successful recovery:

```text
[SUCCESS] nginx restarted successfully
```

If recovery fails:

```text
[CRITICAL] Failed to restart nginx
```

## Automation with systemd

The monitoring process is automated using a **systemd service and systemd timer**.

The timer triggers the monitoring service every minute.

```text
linux-monitor.timer
        |
        | Every 1 minute
        v
linux-monitor.service
        |
        +-----------------------+
        |                       |
        v                       v
system-monitor.sh       service-monitor.sh
        |                       |
        v                       v
CPU/RAM/Disk              Nginx health
monitoring                & auto-healing
```

The timer uses:

```ini
OnBootSec=1min
OnUnitActiveSec=1min
```

The monitoring service uses:

```ini
Type=oneshot
User=root
```

The `oneshot` service runs the monitoring scripts, completes the health check, and exits. The timer triggers it again during the next cycle.

## Installing the systemd Components

Copy the systemd files:

```bash
sudo cp systemd/linux-monitor.service /etc/systemd/system/
sudo cp systemd/linux-monitor.timer /etc/systemd/system/
```

Reload systemd:

```bash
sudo systemctl daemon-reload
```

Enable the timer:

```bash
sudo systemctl enable linux-monitor.timer
```

Start the timer:

```bash
sudo systemctl start linux-monitor.timer
```

Check the timer:

```bash
sudo systemctl status linux-monitor.timer
```

The timer should show:

```text
Active: active (waiting)
```

## Testing Auto-Healing

The auto-healing mechanism was tested by intentionally stopping Nginx:

```bash
sudo systemctl stop nginx
```

Verify that Nginx is down:

```bash
sudo systemctl status nginx --no-pager
```

Expected:

```text
Active: inactive (dead)
```

The systemd timer then triggers the monitoring service.

The monitoring system detects the failure:

```text
[WARNING] nginx is DOWN
```

The system automatically restarts Nginx:

```text
[SUCCESS] nginx restarted successfully
```

The next monitoring cycle confirms:

```text
[OK] nginx is running
```

### Actual Test Result

The auto-healing test successfully produced:

```text
[Tue Oct  6 22:19:44 PKT 2026] [WARNING] nginx is DOWN
[Tue Oct  6 22:19:44 PKT 2026] [SUCCESS] nginx restarted successfully
```

The following monitoring cycle confirmed:

```text
[Tue Oct  6 22:21:05 PKT 2026] [OK] nginx is running
```

This confirms that the monitoring system successfully detected a service failure and automatically recovered the service.

## Logging

Monitoring results and service events are written to:

```text
logs/monitor.log
```

Example:

```text
======================================
Linux Server Health Check
Date: Tue Oct  6 22:19:43 PKT 2026
Hostname: lahaasil
CPU Usage: 7.3%
Memory Usage: 31%
Disk Usage: 1%
======================================

[Tue Oct  6 22:19:44 PKT 2026] [WARNING] nginx is DOWN
[Tue Oct  6 22:19:44 PKT 2026] [SUCCESS] nginx restarted successfully
```

Runtime logs are excluded from Git using `.gitignore`.

## Technologies

* Linux
* Bash
* systemd
* systemd timers
* Nginx
* Shell scripting
* Linux service management
* Linux resource monitoring
* Automated recovery
* Log management

## Key DevOps Concepts Demonstrated

This project demonstrates practical experience with:

* Linux system administration
* Bash scripting
* CPU, memory and disk monitoring
* Linux service management
* `systemctl`
* systemd services
* systemd timers
* Automated service recovery
* Health checks
* Failure simulation
* Log management
* Basic infrastructure automation

## What I Learned

Through this project, I practiced how to:

1. Monitor Linux server resources using Bash.
2. Check and manage Linux services using `systemctl`.
3. Create custom systemd services.
4. Create systemd timers for scheduled automation.
5. Detect service failures automatically.
6. Restart failed services automatically.
7. Verify successful recovery.
8. Store monitoring events in log files.
9. Test failure and recovery scenarios.
10. Build a practical Linux/DevOps automation project.

## Future Improvements

Possible improvements include:

* Configurable CPU, RAM and disk thresholds
* Monitoring multiple Linux services
* Email notifications
* Slack or Microsoft Teams alerts
* Prometheus metrics
* Grafana dashboard
* Docker-based deployment
* Alert history
* Multiple server monitoring
* Remote server monitoring

## Author

**Junaid Ahmed**

DevOps / Cloud Engineer

This project was built as a practical Linux and DevOps automation project to demonstrate server monitoring, service management and automated recovery.
