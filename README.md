# AWS Docker CI/CD Pipeline with Terraform

An end-to-end DevOps project demonstrating AWS infrastructure provisioning with Terraform, Docker image publishing with Amazon ECR, and automated deployment to Amazon EC2 using GitHub Actions and AWS Systems Manager.

## Architecture

```text
Developer
   |
   | git push to main
   v
GitHub Repository
   |
   v
GitHub Actions
   |
   | GitHub OIDC -> AWS IAM Role
   v
Build Docker Image
   |
   v
Amazon ECR
   |
   | AWS Systems Manager Run Command
   v
Amazon EC2
   |
   | Pull image from ECR
   v
Docker Container (Nginx)
   |
   v
Website served on port 80
```

## Technologies

- **AWS:** VPC, subnets, Internet Gateway, route tables, security groups, EC2, IAM, Amazon ECR, Systems Manager
- **Infrastructure as Code:** Terraform
- **Containers:** Docker, Nginx
- **CI/CD:** GitHub Actions
- **Authentication:** GitHub OIDC and AWS IAM roles
- **Operating system:** Amazon Linux 2023
- **Version control:** Git and GitHub

## Project Features

- Provision AWS infrastructure using Terraform.
- Build a Docker image for a static website.
- Push versioned Docker images to Amazon ECR.
- Authenticate GitHub Actions to AWS using OIDC and an IAM role.
- Deploy the application to EC2 through AWS Systems Manager Run Command.
- Run the container with automatic restart enabled.
- Perform an HTTP health check after deployment.
- Attempt to restore the previous image if the deployment fails.

## CI/CD Workflow

1. A code change is pushed to the `main` branch.
2. GitHub Actions checks out the repository.
3. GitHub Actions assumes the configured AWS IAM role using OIDC.
4. Docker builds the image and tags it with the Git commit SHA.
5. The image is pushed to Amazon ECR.
6. GitHub Actions sends a deployment command through AWS Systems Manager.
7. EC2 authenticates to ECR using its IAM instance role and pulls the image.
8. The application container is replaced and an HTTP health check is performed.
9. GitHub Actions checks the SSM command result.

## Repository Structure

```text
Docker-lab/
├── .github/
│   └── workflows/
│       └── ci.yml
├── Dockerfile
├── .dockerignore
├── index.html
└── README.md
```

## Security Considerations

- Use GitHub OIDC and IAM roles instead of long-lived AWS access keys in GitHub Actions.
- Follow least-privilege IAM permissions for deployment and image access.
- Keep Terraform state, private keys, credentials, and secret variable files out of version control.
- Restrict inbound network access to only the required sources and ports.
- Review AWS resource costs and remove resources when the project is no longer needed.

## Future Improvements

- Add Amazon CloudWatch dashboards, logs, metrics, and alarms.
- Improve deployment health checks and rollback reliability.
- Introduce an Application Load Balancer and Auto Scaling Group.
- Add automated testing and deployment approval controls.

## Author

Mohamed Emad Elgendy

GitHub: [MEGendy](https://github.com/MEGendy)
