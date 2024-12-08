output "kubeletid" {
  value = azurerm_kubernetes_cluster.main.kubelet_identity[0].client_id
}