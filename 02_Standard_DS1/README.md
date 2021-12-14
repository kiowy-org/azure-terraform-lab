# Exercie 2 : Infrastructure Standard_DS1 pour un site web
Dans cet exercice, nous allons déployer une infrastructure AZURE plus conséquente qu'un bucket. Le but est d'héberger une page web sur une instance Azure de type Standard_DS1 et de l'exposer à l'extérieur.

## Partie 1
**N'oubliez pas de supprimer l'infrastructure crée lors du TP précédent via `terraform destroy`**

#### 1. Mise en place du projet
Créez un nouveau dossier qui servira de base à votre projet terraform. Dans ce dossier, créez un fichier `terraform.tf` avec le contenu suivant :
```hcl
# terraform.tf
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}
```

Créez un fichier `providers.tf` avec le contenu suivant :
```hcl
# providers.tf
provider "azurerm" {
    region = "eu-west"
    access_key = "<votre-access-key>"
    secret_key = "<votre-secret-key"
}
```
Enfin, ajoutez un fichier `main.tf` vierge pour le moment.

#### 2. Création de l'instance Standard_DS1_v2
Nous allons tout d'abord ajouter à notre projet une instance `Standard_DS1_v2`.

Ajoutez une ressource de type `azurerm_virtual_machine` dans le fichier `main.tf` grâce aux informations ci-dessus, ainsi qu'à la [documentation terraform correspondante](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine).

> **Suppression des données** : Les instances de machine Azure conservent leurs données par défaut une fois le processus terminer. Dans notre exemple se n'est pas nécéssaire, nous allons donc spécifier :
> ```hcl
>   delete_os_disk_on_termination = true
>   delete_data_disks_on_termination = true
> ```
> Ces paramêtres définisse la suppression des données du disque de l'os et des disques des données associées lors de la terminaison de l'instance.

Pour valider, vérifiez que terraform va bien créer votre instance grâce à la commande `terraform plan`.
*(Si terraform râle, rappelez vous les commandes du TP précédent pour INITialiser le projet...)*

Si le plan vous convient, créez l'instance avec `terraform apply`.

#### 3. Un peu de personalisation
Pour l'instant, l'instance que vous venez de créer est difficilement identifiable. Pour lui ajouter un nom, vous pouvez ajouter un tag `Name` à votre ressource.

Vérifiez que terraform va uniquement modifier votre ressource (symbole `~`) et appliquez les changements avec `terraform apply`

#### 4. Installons notre serveur web
**Plusieurs solutions existent pour configurer notre instance** : générer une image AMI avec sa configuration, utiliser un outil comme Ansible par exemple. Ici, nous allons spécifier un script à éxecuter au démarrage de notre instance, via l'attribut `inline`.


```shell
#!/bin/bash
sudo apt-get update
sudo apt-get install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2
sudo echo "<h1>Hello devopssec</h1>" > /var/www/html/index.html
```

Ajoutez le script ci-dessus à l'instance grâce à l'attribut `inline` sous la forme d'un tableau contenant une chaine de caract. Le HCL support la notation [Heredoc](https://fr.wikipedia.org/wiki/Here_document).
```hcl
# ...  
provisioner "remote-exec" {
  inline = [
    "sudo apt-get update",
    "sudo apt-get install -y apache2",
    "sudo systemctl start apache2",
    "sudo systemctl enable apache2"
    "sudo echo "<h1>Hello Terraform</h1>" > /var/www/html/index.html",
  ]
...}
```

Validez et déployez les changements (vous connaissez les commandes désormais ;))

Voilà ! Votre instance EC2 est déployée, cependant, il manque encore quelques éléments afin d'accéder à votre page web depuis internet.

## Partie 2

#### 1. Configuration réseau
Afin que le traffic depuis internet vers notre instance sur le port 80 puisse passer, nous allons créer un `SecurityGroup`.

Ajoutez la ressource suivante à votre projet :
```hcl
resource "azurerm_security_group" "apache_server_sg" {
  name                          = "tp2-sg"
  resource_group_name           = azurerm_resource_group.apache_server.name
  location                      = azurerm_resource_group.apache_server.location

  security_rule {
    name                        = "HTTP"
    prority                     = 100
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "80"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
  }

  security_rule {
      name                        = "SSH"
      prority                     = 101
      direction                   = "Inbound"
      access                      = "Allow"
      protocol                    = "Tcp"
      source_port_range           = "*"
      destination_port_range      = "22"
      source_address_prefix       = "*"
      destination_address_prefix  = "*"
  }
}
```

Vous devez ensuite attribuer cette règle à l'instance Standard_DS1_v2. Pour cela, il faut référencer le `SecurityGroup` par son attribut `id` dans l'argument `network_interface_ids`de votre instance Standard_DS1_v2.

Modifiez donc votre instance en conséquence, à noter que l'argument `network_interface_ids` attend une liste d'id de `SecurityGroup`.

> Indice : On peut définir une liste avec la syntaxe `[ELEM1, ELEM2, ...]`

Exécutez vos modifications, vérifiez ce que terraform réaliser afin de prendre en compte vos modifications.

#### 2. Accès à l'instance

Votre instance est créée avec le bon groupe, il ne vous reste plus qu'à y accéder. Pour cela vous avez besoin de l'IP publique. 

Vous pouvez l'obtenir de différente manière (ui, cli) et notament grâce à Terraform via la commande `terraform state show`. Nous verrons plus tard comment afficher certaines informations lors de l'éxecution du code Terraform via les *outputs*.