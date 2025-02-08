fmt: 
	terraform fmt --recursive

fmt-check:
	terraform fmt -check --recursive

deploy:
	#source .env.$(env) && terraform init -upgrade && terraform apply --parallelism 2
	terraform init -upgrade && terraform apply --parallelism 2

destroy:
	terraform init -upgrade && terraform destroy --parallelism 2 

.PHONY: fmt fmt-check deploy destroy
