output "frontend" { value = aws_instance.client.private_ip }

output "haproxy" { value = aws_instance.haproxy.public_ip }

output "auth" { value = aws_instance.auth.private_ip }

output "discount" { value = aws_instance.discounts.private_ip }

output "items" { value = aws_instance.items.private_ip }