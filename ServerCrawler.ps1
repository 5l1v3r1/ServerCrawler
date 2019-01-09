$ScanPhrase = "^[1-9]{1}[0-9]{10}$" # Phrase to be searched in files. Regex can be used, example is TC ID
$ScanPath = "D:\File_Path" # File path to be searched
$FileName = "Results.txt" # Desired output file name
$ResultPath = "D:\" # File path to export results to
$Result = $ResultPath+$FileName
Get-ChildItem $ScanPath -Recurse | Select-String -Pattern $ScanPhrase | 
%{
$len = $_.line.length # length of line
$lindex = $_.line.tolower().IndexOf($ScanPhrase) # Index of scanned phrase's location
$rang = $_.line.length-$_.line.tolower().IndexOf($ScanPhrase) # The range between scanned phrase's location and end of line 
if 
 ( ($lindex-50) -lt 0 -and $len -lt 50) { $_.Path + "~" + $_.LineNumber + "~" + $_.line.SubString(0,$len)}
elseif 
 ( ($lindex-50) -lt 0 -and $len -gt 50) {$_.Path + "~" + $_.LineNumber + "~" + $_.line.SubString(0,50) } 
elseif
 ( ($lindex-50) -gt 0 -and $rang -gt 50) { $_.Path + "~" + $_.LineNumber + "~" + $_.line.SubString(($lindex-50),100)}
elseif
 ( ($lindex-50) -gt 0 -and $rang -lt 50) { $_.Path + "~" + $_.LineNumber + "~" + $_.line.SubString(($lindex-50),($len-$lindex+50))}
else
 { $_.Path + "~" + $_.LineNumber + "~" + "Unable to retrieve contents"} 
 } | Out-File -FilePath $Result -Force
