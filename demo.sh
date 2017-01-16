#!/bin/bash

. /etc/os-release

die() { echo "FATAL: $@" >&2 ; exit 1 ; }
title() { echo "== $@ ==" ; }
info() { echo "INFO: $@" ; }
ask_continue() { read -p "QUESTION: $@ (y/n): " CONT ; [[ "$CONT" =~ [nN] ]] && die "Aborting on request." ; }
capture() { eval $@ 2>&1 > .capture.log && rm .capture.log || { cat .capture.log ; rm .capture.log ; die "Failed to run: $@" ; } ; }

check_pkcon() {
  [[ -z "$(which pkcon)" ]] && die "Please install pkcon"
}

install_dependencies() {
  info "Checking dependencies"
  if [[ "$ID" == "fedora" ]]; then
    for PKG in qemu-system-x86 libguestfs-tools-c expect; do
      if ! pkcon --filter installed get-details $PKG >&- 2>&-; then
        ask_continue "Continue and install $PKG?"
        info "Installing $PKG"
        capture pkcon install -y $PKG
      fi
      #capture "( pkcon -p get-packages --filter installed | grep ' $PKG' || ( info 'Installing $PKG' ; pkcon install -y $PKG ) )"
    done
  else
    die "Unsupported operating system '$NAME' you are welcoe to provide patches to get it supported."
  fi
}

clone_and_run() {
  info "Cloning repository ..."
  capture "git clone -q https://github.com/kubevirt/demo.git kubevirt-demo"
  cd kubevirt-demo
  info "Building the demo (this can take a while) - Downloads a few hundred MB of data (tail -f $(realpath $PWD/.capture.log))"
  capture make build
  info "All done - Running the demo"
  ./run-demo.sh
}

title "Preparing to run the KubeVirt Demo"
cd /var/tmp/
check_pkcon
install_dependencies
clone_and_run
title "Demo has ended"
