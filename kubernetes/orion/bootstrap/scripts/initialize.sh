#!/bin/sh 

export ARGOCD_ADMIN_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

argocd login localhost:8080 --username admin --password $ARGOCD_ADMIN_PASSWORD
argocd account update-password --account $ARGO_USERNAME --new-password $ARGO_PASSWORD --current-password $ARGOCD_ADMIN_PASSWORD

argocd app create apps \
    --dest-namespace default \
    --dest-server https://kubernetes.default.svc \
    --repo https://github.com/bobmaertz/home-ops.git \
    --path kubernetes/orion/apps \
    --directory-recurse  
