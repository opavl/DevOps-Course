* install terraform (https://developer.hashicorp.com/terraform/install)
* install azure-cli (https://developer.hashicorp.com/terraform/tutorials/)
* provide azure-cli secrets inside terraform.tfvars
* run via **terraform init**




What was done:
- Terraform config from HW#10 changed to use existing created VNET\subnet
- Ansible hosts should be modified after terraform setup
- Test agent with:
    - terraform + azure cli
    - ansible
    - get terraform credenttials
Test agent deploys VMs with sample HTTP server and custom web page
    - configure node
    - install JDK on agent
    - create agent folder /var/jenkins/agent and chown and chmod
    - Clone git 
    - provide credentials
        - https://developer.hashicorp.com/terraform/tutorials/azure-get-started/azure-build
        - install azure plugin for jenkins
    - set ansible hosts from terramind
        - output public ips
        - json public ips to invertory.ini and move to ./ansible
        - runs ansible with invertory.ini


## Improvemnets:
- configure test agent from job