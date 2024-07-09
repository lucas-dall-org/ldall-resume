# Lucas Dall'Occghio Resume Repository

This repository contains my resume in HTML format. It is built with Terraform and deployed using GitHub Actions. The IAM identity used for deployment is restricted specifically to the purposes of this repository.
Any recommendations and improvements are totally welcome. 
Reach me out in lucas.dall.celmi@gmail.com or [Linkedin](https://www.linkedin.com/in/lucas-dall-occhio/)

## Table of Contents
- [Overview](#overview)
- [Architecture](#architecture)
- [Structure](#structure)
- [Deployment](#deployment)
- [IAM Identity](#iam-identity)
- [Contributing](#contributing)

## Overview
This project stores my professional resume in a structured HTML format. The resume is automatically deployed to an S3 bucket using Terraform, with the deployment pipeline managed by GitHub Actions.

## Architecture
The architecture for deploying and serving the resume includes:
- **Amazon S3**: Used as the origin to store the resume HTML and related assets.
- **Amazon CloudFront**: Configured as the CDN to serve the content globally with low latency.
- **AWS Certificate Manager (ACM)**: Used to manage TLS/SSL certificates for securing the content served by CloudFront.

## Structure
- `index.html`: The main HTML file containing my resume.
- `styles.css`: The CSS file for styling the resume.
- `main.tf`: Terraform configuration for deploying the resume to AWS.
- `.github/workflows/deploy.yml`: GitHub Actions workflow file for automating the deployment process.
- `.github/workflows/pr.yml`: GitHub Actions workflow file for validating the code on pull requests and running a Terraform plan.

## Deployment
The deployment process is automated using GitHub Actions. Whenever changes are pushed to the repository, the workflow defined in `.github/workflows/deploy.yml` is triggered. This workflow:
1. Checks out the code.
2. Sets up Terraform.
3. Configures AWS credentials using an OIDC token.
4. Applies the Terraform configuration to deploy the infrastructure
5. Uploads the website files to the origin bucket
6. Invalidates Cloudfront distribution cache.

### IAM Identity
The IAM role used for deploying the resume has restricted permissions to ensure it is only used for this specific purpose. The trust policy for the role ensures it can only be assumed by GitHub Actions running on pull requests in this repository.

## Contributing
Contributions are welcome! To propose changes:
1. Clone the repository.
2. Create a new branch for your changes.
3. Make your modifications.
4. Submit a pull request (PR) with a detailed description of your changes.

All proposals must be made through a pull request, and a description is required for each PR to explain the purpose and context of the changes.

---

Thank you for your interest in improving this project!
