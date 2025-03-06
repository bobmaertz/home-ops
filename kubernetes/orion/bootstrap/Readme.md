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

## Next Steps
- [ ] Setup Dex Signin
- [ ] Inject username into config map 
