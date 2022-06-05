###########################
# HOMEPAGE : https://github.com/ZarTek-Creole/POWERSHELL-WinSCP-PORTABLE-FR-UPDATE
# AUTHOR   : ZarTek.Creole@gmail.com
#
# Update your WinSCP portable with your lang
#
###########################

####################
# CONFIGURATION:
$CONF_LANG		=	"fr"
$INSTALL_DIR	=	"D:\_APP_PORTABLE\WinSCP"
$VERBOSE		=	1
####################

####################
# CODE:
function RMFILE {
	param (
		$FILE_NAME
	)
	if (Test-Path $FILE_NAME) {
		Remove-Item $FILE_NAME
		if ($VERBOSE -eq 1) { echo "File removed: $FILE_NAME" }
	}
}
## VARS
$URL_WEBSITE				= "https://winscp.net"
$URL_HOME_DOWNLOAD_PAGE		= "${URL_WEBSITE}/eng/downloads.php"
$URL_LANG_DOWNLOAD_PAGE		= "${URL_WEBSITE}/eng/translations.php"

$RE_GET_WinSCP_Filename		= "WinSCP.+Portable\.zip$"
$RE_GET_WinSCP_URL			= "${URL_WEBSITE}/download/files/"
## DOWNLOAD WinSCP
$HomePageDownload			= Invoke-WebRequest -Uri $URL_HOME_DOWNLOAD_PAGE -UseBasicParsing
$url						= @($HomePageDownload.links | ? href -match ${RE_GET_WinSCP_Filename}) -notmatch "beta|rc" | % href
$url						= "${URL_WEBSITE}/eng" + $url
$version					= $url -split "-" | select -Last 1 -Skip 1
$file_name					= $url -split "/" | select -last 1
$FILEGET					= "${URL_WEBSITE}/download/${file_name}"
$PageDownload				= Invoke-WebRequest -Uri $FILEGET -UseBasicParsing
$DIRECT_DOWNLOAD			= @($PageDownload.links | ? href -match ${RE_GET_WinSCP_URL}) | % href
if ($VERBOSE -eq 1) { echo "Download URL: $DIRECT_DOWNLOAD" }
Invoke-WebRequest -Uri "$DIRECT_DOWNLOAD" -OutFile "$file_name"
if ($VERBOSE -eq 1) { echo "Extract files from $file_name" }
Expand-Archive -Path $file_name -DestinationPath ${INSTALL_DIR} -Force
RMFILE $file_name

## DOWNLOAD WinSCP Lang
$LangPageDownload			= Invoke-WebRequest -Uri $URL_LANG_DOWNLOAD_PAGE -UseBasicParsing
$RE_GET_WinSCP_LANG_URL		= "${version}/${CONF_LANG}\.zip$"
$LANG_DIRECT_LINK			= @($LangPageDownload.links | ? href -match ${RE_GET_WinSCP_LANG_URL}) | % href
$LANG_DIRECT_DOWNLOAD		= "${URL_WEBSITE}/eng/${LANG_DIRECT_LINK}"
if ($VERBOSE -eq 1) { echo "Download URL: $LANG_DIRECT_DOWNLOAD" }
Invoke-WebRequest -Uri "$LANG_DIRECT_DOWNLOAD" -OutFile "${CONF_LANG}.zip"
if ($VERBOSE -eq 1) { echo "Extract files from ${CONF_LANG}.zip" }
Expand-Archive -Path "${CONF_LANG}.zip" -DestinationPath ${INSTALL_DIR} -Force
RMFILE "${CONF_LANG}.zip"
RMFILE "${INSTALL_DIR}/license.txt"
RMFILE "${INSTALL_DIR}/debug.log"
RMFILE "${INSTALL_DIR}/readme.txt"
Start-Process -FilePath "${INSTALL_DIR}/WinSCP.exe"
####################

