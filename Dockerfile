FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive \
    DISPLAY=:0 \
    SCREEN_WIDTH=1280 \
    SCREEN_HEIGHT=720 \
    SCREEN_DEPTH=24 \
    VNC_PORT=5900 \
    NOVNC_PORT=6080 \
    VNC_PASSWORD=""

# Install base dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    gnupg2 \
    ca-certificates \
    apt-transport-https \
    xvfb \
    x11vnc \
    openbox \
    supervisor \
    python3 \
    python3-numpy \
    procps \
    libgtk-3-0 \
    libnotify4 \
    libnss3 \
    libxss1 \
    libxtst6 \
    xdg-utils \
    libsecret-1-0 \
    libasound2 \
    libgbm1 \
    libatk-bridge2.0-0 \
    libdrm2 \
    libatspi2.0-0 \
    fonts-noto \
    fonts-noto-color-emoji \
    dbus \
    dbus-x11 \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install noVNC and websockify
RUN git clone --depth 1 https://github.com/novnc/noVNC.git /opt/noVNC \
    && git clone --depth 1 https://github.com/novnc/websockify.git /opt/noVNC/utils/websockify

# Install Signal Desktop from official repo
RUN wget -qO- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > /usr/share/keyrings/signal-desktop-keyring.gpg \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main" \
    > /etc/apt/sources.list.d/signal-xenial.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends signal-desktop \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN useradd -m -s /bin/bash signal \
    && mkdir -p /home/signal/.config/Signal \
    && chown -R signal:signal /home/signal

# Copy configuration files
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY entrypoint.sh /entrypoint.sh
COPY openbox-rc.xml /home/signal/.config/openbox/rc.xml
COPY novnc-index.html /opt/noVNC/index.html

RUN chmod +x /entrypoint.sh \
    && mkdir -p /home/signal/.config/openbox \
    && chown -R signal:signal /home/signal/.config

VOLUME /home/signal/.config/Signal

EXPOSE ${NOVNC_PORT}

ENTRYPOINT ["/entrypoint.sh"]
