variable "rds_db_username" {
  type = string
  description = "This is the database username of RDS"
  sensitive = true
}

variable "rds_db_password" {
  type = string
  description = "This is the database password of RDS"
  sensitive = true  
}

variable "repo_name" {
  type = list(string)
  description = "This is the repository name"  
  
}

variable "db_schema_name" {
  type = string
  description = "This is the database username of RDS"
  sensitive = true
}

variable "jwt_secret" {
  type = string
  description = "This is the database username of RDS"
  sensitive = true
}


