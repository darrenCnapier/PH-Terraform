
//output "dev_instance_ip" {
//  value = module.dev_instance.instance_ip
//}


output "access_key" {
  value = module.service_iam.iam_access_key_id
}

output "iam_access_key_secret" {
  value = module.service_iam.iam_access_key_secret
}

output "staging_instance_ip" {
  value = module.staging_instance.instance_ip
}

output "prod_instance_ip" {
  value = module.production_instance.instance_ip
}

//output "cloudwatch_log_stream_names" {
//  description = ""
//  value       = "${module.dev_cloudwatch.cloudwatch_log_stream_names}"
//}
