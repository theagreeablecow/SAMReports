############################################################################################################
#  Manage Credentials    #
#------------------------

function Get-MyCredential
{
param(
	$CredPath,
	[switch]$Help
)
$HelpText = @"

    Get-MyCredential
    Usage:
    Get-MyCredential -CredPath <[CredPath]>
	
	eg  $Credentials = Get-MyCredential (join-path ($ScriptPath) Syncred.xml)

    If a credential is stored in $CredPath, it will be used.
    If no credential is found, Export-Credential will start and offer to
    Store a credential at the location specified.

"@
    if($Help -or (!($CredPath))){write-host $Helptext; Break}
    if (!(Test-Path -Path $CredPath -PathType Leaf)) {
        Export-Credential (Get-Credential) $CredPath
    }
    $cred = Import-Clixml $CredPath
    $cred.Password = $cred.Password | ConvertTo-SecureString
    $Credential = New-Object System.Management.Automation.PsCredential($cred.UserName, $cred.Password)
    Return $Credential
}

function Export-Credential($cred, $path) {
      $cred = $cred | Select-Object *
      $cred.password = $cred.Password | ConvertFrom-SecureString
      $cred | Export-Clixml $path
}


############################################################################################################
#    Veeam  Functions    #
#------------------------

# Functin credit to ThomasMc http://vpowercli.wordpress.com/2012/01/23/vpowercli-v6-army-report/
function Get-vPCRepoInfo {
[CmdletBinding()]
	param (
		[Parameter(Position=0, ValueFromPipeline=$true)]
		[PSObject[]]$Repository
		)
	Begin {
		$outputAry = @()
		[Reflection.Assembly]::LoadFile("C:\Program Files\Veeam\Backup and Replication\Veeam.Backup.Common.dll") | Out-Null
		function Build-Object {param($name, $path, $free, $total)
			$repoObj = New-Object -TypeName PSObject -Property @{
					Target = $name
					Storepath = $path
					StorageFree = [Math]::Round([Decimal]$free/1GB,2)
					StorageTotal = [Math]::Round([Decimal]$total/1GB,2)
					FreePercentage = [Math]::Round(($free/$total)*100)
				}
			return $repoObj | Select Target, Storepath, StorageFree, StorageTotal, FreePercentage
		}
	}
	Process {
		foreach ($r in $Repository) {
			if ($r.GetType().Name -eq [String]) {
				$r = Get-VBRBackupRepository -Name $r
			}
			if ($r.Type -eq "WinLocal") {
				$Server = $r.GetHost()
				$FileCommander = [Veeam.Backup.Core.CRemoteWinFileCommander]::Create($Server.Info)
				$storage = $FileCommander.GetDrives([ref]$null) | ?{$_.Name -eq $r.Path.Substring(0,3)}
				$outputObj = Build-Object $r.Name $r.Path $storage.FreeSpace $storage.TotalSpace
			}
			elseif ($r.Type -eq "LinuxLocal") {
				$Server = $r.GetHost()
				$FileCommander = new-object Veeam.Backup.Core.CSshFileCommander $server.info
				$storage = $FileCommander.FindDirInfo($r.Path)
				$outputObj = Build-Object $r.Name $r.Path $storage.FreeSpace $storage.TotalSize
			}
			elseif ($r.Type -eq "CifsShare") {
				$fso = New-Object -Com Scripting.FileSystemObject
				$storage = $fso.GetDrive($r.Path)
				$outputObj = Build-Object $r.Name $r.Path $storage.AvailableSpace $storage.TotalSize
			}
			$outputAry = $outputAry + $outputObj
		}
	}
	End {
		$outputAry
	}
}

# Functin credit to ThomasMc http://vpowercli.wordpress.com/2012/01/23/vpowercli-v6-army-report/
function Get-vPCReplicaTarget {
[CmdletBinding()]
	param(
		[Parameter(Position=0)]
		[String]$Name,
		
		[Parameter(Position=1, ValueFromPipeline=$true)]
		[PSObject[]]$InputObj
	)
	BEGIN {
		$outputAry = @()
		$dsAry = @()
		if (($Name -ne $null) -and ($InputObj -eq $null)) {
			$InputObj = Get-VBRJob -Name $Name
		}
	}
	PROCESS {
		foreach ($obj in $InputObj) {
			if (($dsAry -contains $obj.ViReplicaTargetOptions.DatastoreName) -eq $false) {
				$esxi = $obj.GetTargetHost()
				$dtstr =  $esxi | Find-VBRDatastore -Name $obj.ViReplicaTargetOptions.DatastoreName	
				$objoutput = New-Object -TypeName PSObject -Property @{
					Target = $esxi.Name
					Datastore = $obj.ViReplicaTargetOptions.DatastoreName
					StorageFree = [Math]::Round([Decimal]$dtstr.FreeSpace/1GB,2)
					StorageTotal = [Math]::Round([Decimal]$dtstr.Capacity/1GB,2)
					FreePercentage = [Math]::Round(($dtstr.FreeSpace/$dtstr.Capacity)*100)
				} 
				$dsAry = $dsAry + $obj.ViReplicaTargetOptions.DatastoreName
				$outputAry = $outputAry + $objoutput
			}
			else {
				return
			}
		}
	}
	END {
		$outputAry | Select Target, Datastore, StorageFree, StorageTotal, FreePercentage
	}
}

# Get the current product version of Veeam 
function Get-VeeamVersion {
	$veeamExe = Get-Item 'C:\Program Files\Veeam\Backup and Replication\Veeam.Backup.Manager.exe'
	$VeeamVersion = $veeamExe.VersionInfo.ProductVersion
	Return $VeeamVersion
}


############################################################################################################
#        Visuals        #
#------------------------


Function Get-Base64Image ($Path) {
	$pic = Get-Content $Path -Encoding Byte
	[Convert]::ToBase64String($pic)
}

# Function credit to Sean Duffy http://www.simple-talk.com/sysadmin/powershell/building-a-daily-systems-report-email-with-powershell/
# NB Required MS Chart Controls for .NET 3.5 installed (http://www.microsoft.com/en-us/download/details.aspx?id=14422)

Function Create-PieChart() {
	param([string]$FileName)
		  
	[void][Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
	[void][Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms.DataVisualization")

	#Create chart object 
	$Chart = New-object System.Windows.Forms.DataVisualization.Charting.Chart 
	$Chart.Width = 150
	$Chart.Height = 150 
	$Chart.Left = 1
	$Chart.Top = 1

	
	#Create a chartarea to draw on and add this to the chart 
	$ChartArea = New-Object System.Windows.Forms.DataVisualization.Charting.ChartArea
	$Chart.ChartAreas.Add($ChartArea) 
	[void]$Chart.Series.Add("Data") 

    #Add a datapoint for each value specified in the arguments (args) 
    foreach ($value in $args[0]) {
		$datapoint = new-object System.Windows.Forms.DataVisualization.Charting.DataPoint(0, $value)
		$datapoint.AxisLabel = $value
		$Chart.Series["Data"].Points.Add($datapoint)
	}

	# Manually Select Colours
	#$Colour1 = "#" + $GoodTitleColour
	#$Colour2 = "#" + $WarningTitleColour
	#$Colour3 = "#" + $AlertTitleColour
	#if ($args[0]){
	#	$datapoint.Color = $Colour1
	#}
	#if ($args[1]){
	#	$datapoint.Color = $Colour2
	#}
	#if ($args[2]){
	#	$datapoint.Color = $Colour3
	#}
	
	$Chart.Series["Data"].ChartType = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::Pie
	$Chart.Series["Data"]["PieLabelStyle"] = "Outside" 
	$Chart.Series["Data"]["PieLineColor"] = "Black" 
	$Chart.Series["Data"]["PieDrawingStyle"] = "Concave" 
	#($Chart.Series["Data"].Points.FindMaxByValue())["Exploded"] = $true

	#Set the title of the Chart to the current date and time 
	$Title = new-object System.Windows.Forms.DataVisualization.Charting.Title 
	$Chart.Titles.Add($Title) 
	$Chart.Titles[0].Text = "My Pie Chart"

	#Save the chart to a file
	$Chart.SaveImage($FileName,"png")
}


############################################################################################################
#        Misc        #
#---------------------


function Get-DirectoryStats() {
  param ([string]$root = $(resolve-path .))
  Get-ChildItem $root -recurse -force | where { -not $_.PSIsContainer } | measure-object -sum -property Length
}

