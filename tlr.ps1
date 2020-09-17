Add-Type -AssemblyName PresentationFramework
try {
    $dir = (gp -ea stop 'Registry::HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\World of Warcraft Classic').InstallLocation
} catch {
    [System.Windows.MessageBox]::Show('游戏未正确安装', '错误', 'OK', 'Error')
}
$bigfuckingobject = '['
$logs = ls $dir\_classic_\WTF\Account\*\*\*\SavedVariables\TradeLogUnlimitedClassic.lua
foreach ($log in $logs) {
    $path = $log.PSPath
    $displayName = $path.Substring($path.IndexOf('Account') + 8, $path.IndexOf('\Saved') - $path.IndexOf('Account') - 8).Replace('\', '→')
    $html += '<hr /><h2>' + $displayName + '</h2>'
    $arrayRegex = New-Object System.Text.RegularExpressions.Regex @('^\t\t\}', 'Multiline')    
    $trailingRegex = New-Object System.Text.RegularExpressions.Regex @('-- \d+', 'Singleline')
    $content = (cat $log -Raw -Encoding UTF8).Replace('[', '').Replace(']', '').Replace('=', ':')
    $content = $arrayRegex.Replace($content, ']')
    $content = $trailingRegex.Replace($content, '')
    $content = $content.Replace('s" : {', 's" : [')
    $content = '[' + $content.Substring($content.IndexOf('TradeLogUnlimited_TradesHistory') + 35)
    $content = $content.Substring(0, $content.IndexOf('TradeLogUnlimited_Announce_Checked'))
    $content = $content.Substring(0, $content.LastIndexOf('}')) + ']'
    $lastItemRegex = New-Object System.Text.RegularExpressions.Regex @(',(?=\s*[\}\]])', 'Singleline')
    $content = $lastItemRegex.Replace($content, '')
    $arrayNumberFixRegex = New-Object System.Text.RegularExpressions.Regex @('(?<=\[\s*)\d+ :', 'Singleline')
    $content = $arrayNumberFixRegex.Replace($content, '')
    $bigfuckingobject += '{"displayName":"' + $displayName + '","details":' + $content + '},'
}
$bigfuckingobject = $bigfuckingobject.Substring(0, $bigfuckingobject.LastIndexOf(',')) + ']'
$tmpPage = $env:TEMP + '\tlr_' + [DateTime]::Now.ToFileTime() + '.html'
(cat -Raw tlrpage.tmpl.html -Encoding UTF8).Replace('$bigfuckingobject', $bigfuckingobject) > $tmpPage
if ((ls -ErrorAction Ignore 'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe').Count) {
    start 'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe' $tmpPage
}
else {
    start $tmpPage
}