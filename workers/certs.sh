#!/bin/bash

export PRIVATE_IP=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
export WORKER_HOST=$(curl http://169.254.169.254/latest/meta-data/local-hostname)

{
cat > ${WORKER_HOST}-csr.json << EOF
{
  "CN": "system:node:${WORKER_HOST}",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "SL",
      "L": "Colombo",
      "O": "system:nodes",
      "OU": "TechCrumble",
      "ST": "Western"
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=./ca/ca-config.json \
  -hostname=${WORKER_HOST},${PRIVATE_IP} \
  -profile=kubernetes \
  ${WORKER_HOST}-csr.json | cfssljson -bare ${WORKER_HOST}
}