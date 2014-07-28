SAMReports
==========

<#
.SYNOPSIS
	The SysAdmin Modular Reporting framework provides flexible data collection and 'traffic light' style alerts for your environment
	
.DESCRIPTION
	Using a modular plugin system, this report collates information from a series of sub-scripts, specific to the module chosen
	
	Get-SAMReport.ps1			This script, used to call all other scripts and join report together
	
	\_Assets
		00_Global_Variables.ps1		Top level variables, applicable for all module sets				<- Update this script accordingly
		01_Global_StyleSheet.ps1	Top level HTML stylesheet, applicable for all module sets
		02_Global_Functions.ps1		Top level functions, applicable for all module sets
		Scheduled Task Example.xml      Example task that can be imported into Task Scheduler
        
	\<module name>
		00 Module Variables.ps1         Module specific plugins, variables and overrides                <- Update this script accordingly
                01 Example Template.ps1		Get-Process demonstration showing example modular script format
	\Output					All generated output files for this module are saved here   
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
			Arguments:	 	-NonInteractive c:\Scripts\SAMReports\Get-SAMReport.ps1 Exchange
			Start in:		c:\Scripts\SAMReports\
	
	3. Ensure script is run manually at least once for each module. You will be prompted for your "Run As" credentials for that module
		- These will be saved for future (scheduled) use in a hashed xml file.
        
	4. Any script in the appropriate format in the module's subfolder will be included in the report
		- Scripts can be renumbered to define order. Rename the extension or simply move it to the zzz_ignore folder to exclude from report
	
.NOTES
	Script Name:	Get-SAMReport.ps1
	Created By: 	The Agreeable Cow
	Contact:	theagreeablecow@gmail.com
	Date: 		August 2012

.VERSION HISTORY
	1.0	Aug 2012    The Agreeable Cow		Original Build
        2.0     Jul 2014    The Agreeable Cow		Module expansions, customisation features and minor updates
  	
.CREDIT
	Report Stylesheet	Alan Renouf 	http://virtu-al.net (vCheck)
	Storage Functions 	ThomasMc 	http://vpowercli.wordpress.com/2012/01/23/vpowercli-v6-army-report/
	License Check		Arne Fokkema	http://xtravirt.com/powershell-veeam-br-%E2%80%93-get-total-days-before-license%C2%A0expires
	Charting		Sean Duffy	http://www.simple-talk.com/sysadmin/powershell/building-a-daily-systems-report-email-with-powershell/
#>
