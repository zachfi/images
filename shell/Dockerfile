FROM archlinux/archlinux:base-devel
LABEL maintainer="none"
RUN pacman -Syu --needed --noconfirm git neovim restic kubectl aarch64-linux-gnu-binutils aarch64-linux-gnu-gcc arm-none-eabi-binutils arm-none-eabi-gcc devtools

# makepkg user and workdir
ARG user=makepkg
RUN useradd --system --create-home $user \
  && echo "$user ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/$user
USER $user
WORKDIR /home/$user
