#!/bin/sh

kubectl delete -f argocd

# Remove OP secrets 
kubectl delete namespace external-secrets
