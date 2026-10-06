output "jenkins_url" { value = "http://${aws_instance.jenkins.public_ip}:8080" }
output "cluster_name" { value = module.eks.cluster_name }
output "update_kubeconfig" {
  value = "aws eks update-kubeconfig --region ${var.region} --name ${module.eks.cluster_name}"
}
