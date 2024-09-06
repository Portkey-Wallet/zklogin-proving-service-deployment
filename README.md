# Portkey zkLogin Prover Deployment Script

This repository contains scripts to deploy the Portkey zkLogin Prover service in Google Cloud Platform (GCP).

## Prerequisites

1. **GCP Account**: Ensure you have an active GCP account.
2. **Project**: Create a new GCP project or use an existing one.
3. **Billing**: Enable billing for your project.
4. **gcloud CLI**: Install and initialize the gcloud CLI.

## Setup

1. Clone this repository:
   ```
   git clone https://github.com/Portkey-Wallet/zklogin-proving-service-deployment.git
   cd zklogin-proving-service-deployment
   ```

2. Make the deployment script executable:
   ```
   chmod +x deploy_gcp_service.sh
   ```

3. Run the deployment script:
   ```
   ./deploy_gcp_service.sh
   ```
   When prompted, enter your GCP Project ID.

## What the Script Does

- Enables necessary GCP APIs
- Creates a service account with required permissions
- Creates an instance template with the Portkey zkLogin Prover configuration
- Launches a GCP instance using the template
- Sets up and runs the Portkey zkLogin Prover service on the instance

## Cleanup

To avoid unnecessary charges, delete the resources when no longer needed:
1. Delete the GCP instance
2. Delete the instance template
3. Delete the service account
4. Disable unused APIs
5. Delete the project if it was created solely for this purpose

## Troubleshooting

If you encounter issues with service account key creation due to organizational policies, you may need to:
- Use your own user credentials: `gcloud auth application-default login`
- Contact your GCP administrator for assistance with service account permissions
