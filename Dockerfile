FROM archlinux:latest

RUN pacman -Syyuu --noconfirm && pacman -S openssh git pkgconf autoconf binutils libtool gzip grep fakeroot make wget sudo gcc --noconfirm

RUN useradd --no-create-home --shell=/bin/false build && usermod -L build

RUN mkdir /home/build 
RUN chgrp build /home/build
RUN chmod g+ws /home/build
RUN setfacl -m u::rwx,g::rwx /home/build
RUN setfacl -d --set u::rwx,g::rwx,o::- /home/build
WORKDIR /home/build
RUN echo "build ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN echo "root ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin && sudo -u build makepkg -si --noconfirm
RUN git clone https://github.com/BlackCatDevel0per/my-aur-packages-source && cd my-aur-packages-source/python3816 && sudo -u build makepkg -si --noconfirm
# RUN sudo -u build yay -S python3816 --noconfirm

RUN sudo -u build yay -S ffmpeg-gpl-bin --noconfirm
# RUN sudo -u build yay -S megatools --noconfirm
RUN sudo -u build yay -S megatools-bin --noconfirm
RUN wget https://bootstrap.pypa.io/get-pip.py && python3.8 get-pip.py
RUN rm -Rf get-pip.py yay-bin

WORKDIR /home/app
# RUN git clone https://github.com/Itz-fork/Mega.nz-Bot.git /app
COPY ./ /home/app/
RUN python3.8 -m pip install -r requirements.txt
CMD [ "bash", "startup.sh" ]
