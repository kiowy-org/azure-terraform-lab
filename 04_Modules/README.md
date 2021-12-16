# Exercie 4 : Créer un module

Dans ce TP, nous allons réaliser un module qui permet de créer un compte de stockage ouvert afin d'héberger un site web. On partira du principe que ce site est composé d'une page `index.html` en guise de page d'accueil, ainsi que d'une page `error.html` pour les cas d'erreur (disponibles dans le dossier `www`).
 
### 1. Mise en place
Quand on travaille avec des modules, les bonnes pratiques de terraform recommandent de les placer sous le dossier `modules` à la racine. Ici, un dossier `az-website-sa` est déjà créé pour vous.

Commencez par ajouter le fichier `LICENSE` et `README.md`. Pour la license, je vous laisse le choix ;) Mais n'oubliez pas de remplir un peu le README, la doc ça ne fait jamais de mal ! En général, on indique les arguments (variables) qu'accepte votre module.

### 2. Variables d'entrée
Pour que les développeurs qui utiliseront votre module puisse le personaliser, vous devez indiquer des variables qui seront utilisables en entrée. Dans cet exercice, **le seul élément que l'utilisateur pourra modifier est le nom du storage account**.

Créez un fichier `variables.tf` dans votre module et définissez une variable qui contiendra le nom du storage account.

### 3. Resources du module
Afin de réaliser votre module, vous devez indiquer les resources à créer dans un fichier `main.tf`. Ajoutez ce fichier à votre module, et ajoutez une ressource [`azurerm_storage_account`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) (ainsi qu'un [`resource_group`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group), mais ça vous avez l'habitude maintenant).

Afin d'héberger un site statique, on s'interessera aux arguments suivant :
* `account_kind` : le type de stockage, à définir sur `StorageV2`
* `static_website` : ce block prend deux arguments :
    * `index_document` : page à retourner pour l'index
    * `error_404_document` : page à retourner en cas d'erreur

Et bien sur, il faut indiquer les arguments requis !

Pour envoyer un fichier sur le storage account, nous allons utiliser une resource [`azurerm_storage_blob`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_blob). Les arguments qui nous intéressent ici sont :
* `name` : Le nom du fichier, tel qu'il apparaitra sur le storage account
* `storage_container_name` : Le nom du container, qui ici prendra la valeur spéciale `$web`
* `type` : Le type de stockage, ici `Block`
* `content_type` : Le content-type de nos fichiers (du html...)
* `source_content` ou `source` : Le contenu du fichier (n'oubliez pas la fonction `file()`)

Nous avons 2 fichiers à uploader (disponibles dans le dossier `www`, ajoutez des `storage_blob` en conséquences).

### 4. Remonter l'information à l'utilisateur
Si vous observez le fichier `outputs.tf` du module racine, vous devriez avoir une idée des outputs à créer dans votre module... N'oubliez pas de parcourir la section *Attributes* de la documentation terraform du [`azurerm_storage_account`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account).

### 5. Utiliser le module
Une fois l'écriture de votre module terminée, n'oubliez pas de l'appeler dans le module racine (dans le `main.tf`).

Vous pouvez ensuite éxecuter `terraform apply`. 

Si tout se passe bien, terraform devrait vous indiquer l'URL de votre site web statique. Vérifiez que vous pouvez voir la page d'accueil et la page d'erreur.

Félicitations, vous venez de créer votre module ! Réjouissez vous face à votre réussite... mais pas trop car la formation n'est pas encore terminée !