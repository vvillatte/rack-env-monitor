#!/bin/bash
set -e

echo "=== Rack Environment Monitor Setup ==="

#
# 1. Create hardened svc-runner user
#
echo "[1/6] Creating svc-runner user..."
if id "svc-runner" &>/dev/null; then
    echo "User svc-runner already exists."
else
    sudo adduser --system --shell /usr/sbin/nologin --group svc-runner
    echo "User svc-runner created."
fi

#
# 2. Add svc-runner to dialout for serial access
#
echo "[2/6] Adding svc-runner to dialout group..."
sudo usermod -a -G dialout svc-runner
echo "svc-runner added to dialout."

#
# 3. Create secure folder structure
#
echo "[3/6] Creating /srv/rack-env-monitor directory structure..."
sudo mkdir -p /srv/rack-env-monitor/logs

echo "Setting ownership..."
sudo chown -R svc-runner:svc-runner /srv/rack-env-monitor

echo "Setting permissions..."
sudo chmod 700 /srv/rack-env-monitor/logs

echo "Folder structure ready."

#
# 4. Install Python wheel (placeholder)
#
echo "[4/6] Preparing Python deployment directory..."

# You will SCP your Poetry-built wheel to /tmp before running this script.
WHEEL_PATH="/tmp/rack_env_monitor-0.1.0-py3-none-any.whl"

if [ -f "$WHEEL_PATH" ]; then
    echo "Installing Python wheel from $WHEEL_PATH..."
    sudo pip3 install "$WHEEL_PATH"
    echo "Wheel installed."
else
    echo "WARNING: Wheel not found at $WHEEL_PATH"
    echo "Copy your Poetry-built wheel to /tmp before running this script."
fi

#
# 5. Create root-owned entrypoint script
#
echo "[5/6] Creating entrypoint script /usr/local/bin/rack-env-monitor.py..."

sudo bash -c 'cat > /usr/local/bin/rack-env-monitor.py << "EOF"
#!/usr/bin/env python3
from rack_env_monitor.main import main

if __name__ == "__main__":
    main()
EOF'

sudo chown root:root /usr/local/bin/rack-env-monitor.py
sudo chmod 755 /usr/local/bin/rack-env-monitor.py

echo "Entrypoint script installed."

#
# 6. Install systemd service + timer
#
echo "[6/6] Installing systemd service..."

sudo bash -c 'cat > /etc/systemd/system/rack-env-monitor.service << "EOF"
[Unit]
Description=Rack Environment Monitor Service
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/python3 /usr/local/bin/rack-env-monitor.py
User=svc-runner
Group=svc-runner

NoNewPrivileges