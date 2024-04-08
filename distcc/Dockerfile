FROM archlinux/archlinux:base-devel
LABEL maintainer="none"
RUN pacman -Syu --needed --noconfirm crosstool-ng distcc
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
