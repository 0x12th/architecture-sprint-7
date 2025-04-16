#!/bin/bash

mkdir -p certs
cd certs

openssl genrsa -out alice.key 2048
openssl req -new -key alice.key -out alice.csr -subj "/CN=alice/O=viewers"
openssl x509 -req -in alice.csr -CA ~/.minikube/ca.crt -CAkey ~/.minikube/ca.key \
  -CAcreateserial -out alice.crt -days 365

openssl genrsa -out bob.key 2048
openssl req -new -key bob.key -out bob.csr -subj "/CN=bob/O=operators"
openssl x509 -req -in bob.csr -CA ~/.minikube/ca.crt -CAkey ~/.minikube/ca.key \
  -CAcreateserial -out bob.crt -days 365

kubectl config set-credentials alice --client-certificate=alice.crt --client-key=alice.key
kubectl config set-context alice-context --cluster=minikube --namespace=default --user=alice

kubectl config set-credentials bob --client-certificate=bob.crt --client-key=bob.key
kubectl config set-context bob-context --cluster=minikube --namespace=default --user=bob

cd ..
