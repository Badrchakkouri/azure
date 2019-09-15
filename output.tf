output "public_IP" {
  value = "${azurerm_public_ip.project1_rg_pub.ip_address}"
}