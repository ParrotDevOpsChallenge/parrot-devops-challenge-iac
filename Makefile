# Define variables
ENV ?= local
ENV_FILE_PATH = secrets/envs.$(ENV).sh
DOCKER_IMAGE = hashicorp/terraform:latest
DOCKER_RUN = docker run --env-file=$(ENV_FILE_PATH) -v $(PWD)/code:/workspace -w /workspace $(DOCKER_IMAGE)

# Initialize the Terraform project with Docker
init:
	@echo "Initializing Terraform..."
	$(DOCKER_RUN) init

# Fetch secrets script
get-secrets:
	@echo "Fetching secrets..."
	ENV=$(ENV) bash scripts/utils/get-secrets.sh

# Commit information script
commit:
	@echo "Getting commit information..."
	bash scripts/utils/get-commit.sh

# Plan the Terraform changes
plan:
	@echo "Planning Terraform changes..."
	$(DOCKER_RUN) plan

# Apply the Terraform changes
apply:
	@echo "Applying Terraform changes..."
	$(DOCKER_RUN) apply -auto-approve

# Apply the Terraform changes
refresh:
	@echo "Applying Terraform changes..."
	$(DOCKER_RUN) refresh

# Destroy the Terraform-managed infrastructure
destroy:
	@echo "Destroying Terraform-managed infrastructure..."
	$(DOCKER_RUN) destroy -auto-approve

graph:
	@echo "Destroying Terraform-managed infrastructure..."
	$(DOCKER_RUN) graph | dot -Tpng > graph.png




