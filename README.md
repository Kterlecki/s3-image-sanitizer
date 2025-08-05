# s3-image-sanitizer

## Overview
- Solution automatically removes EXIF metadata from JPG images uploaded to S3, creating "sanitized" versions without location data, camera info, or other potentially sensitive metadata.
## Architecture assumptions made
- User Uploads their image via WebUI
- Backend validates the user input and sends it to AWS S3 landing bucket
- Backend built on the same private AWS VPC as AWS S3
- AWS S3 is private - no public access, traffic doesnt traverse public internet. Gateway VPC Endpoint setup for handling private subnet connections
- HTTPS connection - encryption in transit and at rest - Following Zero testu best practisese
- Base Images that Im using for creation of my Python App, Are created internally.
- IAM User key and secret rotation done by admin


### Infrastructure Components

This system is built using AWS services with Infrastructure as Code (Terraform) following security best practices:

#### Core AWS Services
- **Amazon S3**: Two private buckets with encryption at rest
  - **Landing Bucket**: Receives uploaded images, triggers Lambda via S3 events
  - **Output Bucket**: Stores sanitized images with EXIF metadata removed
- **AWS Lambda**: Serverless image processing function
  - Removes EXIF metadata from JPG images using Python/Pillow
  - Deployed as container image via ECR for better dependency management
  - Runs in private VPC subnets with NAT gateway access
- **Amazon ECR**: Private container registry for Lambda images
- **AWS Secrets Manager**: Secure storage for IAM user credentials with rotation support

#### Security & Access Control
- **IAM Users**: Programmatic access users with least-privilege policies
- **IAM Roles**: Lambda execution role with minimal S3 permissions
- **VPC Setup**: Private subnets with Gateway VPC Endpoints for S3 access
- **Encryption**: AES-256 at rest, TLS in transit
- **No Public Access**: All resources private, traffic stays within AWS network

#### Infrastructure Management
- **Terraform State**: Remote backend with S3
- **Modular Design**: Reusable Terraform modules for each component
- **Environment Separation**: Dev/staging/prod configurations
- **Resource Labeling**: Consistent tagging for cost tracking and governance

### Key Design Patterns
- **Modular Infrastructure**: Each AWS service has its own Terraform module
- **Environment Separation**: Dev/staging/prod configurations in separate directories  
- **Security by Default**: All resources private, least-privilege access, encrypted
- **Container-based Lambda**: Better dependency management and faster cold starts
- **Event-driven Processing**: S3 events trigger Lambda automatically



# Cloud architecture diagram

To Run:
1. Clone repository
```
git clone <your-repo-url>
cd s3-image-sanitizer
```
2. Set up python env
```
python3 -m venv .venv
source .venv/bin/activate
pip install -r apps/etl/requirements.txt
```

## Getting Started

### Prerequisites

- AWS CLI configured
- Terraform >= 1.0
- Docker (for local testing)
- Python 3.11+

### Environment Variables
Create a .env file
```
cp apps/etl/src/.env.example apps/etl/src/.env
```
Add the env values in ```.env``` with your `DESTINATION_BUCKET`


### Local Development Setup - Python Needs further developemnt

1. **Create virtual environment**:
```bash
python -m venv apps/etl/venv
```

2. **Activate virtual environment**:
```bash
# Windows
source apps/etl/venv/Scripts/activate

# macOS/Linux
source apps/etl/venv/bin/activate
```

3. **Install dependencies**:
```bash
pip install -r apps/etl/requirements.txt
```
4. ## Test using Python
 - Needs further developement

### Local Development Setup - Docker
1. ## Docker Container Testing

Test the Lambda function in a container environment:
Note: Update bucket refernce and bucket must hold the image specified 

```bash
# Build the Lambda container locally
docker build -t image-sanitizer apps/etl/

# Run with test event
docker run --rm \
  -e DESTINATION_BUCKET=test-bucket \
  image-sanitizer:latest \
  '{"Records":[{"eventSource":"aws:s3","s3":{"bucket":{"name":"test-source"},"object":{"key":"test.jpg"}}}]}'
```

### Local Development Setup - AWS SAM
6. ## AWS SAM Local Testing

For Lambda-like local testing, create a `template.yml` in the project root, based on `template.example.yml`:

Then run:
```bash
# Install SAM CLI first
sam local invoke ImageSanitationFunction

# Or with custom event
sam local invoke ImageSanitationFunction -e event.json


### Deployment

1. **Deploy Infrastructure**:
```bash
cd infra/dev/etl
terraform init
terraform plan
terraform apply
```


Note - In order to run some components of Infra will need to be filled out with resources local to your aws environment
- VPC with atleast 5 subnets
- Admin role that refernce will need to be added in a IAM policies
- 



# Post-Terraform Manual Steps

## For each user created by Terraform You need to rotate the secret and key value, as these will not be stored/printed at time of creation
## As a result, please follow the below steps to update AWS secret manager for both secret and key values for each user created:

1. **AWS Console** → IAM → Users → [user-name]
2. **Security Credentials** tab
3. **Create Access Key** → Command Line Interface
4. **Copy Access Key ID and Secret**
5. **AWS Console** → Secrets Manager → [secret-name]
6. **Store a new version of secret**
7. **Paste credentials in JSON format**
8. **Close all browser tabs**
9. **Clear clipboard**

## Rotation (every 90 days):
- Repeat steps 3-9
- **Delete old access key** after verification


## Tech Debt
- CI/CD pipelines
- linter + formatter for Python
- Setup local debuggin for AWS Lambda
- Scanning for code smells, security - Sonarqueb (probably part of CI)
- Handling user data - may need to look best practises for user data
- Lambda testing - Would need realastic data set to see performance of current setup
    - Increase Concurency?
    - Descrease cold starts even further?
- Step functions - To handle retries, fails and integrate with dead-letter queues (SNS or SQS)
