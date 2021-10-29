FROM rockylinux/rockylinux:8
LABEL maintainer="lotusnoir"

ENV container docker
ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive

WORKDIR /lib/systemd/system/sysinit.target.wants/
RUN (for i in *; do [ "${i}" == systemd-tmpfiles-setup.service ] || rm -f "${i}"; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*;\
    rm -f /etc/systemd/system/*.wants/*;\
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*;\
    rm -f /lib/systemd/system/anaconda.target.wants/*; \
    yum -y install rpm dnf-plugins-core \
    && yum -y update \
    && yum -y config-manager --set-enabled powertools \
    && yum -y install epel-release initscripts sudo which hostname python3 \
    && yum clean all && rm -rf /tmp/* /var/tmp/* /usr/share/doc /usr/share/man

VOLUME [ "/sys/fs/cgroup" ]
ENTRYPOINT ["/lib/systemd/systemd"]
