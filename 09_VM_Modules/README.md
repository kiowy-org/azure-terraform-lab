# Exercice 9 : Création de VM avec les modules

Dans ce TP, nous allons déployer des machines virtuelles, en nous servant uniquement de modules externes, fournis par Azure.

### 1. Définition du réseau

Nous allons commencer par déployer la couche réseau de l'infrastructure. Pour cela, utilisez le module [Azure / network](https://registry.terraform.io/modules/Azure/network/azurerm/latest). Pas de contrainte particulières sur le réseau, usez à bon escient des valeurs par défaut, pour écrire le moins de code possible !

### 2. Création de la machine virtuelle

Pour changer un peu, nous allons déployer une machine virtuelle Windows. Mais afin de rendre les choses plus simples, rendez-vous sur la documentation du module [Azure / compute](https://registry.terraform.io/modules/Azure/compute/azurerm/latest).

Pensez à bien spécifier les arguments requis pour créer un machine windows.

### 3. Quelques outputs

N'oubliez pas d'afficher quelques informations sur votre VM en outputs :
* `public_ip_dns_name`
* `public_ip_address`
* `network_interface_private_ip`