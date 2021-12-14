# Exercie 3 : Utiliser les variables et les outputs
Nous allons refactorer le code réalisé lors de l'exercice précédent afin de le rendre un peu plus flexible grâce aux variables.

**N'oubliez pas de supprimer l'infrastructure créée lors du TP précédent via `terraform destroy`**

#### 1. Mise en place du projet
Vous pouvez utiliser ce dossier comme base, n'oubliez pas d'éxecuter `terraform init` ;)

#### 2. Première variable : votre préfixe
Pour commencer en douceur, vous allez définir une variable de type `string` contenant un préfixe de votre choix, vous pourrez ensuite l'utiliser tout au long de la formation dans le nom des ressources afin de les rendre unique.

Commencez par créer un fichier `variables.tf` et déclarez une variable de type `string`, appelée `prefix`. N'oubliez pas la description de votre variable afin qu'un autre développeur comprenne ce que c'est.

Ensuite, éditez `main.tf` afin que le tag `Name` de l'instance EC2 soit `<prefix>-instance`. Utilisez la syntaxe d'interpolation `"${var.<NOM_VARIABLE>}"` pour cela.

#### 3. Spécifier une région, mais seulement européenne
Afin de rendre notre code plus flexible, nous souhaitons laisser le choix dans la région, mais pas trop non plus ! RGPD oblige, il faut que la région soit parmis les suivantes :

```
francecentral
francesouth
northeurope
swedencentral
uksouth
westeurope
```

Déclarez la variable `azure_region`, avec comme paramètre par défaut la région `westeurope` et n'acceptant que les régions ci-dessus (indice : [il existe la fonction `contains`](https://www.terraform.io/docs/language/functions/contains.html)).

Ajoutez ensuite la référence à cette variable dans l'argument `location` du provider AZURE.

#### 4. Spécifier le paramètres region en fonction de la location
Pour simplifier la vie des utilisateurs de notre code Terraform (ou la notre...), nous souhaitons fixer les AMIs à utiliser. Cependant sur AWS, l'AMI ID dépend de la région.

Nous allons utiliser une `local` afin de spécifier la liste des locations par région grâce à une map.

```
locals {
    location_by_region = {
        "francecentrale"        = "France Central"
        "francesouth"           = "France South"
        "northeurope"           = "North Europe"
        "swedencentral"         = "Sweden Central"
        "uksouth"               = "UK South"
        "westeurope"            = "West Europe"
    }
}
```

Afin que terraform "choissise" la bonne région, vous devez définir une autre `local` basée sur la variable `azure_region`. Vous pourrez ensuite référencer cette `local` dans l'argument `location` de les instances de ressources de votre cluster.

#### 5. Afficher l'IP Publique de l'instance

Afin d'afficher l'IP de notre instance Standard DS1 v2, nous allons ajouter un output. Créez un fichier `outputs.tf`. Ajoutez un `output` appelé `public_ip` qui affiche l'argument `public_ip` de l'instance Standard_DS1_v2.

#### 6. Ajouter des variables et éxecuter

Pour terminer, assignez des valeurs aux variables (vous pouvez tenter un `terraform apply` sans variables pour voir le comportement de la commande).

Vérifiez également que les valeurs sont bien validées par Terraform si vous indiquez une région non autorisée.