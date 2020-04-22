# terraform_aws_eks_modules
Terraform modules for AWS's EKS, ALB and route53 


EX:
<pre>
      module "cutom_eks_cluster" {
        source = "./eks/cluster"

        cluster_name = "test-cluster12042020"
        eks_version = var.eks_version
        subnet_ids_list = var.subnet_ids_list
        vpcid = var.vpc_id

        work_groups = [
          {
            node_group_name = "node-group-1"
            ec2_ssh_key     = "example-key"
            labels          = {
              build = "query"
            }
          },
          {
            node_group_name = "node-group-2"
            ec2_ssh_key     = "example-key"
            labels          = {
              name  = "query_build"
            }
          },
        ]
      }

        module "custom_alb" {
          source = "./eks/alb"

          cluster_name    = module.cutom_eks_cluster.cluster_id
          subnet_ids_list = var.subnet_ids_list
          vpcid           = var.vpc_id
        
          node_group_names          = module.cutom_eks_cluster.node_group_names        ### Example - { node1 = "node1", node2 = "node2" } 
          autoscale_group_names     = module.cutom_eks_cluster.autoscale_group_names   #### Example - { node1 = "abcdferfg", node2 = "asfasfdsf" }

          cluster_security_group_id = module.cutom_eks_cluster.cluster_security_group_id

          alb = {
            node_port   = 31121       #### Need to be hardcoded in NodePort service pods.
            enable_http = true        ### Required if http access is required.
            enable_https = true       #### Required to enable https routing 
            tags = {
              managedBy = "ALB Terraform"
            }
            certificate_arn = data.aws_acm_certificate.example.arn #### Required if https.
          }

          route_53 = {
            domain_name = "example.com"
            private_zone = false
            host_name = "abcd.example.com"
          }

        }
</pre>
