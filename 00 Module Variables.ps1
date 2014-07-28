############################################################################################################
#   Module Variables - Certificates   #
#-------------------------------------#

# Customise report Variables
$EmailTo = $EmailTo
$EmailSubject = $EmailSubject
$ReportTitle = $ReportTitle
$ReportSubTitle = $ReportSubTitle

# Load required plug-ins
import-module ActiveDirectory

# Load server and array information
$Servers = Get-ADComputer -Filter {OperatingSystem -Like "Windows *Server*"} | select-object -expandproperty name

<#
    $OU = "OU=MyServers,DC=mydomain,DC=com,DC=au"
    $Servers = Get-ADComputer -Filter {OperatingSystem -Like "Windows *Server*"} -SearchBase $OU | Select-Object –ExpandProperty Name

    $Servers = @("Server1","Server2","Server3")
    $Servers = Get-Content .\<path>\servers.txt
    $Servers = ($env:COMPUTERNAME)
#>
    
#Miscellaneous 
$Logfile = $OutputFolder + "PurgedCerts_$Date.txt"
Add-content -path $Logfile -value "#############################################################################"
Add-content -path $Logfile -value "New Script Run on $Date"
Add-content -path $Logfile -value "Started by $ScriptUser on $ScriptComputer"
Add-content -path $Logfile -value "#############################################################################"
Add-content -path $Logfile -value " "

