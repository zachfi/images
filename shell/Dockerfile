FROM archlinux/archlinux:base-devel
LABEL maintainer="none"
RUN pacman -Syu --needed --noconfirm git neovim restic kubectl aarch64-linux-gnu-gcc arm-none-eabi-gcc devtools docker docker-buildx go pacman-contrib
COPY entrypoint.sh /bin/entrypoint.sh
RUN chmod 0755 /bin/entrypoint.sh
RUN paccache -rk0

# makepkg user and workdir
ARG user=makepkg
RUN useradd --system --create-home $user \
  && echo "$user ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/$user
USER $user
WORKDIR /work
ENTRYPOINT [ "/bin/entrypoint.sh" ]
