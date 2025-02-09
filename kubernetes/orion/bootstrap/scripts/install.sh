#!/bin/sh

op run --env-file .secrets.env --no-masking -- minijinja-cli --env templates/resources.yaml.j2 | kubectl apply --server-side --filename -

kubectl apply -f argocd/namespace.yml

kubectl apply -f argocd/deployment.yaml -n argocd 
kubectl apply -f argocd/argocd-cm.yaml -n argocd 
kubectl apply -f argocd/argocd-rbac-cm.yaml -n argocd 


