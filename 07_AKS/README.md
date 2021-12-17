# Exercice 7 : Créer un cluster K8S

Dans ce TP, nous allons déployer un cluster AKS pour héberger des applications conteneurisées.

### 1. Log analytics
Afin de pouvoir lire les logs de notre cluster, nous devons tout d'abord configurer le service `log_analytics`. Vous pouvez vous aider des variables définies dans le fichier `variables.tf`.

Commencez par créer une ressource [`azurerm_log_analytics_workspace`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace). Assurez vous que son nom est unique pour tout Azure (vous pouvez générer une chaine aléatoire avec `random_id` par exemple).

Ajoutez ensuite une ressource [`azurerm_log_analytics_solution`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_solution). Indiquez les arguments requis, ainsi que le block :
```hcl
plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
}
```

### 2. Cluster AKS

Dans Azure, un cluster AKS peut être créé en une seule ressource Terraform. C'est la resource [`azurerm_kubernetes_cluster`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster). Elle ne manque pas d'options, je vous indique ci-dessous la listes des options importantes :

* Le `dns_prefix` sera donné par l'utilisateur en tant que variable.
* La `vm_size` du default node pool est `Standard_D2_v2`
* Le nombre de noeuds est donné par l'utilisateur en variable.
* Le `type` d'identité est `SystemAssigned`
* Dans les profils d'addons, on activera `oms_agent` (en pensant bien à indiquer notre workspace logs analytics)
* Pour le networking, le `load_balancer_sku` sera `Standard` et le network plugin `kubenet`.

À l'aide de toutes ces informations, et de la documentation, déployez votre cluster AKS.
