output "website_storage_account_name" {
    description = "Nom du storage account"
    value       = module.website_storage.name
}
  
output "website_endpoint" {
    description = "Nom de domaine du storage account"
    value       = module.website_storage.web_endpoint
}