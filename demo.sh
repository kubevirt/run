#!/bin/bash

die() { echo "FATAL: $@" >&2 ; exit 1 ; }
title() { echo "== $@ ==" ; }
info() { echo "INFO: $@" ; }
capture() { eval $@ 2>&1 > .capture.log && rm .capture.log || { cat .capture.log ; rm .capture.log ; die "Failed to run: $@" ; } ; }

clone_and_run() {
  info "Cloning repository ..."
  if [[ -d "/var/tmp/run-kubevirt-demo" ]]; then
    info "Reusing existing clone"
    cd run-kubevirt-demo
    capture git pull
  else
    capture "git clone -q https://github.com/kubevirt/demo.git run-kubevirt-demo"
    cd run-kubevirt-demo
  fi
  info "Running the demo"
  ./run-demo.sh
}

title "Preparing to run the KubeVirt Demo"
cd /var/tmp/
clone_and_run
