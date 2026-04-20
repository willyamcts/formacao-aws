wget https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks2022.bak

## MS SQL Server Docker

```
PASSWORD_DB="@PassWd3"
docker run --name sql -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=${PASSWORD_DB}" -p 1433:1433 -d mcr.microsoft.com/mssql/server:2022-latest

docker /tmp/AdventureWorks2022.bak /var/opt/mssql/data/
```

## Port forwarding via SSH

```
# mapeando porta remota via SSH
PORT_LOCAL=1435
PORT_REMOTE=1433
IP_INTERNAL=
HOST_BASTION=


ssh -f -N -i key-ssh.pem -L ${PORT_LOCAL}:${IP_INTERNAL}:${PORT_REMOTE} admin@${HOST_BASTION)
# map EC2 port itself
# ssh -f -N -i key-ssh.pem -L 1435:172.31.18.179:1433 admin@ec2-3-87-98-36.compute-1.amazonaws.com

# Map the RDS port from the EC2 bastion
ssh -f -N -i key-ssh.pem -L 1436:mssql-server.cqzmsio0yzwj.us-east-1.rds.amazonaws.com:1433 admin@ec2-3-87-98-36.compute-1.amazonaws.com
```



## Restore db...

### from file


```
# In databases > new script
RESTORE FILELISTONLY FROM DISK = 'AdventureWorks2022.bak'

RESTORE database AdventureWorks
From disk = 'AdventureWorks2022.bak'
with
   move 'AdventureWorks' to '/var/opt/mssql/data/AdventureWorks2022.mdf',
   move 'AdventureWorks_log' to '/var/opt/mssql/data/AdventureWorks2022_log.ldf'
```


### restore db from S3 bucket file

```
exec msdb.dbo.rds_restore_database
@restore_db_name='AdventureWorks',
@s3_arn_to_restore_from='arn:aws:s3:::asfags-bucket-mssql/AdventureWorks2022.bak';
```
