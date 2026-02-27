# Signal Desktop VNC Remote

Run Signal Desktop in a Docker container and access it from any browser via noVNC.

## Quick Start

### Using the pre-built image

```bash
docker run -d \
  --name signal-desktop \
  --shm-size=1g \
  -p 6080:6080 \
  -v signal-data:/home/signal/.config/Signal \
  ghcr.io/j4n-e4t/signal-vnc-remote:latest
```

Open `http://localhost:6080` in your browser.

### Using Docker Compose

```bash
docker compose up -d
```

## Configuration

| Variable | Default | Description |
|---|---|---|
| `VNC_PASSWORD` | *(empty)* | Password for VNC access. Leave empty for no authentication. |
| `SCREEN_WIDTH` | `1280` | Virtual screen width in pixels |
| `SCREEN_HEIGHT` | `720` | Virtual screen height in pixels |
| `SCREEN_DEPTH` | `24` | Color depth |
| `NOVNC_PORT` | `6080` | noVNC web port |

### Setting a VNC password

```bash
docker run -d \
  --name signal-desktop \
  --shm-size=1g \
  -p 6080:6080 \
  -e VNC_PASSWORD=mysecretpassword \
  -v signal-data:/home/signal/.config/Signal \
  ghcr.io/j4n-e4t/signal-vnc-remote:latest
```

## Linking Signal

1. Start the container and open `http://localhost:6080` in your browser
2. Signal Desktop will show a QR code
3. On your phone: **Signal Settings > Linked Devices > Link New Device**
4. Scan the QR code displayed in the browser

## Persistence

Signal data is stored in the `/home/signal/.config/Signal` volume. Mount a named volume or host path to persist your linked device across container restarts.

## Building Locally

```bash
docker build -t signal-vnc-remote .
```

## Security Notes

- Set `VNC_PASSWORD` when exposing beyond localhost
- Consider placing behind a reverse proxy with TLS for remote access
- The container runs Signal with `--no-sandbox` (required inside Docker)
