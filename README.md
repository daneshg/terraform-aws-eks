## Terraform_aws_eks_modules

These terraform modules can be used to create eks cluster and alb.

There are two approaches to create ALB to EKS cluster
   * Using ALB Ingress controller
   * Using traditional ALB 
   
1.  ALB Ingress controller: 
    * This approach involves us to deploy ingress-controller pod and ingress 
    service pods in EKS cluster and a service account which can do this on our
    behalf. 
2. Traditional ALB:
    * Pre-requisite:
      * NodePort service is used in EKS cluster.
    * We can eliminate the deployment of pods in cluster, instead create aws
    resources through terraform
    * Created ALB will route its requests to EKS cluster.
    
