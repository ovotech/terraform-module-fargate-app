#--------------------------------------------------------------
# General
#--------------------------------------------------------------
region          = "eu-west-1"
environment     = "nonprod"
cms_environment = "uat"
team            = "DSE - Digital Support Experience"

#--------------------------------------------------------------
# Network
#--------------------------------------------------------------
vpc_cidr = "10.144.11.0/24"

public_cidr             = "10.144.11.0/26"
private_cidr            = "10.144.11.64/26"
protected_cidr          = "10.144.11.128/26"
public_subnet_a_cidr    = "10.144.11.0/28"
public_subnet_a_az      = "eu-west-1a"
public_subnet_b_cidr    = "10.144.11.16/28"
public_subnet_b_az      = "eu-west-1b"
public_subnet_c_cidr    = "10.144.11.32/28"
public_subnet_c_az      = "eu-west-1c"
private_subnet_a_cidr   = "10.144.11.64/28"
private_subnet_a_az     = "eu-west-1a"
private_subnet_b_cidr   = "10.144.11.80/28"
private_subnet_b_az     = "eu-west-1b"
private_subnet_c_cidr   = "10.144.11.96/28"
private_subnet_c_az     = "eu-west-1c"
protected_subnet_a_cidr = "10.144.11.128/28"
protected_subnet_a_az   = "eu-west-1a"
protected_subnet_b_cidr = "10.144.11.144/28"
protected_subnet_b_az   = "eu-west-1b"
protected_subnet_c_cidr = "10.144.11.160/28"
protected_subnet_c_az   = "eu-west-1c"

office_cidr = "10.0.0.0/8"

ovo_transit_gateway_id = "tgw-0f6aa8c3ecdb178a0"
#--------------------------------------------------------------
# Elasticsearch
#--------------------------------------------------------------
elasticsearch_instance_count           = 2
elasticsearch_instance_type            = "r5.large.elasticsearch"
elasticsearch_zone_awareness           = true
elasticsearch_master_count             = 0
elasticsearch_dedicated_master_enabled = false
elasticsearch_master_type              = "r5.large.elasticsearch"