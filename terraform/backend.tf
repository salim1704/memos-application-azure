terraform {
  backend "azurerm" {
    resource_group_name  = "memos-tfstate-rg"
    storage_account_name = "memosb934htfstate"
    container_name       = "tfstate"
    key                  = "memos.tfstate"
  }
}