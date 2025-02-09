#!/bin/sh

kubectl delete -f argocd

# Remove OP secrets 
kubectl delete secret op-credentials -n external-secrets
