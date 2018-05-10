#!/bin/bash

KUBEVIRT_VER=v0.4.1

die() { echo "FATAL: $@" >&2 ; exit 1 ; }
title() { echo "== $@ ==" ; }
_info() { echo "INFO: $@" ; }
capture() { eval $@ 2>&1 > .capture.log && rm .capture.log || { cat .capture.log ; rm .capture.log ; die "Failed to run: $@" ; } ; }

KUBECTL=$(which oc 2>/dev/null || which kubectl 2>/dev/null)

check_client() {
  if [[ -z "$KUBECTL" ]]; then
    _info "No CLI client tools (kubectl or oc) could be found."
    die "Install kubectl or oc and retry."
  fi
}

clone_and_run() {
  _info "Cloning repository ..."
  if [[ -d "/var/tmp/run-kubevirt-demo" ]]; then
    _info "Reusing existing clone"
    cd run-kubevirt-demo
    capture git pull
  else
    capture "git clone -q https://github.com/kubevirt/demo.git run-kubevirt-demo"
    cd run-kubevirt-demo
  fi
  if $KUBECTL get crds | grep -q kubevirt.io; then
    die "KubeVirt is already deployed. Exiting."
  fi
  _info "Running the demo"
  $KUBECTL apply \
    -f https://github.com/kubevirt/kubevirt/releases/download/$KUBEVIRT_VER/kubevirt.yaml
  echo "KubeVirt is now deployed, please follow the README for the next steps:"
  echo "https://github.com/kubevirt/demo#deploy-a-virtualmachine"
}

title "Preparing to run the KubeVirt minikube demo"
check_client
cd /var/tmp/
clone_and_run
