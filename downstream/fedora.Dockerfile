FROM fedora:latest

# Must first enable rpmfusion <https://docs.fedoraproject.org/en-US/quick-docs/setup_rpmfusion/>
RUN dnf -y install \
        https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    && yum -y install ffmpeg \
    && yum clean all

ENTRYPOINT [ "/usr/bin/ffmpeg" ]
