variable "zone" {
	description = "access zone"
	default = "ru-central1-a"
}

variable "token_oauth2" {
	description = "access token"
}
 
variable "cloud_id" {
	description = "cloud_id from yandex"
}

variable "folder_id" {
        description = "Folder from yandex console"
}

variable "image_id" {
	description = "alma linux 9"
        default = "fd88q0bhq1dnc8iro935"
        #image_id = "fd892a86kk3di19fco01"  rhel8.2
}

variable "image_deb" {
        description = "debian 12"
        default = "fd85al33fsnmk9u9pjj9" #"fd801rku4j14mv7fs703"  #debian12
}

variable "svc_acc_file" {
        description = "service_account_key_file . locate file with credentials"
        default = "../../key.json"
}
