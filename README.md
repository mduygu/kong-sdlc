# Environment-Based, Git-Driven API Configuration Management with KONG

This repository contains two shell scripts for managing API configurations with the Kong API Gateway. The scripts support releasing APIs from Kong to a repository and deploying API changes from a repository to Kong.

For more detailed information and practical application examples of these scripts, please read our [comprehensive guide on Medium](https://medium.com/@mehmetduygu/kong-api-gateway-environment-based-git-driven-api-configuration-management-with-jenkins-shell-9617faf255a5).


## Prerequisites

- [KONG](https://github.com/Kong/kong): Kong API Gateway set up and running.
- [Jq](https://jqlang.github.io/jq/): Installed for JSON processing.

## Usage

This script pulls API configurations from Kong API Gateway and stores them in a local folder.

```bash
./kong-api-release.sh [option]
```

- -release: Fetches and updates the API configurations from Kong API Gateway to the local repository.
- -deploy: Deploys API changes from the local repository to Kong API Gateway.

Run the script directly; it requires no additional arguments for deployment from last commit.

```bash
./kong-api-deploy.sh
```

## Features

- Clones the specified Git repository.
- Identifies the last commit and deploys changes to Kong API Gateway.
- Handles addition, modification, and deletion of API configurations.
- Uses jq to process JSON files and curl for API communication.

## Notes

Ensure that Kong API Gateway is accessible from the machine where scripts are running.
Verify that the Git repository URL and branch are correctly set in deploy.sh.
The scripts assume that API configurations are stored in JSON format in the repository.

## Contributing

Feel free to contribute to this project by submitting pull requests or issues for any improvements or bug fixes.
