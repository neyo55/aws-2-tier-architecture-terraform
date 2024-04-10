# Assume you have already created the MySQL RDS instance and have the necessary configuration

# Define a table in the database to store the text files


# MySQL table creation script
resource "null_resource" "create_table" {
  depends_on = [aws_db_instance.db_1]

  provisioner "local-exec" {
    command = <<-EOT
      mysql -h ${aws_db_instance.db_1.endpoint} -u ${var.db_username} -p${var.db_password} -e "CREATE TABLE IF NOT EXISTS files (id INT AUTO_INCREMENT PRIMARY KEY, file_content BLOB);"
    EOT
  }
}

# Read the contents of the text file
locals {
  file_content = file("${path.module}file/textfile.txt")
}

# Store the text file contents in the database
resource "null_resource" "store_file_in_db" {
  depends_on = [null_resource.create_table]

  provisioner "local-exec" {
    command = <<-EOT
      echo '${base64encode(local.file_content)}' | mysql -h ${aws_db_instance.db_1.endpoint} -u ${var.db_username} -p${var.db_password} -e "INSERT INTO files (file_content) VALUES (FROM_BASE64(@@{stdin}));"
    EOT
  }
}