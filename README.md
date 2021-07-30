<!-- TABLE OF CONTENTS -->
## Table of Contents
- [Table of Contents](#table-of-contents)
- [Introduction](#introduction)
- [Getting Started](#getting-started)
- [Post-setup configuration](#post-setup-configuration)
- [Getting help](#getting-help)
- [HelloID Docs](#helloid-docs)


## Introduction
The interface to communicate with Profit is through a set of GetConnectors, which is component that allows the creation of custom views on the Profit data. GetConnectors are based on a pre-defined 'data collection', which is an existing view based on the data inside the Profit database. 

For this connector we have created a default set, which can be imported directly into the AFAS Profit environment.

<!-- GETTING STARTED -->
## Getting Started

By using this connector you will have the ability to create AD groups based on data from the AFAS Profit HR system.

Connecting to Profit is done using the app connector system. 
Please see the following pages from the AFAS Knowledge Base for more information.

[Create the APP connector](https://help.afas.nl/help/NL/SE/App_Apps_Custom_Add.htm)

[Manage the APP connector](https://help.afas.nl/help/NL/SE/App_Apps_Custom_Maint.htm)

[Manual add a token to the APP connector](https://help.afas.nl/help/NL/SE/App_Apps_Custom_Tokens_Manual.htm)


The following GetConnectors are required by HelloID: 
*	Tools4ever - HelloID - T4E_HelloID_OrganizationalUnits

## Post-setup configuration
The following items need to be configured according to your own environment
 1. Update the following [user defined variables](https://docs.helloid.com/hc/en-us/articles/360014169933-How-to-Create-and-Manage-User-Defined-Variables)
<table>
  <tr><td><strong>Variable name</strong></td><td><strong>Example value</strong></td><td><strong>Description</strong></td></tr>
  <tr><td>AFASBaseUri</td><td>https://12345.rest.afas.online/ProfitRestServices</td><td>Base URI of the AFAS REST API endpoint for this environment</td></tr>
<tr><td>AFASToken</td><td><token><version>1</version><data>D5R324DD5F4TRD945E530ED3CDD70D94BBDEC4C732B43F285ECB12345678</data></token></td><td>App token in XML format for this environment</td></tr>
</table>

## Getting help
> _For more information on how to configure a HelloID PowerShell scheduled task, please refer to our [documentation](https://docs.helloid.com/hc/en-us/articles/115003253294-Create-Custom-Scheduled-Tasks) pages_

> _If you need help, feel free to ask questions on our [forum](https://forum.helloid.com)_

## HelloID Docs
The official HelloID documentation can be found at: https://docs.helloid.com/
