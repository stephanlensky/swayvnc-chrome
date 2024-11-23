# swayvnc-chrome

swayvnc-chrome uses [Sway](https://swaywm.org) with [wayvnc](https://github.com/any1/wayvnc) to create a headless, GPU-accelerated wayland desktop with a browser payload (Google Chrome), to display one or several web pages.

GPU acceleration has currently only been tested under Linux.

This project is a fork of [swayvnc-firefox](https://github.com/bbusse/swayvnc-firefox), rewritten to minimize external dependencies and improve overall configurability.

## Usage

The latest image is always available at `ghcr.io/stephanlensky/swayvnc-chrome:latest`.

To run using `docker compose`, create a new file named `docker-compose.yml` with the following contents:

```yaml
services:
  swayvnc-chrome:
    image: ghcr.io/stephanlensky/swayvnc-chrome:latest
    container_name: swayvnc-chrome
    environment:
      # replace with GID of the group which owns the /dev/dri/renderD128 device
      - RENDER_GROUP_GID=107
      - SWAY_RESOLUTION=1920x1080
      - WAYVNC_PORT=5910
      - WAYVNC_ENABLE_AUTH=true
      - WAYVNC_USERNAME=wayvnc
      - WAYVNC_PASSWORD=wayvnc
    volumes:
      - swayvnc-wayvnc-certs:/certs
    privileged: true
    ports:
      - 5910:5910
    # optional, pass a custom command as an argument to entrypoint.sh to run it under the wayland session
    entrypoint: [
        "/entrypoint.sh",
        # example for running chrome
        "google-chrome-stable",
        "--enable-features=UseOzonePlatform",
        "--ozone-platform=wayland",
        "--disable-dev-shm-usage",
        "--disable-notifications",
        "--disable-popup-blocking",
        "--no-first-run",
        "--disable-fre",
        "--no-default-browser-check",
      ]

volumes:
  swayvnc-wayvnc-certs:
```

Then start the container with:

```
docker compose up
```

### Authentication

By default, the built-in VNC server has authentication enabled and the username/password both set to `wayvnc`. To disable authentication or change the credentials, edit the environment variables in the `docker-compose.yml` file created above:

```yaml
services:
  swayvnc-chrome:
    ...
    environment:
      - WAYVNC_ENABLE_AUTH=true  # enable/disable auth
      - WAYVNC_USERNAME=wayvnc  # set username here
      - WAYVNC_PASSWORD=wayvnc  # set password here
```

## Connect

Use a vnc client to connect to the server. [RealVNC Viewer](https://www.realvnc.com/en/connect/download/viewer/) is recommended for windows, or:

```
$ wlvncc <vnc-server>
# or
$ vinagre [vnc-server:5910]
```
