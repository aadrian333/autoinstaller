$scriptBlock = {
	$currentPath = "replace"
	Set-Location $currentPath
	$openFile = $currentPath + "config.txt"
	$fileLines = Get-Content -Path $openFile | Where-Object { $_ -match "\S"}

	$strCommands = @()
	forEach ($line in $fileLines){
		$f, $attr = $line -split " ", 2
		$strCommands += "Start-Process $f -ArgumentList `"$attr`" -Verb RunAs"
	}
	
	foreach ($command in $strCommands) {
		Write-host "Executing $command"
		Invoke-Expression $command
		Start-Sleep -Seconds 5
	}
}

<#
	$strCommands = @(
		"Start-Process E:\VBDeploy\VC_redist.x64.exe -ArgumentList '/Q' -Verb RunAs",
   		"Start-Process E:\VBDeploy\sublime_text_build_4143_x64_setup.exe -ArgumentList '/verysilent /norestart' -Verb RunAs",
    		"Start-Process E:\VBDeploy\VirtualBox-7.0.4-154605-Win.exe -ArgumentList '--silent --ignore-reboot' -Verb RunAs",
		"Start-Process E:\VBDeploy\OperaGXSetup.exe -ArgumentList '/silent' -Verb RunAs",
    		"Start-Process E:\VBDeploy\Wireshark-win64-4.0.2.exe -ArgumentList '/S' -Verb RunAs"
	)
	#>

$currentPath = $pwd.path + "\"

$scriptBlock = $scriptBlock -replace "replace", $currentPath

$encodedCommand = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes(($scriptBlock | Out-String)))
$arguments = "-NoExit", "-EncodedCommand", $encodedCommand

Start-Process powershell.exe -Verb RunAs -ArgumentList $arguments 

