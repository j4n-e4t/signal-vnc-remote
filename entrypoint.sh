#!/bin/bash
set -e

# Configure VNC password if set
if [ -n "$VNC_PASSWORD" ]; then
    mkdir -p /home/signal/.vnc
    x11vnc -storepasswd "$VNC_PASSWORD" /home/signal/.vnc/passwd
    chown -R signal:signal /home/signal/.vnc
    export VNC_AUTH="-rfbauth /home/signal/.vnc/passwd"
else
    export VNC_AUTH=""
fi

# Ensure Signal config directory has correct ownership
chown -R signal:signal /home/signal/.config/Signal

# Start dbus
mkdir -p /run/dbus
dbus-daemon --system --nofork &

exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
