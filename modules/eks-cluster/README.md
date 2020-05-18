Input parameters
  
  * cluster_name: Cluster name to be Created (*required)
  * vpc_id: VPC ID to be linked with EKS cluster (*required)
  * eks_version: EKS version to be deployed 
  * create_service_account: true for creating service account else false
  * subnet_ids_list: Subnet ids as a list

  
  * work_groups: List of worker node groups as a map 
     * node_group_name: Name of the unique worker node group  (*required)
     * labels         : List of labels as a map
     * min_size       : Defaults to 1
     * max_size       : Defaults to 1
     * desired_size   : Defaults to 1
     * disk_size      : Defaults to 50
     * instance_types : Defaults "t3.medium"
     * ec2_ssh_key    : SSH key to login (*required)


      module "cutom_eks_cluster" {
        source = "./eks-cluster"
    
        cluster_name = "test-cluster12042020"
        eks_version = "1.14"
        subnet_ids_list = ["subnet-****************7", "subnet-************1"]
        vpcid = "vpc-*****************5"
    
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
