# Exercie 5 : Provisioner une VM

Le but de ce TP est de vous présenter comment provisionner une VM via le `provisioner` `remote-exec`. Nous allons installer un serveur web apache (comme sur les TP précédents), mais cette fois sans utiliser l'argument `custom_data`.

Dans le fichier `main.tf`, vous trouverez la configuration des TPs du serveur Web précédent. Ajoutez un block `provisioner "remote-exec"` à la resource `azurerm_linux_virtual_machine`. 

La VM est accessible via login/password, quelle configuration du block `connection` faut il écrire ?

Enfin, utilisez le code présent dans le script d'installation des TPs précédents dans le provisioner, afin qu'il soit utilisé au démarrage de la machine.

Éxecutez terraform apply, récupérez l'adresse IP publique de l'instance (`terraform show`) et vérifiez que vous pouvez bien accéder au site web !