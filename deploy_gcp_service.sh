#!/bin/bash

# Prompt for project ID
read -p "Enter your GCP project ID: " PROJECT_ID

# Set variables
INSTANCE_TEMPLATE_NAME="portkey-zklogin-prover-template"
INSTANCE_NAME="portkey-zklogin-prover"
ZONE="us-central1-a"  # Replace with your desired zone
SERVICE_ACCOUNT_NAME="portkey-prover-sa"
KEY_FILE="portkey-prover-sa-key.json"

# Set the project
gcloud config set project $PROJECT_ID

# Enable the Compute Engine API for managing VM instances and related resources
gcloud services enable compute.googleapis.com

# Enable the Identity and Access Management (IAM) API for managing service accounts and permissions
gcloud services enable iam.googleapis.com

# 2. Create a service account
gcloud iam service-accounts create $SERVICE_ACCOUNT_NAME \
    --display-name="Deployment Service Account"

# 3. Generate a key for the service account
gcloud iam service-accounts keys create $KEY_FILE \
    --iam-account=$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com

# 4. Grant necessary permissions to the service account
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/compute.admin"

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/iam.serviceAccountUser"

# 5. Activate the service account
gcloud auth activate-service-account \
    --key-file=$KEY_FILE

# 6. Create an Instance Template
gcloud compute instance-templates create $INSTANCE_TEMPLATE_NAME \
    --machine-type=n2-custom-16-8192 \
    --image-family=ubuntu-2004-lts \
    --image-project=ubuntu-os-cloud \
    --boot-disk-size=30GB \
    --tags=http-server,https-server \
    --metadata-from-file startup-script=portkey_zklogin_prover_setup.sh

# 7. Create an instance with the template
gcloud compute instances create $INSTANCE_NAME \
    --zone=$ZONE \
    --source-instance-template=$INSTANCE_TEMPLATE_NAME

echo "Portkey zkLogin Prover deployment completed successfully!"