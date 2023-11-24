SET aad_auth_validate_oids_in_tenant = OFF;
DROP USER IF EXISTS 'mysql_conn'@'%';
CREATE AADUSER 'mysql_conn' IDENTIFIED BY 'f97d53ae-49ed-4f82-8e1d-bd38a908f2f3';
GRANT ALL PRIVILEGES ON petclinic.* TO 'mysql_conn'@'%';
FLUSH privileges;
