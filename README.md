[![Build Status](https://travis-ci.org/kubevirt/run.svg?branch=master)](https://travis-ci.org/kubevirt/run)

# KubeVirt Run

This repository is backing <http://run.kubevirt.io>. It provides a few
scripts to ease different deployments of KubeVirt.

## `demo.sh` -- Running a single host demo in minikube

This will clone the KubeVirt Demo and launch it on your local minikube setup.

See <https://github.com/kubevirt/demo> for more details.

```
curl run.kubevirt.io/demo.sh | bash

```

## Releases -- Deploying a specific release

Calling

```
kuectl apply -f run.kubevirt.io/v/0.2.0.yaml
```

will deploy a given release to your existing cluster.

**Please file bugs.**
