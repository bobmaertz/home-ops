# Bootstraping 


## Install 
Run the following script. It is a wrapper around the necessary kubectl cmds for ease of testing. 
```sh 
./scripts/install.sh 
```
### User Initialization 

Initial secret will be output from the install.sh script 
```sh 

kubectl port-forward svc/argocd-server -n argocd 8080:443 

ARGO_USERNAME=bob ARGO_PASSWORD=$(op read op://orion/argocd/password) ./scripts/initialize.sh
```

Dont Forget: Disable admin access via argocd-cm update. 

### Secret Management

Secrets are stored in one password. The operator will be initialized by ArgoCD but 
a kubernetes secret neeeds to be created for the operator to connecto the the righ vault. 

References here: (One Password Connect - Getting Started)[https://developer.1password.com/docs/connect/get-started] 

```sh 
op connect server create $SERVER_NAME --vaults $VAULT_NAME 

mv 1password-credentials.json 1password-credentials.json.pre-encode

# Workaround to fix a encoding issue with k8 
cat 1password-credentials.json.pre-encode | base64 | tr '/+' '_-' | tr -d '=' | tr -d '\n' > 1password-credentials.json

# Match namespace that operator was installed into
kubectl create secret generic op-credentials --from-file=1password-credentials.json -n security

rm 1password-credentials.*

```

## Next Steps
- [ ] Setup Dex Signin
- [ ] Inject username into config map 
