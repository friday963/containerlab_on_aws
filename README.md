# Containerlab On AWS
Containerlab on AWS is a project aimed at giving users the ability to deploy containerlab [FIND IT HERE](https://containerlab.dev/) onto AWS.  This allows users to build and maintain their containerlab environment in a more scalable environment vs their PC which may be limited due to CPU or RAM.  With this code a user is able to build the AWS infrastructure which stands up a VPC, Internet Gateway, and an EC2 instance with a public IP.  The infrastructure has an internet gateway and public IP for two reasons, reachability from AWS "Instance Connect" and from the users public IP.  The users home IP is required so an ansible script can run which updates the environment, installs necessary packages or images, and uploads any containerlab topology files or docker images.

## Installation & Configuration
*Currently this project is more suited to be run from a linux host but eventually this project will be containerized allowing it to be run from anywhere.*

Installation:
1. Install Terraform - https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
2. Install the AWS CLI
    ```
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    ```
3. Install Python >=3.9 - https://www.python.org/downloads/
4. Create a virtual environment:
    ```
    python3 -m venv venv
    source venv/bin/activate
    pip install -r requirements.txt
    ```

Configuration:
1. Configure the AWS CLI with permissions.  AWS user must have at least enough privilages to create a VPC, Subnet, NACL, Security Group, Internet Gateway, and an EC2 instance.
2. Configure the AWS CLI
    ```
    aws configure 

    AWS Access Key ID [None]: YOUR_ACCESS_KEY_HERE
    AWS Secret Access Key [None]: YOUR_SECRET_ACCESS_KEY_HERE
    Default region name [None]: YOUR_PREFERRED_REGION
    Default output format [None]: json
    ```
3. Review the ```vars.yml``` file, this file contains the settings that will be applied to the infrastructure.  For instance if you want this deployed in us-east-2, you would set that here, if you wanted a different AMI or instance size you would set that here.  Review that file before deploying to ensure you deploy the infrastructure with the settings you prefer.
    ```
    <Truncated>
    region: us-east-2
    ec2_instance_type: t2.medium
    ami_id: ami-024e6efaf93d85776
    <Truncated>
    ```

# Usage
With the required software installed and configured it's time to prepare to build the infrastructure and upload the required software.

1. If you have a containerlab topology file that you'd like to upload as part of the work flow, include it in the ```cl_topology_images``` folder where ansible will automatically pick it up.
2. If you have docker images that need to be uploaded because the image is not publically available from docker or because you have a special usecase, include it in the ```cl_topology_images``` folder and it will automatically upload those images.
## Build the infrastrucuture

3. Build the infrastructure:
    ```
    terraform init
    terraform plan
    terraform apply OR terraform apply --auto-approve
    ```

Besides building the infrastucture terraform is also performing a few things behind the scenes.  It creates a key pair for the EC2 instance and places it in the local directory so ansible and the end user can manage the instance.  *KEEP THIS SAFE, THIS GRANTS ACCESS TO A USER WITH SUDO PRIVILAGES*. In addition, a shell file is made executable along with the public IP address of the instance so ansible knows how to log into it.  Lastly a custom user has been created so no matter which instance type you choose the username is ubiquitous across environments.

4. Configure the environment:

    ```
    source venv/bin/activate (This should already be activated from earlier, but if not activate the venv again)
    ansible-playbook site.yml
    ```
5. Log into your EC2 Instance and run your topology!
    ```
    ssh -i containerlab-key.pem containerlabuser@WHATEVER_IP_ADDRESS_IS_ASSOCIATED_WITH_EC2
    cd containerlab_environment/
    sudo containerlab deploy -t YOUR_TOPOLOGY_FILE_NAME.yml
    ```


# Troubleshooting
- Ansible is not recognized or is throwing errors.
    - Make sure your virtual environemnt is still activated after installing the requirements.
    ```
    source venv/bin/activate
    ```
- Containerlab command erroring
    - Deployments and destroys require sudo, ensure you're running commands as sudo.