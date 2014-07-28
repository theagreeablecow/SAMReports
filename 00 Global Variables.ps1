############################################################################################################
#   Global Variables    #
#------------------------

# Email Variables
$SmtpServer = "exchange.mydomain.com.au"
$EmailFrom = "SAMReports@mydomain.com.au"
$EmailTo = "administrator@mydomain.com.au"
$EmailSubject = "SysAdmin Modular Report for $module $($Date)"

# Report HTML Formatting
$DefaultBannerColour = "848284"
$BannerTxtColour = "FFFFFF"
$BannerTxtSize = "18pt"
$DefaultTitleColour = "D4DBDC"
$GoodTitleColour = "4EA846"
$WarningTitleColour = "FFB901"
$AlertTitleColour = "BD1917"
$TitleTxtColour = "FFFFFF"

$DefaultCommentColour = "F3F4F4"
$TableTxtColour = "000000"
$TableTxtSize = "10pt"

# Report Variables
$ReportTitle = $EmailSubject
$ReportSubTitle = "Created by <a href='sip:theagreeablecow@gmail.com' target='_blank'>The Agreeable Cow</a>, generated on $($ENV:Computername)."

#Environment Variables
$ScriptComputer = ($ENV:Computername)
$ScriptUser = ($ENV:Username)

