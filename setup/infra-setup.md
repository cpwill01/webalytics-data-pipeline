# Infrastructure Setup
The infrastructure setup consists of 2 main parts, an initial setup of a GCP Project & service account
followed by using Terraform to set up the cloud infrastructure we need. 

Note: These instructions were written
with reference to the instructions in the DE ZoomCamp course

## 1. GCP Project & Service Account
1. Create a GCP account [here](https://cloud.google.com/?hl=en) using your Google email ID
2. Setup a [project](https://console.cloud.google.com/) if you haven't already
    * eg. "Data Pipeline Project", and note down the "Project ID" (we'll use this later when deploying infra with Terraform)
3. Setup [service account & authentication](https://cloud.google.com/docs/authentication/getting-started) for this project
    * Grant `Viewer` role to begin with.
    * Download service-account-keys (.json) for auth.
4. [IAM Roles](https://cloud.google.com/storage/docs/access-control/iam-roles) for Service account:
    * Go to the *IAM* section of *IAM & Admin* https://console.cloud.google.com/iam-admin/iam
    * Click the *Edit principal* icon for your service account.
    * Add these roles in addition to *Viewer* : 
      * **Storage Admin**
      * **Compute Admin**
      * **BigQuery Admin**
      * **Security Admin**
      * **Create Service Accounts**
      * **Service Account User**
    
5. Enable these APIs for your project:
    * https://console.cloud.google.com/apis/library/iam.googleapis.com
    * https://console.cloud.google.com/apis/library/iamcredentials.googleapis.com
    * https://console.cloud.google.com/apis/library/compute.googleapis.com
    * https://console.cloud.google.com/apis/library/cloudresourcemanager.googleapis.com
    
## 2. Terraform 
> [!NOTE]
> I used Terraform Cloud with GitHub Actions CI/CD (similar to 
> [this](https://developer.hashicorp.com/terraform/tutorials/automation/github-actions)) to deploy my project, but these
> require additional setup. The instructions here will use a local backend instead, like what we've been doing during 
> the course.

1. Clone this repository in your local machine and navigate to the Terraform folder:
   ```shell
   git clone https://github.com/cpwill01/webalytics-data-pipeline.git && \
   cd webalytics-data-pipeline/terraform/for_peer_reviewers
   ```
2. We need to give Terraform access to the service account's json key we created earlier. Set the environment  variable 
   `GOOGLE_CREDENTIALS` to the **full path** to your service account json file. Assuming 
you are using a Linux shell (or git bash on Windows), you can run this:
   ```shell
   export GOOGLE_CREDENTIALS='path/to/your/service/account/key.json'
   ```
   Note: If you're using cmd on Windows, it'll be `set` instead of `export`. On Powershell, the syntax is `$env:GOOGLE_CREDENTIALS="path/to/your/service/account/key.json"`
3. Initialise terraform:
   ```shell
   terraform init
   ```
4. View the Terraform plan. 
   ```shell
   terraform plan
   ```
   You will be prompted to enter 2 values: 
      * Your GCP Project ID from earlier
      * A name for your GCS Bucket. Try to give your bucket an uncommon name, as bucket names must be globally unique 
        (i.e. nobody else should have a GCS bucket with the same name)
        
   Check that the plan creates the following:
      * a Google Cloud Storage bucket
      * a BigQuery Dataset called "web_events_dataset"
      * an `e2-standard-4` Google Compute Instance called "eventsim-kafka-instance"
      * a Service Account for the compute instance
      * IAM membership for the service account with role `roles/storage.objectUser`
   
5. Apply the plan. If prompted, enter the same 2 values.
   ```shell
   terraform apply
   ```

> [!WARNING]  
> Once you have completed the project, remember to tear down the infrastructure by
> navigating back to the `terraform/for_peer_reviewers` folder and running `terraform destroy`
> so that you don't incur unnecessary costs.
