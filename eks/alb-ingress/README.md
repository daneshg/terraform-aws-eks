Input parameters
  
  cluster_name: Cluster name to be Created (*required)
  vpc_id: VPC ID to be linked with EKS cluster (*required)
  region: AWS region to deploy EKS cluster (*required)
  subnet_ids_list: subnet ids as a list
 
  service_account_arn: Service account arn; (*required) 

  service_port: nodePort services's --port value
  service_name: nodePort service name

    Example :

    <pre>
      data "aws_eks_cluster" "example" {
        name = var.cluster_name
      }

      data "aws_eks_cluster_auth" "cluster" {
        name = var.cluster_name
      }

      provider "kubernetes" {
        host                   = data.aws_eks_cluster.example.endpoint
        cluster_ca_certificate = base64decode(data.aws_eks_cluster.example.certificate_authority.0.data)
        token                  = data.aws_eks_cluster_auth.cluster.token
        load_config_file       = false
      }

      module "alb-ingress" {
        source = "./modules/eks/alb-ingress"

        vpcid               = var.vpcid
        subnet_ids_list     = ["subnet-*************", "subnet-************"]
        cluster_name        = var.cluster_name
        region              = var.region
        service_account_arn = var.eks_service_account_arn
        service_port        = var.service_port
        service_name        = var.service_name
      }

    </pre>
