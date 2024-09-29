FROM archlinux:latest

ENV USER="chrome-user"

USER root

RUN useradd -ms /bin/bash $USER

# for GPU acceleration, replace with the gid which owns the /dev/dri/renderD128 device on host
RUN groupadd gpu_access --gid 107 && usermod -aG gpu_access $USER

# Install sway, xorg-xwayland, wayvnc, and chromium
RUN pacman -Syyu --noconfirm sway xorg-xwayland wayvnc chromium

# Copy sway/wayvnc configs
COPY sway/config /home/$USER/.config/sway/config
COPY wayvnc/config /home/$USER/.config/wayvnc/config
RUN chown -R $USER:$USER /home/$USER/.config

USER $USER

COPY entrypoint.sh /
WORKDIR /home/$USER
ENTRYPOINT ["/entrypoint.sh"]
