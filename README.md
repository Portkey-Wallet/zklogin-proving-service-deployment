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
- Exposes port 80 for HTTP traffic

## Accessing the Service

After deployment, the service will be accessible via HTTP on the instance's external IP address.

1. Find the instance's external IP address:
   ```
   gcloud compute instances describe portkey-zklogin-prover --zone=us-central1-a --format='get(networkInterfaces[0].accessConfigs[0].natIP)'
   ```

2. The instance should be available in a couple of minutes. Once you have the IP address, you can check the status of the service by running the following command:
   ```
   IP=$(gcloud compute instances describe portkey-zklogin-prover --zone=us-central1-a --format='get(networkInterfaces[0].accessConfigs[0].natIP)')
   curl -X GET "http://$IP/v1/health"  -H "accept: text/plain"
   ```

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
