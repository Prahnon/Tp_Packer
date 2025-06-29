# Tp_Packer
Bonjour,
Voici le readme pour le compte-rendu de l'atelier Packer. Celui-ci vous guidera sur l'utilisation de mes dossier et ce que j'ai compris/fait pour le TP.
Avant, il faut savoir que j'utilise AWS pour l'hébergement de mes VMs, il faudrait donc changer dans les fichiers de configuration de packer et terraform les sources AWS, si vous utilisez aussi du AWS.

## Construction de mes dossiers
### Dossier Packer
Dans un premier temps, vous trouverez dans mon dossier **/TP_Packer/packer** les 3 fichiers .hcl pour la configuration des images AMI avec Packer.
-1 fichier chacun pour la VM Frontend (frontend.pkr.hcl), Backend (backend.pkr.hcl) et Database (database.pkr.hcl).

### Dossier Terraform
Ensuite dans le dossier **/TP_Packer/terraform**, vous trouverez le main.tf permettant de déployer les VM selon les images de packer.

## Déploiement des VMs à partir des images
### Construction des images
Une fois mon dossier récupéré, allez dans le dossier **/TP_Packer/packer** et faites les commandes suivantes :
packer validate .\<nomdufichier> -> Cela permet de vérifier si la configuration est correct
packer init .\<nomdufichier> -> Mettre à jour les plugins de la configuration
packer build .\<nomdufichier> -> Pour construire l'image dans AWS
Sous **AWS/AMI** (et sous la bonne région (renseigner dans le fichier main.tf)), regardez si l’AMI est bien créé. 

### Construction du ssh
Pour nous connecter aux machines, nous aurons besoin de SSH. 
Pour cela, faites la commande :
ssh-keygen -f terraform_<nomdelarégion>_key

### Construction des VMs
Une fois l’AMI bien créé, allez dans le dossier /TP_Packer/terraform et faites les commandes tf suivantes :
terraform init -> Pour initialiser le dossier terraform dans lequel on se situe (/TP_Packer/terraform)
terraform plan -> Pour voir toutes les modifications, suppressions et/ou ajout qu'il y aura en lançant la construction des VMs
terraform apply -> Pour lancer la construction des VMs
Sous **AWS/EC2**, allez dans **Instances** et vous devriez voir 3 machines de créées avec pour nom "FCS-Frontend", "FCS-Backend" et "FCS-Database"

### Connexion aux VMs
#### Prérequis
Avant de vous connecter aux VMs, si vous utilisez la configuration vanilla d'AWS, il faut changer les règles de firewall.
Pour cela dans la page **AWS EC2/Réseau et sécurité/Groupes de sécurité** sélectionner la seule règle de sécurité et faites **Actions/Gérer les règles obsolètes**. Puis faites **Ajouter une règle**, par la suite suivre ces configurations :
Type = TCP personnalisé
Plage de ports = 22
Source = N'importe où + 0.0.0.0/0
Enfin **Enregistrer les règles**
#### Connexion aux VMs
Pour finir, une fois les règles ouvertes, faites la commande :
ssh -i <clécrééprécédemment> ubuntu@<adresseIP+nomdedomaine>
Afin de vous connecter aux VMs
