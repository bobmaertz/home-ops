#!/bin/sh

kubectl apply -f argocd/namespace.yml

kubectl apply -f argocd/deployment.yaml -n argocd 
kubectl apply -f argocd/argocd-cm.yaml -n argocd 
kubectl apply -f argocd/argocd-rbac-cm.yaml -n argocd 


