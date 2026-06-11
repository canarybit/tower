resource "aws_security_group" "default" {
  name = var.cvm_name
}

resource "aws_security_group_rule" "ssh" {
  count = var.cvm_ssh_enabled ? 1 : 0
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = var.cvm_ssh_source_ip != null ? ["${var.cvm_ssh_source_ip}/32"] : ["${chomp(data.http.my-public-ip.response_body)}/32"]
  security_group_id = aws_security_group.default.id
}

resource "aws_security_group_rule" "custom-ingress" {
  count = var.cvm_ports_open != "" ? length(var.cvm_ports_open) : 0
  type = "ingress"
  from_port = element(var.cvm_ports_open, count.index)
  to_port = element(var.cvm_ports_open, count.index)
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.default.id
}

resource "aws_security_group_rule" "default-egress" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.default.id
}