#!/bin/bash

WD=$(mktemp -d --suffix .kubevirt -p /var/tmp)

pushd $WD
git clone https://github.com/kubevirt/demo.git
cd demo
make build
./run-demo.sh
