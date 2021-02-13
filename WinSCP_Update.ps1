
$URL_HOME_DOWNLOAD_PAGE = 'https://winscp.net/eng/downloads.php'
$REGEXP_FILE1  = 'WinSCP.+Portable\.zip$'
$REGEXP_FILE2  = 'https://winscp.net/download/files/'
$HomePageDownload = Invoke-WebRequest -Uri $URL_HOME_DOWNLOAD_PAGE -UseBasicParsing
$url = @($HomePageDownload.links | ? href -match $REGEXP_FILE1) -notmatch 'beta|rc' | % href
$url = 'https://winscp.net/eng' + $url
$version   = $url -split '-' | select -Last 1 -Skip 1
$file_name = $url -split '/' | select -last 1
$FILEGET		= "https://winscp.net/download/${file_name}"
$PageDownload = Invoke-WebRequest -Uri $FILEGET -UseBasicParsing
$DIRECT_DOWNLOAD = @($PageDownload.links | ? href -match $REGEXP_FILE2) | % href
echo "Download URL: $DIRECT_DOWNLOAD"
Invoke-WebRequest -Uri "$DIRECT_DOWNLOAD" -OutFile "$file_name"
Expand-Archive -Path $file_name -DestinationPath . -Force
Remove-Item $file_name
# LANG FR
$URL_LANG_DOWNLOAD_PAGE = 'https://winscp.net/eng/translations.php'
$REGEXP_FILELANG  = "${version}/fr\.zip$"
$LangPageDownload = Invoke-WebRequest -Uri $URL_LANG_DOWNLOAD_PAGE -UseBasicParsing
$LANG_DIRECT_LINK = @($LangPageDownload.links | ? href -match $REGEXP_FILELANG) | % href
$LANG_DIRECT_DOWNLOAD = "https://winscp.net/eng/${LANG_DIRECT_LINK}"
echo "Download URL: $LANG_DIRECT_DOWNLOAD"
Invoke-WebRequest -Uri "$LANG_DIRECT_DOWNLOAD" -OutFile "fr.zip"

Expand-Archive -Path fr.zip -DestinationPath . -Force
Remove-Item fr.zip
Remove-Item license.txt
Remove-Item debug.log
Remove-Item readme.txt

