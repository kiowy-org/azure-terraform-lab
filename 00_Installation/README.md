# Installation de Terraform
## Pré-requis
* [Cli AZURE](https://docs.microsoft.com/fr-fr/cli/azure/install-azure-cli)
* Git
* Un shell
* Un éditeur de code (VSCode)

## Installation
Terraform est livré sous la forme d'un binaire unique, disponible pour de nombreux environnements sur https://www.terraform.io/downloads.html

### Linux

Téléchargez le binaire pour votre système.
```
$ wget https://releases.hashicorp.com/terraform/1.1.0/terraform_1.1.0_linux_amd64.zip
```

Dézippez l'archive
```
$ unzip terraform_1.1.0_linux_amd64.zip
```

Rendez le éxecutable
```
$ chmod +x terraform
```

Enfin, ajoutez le à un dossier de votre `PATH`
```
$ sudo mv terraform /usr/local/bin
```

### MacOS

Installez Terraform avec Homebrew. NOTE : HashiCorp ne maintient pas cette formula, il peut y avoir un délai avec les sorties de versions.
```
$ brew install terraform
```

## Test de l'installation
```
$ terraform version
```
Si l'installation s'est bien passée, vous devez obtenir le retour suivant
```
Terraform v1.1.0
```

## Autocompletion
```
$ terraform -install-autocomplete
```
