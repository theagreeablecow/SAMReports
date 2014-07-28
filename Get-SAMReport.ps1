<#
.SYNOPSIS
	The SysAdmin Modular Reporting framework provides flexible data collection and 'traffic light' style alerts for your environment
	
.DESCRIPTION
	Using a modular plugin system, this report collates information from a series of sub-scripts, specific to the module chosen
	
	Get-SAMReport.ps1					        This script, used to call all other scripts and join report together
	
	\_Assets
		00_Global_Variables.ps1					Top level variables, applicable for all module sets				<- Update this script accordingly
		01_Global_StyleSheet.ps1				Top level HTML stylesheet, applicable for all module sets
		02_Global_Functions.ps1					Top level functions, applicable for all module sets
		Scheduled Task Example.xml              Example task that can be imported into Task Scheduler
        
	\<module name>
		00 Module Variables.ps1                 Module specific plugins, variables and overrides                <- Update this script accordingly
        01 Example Template.ps1					Get-Process demonstration showing example modular script format
		\Output									All generated output files for this module are saved here   
        \zzz_Ignore                             Items in here will not be processed or run
	
		
.USAGE
	1. Modify the scripts in the Assets folder according to your environment
	
	2. This script is currently designed to be run from a server with the relevant module's management tools and powershell plugins installed locally
			
		Syntax
			Get-SAMReport [[-module] <string>] [[-output] <Email/OnScreen>]
		
		Example
			Get-SAMReport Veeam Email 
			
		Scheduled Task Action settings
			Start a program: 	C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
			Arguments:	 		-NonInteractive c:\Scripts\SAMReports\Get-SAMReport.ps1 Exchange
			Start in:			c:\Scripts\SAMReports\
	
	3. Ensure script is run manually at least once for each module. You will be prompted for your "Run As" credentials for that module
		- These will be saved for future (scheduled) use in a hashed xml file.
        
	4. Any script in the appropriate format in the module's subfolder will be included in the report
		- Scripts can be renumbered to define order. Rename the extension or simply move it to the zzz_ignore folder to exclude from report
	
.NOTES
	Script Name:	Get-SAMReport.ps1
	Created By: 	The Agreeable Cow
	Contact:		theagreeablecow@gmail.com
	Date: 			August 2012

.VERSION HISTORY
	1.0		Aug 2012	The Agreeable Cow		Original Build
    2.0     Jul 2014    The Agreeable Cow		Module expansions, customisation features and minor updates
	
.CREDIT
	Report Stylesheet	Alan Renouf 	http://virtu-al.net (vCheck)
	Storage Functions 	ThomasMc 		http://vpowercli.wordpress.com/2012/01/23/vpowercli-v6-army-report/
	License Check		Arne Fokkema	http://xtravirt.com/powershell-veeam-br-%E2%80%93-get-total-days-before-license%C2%A0expires
	Charting			Sean Duffy		http://www.simple-talk.com/sysadmin/powershell/building-a-daily-systems-report-email-with-powershell/
#>


#----------------------------------------------------------------------------------------------------------------
# Variables
$ScriptPath = (Split-Path ((Get-Variable MyInvocation).Value).MyCommand.Path) + "\"
$ModuleArray = @(Get-ChildItem -exclude "_*" | where { $_.PSIsContainer} | ForEach-Object { $_.Name })
$OutputArray=@("OnScreen","Email")
$TranscriptLog = $True
$Date = get-date -f yyyy-MM-dd
#----------------------------------------------------------------------------------------------------------------


# Run SAM Report
Function get-SAMReport{
    [CmdletBinding()]
	Param( 
		[Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName = $true,Position=0)] 
		[String] $Module="",

		[Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName = $true,Position=1)] 
		[String] $Output="email"
	) 
    
    Begin{
		#Logging
		if ($TranscriptLog -eq $True){
			$Logfile = $ScriptPath + "SAMReport.log"
			Start-Transcript -path $Logfile -append
		}
			
		# Assets Folder
		$AssetsFolder = $ScriptPath + "_Assets\"
		$Assets = Get-ChildItem -Path $AssetsFolder -filter "*.ps1" | Sort Name
		Foreach ($Asset in $Assets) { 
			. $Asset.Fullname
		}

		# Module Folder
		$ModulesFolder = $ScriptPath + $module + "\"
		$Modules = Get-ChildItem -Path $ModulesFolder -filter "*.ps1" | Sort Name
		
		# Output Folder
		$OutputFolder = $ModulesFolder + "Output\"
		IF (!(TEST-PATH $OutputFolder)) {NEW-ITEM $OutputFolder -type Directory}
        
        # Ignore Folder
		$IgnoreFolder = $ModulesFolder + "zzz_Ignore\"
		IF (!(TEST-PATH $IgnoreFolder)) {NEW-ITEM $IgnoreFolder -type Directory}
		
		# Credentials
		$Credentials = Get-MyCredential (join-path ($ModulesFolder) ModuleCredentials.xml)
	}    
    
    Process{
		$OutReport = Get-ReportHeaderHTML "$Module Modular Report"
		$AllAttachments = @()

		# Call each plugin
		Foreach ($script in $Modules) { 
			. $script.Fullname

			# Footer
			$OutFooter = "<div style='font-family:Arial, Helvetica, sans-serif; font-size:9px; color:#bbbbbb'>" + $script.name + " " + $Author + " " + $PluginDate + " (" + $Version + ")</br></br>"
			
			# Text and Data 
			if ($OutText -AND $OutData) {
				$OutReport += Get-CustomHeader $Title $Comment $OutAlert
				$OutReport += Get-HTMLText $OutText
				$OutReport += "</br>"
				$OutReport += Get-HTMLTable $OutData
				$OutReport += Get-CustomHeaderClose $OutFooter
			}
			elseif ($OutText) {
				$OutReport += Get-CustomHeader $Title $Comment $OutAlert
				$OutReport += Get-HTMLText $OutText
				$OutReport += Get-CustomHeaderClose $OutFooter
			}
			elseif ($OutData) {
				$OutReport += Get-CustomHeader $Title $Comment $OutAlert
				$OutReport += Get-HTMLTable $OutData
				$OutReport += Get-CustomHeaderClose $OutFooter
			}
			$OutReport += Get-CustomHeader0Close
			$OutReport += Get-CustomHTMLClose
			
			# Attachments
			if (!$attachment -eq ""){
				$AllAttachments += $Attachment 
			}
			
			# Count OutAlerts
			if ($OutAlert -eq "Good"){
				$GoodStatus += $GoodStatus.count + 1
			}
			elseif ($OutAlert -eq "Warning"){
				$WarningStatus += $WarningStatus.count + 1
			}			
			elseif ($OutAlert -eq "Alert"){
				$AlertStatus += $AlertStatus.count + 1
			}	
			
			# Reset Fields
			$ResultsText = ""
			$ResultsData = ""
			$ResultsAlert = ""
			$OutText = ""
			$OutData = ""
			$OutAlert = ""
		}
	}
		
	End{
		# Apply Global Banner Status Colours
		if ($AlertStatus -ge 1){
			$OutReport = $OutReport -replace ("#BANNER_MARKER#",$AlertTitleColour)
		}
		elseif ($WarningStatus -ge 1){
			$OutReport = $OutReport -replace ("#BANNER_MARKER#",$WarningTitleColour)
		}
		else{
			$OutReport = $OutReport -replace ("#BANNER_MARKER#",$GoodTitleColour)
		}

		# Update Colour Formatting for Text
		$OutReport = $OutReport -replace ("!GREEN!","<span style='color:green'>")
		$OutReport = $OutReport -replace ("!ORANGE!","<span style='color:orange'>")
		$OutReport = $OutReport -replace ("!RED!","<span style='color:red'>")
		
		if ($module -eq "Veeam") {
			$OutReport = $OutReport -replace ("01/01/1900 00:00:00","")
			$OutReport = $OutReport -replace ("Success:","<span style='color:green'>Success")
			$OutReport = $OutReport -replace ("InProgress:","<span style='color:orange'>InProgress")
			$OutReport = $OutReport -replace ("Pending:","<span style='color:orange'>Pending")
			$OutReport = $OutReport -replace ("Warning:","<span style='color:orange'>Warning")
			$OutReport = $OutReport -replace ("Error:","<span style='color:red'>Error:")
			$OutReport = $OutReport -replace ("Unknown:","<span style='color:red'>Unknown:")
			$OutReport = $OutReport -replace ("Failed","<span style='color:red'>Failed")
			$OutReport = $OutReport -replace ("Stopped","<span style='color:red'>Stopped")
		}

		# Output Report
		if ($output -eq "OnScreen"){
				$Filename = $Env:TEMP + "\" + $Module + "_" + $Date + ".htm"
				$OutReport | out-file -encoding ASCII -filepath $Filename
				Invoke-Item $Filename
		}
		elseif ($output -eq "Email"){
			if ($AllAttachments) {
				Send-MailMessage -To $EmailTo -From $EmailFrom -Subject $EmailSubject -SmtpServer $SmtpServer -body $OutReport -BodyAsHtml -attachment $AllAttachments
			}
			else {
				Send-MailMessage -To $EmailTo -From $EmailFrom -Subject $EmailSubject -SmtpServer $SmtpServer -body $OutReport -BodyAsHtml
			}
		}
		
		# Close Log
		if ($TranscriptLog -eq $True){
			Stop-Transcript
			$Format = Get-Content $Logfile
			$Format > $Logfile
		}
	}
}

# Module Validation
$HelpText = @"

    Missing or invalid arguments. Correct syntax is Get-SAMReport.ps1 <module> <output>
 
        Valid modules are: $ModuleArray
    
        Valid outputs are: $OutputArray

    For example Get-SAMReport.ps1 Exchange OnScreen
 
"@

if ($args[0] -ne $NULL){
	$ModuleCheck = $ModuleArray -contains $args[0]
	if ($ModuleCheck -eq $false){
		write-host $HelpText
		exit
	}
	else{
		$Module = $args[0]
	}
}
else{
	write-host $HelpText
	exit
}

# Output Validation
if ($args[1] -ne $NULL){
	$OutputCheck = $OutputArray -contains $args[1]
	if ($OutputCheck -eq $false){
		write-host $HelpText
		exit
	}
	else{
		$Output = $args[1]
	}
}
else{
	$Output = "Email"
}

get-SAMReport $Module $Output 
