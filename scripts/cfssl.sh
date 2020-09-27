#!/bin/bash

sudo curl -s -L -o /bin/cfssl https://pkg.cfssl.org/R1.2/cfssl_linux-amd64
sudo curl -s -L -o /bin/cfssljson https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64
sudo curl -s -L -o /bin/cfssl-certinfo https://pkg.cfssl.org/R1.2/cfssl-certinfo_linux-amd64
sudo chmod +x /bin/cfssl*

#------- Kube CA  -----
cfssl gencert -initca ./ca/ca-csr.json | cfssljson -bare ca

#------ Kube Admin -----
cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=./ca/ca-config.json \
  -profile=kubernetes \
  ./ca/admin-csr.json | cfssljson -bare admin

#-----  Controller Manager -----
cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=./ca/ca-config.json \
  -profile=kubernetes \
  kube-controller-manager-csr.json | cfssljson -bare kube-controller-manager

#----- Kube Proxy -----
cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  kube-proxy-csr.json | cfssljson -bare kube-proxy

#----- Kube Scheduler ------
cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  kube-scheduler-csr.json | cfssljson -bare kube-scheduler

#----- Service Account  -----
cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  service-account-csr.json | cfssljson -bare service-account