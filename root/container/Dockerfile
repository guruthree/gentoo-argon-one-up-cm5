FROM docker.io/gentoo/stage3:nomultilib-systemd

# setup make.conf
RUN echo PORTAGE_RO_DISTDIRS=\"/mnt/distfiles\" >> /etc/portage/make.conf
RUN echo FEATURES=\"getbinpkg binpkg-request-signature -ipc-sandbox -network-sandbox -pid-sandbox\" >> /etc/portage/make.conf
RUN eselect profile set default/linux/arm64/23.0/desktop/systemd

# install packages
RUN getuto  # binpkg keys
RUN emerge dev-vcs/git app-portage/gentoolkit app-shells/bash-completion 
RUN emerge -1 --nodeps media-libs/tiff  # prevents circular dependencies
RUN USE="-X -sound -wayland" emerge app-editors/vim
RUN USE="-X" ACCEPT_KEYWORDS="*" emerge app-portage/cfg-update
RUN sed -i 's/^MERGE_TOOL.*/MERGE_TOOL = \/usr\/bin\/sdiff/' /etc/cfg-update.conf

# setup ssh stuff
RUN mkdir -p /root/.ssh
RUN cat /mnt/ssh/id_*.pub >> /root/.ssh/authorized_keys  # copy public key
RUN /usr/bin/ssh-keygen -A

# clean up package stuff
RUN eclean-dist
RUN eclean-pkg

# setup git
RUN git clone https://github.com/guruthree/gentoo-argon-one-up-cm5.git /repo
RUN mv /repo/.git* / && rm -rf /repo
RUN git ls-files --stage | grep \^120000 | awk '{ print $4 }'| xargs git checkout  # restore symlinks
RUN git status | grep deleted\: | awk '{ print $2 }' | xargs git checkout  # restore deleted files
RUN git status | grep modified\: | awk '{ print $2 }' | xargs -I {} sh -c 'git show HEAD:{} > $(dirname {})/._cfg0000_$(basename {})'  # move changed files to ._cfg*

# merge trivial config changes
RUN etc-update / <<< -1
RUN CONFIG_PROTECT='/.' cfg-update -ua
# reminder to fix remaining config files
RUN echo "find / -mount -name '._cfg*' | egrep -q '.*'" >> /etc/bash/bashrc.d/99-cfgs.sh
RUN echo "if [ $? -eq 0 ]; then echo 'Run CONFIG_PROTECT=/. cfg-update -u to update config files!'; fi" >> /etc/bash/bashrc.d/99-cfgs.sh
# && or || ?

CMD ["/usr/sbin/sshd", "-D", "-e"]
