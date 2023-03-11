resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

}
resource "aws_subnet" "public_subnet" {
  count             = length(var.public_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_cidr[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    name = "public_subnet${count.index}"
  }

}

resource "aws_subnet" "private_subnet" {
  count             = length(var.private_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_cidr[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = {
    name = "private_subnet${count.index}"
  }
}



resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}


resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table" "private_route_table" {
  count  = length(var.private_cidr)
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[count.index].id
  }
}



resource "aws_eip" "elastic_ip_adress_nat_gw" {
  count = length(var.private_cidr)
  vpc   = true
}


resource "aws_nat_gateway" "nat" {
  count         = length(var.private_cidr)
  allocation_id = aws_eip.elastic_ip_adress_nat_gw[count.index].id
  subnet_id     = aws_subnet.public_subnet[count.index].id
}



resource "aws_route_table_association" "public_association" {
  count          = length(var.public_cidr)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}


resource "aws_route_table_association" "private_association" {
  count          = length(var.private_cidr)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table[count.index].id
}





