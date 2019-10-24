//the public IP is printed after the apply so that we can access the web page later
output "public_IP" {
  value = "${azurerm_public_ip.project1_rg_pub.ip_address}"
}