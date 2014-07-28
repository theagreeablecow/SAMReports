############################################################################################################
#      HTML Styles      #
#------------------------

$DspHeader0 = "
	BORDER-RIGHT: #bbbbbb 1px solid;
	PADDING-RIGHT: 0px;
	BORDER-TOP: #bbbbbb 1px solid;
	DISPLAY: block;
	PADDING-LEFT: 0px;
	FONT-WEIGHT: bold;
	FONT-SIZE: $($TableTxtSize);
	MARGIN-BOTTOM: -1px;
	MARGIN-LEFT: 0px;
	BORDER-LEFT: #bbbbbb 1px solid;
	COLOR: #$($BannerTxtColour);
	MARGIN-RIGHT: 0px;
	PADDING-TOP: 4px;
	BORDER-BOTTOM: #bbbbbb 1px solid;
	FONT-FAMILY: Tahoma;
	POSITION: relative;
	HEIGHT: 2.25em;
	WIDTH: 95%;
	TEXT-INDENT: 10px;
	BACKGROUND-COLOR: #$($ReportBannerColour);
"

$DspHeader1 = "
	BORDER-RIGHT: #bbbbbb 1px solid;
	PADDING-RIGHT: 0px;
	BORDER-TOP: #bbbbbb 1px solid;
	DISPLAY: block;
	PADDING-LEFT: 0px;
	FONT-WEIGHT: bold;
	FONT-SIZE: $($TableTxtSize);
	MARGIN-BOTTOM: -1px;
	MARGIN-LEFT: 0px;
	BORDER-LEFT: #bbbbbb 1px solid;
	COLOR: #$($TitleTxtColour);
	MARGIN-RIGHT: 0px;
	PADDING-TOP: 4px;
	BORDER-BOTTOM: #bbbbbb 1px solid;
	FONT-FAMILY: Tahoma;
	POSITION: relative;
	HEIGHT: 2.25em;
	WIDTH: 95%;
	TEXT-INDENT: 10px;
	BACKGROUND-COLOR: #$($DefaultTitleColour);
"
$DspHeaderGood = "
	BORDER-RIGHT: #bbbbbb 1px solid;
	PADDING-RIGHT: 0px;
	BORDER-TOP: #bbbbbb 1px solid;
	DISPLAY: block;
	PADDING-LEFT: 0px;
	FONT-WEIGHT: bold;
	FONT-SIZE: $($TableTxtSize);
	MARGIN-BOTTOM: -1px;
	MARGIN-LEFT: 0px;
	BORDER-LEFT: #bbbbbb 1px solid;
	COLOR: #$($TitleTxtColour);
	MARGIN-RIGHT: 0px;
	PADDING-TOP: 4px;
	BORDER-BOTTOM: #bbbbbb 1px solid;
	FONT-FAMILY: Tahoma;
	POSITION: relative;
	HEIGHT: 2.25em;
	WIDTH: 95%;
	TEXT-INDENT: 10px;
	BACKGROUND-COLOR: #$($GoodTitleColour);
"

$DspHeaderWarning = "
	BORDER-RIGHT: #bbbbbb 1px solid;
	PADDING-RIGHT: 0px;
	BORDER-TOP: #bbbbbb 1px solid;
	DISPLAY: block;
	PADDING-LEFT: 0px;
	FONT-WEIGHT: bold;
	FONT-SIZE: $($TableTxtSize);
	MARGIN-BOTTOM: -1px;
	MARGIN-LEFT: 0px;
	BORDER-LEFT: #bbbbbb 1px solid;
	COLOR: #$($TitleTxtColour);
	MARGIN-RIGHT: 0px;
	PADDING-TOP: 4px;
	BORDER-BOTTOM: #bbbbbb 1px solid;
	FONT-FAMILY: Tahoma;
	POSITION: relative;
	HEIGHT: 2.25em;
	WIDTH: 95%;
	TEXT-INDENT: 10px;
	BACKGROUND-COLOR: #$($WarningTitleColour);
"

$DspHeaderAlert = "
	BORDER-RIGHT: #bbbbbb 1px solid;
	PADDING-RIGHT: 0px;
	BORDER-TOP: #bbbbbb 1px solid;
	DISPLAY: block;
	PADDING-LEFT: 0px;
	FONT-WEIGHT: bold;
	FONT-SIZE: $($TableTxtSize);
	MARGIN-BOTTOM: -1px;
	MARGIN-LEFT: 0px;
	BORDER-LEFT: #bbbbbb 1px solid;
	COLOR: #$($TitleTxtColour);
	MARGIN-RIGHT: 0px;
	PADDING-TOP: 4px;
	BORDER-BOTTOM: #bbbbbb 1px solid;
	FONT-FAMILY: Tahoma;
	POSITION: relative;
	HEIGHT: 2.25em;
	WIDTH: 95%;
	TEXT-INDENT: 10px;
	BACKGROUND-COLOR: #$($AlertTitleColour);
"

$dspcomments = "
	BORDER-RIGHT: #bbbbbb 1px solid;
	PADDING-RIGHT: 0px;
	BORDER-TOP: #bbbbbb 1px solid;
	DISPLAY: block;
	PADDING-LEFT: 0px;
	FONT-WEIGHT: bold;
	FONT-SIZE: $($TableTxtSize);
	MARGIN-BOTTOM: -1px;
	MARGIN-LEFT: 0px;
	BORDER-LEFT: #bbbbbb 1px solid;
	COLOR: #$($TitleTxtColour);
	MARGIN-RIGHT: 0px;
	PADDING-TOP: 4px;
	BORDER-BOTTOM: #bbbbbb 1px solid;
	FONT-FAMILY: Tahoma;
	POSITION: relative;
	HEIGHT: 2.25em;
	WIDTH: 95%;
	TEXT-INDENT: 10px;
	COLOR: #000000;
	FONT-STYLE: ITALIC;
	FONT-WEIGHT: normal;
	FONT-SIZE: $($TableTxtSize);
	BACKGROUND-COLOR: #$($DefaultCommentColour)
"

$filler = "
	BORDER-RIGHT: medium none; 
	BORDER-TOP: medium none; 
	DISPLAY: block; 
	BACKGROUND: none transparent scroll repeat 0% 0%; 
	MARGIN-BOTTOM: -1px; 
	FONT: 100%/8px Tahoma; 
	MARGIN-LEFT: 43px; 
	BORDER-LEFT: medium none; 
	COLOR: #ffffff; 
	MARGIN-RIGHT: 0px; 
	PADDING-TOP: 4px; 
	BORDER-BOTTOM: medium none; 
	POSITION: relative
"

$dspcont ="
	BORDER-RIGHT: #bbbbbb 1px solid;
	BORDER-TOP: #bbbbbb 1px solid;
	PADDING-LEFT: 0px;
	FONT-SIZE: $($TableTxtSize);
	MARGIN-BOTTOM: -1px;
	PADDING-BOTTOM: 5px;
	MARGIN-LEFT: 0px;
	BORDER-LEFT: #bbbbbb 1px solid;
	WIDTH: 95%;
	COLOR: #000000;
	MARGIN-RIGHT: 0px;
	PADDING-TOP: 4px;
	BORDER-BOTTOM: #bbbbbb 1px solid;
	FONT-FAMILY: Tahoma;
	POSITION: relative;
	BACKGROUND-COLOR: #f9f9f9
"

############################################################################################################
# Style Sheet Functions #
#------------------------

# Functions Credit to Alan Renouf http://virtu-al.net vCheck

Function Get-CustomHeader0 ($Title){
$Report = @"
		<div style="margin: 0px auto;">		

		<h1 style="$($DspHeader0)">$($Title)</h1>
	
    	<div style="$($filler)"></div>
"@
Return $Report
}

Function Get-CustomHeader ($Title, $Cmnt, $Alert){
if ($Alert -eq "Good") {
$Report = @"
		<h2 style="$($DspHeaderGood)">$($Title)</h2>
"@
}
elseif ($Alert -eq "Warning") {
$Report = @"
		<h2 style="$($DspHeaderWarning)">$($Title)</h2>
"@
}
elseif ($Alert -eq "Alert") {
$Report = @"
		<h2 style="$($DspHeaderAlert)">$($Title)</h2>
"@
}
else {
$Report = @"
		<h2 style="$($dspheader1)">$($Title)</h2>
"@
}
If ($Cmnt) {
	$Report += @"
			<div style="$($dspcomments)">$($Cmnt)</div>
"@
}
$Report += @"
        <div style="$($dspcont)">
"@
Return $Report
}

Function Get-CustomHeaderClose ($Footer){

	$Report = @"
		</DIV>
		<div style="$($filler)">$($Footer)</div>
"@
Return $Report
}

Function Get-CustomHeader0Close{
	$Report = @"
</DIV>
"@
Return $Report
}

Function Get-CustomHTMLClose{
	$Report = @"
</div>

</body>
</html>
"@
Return $Report
}

Function Get-ReportHeaderHTML ($Header){
$Report = @"
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<html><head><title>$($Header)</title>
		<META http-equiv=Content-Type content='text/html; charset=windows-1252'>

		<style type="text/css">

		TABLE 		{
						TABLE-LAYOUT: fixed; 
						font-family: Tahoma; 
						font-size:$($TableTxtSize);
						WIDTH: 100%
					}
		*
					{
						margin:0
					}

		.pageholder	{
						margin: 0px auto;
					}
					
		td 				{
						VERTICAL-ALIGN: TOP; 
						FONT-FAMILY: Tahoma
					}
					
		th 			{
						VERTICAL-ALIGN: TOP; 
						COLOR: #$($TableTxtColour); 
						TEXT-ALIGN: left
					}
					
		</style>
	</head>
	<body margin-left: 4pt; margin-right: 4pt; margin-top: 6pt;>
<div style="font-family:Arial, Helvetica, sans-serif; font-size:$($BannerTxtSize); font-weight:bolder; background-color: ##BANNER_MARKER#;"><center>
<p class="accent">
	<H1><FONT COLOR= $($BannerTxtColour)>$($ReportTitle)</Font></H1>
</p>
</center></div>
    <div style="font-family:Arial, Helvetica, sans-serif; font-size:14px; font-weight:bold;"><center>$($ReportSubTitle)
</center></div>
"@
Return $Report
}

Function Get-HTMLTable {
	param([array]$Data)
	$HTMLTable = $Data | ConvertTo-Html -Fragment
	$HTMLTable = $HTMLTable -Replace '<TABLE>', '<TABLE><style>tr:nth-child(even) { background-color: #e5e5e5; TABLE-LAYOUT: Fixed; FONT-SIZE: 100%; WIDTH: 100%}</style>' 
	$HTMLTable = $HTMLTable -Replace '<td>', '<td style= "FONT-FAMILY: Tahoma; FONT-SIZE: $($TableTxtSize);">'
	$HTMLTable = $HTMLTable -Replace '<th>', '<th style= "COLOR: #$($DefaultBannerColour); FONT-FAMILY: Tahoma; FONT-SIZE: $($TableTxtSize);">'
	$HTMLTable = $HTMLTable -replace '&lt;', "<"
	$HTMLTable = $HTMLTable -replace '&gt;', ">"
	Return $HTMLTable
}

Function Get-HTMLText ($OutText){
$Report = @"
<TABLE>
	<tr>
		$OutText
	</tr>
</TABLE>
"@
Return $Report
}

Function Get-HTMLTable {
	param([array]$OutData)
	$HTMLTable = $OutData | ConvertTo-Html -Fragment
	$HTMLTable = $HTMLTable -Replace '<TABLE>', '<TABLE><style>tr:nth-child(even) { background-color: #e5e5e5; TABLE-LAYOUT: Fixed; FONT-SIZE: 100%; WIDTH: 100%}</style>' 
	$HTMLTable = $HTMLTable -Replace '<td>', '<td style= "FONT-FAMILY: Tahoma; FONT-SIZE: $($TableTxtSize);">'
	$HTMLTable = $HTMLTable -Replace '<th>', '<th style= "COLOR: #$($ReportBannerColour); FONT-FAMILY: Tahoma; FONT-SIZE: $($TableTxtSize);">'
	$HTMLTable = $HTMLTable -replace '&lt;', "<"
	$HTMLTable = $HTMLTable -replace '&gt;', ">"
	Return $HTMLTable
}
