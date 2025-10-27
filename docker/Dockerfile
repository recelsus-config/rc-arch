# vim: ft=dockerfile
FROM archlinux:latest

ENV TERM=xterm-256color \
    SHELL=/bin/bash \
    SSH_CONNECTION=1

COPY config /tmp/config

RUN set -eux; \
    pacman -Syu --noconfirm && \
    source /tmp/config && \
    pacman -S --noconfirm --needed sudo git base-devel "${INSTALL_PACKAGES[@]}" && \
    groupadd -g 1000 arch && \
    useradd -m -u 1000 -g arch -s /bin/bash arch && \
    echo "arch ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/arch && \
    git clone https://github.com/${CONFIG_REPO_NVIM}.git /home/arch/.config/nvim && \
    git clone https://github.com/${CONFIG_REPO_TMUX}.git /home/arch/.config/tmux && \
    git clone https://github.com/${CONFIG_REPO_BASH}.git /home/arch/.config/bash && \
    echo 'source ~/.config/bash/bashrc' >> /home/arch/.bashrc && \
    chown -R arch:arch /home/arch/.config /home/arch/.bashrc && \
    rm -f /tmp/config && \
    pacman -Scc --noconfirm && \
    rm -rf /var/cache/pacman/pkg/* /var/lib/pacman/sync/*

USER root
WORKDIR /home/arch

COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/usr/bin/tmux"]
