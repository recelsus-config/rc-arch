# vim: ft=dockerfile
FROM archlinux:latest

ARG USERNAME="arch"
ARG USER_UID=1000
ARG USER_GID=1000

ENV TERM=xterm-256color \
    SHELL=/bin/bash \
    SSH_CONNECTION=1 \
    CARGO_HOME=/home/${USERNAME}/.local/share/cargo \
    CONAN_USER_HOME=/home/${USERNAME}/.local/share/conan \
    RUSTUP_HOME=/home/${USERNAME}/.local/share/rustup

COPY config /tmp/config

RUN set -eux; \
    \
    pacman -Syu --noconfirm && \
    source /tmp/config && \
    pacman -S --noconfirm --needed sudo git base-devel rustup "${INSTALL_PACKAGES[@]}" && \
    \
    groupadd -g $USER_GID $USERNAME && \
    useradd -m -u $USER_UID -g $USERNAME -s /bin/bash $USERNAME && \
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME && \
    \
    git clone https://github.com/${CONFIG_REPO_NVIM}.git /home/${USERNAME}/.config/nvim && \
    git clone https://github.com/${CONFIG_REPO_TMUX}.git /home/${USERNAME}/.config/tmux && \
    git clone https://github.com/${CONFIG_REPO_BASH}.git /home/${USERNAME}/.config/bash && \
    \
    echo 'source ~/.config/bash/bashrc' >> /home/${USERNAME}/.bashrc && \
    chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/.config /home/${USERNAME}/.bashrc && \
    \
    git clone https://aur.archlinux.org/paru.git /tmp/paru && \
    chown -R ${USERNAME}:${USERNAME} /tmp/paru && \
    \
    rm -f /tmp/config

USER $USERNAME
WORKDIR /home/$USERNAME

RUN set -eux; \
    rustup default stable && \
    \
    cd /tmp/paru && \
    makepkg -si --noconfirm && \
    rm -rf /tmp/paru && \
    \
    paru -Syu --noconfirm && \
    paru -S conan --noconfirm && \
    paru -Scc --noconfirm && \
    sudo rm -rf /var/cache/pacman/pkg/* /var/lib/pacman/sync/*

CMD ["/usr/bin/tmux"]
