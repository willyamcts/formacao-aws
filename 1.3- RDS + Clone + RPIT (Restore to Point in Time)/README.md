# Diagram

flowchart LR
    internet([clients]) -->|80| ec2[EC2 BIA-Web]

    ec2 -->|5432| db[(Aurora PostgreSQL)]

    sg1[SG EC2<br/>Inbound 80]
    sg2[SG DB<br/>Inbound 5432 from SG EC2]

    sg1 -.-> ec2
    sg2 -.-> db



# Creating CSV to populate DB

Usage `db-generate_csv.js` to generate 2M of records. To run:

```
node db-generate_csv.js
```



# Importing data to Postgres

Connect database in locally. Consider a restricted Security Group, allowing access only to BIA-Web on the database instance.

```
# port-forwarding via SSM
aws ssm start-session --target i-0140262f25477f754 --document-name AWS-StartPortForwardingSessionToRemoteHost --parameters '{"host":["bia-aurora.cluster-cqzmsio0yzwj.us-east-1.rds.amazonaws.com"],"portNumber":["5432"],"localPortNumber":["5432"]}'
```


To install postgres CLI. Is required to run the script of importation CSV to database.

```
# fix yum/dnf problem
sudo sed -i '1s|.*|#!/usr/bin/python3.9|' /usr/bin/dnf /usr/bin/yum
sudo ln -sf /usr/bin/python3.11 /usr/bin/python3


# install
sudo dnf install postgresql15
```



# Resize field from table

Install sequelize to resize apply

```
# install sequelize package
npm install --save-dev sequelize-cli
```

Run resize

```
cd bia
npx sequelize migration:generate --name rezise-title
```


Replace file content generated in `npx sequelize` command:

```
'use strict';

/** @type {import('sequelize-cli').Migration} */
'use strict';

module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.changeColumn('Tarefas', 'titulo', {
      type: Sequelize.STRING(200),
      allowNull: false,
    });
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.changeColumn('Tarefas', 'titulo', {
      type: Sequelize.STRING(255),
      allowNull: false,
    });
  }
};
```
