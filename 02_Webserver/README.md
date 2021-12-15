# Exercie 2 : Infrastructure Standard_DS1 pour un site web
Dans cet exercice, nous allons déployer une infrastructure AZURE plus conséquente qu'un bucket. Le but est d'héberger une page web sur une instance Azure de type Standard_DS1 et de l'exposer à l'extérieur.

## Partie 1
**N'oubliez pas de supprimer l'infrastructure crée lors du TP précédent via `terraform destroy`**

### 1. Mise en place du projet
Ce dossier servira de base à votre projet terraform. Dans ce dossier, vous trouverez les fichiers `terraform.tf`, `providers.tf` et `outputs.tf` déjà remplis (*n'oubliez pas d'ajouter vos identifiants au provider*). Vous allez ajouter vos ressources dans le fichier `main.tf`.

### 2. Création de l'instance Standard_DS1_v2
Nous allons tout d'abord ajouter à notre projet une instance `Standard_DS1_v2`.
Sur Azure, une instance de VM doit forcément être créé au sein d'un `Virtual Network`. Nous allons donc crééer les ressources correspondantes.

Dans le `main.tf` ajoutez une ressource [`azurerm_virtual_network`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network). Définissez les options `name`, `resource_group_name`, `location` et `address_space` (sur `10.0.0.0/16` par exemple).

Ajoutez ensuite une ressource [`azurerm_subnet`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet), en définissant les options `name`, `resource_group_name`, `virtual_network_name` et enfin `address_prefixes` (sur `10.0.2.0/24` par exemple).

Pour valider, vérifiez que terraform va bien créer votre network grâce à la commande `terraform plan`.
*(Si terraform râle, rappelez vous les commandes du TP précédent pour INITialiser le projet...)*

Si le plan vous convient, créez les ressources avec `terraform apply`.

Avant de crééer notre VM, nous devons tout d'abord ajouter une interface réseau. Créez une ressource [`azurerm_network_interface`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) en définissant les options `name`, `resource_group_name` et `location`. Ajoutez également un block `ip_configuration` avec les champs `name`, `subnet_id`, `private_ip_address_allocation` à la valeur `Dynamic`.

Enfin, ajoutez une ressource de type [`azurerm_linux_virtual_machine`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) dans le fichier `main.tf` grâce aux informations ci-dessous.

Vous devez définir les paramètres requis classiques, mais vous devrez porter une attention particulière au paramètre `size` qui aura la valeur `Standard_DS1_v2`. Vérifiez bien le contenu des champs requis. Pour le block `os_disk`, vous pouvez utiliser les options suivantes :
```
caching               = "ReadWrite"
storage_account_type  = "Standard_LRS"
```
Le block `source_image_reference` doit également être présent avec la configuration suivante :
```
publisher = "Canonical"
offer     = "UbuntuServer"
sku       = "16.04-LTS"
version   = "latest"
```

Vérifiez votre code (`validate`), validez le plan et déployez votre infrastructure. Si tout va bien, votre VM est en ligne !

### 3. Ajouter une IP externe
Le but de notre TP est de créer un serveur web, il faut donc que notre VM soit accessible depuis l'extérieur. Nous avons donc besoin d'une IP externe !

Créez une ressource [`azurerm_public_ip`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip). Je vous laisse le soin de trouver les bons arguments, il faut simplement que votre IP soit `Static` et `Regional`.

Vous devez ensuite assigner cette IP à votre VM, comment spécifier cela ? (indice : ça concerne [`azurerm_network_interface`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface))

Vérifiez que terraform va bien créer votre IP et modifier votre ressource `azurerm_network_interface` (symbole `~`) et appliquez les changements avec `terraform apply`                  

### 4. Installons notre serveur web
**Plusieurs solutions existent pour configurer notre instance** : générer une image avec sa configuration, utiliser un outil comme Ansible par exemple. Ici, nous allons donner un script à Azure qui sera exécuté à la création de l'instance.

Le script est présent dans le dossier du TP (`./apache_script.sh`). Étudiez la documentation de l'argument `custom_data` de [`azurerm_linux_virtual_machine`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) afin de passer ce script à l'instance.

Validez et déployez les changements (vous connaissez les commandes désormais ;))

Voilà ! Votre instance est déployée, cependant, il manque encore quelques éléments afin d'accéder à votre page web depuis internet.

## Partie 2

### 1. Configuration réseau
Afin que le traffic depuis internet vers notre instance sur le port 80 puisse passer, nous allons créer un [`azurerm_network_security_group`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group).

Quelle configuration écrire afin d'autoriser le traffic entrant sur le port 80 ?

Exécutez vos modifications, vérifiez ce que terraform va réaliser afin de prendre en compte vos modifications.

### 2. Accès à l'instance

Votre instance est créée avec le bon groupe, il ne vous reste plus qu'à y accéder. Pour cela vous avez besoin de l'IP publique. 

Vous pouvez l'obtenir de différente manière (ui, cli) et notament grâce à Terraform via la commande `terraform state show`. Nous verrons plus tard comment afficher certaines informations lors de l'éxecution du code Terraform via les *outputs*.