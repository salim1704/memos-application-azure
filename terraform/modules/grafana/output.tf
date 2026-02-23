output "grafana_endpoint" {
  description = "Grafana dashboard URL"
  value       = azurerm_dashboard_grafana.main.endpoint
}