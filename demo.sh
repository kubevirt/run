#!/bin/bash

. /etc/os-release

die() { echo "FATAL: $@" >&2 ; exit 1 ; }
title() { echo "== $@ ==" ; }
info() { echo "INFO: $@" ; }
capture() { eval $@ 2>&1 > .capture.log && rm .capture.log || { cat .capture.log ; rm .capture.log ; die "Failed to run: $@" ; } ; }

install_dependencies() {
  info "Checking dependencies"
  if [[ "$ID" == "fedora" ]]; then
    for PKG in qemu-system-x86 libguestfs-tools-c make git; do
      if ! dnf list installed $PKG >&- 2>&-; then
        die "Please install '$PKG'"
      fi
    done
  elif [[ "$ID" == "ubuntu" ]]; then
    info "Please ensure to setup libguestfs correctly: http://libguestfs.org/guestfs-faq.1.html#downloading-installing-compiling-libguestfs"
    info "Eventually you need to run this script using sudo"
    for PKG in qemu-system-x86 libguestfs-tools make git; do
      if ! dpkg -s $PKG >/dev/null ; then
        die "Please install '$PKG'"
      fi
    done
  else
    die "Unsupported operating system '$ID'. We will be happy to merge patches to support your OS as well."
  fi
}

clone_and_run() {
  info "Cloning repository ..."
  if [[ -d "/var/tmp/kubevirt-demo" ]]; then
    info "Reusing existing clone"
    cd kubevirt-demo
    capture git pull
  else
    capture "git clone -q https://github.com/kubevirt/demo.git kubevirt-demo"
    cd kubevirt-demo
  fi
  info "Building the demo (this can take a while) - Downloads a few hundred MB of data (tail -f $(realpath $PWD/.capture.log))"
  capture make clean build
  info "All done - Running the demo"
  ./run-demo.sh
}

title "Preparing to run the KubeVirt Demo"
cd /var/tmp/
install_dependencies
clone_and_run
title "Demo has ended"
