<!-- TABLE OF CONTENTS -->
## Table of Contents
- [Table of Contents](#table-of-contents)
- [Introduction](#introduction)
- [Getting started](#Getting-started)
  - [Prerequisites](#Prerequisites)
  - [Connection settings](#Connection-settings)
  - [Contents](#Contents)
  - [Remarks](#Remarks)
- [Getting help](#getting-help)
- [HelloID Docs](#helloid-docs)


## Introduction
Make sure you have Windows PowerShell 5.1 installed on the server where the HelloID agent and Service Automation agent are running.

By using this connector you will have the ability to create AD groups based on data from the AFAS Profit HR system.


## Getting started

### Prerequisites

- [ ] Active Directory PowerShell module

  The Active Directory PowerShell module must be installed locally. The module can be installed by installing  [Remote Server Administration Tools (RSAT) for Windows](https://docs.microsoft.com/en-US/troubleshoot/windows-server/system-management-components/remote-server-administration-tools).

- [ ] Windows PowerShell 5.1

  Windows PowerShell 5.1 must be installed on the server where the 'HelloID Directory agent and Service Automation agent' are running.

  > The connector is compatible with older versions of Windows PowerShell. Although we cannot guarantuee the compatibility.

- [ ] AFAS App Token

  Connecting to Profit is done using the app connector system.
  Please see the following pages from the AFAS Knowledge Base for more information.
  
  - [Create the APP connector](https://help.afas.nl/help/NL/SE/App_Apps_Custom_Add.htm)
  - [Manage the APP connector](https://help.afas.nl/help/NL/SE/App_Apps_Custom_Maint.htm)
  - [Manual add a token to the APP connector](https://help.afas.nl/help/NL/SE/App_Apps_Custom_Tokens_Manual.htm)

- [ ] AFAS GetConnector Tools4ever - HelloID - T4E_HelloID_OrganizationalUnits

  The interface to communicate with Profit is through a set of GetConnectors, which is component that allows the creation of custom views on the Profit data. GetConnectors are based on a pre-defined 'data collection', which is an existing view based on the data inside the Profit database. 
  
  For this connector we have created a default set, which can be imported directly into the AFAS Profit environment.
  
  The following GetConnectors are required by HelloID: 
  -	Tools4ever - HelloID - T4E_HelloID_OrganizationalUnits

### Connection settings

The connection settings are defined in the automation variables.
 1. Create the following [user defined variables](https://docs.helloid.com/hc/en-us/articles/360014169933-How-to-Create-and-Manage-User-Defined-Variables)

| Variable name                   | Example value                                                | Description                                                  |
| ------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| AFASBaseUri                     | https://12345.rest.afas.online/ProfitRestServices            | Base URI of the AFAS REST API endpoint for this environment  |
| AFASToken                       | \<token>\<version>1\</version>\<data>D5R324DD5F4TRD945E530ED3CDD70D94BBDEC4C732B43F285ECB12345678\</data>\</token>            | App token in XML format for this environment       


## contents

| File/Directory                                             | Description                                                  |
| ---------------------------------------------------------- | ------------------------------------------------------------ |
| Sync AFAS Organizational Units to AD Groups.ps1            | Synchronizes the AFAS data to AD groups                      |
| Tools4ever - HelloID - T4E_HelloID_OrganizationalUnits.gcn | AFAS GetConnector to provide all Organizational Units        | 

## Remarks
- The groups are only created, no update or deletion will take place.
  
> When a group already exists, the group will be skipped (no update will take place).

## Getting help
> _For more information on how to configure a HelloID PowerShell scheduled task, please refer to our [documentation](https://docs.helloid.com/hc/en-us/articles/115003253294-Create-Custom-Scheduled-Tasks) pages_

> _If you need help, feel free to ask questions on our [forum](https://forum.helloid.com)_

## HelloID Docs
The official HelloID documentation can be found at: https://docs.helloid.com/
