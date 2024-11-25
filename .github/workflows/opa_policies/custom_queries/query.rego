package Cx
import input.document


CxPolicy[result] {
    some i
    file := document[i].file
    id := document[i].id
    resource := document[i].resource
    azurerm_key_vault :=  resource["azurerm_key_vault"].key_vault
    not azurerm_key_vault.network_acls.default_action == "Deny"
    result := {
            "documentId": id,
            "searchKey": sprintf("%s", [resource]),
            "issueType": "InsecureNetworkConfig",
            "keyExpectedValue": "Insecure network configuration for Key Vault",
            "keyActualValue":sprintf("Insecure network configuration for Key Vault in file %s (ID: %s)", [file, id])

        }

}
