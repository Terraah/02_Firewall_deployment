provider "null" {}

resource "null_resource" "guaca" {
  provisioner "local-exec" {
    command = <<EOT
    # Exemple de commande pour créer la VM
    # Utilisation d'un outil tel que `qm` pour créer la VM directement sur Proxmox via un script

    # Cloner la VM en utilisant qm (commande Proxmox)
    qm clone 101 5002 --name "guacamole" --full --storage "production"

    # Configuration des ressources pour la VM clonée
    qm set 5002 --cores 2 --memory 2048 --net0 virtio,bridge=vmbr0 --scsihw virtio-scsi-pci
    qm set 5002 --bootdisk scsi0
    qm set 5002 --ipconfig0 ${var.ipconfig0}
    qm set 5002 --ipconfig1 ${var.ipconfig1}
    
    # Configuration DNS, Cloud-Init, utilisateur, mot de passe et clé SSH
    qm set 5002 --searchdomain ${var.searchdomain}
    qm set 5002 --nameserver ${var.nameserver}
    qm set 5002 --ciuser ${var.ci_user}
    qm set 5002 --cipassword ${var.ci_mdp}
    qm set 5002 --sshkeys ${var.ssh_key_pub}

    # Attendre un peu pour que la VM soit configurée (facultatif)
    sleep 5
    EOT
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}

# Variables pour Cloud-Init et autres configurations
variable "ci_user" {
  description = "Nom de l'utilisateur Cloud-Init"
  type        = string
}

variable "ci_mdp" {
  description = "Mot de passe de l'utilisateur Cloud-Init"
  type        = string
}

variable "ssh_key_pub" {
  description = "Clé publique SSH pour l'utilisateur"
  type        = string
}

variable "ipconfig0" {
  description = "Configuration réseau de la VM (interface 0)"
  type        = string
}

variable "ipconfig1" {
  description = "Configuration réseau de la VM (interface 1)"
  type        = string
}

variable "searchdomain" {
  description = "Domaine de recherche DNS"
  type        = string
}

variable "nameserver" {
  description = "Serveur DNS"
  type        = string
}

