# DeltaSquad Gym Database & Web App Project

## Objective

The goal of this case study was to demonstrate the steps required to build a database using a business case. Information about the business was derived from wireframes provided. Assumptions made through the analysis stage were reviewed and documented with the client.

To ensure tasks of group project were identified and prioritized accordingly, initial timeline created to organize project tasks. After discussion with group members to assign tasks, responsibilities chart was created and timeline updated for visibility to ensure responsibilities communicated clearly to group members. Timeline was then used to track project status with target milestones to avoid delays and preemptively flag timing concerns.

In addition to the design and development of the database, the group worked to deploy the database to the cloud to provide access for all members to work simultaneously on the project. A web app was also developed to demonstrate how the information is accessed from the database & web development skills.

## Skills Learned/Applied
- Project management & interpersonal skills in a group setting
- Analyzing case study & interpreting **entities**, **attributes** & **business relationships**
- Building **Enhanced Entity Relationship** (EER) & **Data Structure Diagram** (DSD) 
- **SQL code** to create database tables, input data and queries to retrieve relevant information
- Microsoft SQL Database server deployed to AWS’s RDS. Configuration included
  - Setting up secure remote access through AWS Systems Manager
  - Database roles and users & IAM
  - Instructions created for team members to connect to remote server
- **Web development**, including:
  - **HTML**
  - **CSS**
  - **JavaScipt** (**Node.js**, **Express**)

## Tools Used
- Microsoft SQL server for database server (testing web app locally)
- VS Code Integrated Development Environment (IDE)
- 

## To-Do:
- Create password table & update session code to compare POST with hash
- Update logout link in header
- Code for back link in header
- Create schedule page
- Update comments
- Review accessibility
- Deploy web app to cloud

## How to Deploy (locally):
- Install SQL Server & SQL Server Management Studio (SSMS)
- Choose windows authentication & set a strong password for admin setup
- Open SSMS, connect to default instance & create database for DeltaSquad Gym
- Under Databases/DeltaSquadDB/Security/Users, create database user & assign datareader & datawriter membership roles
- Under Security/Logins, create an application login & map to user
- Enable network access, under SQL Server Network Configuration/Protocols for your instance:
  - Enable TCP/IP
  - Open TCP/IP properties and select IP Addresses
  - Under IPAll, set a fixed TCP port, commonly 1433
  - Clear the dynamic port value if present
- Restart the SQL Server service
- If required, allow the port through the server firewall. On Windows PowerShell:
  ``New-NetFirewallRule `
    -DisplayName "SQL Server TCP 1433" `
    -Direction Inbound `
    -Protocol TCP `
    -LocalPort 1433 `
    -Action Allow``
- Populate database, open IDE:
  - Load sql file
  - Connnect to database (Ctl+Shift+C) & choose create connection
  - Enter profile name DeltaSquadDB
  - Enter name of server from SSMS
  - Click trust server certificate
  - Choose Windows Authentication
  - Enter database name
  - Choose encrypt mandatory
  - Click connect
- Execute code from SQL file
- Open command prompt:
  - Change to web app project directory and run npm install express ejs express-session -s
  - Run nodemon app
- Open web app in web browser at http:\//localhost:3000/gym
