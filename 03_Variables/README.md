# Exercie 3 : Utiliser les variables et les outputs
Nous allons refactorer le code réalisé lors de l'exercice précédent afin de le rendre un peu plus flexible grâce aux variables.

**N'oubliez pas de supprimer l'infrastructure créée lors du TP précédent via `terraform destroy`**

### 1. Mise en place du projet
Vous pouvez utiliser ce dossier comme base, n'oubliez pas d'éxecuter `terraform init` ;)

### 2. Première variable : votre préfixe
Pour commencer en douceur, vous allez définir une variable de type `string` contenant un préfixe de votre choix, afin de rendre le nom de vos ressources encore plus unique (en le combinant avec le Pet Name).

Commencez par créer un fichier `variables.tf` et déclarez une variable de type `string`, appelée `prefix`. N'oubliez pas la description de votre variable afin qu'un autre développeur comprenne ce que c'est.

Ensuite, éditez `main.tf` afin que le `name` de l'instance soit `<prefix>-<pet name>-instance`. Utilisez la syntaxe d'interpolation `"${var.<NOM_VARIABLE>}"` pour cela.

### 3. Spécifier une région, mais seulement européenne
Afin de rendre notre code plus flexible, nous souhaitons laisser le choix dans la région, mais pas trop non plus ! RGPD oblige, il faut que la région soit parmis les suivantes :

```
France Central
France South
North Europe
Sweden Central
Uk South
West Europe
```

Déclarez la variable `azure_region`, avec comme paramètre par défaut la région `France Central` et n'acceptant que les régions ci-dessus (indice : [il existe la fonction `contains`](https://www.terraform.io/docs/language/functions/contains.html)).

Ajoutez ensuite la référence à cette variable dans l'argument `location` du `Resource Group`.

### 4. Spécifier le nommage des objets
Azure tient a de fortes contraintes sur le nommage des objets. Notamment sur l'unicité. Afin de simplifier l'écriture du code Terraform, utilisez une `local` afin de définir un préfixe pour vos resources, composé de `<votre prefix>-<pet name>`. Ajoutez ce préfix à tous vos objets portants un nom.


### 5. Afficher l'IP Publique de l'instance

Afin d'afficher l'IP de notre instance Standard DS1 v2, nous allons ajouter un output. Créez un fichier `outputs.tf`. Ajoutez un `output` appelé `public_ip` qui affiche l'attribut `ip_address` de votre [`azurerm_public_ip`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip).

### 6. Ajouter des variables et éxecuter

Pour terminer, assignez des valeurs aux variables (vous pouvez tenter un `terraform apply` sans variables pour voir le comportement de la commande).

Vérifiez également que les valeurs sont bien validées par Terraform si vous indiquez une région non autorisée.