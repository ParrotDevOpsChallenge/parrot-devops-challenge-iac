
# Parrot DevOps Challenge IAC

This repository contains the Terraform configurations for the `parrot-devops-challenge-iac` project. The Makefile included provides various commands to manage and deploy the infrastructure.

## Commands

### `make init`
Command to initialize the Terraform project using Docker.

```bash
make init
```

### `make get-secrets`
Command to fetch secrets.

```bash
make get-secrets
```

### `make commit`
Command to get commit information.

```bash
make commit
```

### `make plan`
Command to plan the Terraform changes.

```bash
make plan
```

### `make apply`
Command to apply the Terraform changes.

```bash
make apply
```

### `make refresh`
Command to refresh the Terraform state.

```bash
make refresh
```

### `make destroy`
Command to destroy the Terraform-managed infrastructure.

```bash
make destroy
```

### `make graph`
Command to generate a graph of the Terraform-managed infrastructure.

```bash
make graph
```

## Makefile Explanation

- **Variables:**
  - `ENV`: The environment to use (default is `local`).
  - `ENV_FILE_PATH`: The path to the environment-specific secrets file.
  - `DOCKER_IMAGE`: The Docker image to use for running Terraform (`hashicorp/terraform:latest`).
  - `DOCKER_RUN`: The Docker run command with the specified environment and volume settings.

- **Targets:**
  - `init`: Initializes the Terraform project.
  - `get-secrets`: Fetches secrets required for the project.
  - `commit`: Retrieves commit information.
  - `plan`: Plans the Terraform changes.
  - `apply`: Applies the Terraform changes.
  - `refresh`: Refreshes the Terraform state.
  - `destroy`: Destroys the Terraform-managed infrastructure.
  - `graph`: Generates a visual graph of the Terraform-managed infrastructure.

## Usage

1. **Initialize the Terraform project:**

   This should be the first command you run.

   ```bash
   make init
   ```

2. **Fetch secrets:**

   Retrieve the necessary secrets for the project.

   ```bash
   make get-secrets
   ```

3. **Plan the Terraform changes:**

   Review the changes that Terraform will make to the infrastructure.

   ```bash
   make plan
   ```

4. **Apply the Terraform changes:**

   Apply the planned changes to the infrastructure.

   ```bash
   make apply
   ```

5. **Refresh the Terraform state:**

   Refresh the state file with the real-world infrastructure.

   ```bash
   make refresh
   ```

6. **Destroy the Terraform-managed infrastructure:**

   Remove all infrastructure managed by Terraform.

   ```bash
   make destroy
   ```

7. **Generate a graph:**

   Create a visual representation of the Terraform-managed infrastructure.

   ```bash
   make graph
   ```