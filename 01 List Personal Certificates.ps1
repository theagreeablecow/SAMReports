
############################################################################################################
#          Info         #
#------------------------

$Title = "Personal Certificates"
$Comment = "This script lists all personal certificates and highlights those that have expired or are expiring soon."
$Author = "The Agreeable Cow"
$PluginDate = "23/06/2014"
$Version = "v1.0"

#	1.0		23/06/2014	The Agreeable Cow	Original Build

############################################################################################################
#      Main Script      #
#------------------------

#Reset Variables
$stores = $null
$Certificates = $null
$ResultsText = $null		
$AlertText = $null
$WarningText = $null
$ResultsData = $null
$AlertData = $null
$WarningData = $null
$AlertCount = 0
$WarningCount = 0

#Reporting variables
$MaxDays = 1095
$WarnDays = 90
$AlertDays = 30

#Certificate Store Properties
$StoreLocation = "LocalMachine" #"LocalMachine","CurrentUser"
$StoreName = "My" 				#"My","CA","AuthRoot","Root"
$OpenFlag = "ReadWrite"			#"ReadOnly","ReadWrite"

#Purge Variable
$PurgeExpired = $False          #$True or $False
$PurgeDays = -90

#Create an Array and run query
$ResultsData = @()
foreach ($Server in $Servers) {
    if (Test-Connection -computername $Server -count 1 -quiet){
        $stores = New-Object System.Security.Cryptography.X509Certificates.X509Store("\\$Server\$StoreName",$StoreLocation)
        $stores.Open($OpenFlag)
        $Certificates = $stores.Certificates | Select FriendlyName, serialNumber, Issuer, Subject, @{Label="Expires";Expression={($_.NotAfter)}}, @{Label="Days";Expression={($_.NotAfter - (Get-Date)).Days}}
        
        Add-content -path $Logfile -value "Server: $Server"
        Add-content -path $Logfile -value "Store: $StoreLocation\$StoreName"
        Add-content -path $Logfile -value " "

        foreach ($Certificate in $Certificates) {
            
            #Build Report
            if ($Certificate.Issuer -ne $null -and $Certificate.days -lt $MaxDays){
                $obj = New-Object PSobject
                $obj | Add-Member -MemberType NoteProperty -name "Server" -value $Server
                $obj | Add-Member -MemberType NoteProperty -name "Name" -value $Certificate.FriendlyName
                $obj | Add-Member -MemberType NoteProperty -name "Issuer" -value $Certificate.Issuer
                $obj | Add-Member -MemberType NoteProperty -name "Subject" -value $Certificate.Subject
                $obj | Add-Member -MemberType NoteProperty -name "Expires" -value $Certificate.Expires
                $obj | Add-Member -MemberType NoteProperty -name "Days" -value $Certificate.Days
                $ResultsData += $obj

                # Update Text and Alert count based on your criteria
                $Name = $Certificate.FriendlyName
                $Days = $Certificate.Days

                if ($Days -lt 0){
                    $AlertText += "!RED!Alert: Certificate $Name on $Server has expired </br>"
                    $AlertCount += $AlertCount.count + 1			
                }
                elseif ($Days -lt $AlertDays){
                    $AlertText += "!RED!Alert: Certificate $Name on $Server is expiring in $Days days</br>"
                    $AlertCount += $AlertCount.count + 1			
                }
                elseif ($Days -lt $WarnDays){
                    $WarningText += "!ORANGE!Warning: Certificate $Name on $Server is expiring in $Days days</br>"
                    $WarningCount += $WarningCount.count + 1		
                }
            }
            
            #Log and Purge Old Certs
            If ($PurgeExpired -eq $True){
                
                $Name = $Certificate.FriendlyName
                $Issuer = $Certificate.Issuer
                $Subject = $Certificate.Subject
                $Expired = $Certificate.Expires
                $Days = $Certificate.Days
                $SerialNumber = $Certificate.serialNumber
                
                if ($Certificate.Issuer -ne $null -and $Certificate.days -lt $PurgeDays){
                    Add-content -path $Logfile -value "Name: $Name"
                    Add-content -path $Logfile -value "Issuer: $Issuer"
                    Add-content -path $Logfile -value "Subject: $Subject"
                    Add-content -path $Logfile -value "Expired: $Expired"
                    Add-content -path $Logfile -value "Days: $Days"
                    Add-content -path $Logfile -value " "
                    
                    $PurgeCert = $stores.Certificates.Find("FindBySerialNumber",$SerialNumber,$FALSE)[0]
                    $stores.Remove($PurgeCert)
                    $ExpiredCount += $ExpiredCount.count + 1
                }
            }
        }
    Add-content -path $Logfile -value "$Server Completed (Purge = $PurgeExpired). $ExpiredCount expired certificates deleted."
    Add-content -path $Logfile -value "-------------------------------------------------------------------"
    Add-content -path $Logfile -value " "
    $ExpiredCount = 0
    $stores.Close()
    }
}

If ($PurgeExpired -eq $True){
    $AlertText += "Purging is enabled for expired Certificates older than $PurgeDays days. See $logfile for details.  </br>"
}

# Results Text
if ($AlertText -ne $null -or $WarningText -ne $null){
	$ResultsText = $AlertText + $WarningText
}
else{
	$ResultsText = "All $StoreLocation certificates are not due to expire for more than $MaxDays days."
}

# Results Data
$ResultsData = $ResultsData | sort -Property "Days"

# Results Alert
if ($AlertCount -ge 1){
	$ResultsAlert = "Alert"
}
elseif ($WarningCount -ge 1){
	$ResultsAlert = "Warning"
}
else{
	$ResultsAlert = "Good"
}


############################################################################################################
#        Output         #
#------------------------

$OutText = $ResultsText							# $OutText MUST be either $ResultsText or ""  	Valid $ResultsText is any text string
$OutData = $ResultsData							# $OutData MUST be either $ResultsData or "" 	Valid $ResultsData is any data array
$OutAlert = $ResultsAlert						# $OutAlert MUST be either $ResultsAlert or "" 	Valid $ResultsAlert are 'Good', 'Warning' or 'Alert'
$Attachment = ""								# $Attachment MUST be either UNC path or ""
