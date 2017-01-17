[![Build Status](https://travis-ci.org/kubevirt/run.svg?branch=master)](https://travis-ci.org/kubevirt/run)

# KubeVirt Run

This repository is backing <http://run.kubevirt.io>. It provides a few
scripts to ease different deployments of KubeVirt.

## `demo.sh` -- Running a single host demo in QEMU

The following line will build a disk image where Kubernetes and Cockpit
are getting installed. Finally KubeVirt is getting deployed on Kubernetes.

Once the image build is done, QEMU is used to boot into the disk image
presenting the user a ready-to-use KubeVirt environment.

See <https://github.com/kubevirt/demo> for more details.

```
curl run.kubevirt.io/demo.sh | bash

```
