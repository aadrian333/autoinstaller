$currentPath = $pwd.path + "\"
$files = Get-ChildItem -Path $currentPath -File
$fileTypes = @(".exe", ".msi")

$outputFile = $currentPath + "config.txt"

Write-host "`nNote before use: `nYou should have your installer files in the same folder as the autoinstallerCreator"
Write-Host "You also shouldn't have an installer with spaces in its name."
Write-Host "If you don't see a config.txt inside the folder create one."
Write-Host "And finally, if there is an order in which each installation has to happen you can modify it manually by changing its place in the config.txt"

$acceptedFiles = @()

foreach ($file in $files) {
	if ($fileTypes -contains $file.Extension) {
		$choice = Read-Host "`nDo you want to add the file $file to the installer? [y/n]"
		while ($choice -notmatch '[ynYN]'){
			$choice = Read-Host "`nInvalid! `nDo you want to add the file $file to the installer? [y/n]"
		}
		
		if ($choice -eq "y") {
			Write-Host "Adding $file in the list!"
			
			$addingContent = $file.Name
			
			$choice = Read-Host "`nDo you want to add some attrubutes? (it helps specially for silent installations) [y/n]"
			while ($choice -notmatch '[ynYN]'){
				$choice = Read-Host "`nInvalid! `nDo you want to add some attrubutes? [y/n]"
			}
			
			if ($choice -eq "y") {
				while ($true) {
					$attribute = Read-Host "`nWhat attribute do you want to add? "
					
					if ($attribute -eq "") {
						break
					}
				
					$choice = Read-Host "`nDo you want really want to add the attribute $attribute ? [y/n]"
					while ($choice -notmatch '[ynYN]'){
						$choice = Read-Host "`nInvalid! `nDo you want really want to add the attribute $attribute ? [y/n]"
					}
					
					$addingContent += " " + $attribute
				}
			}

			$acceptedFiles += $addingContent
			Write-Host "Final result is: `n$addingContent"
		}
	}
}

$acceptedFiles | Out-File -FilePath $outputFile