#Region Script
# AFAS Profit Parameters
$baseUri = $AFASBaseUri
$token = $AFASToken

$path = "OU=OrganizationalUnits,OU=Security Groups,DC=enyoi,DC=local"
$adGroupNamePrefix = "HelloID-Department-"
$adGroupNameSuffix = ""
$adGroupDescriptionPrefix = "Security Group for "
$adGroupDescriptionSuffix = ""

$debug = $true

# Set TLS to accept TLS, TLS 1.1 and TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls -bor [Net.SecurityProtocolType]::Tls11 -bor [Net.SecurityProtocolType]::Tls12

function Get-AFASConnectorData
{
    param(
        [parameter(Mandatory=$true)]$Token,
        [parameter(Mandatory=$true)]$BaseUri,
        [parameter(Mandatory=$true)]$Connector,
        [parameter(Mandatory=$true)][ref]$data
    )

    try {
        $encodedToken = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($Token))
        $authValue = "AfasToken $encodedToken"
        $Headers = @{ Authorization = $authValue }

        $take = 100
        $skip = 0

        $uri = $BaseUri + "/connectors/" + $Connector + "?skip=$skip&take=$take"
        $counter = 0 
        do {
            if ($counter -gt 0) {
                $skip += 100
                $uri = $BaseUri + "/connectors/" + $Connector + "?skip=$skip&take=$take"
            }    
            $counter++
            [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;
            $dataset = Invoke-RestMethod -Method GET -Uri $uri -ContentType "application/json" -Headers $Headers #-UseBasicParsing

            foreach ($record in $dataset.rows) { $null = $data.Value.add($record) }

        }until([string]::IsNullOrEmpty($dataset.rows))
    } catch {
        $data.Value = $null
        throw $_
    }
}

#region Supporting Functions
function Get-ADSanitizeGroupName
{
    param(
        [parameter(Mandatory = $true)][String]$Name
    )
    $newName = $name.trim();
    $newName = $newName -replace ' - ','_'
    $newName = $newName -replace '[`,~,!,#,$,%,^,&,*,(,),+,=,<,>,?,/,'',",;,:,\,|,},{,.]',''
    $newName = $newName -replace '\[','';
    $newName = $newName -replace ']','';
    $newName = $newName -replace ' ','_';
    $newName = $newName -replace '\.\.\.\.\.','.';
    $newName = $newName -replace '\.\.\.\.','.';
    $newName = $newName -replace '\.\.\.','.';
    $newName = $newName -replace '\.\.','.';
    return $newName;
}
#endregion Supporting Functions

try{
    Hid-Write-Status -Event "Information" -Message "Processing T4E_HelloID_OrganizationalUnits.."
    $organizationalUnits = [System.Collections.ArrayList]::new()
    Get-AFASConnectorData -Token $token -BaseUri $baseUri -Connector "T4E_HelloID_OrganizationalUnits" ([ref]$organizationalUnits)

    $departments = $organizationalUnits | Sort-Object ExternalId -Unique | Sort-Object ExternalId, DisplayName
    foreach($department in $departments){
        try{
            # The names of security principal objects can contain all Unicode characters except the special LDAP characters defined in RFC 2253.
            # This list of special characters includes: a leading space; a trailing space; and any of the following characters: # , + " \ < > ;
            # A group account cannot consist solely of numbers, periods (.), or spaces. Any leading periods or spaces are cropped.
            # https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2003/cc776019(v=ws.10)?redirectedfrom=MSDN
            # https://www.ietf.org/rfc/rfc2253.txt
            $ADGroupName = ("$adGroupNamePrefix$($department.ExternalId)$adGroupNameSuffix")
            $ADGroupName = Get-ADSanitizeGroupName -Name $ADGroupName

            $ADGroupParams = @{
                Name                = $ADGroupName
                SamAccountName      = $ADGroupName
                GroupCategory       = "Security"
                GroupScope          = "Universal"
                DisplayName         = $ADGroupName
                Path                = $path
                Description         = "$adGroupDescriptionPrefix$($ADGroupName)$adGroupDescriptionSuffix"
            }

            $ADGroup = $null
            $distinguishedName = "CN=$ADGroupName,$($ADGroupParams.Path)"
            $ADGroup = Get-ADGroup -Filter { DistinguishedName -eq $distinguishedName }
            if($ADGroup){
                if($debug -eq $true){ Hid-Write-Status -Event "Warning" -Message "AD Group $($distinguishedName) already exists" }
            }else{
                $NewADGroup = New-ADGroup @ADGroupParams
                if($debug -eq $true){ Hid-Write-Status -Event "Success" -Message "AD Group $($distinguishedName) created successfully" }
            }
        }catch{
            Hid-Write-Status -Event "Error" -Message "$($ADGroupParams | Out-String)"
            throw $_
        }
    }
    Hid-Write-Summary -Event "Success" -Message "Successfully synchronized $($departments.Count) AFAS Organizational Units to AD Groups"
}catch{
    throw $_
}