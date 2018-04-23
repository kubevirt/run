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
  if kubectl api-versions | grep -q kubevirt.io; then
    die "KubeVirt is already deployed. Exiting."
  fi
  info "Running the demo"
  export VERSION=v0.3.0
  kubectl create \
    -f https://github.com/kubevirt/kubevirt/releases/download/$VERSION/kubevirt.yaml
  echo "KubeVirt is now deployed, please follow the README for the next steps:"
  echo "https://github.com/kubevirt/demo#deploy-a-virtualmachine"
}

title "Preparing to run the KubeVirt minikube demo"
cd /var/tmp/
clone_and_run
