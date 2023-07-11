@echo off

set new="C:\Program Files\KeePass-Portable"
set destination="C:\Users\Public\Desktop"

if "%~1"=="install" (
	
	powershell -Command "if (Test-Path -Path '%new%' ){$new = '%new%'; $destination = '%destination%'; $exePath = Join-Path -Path $new -ChildPath 'KeePass.exe'; $arg = '--exit-all'; Start-Process -FilePath $exePath -ArgumentList $arg -NoNewWindow -Wait}"
    powershell -Command "if (Test-Path -Path '%new%' ){ $new = '%new%'; $destination = '%destination%'; $profiles = Get-ChildItem -Path "C:\Users" -Directory;	foreach ($profile in $profiles) { $shortcutFile = Join-Path -Path $profile.FullName -ChildPath "Desktop\KeePass-Portable.lnk"; if (Test-Path $shortcutFile) { Remove-Item -Path $shortcutFile -Force -Confirm:$false;} }; Remove-Item -Path $new -Recurse -Force }"
	
	mkdir %new%
	powershell -Command "$new = '%new%'; $destination = '%destination%'; Copy-Item -Path .\KeePass.zip -Destination $new -Force; Expand-Archive -Path (Join-Path -Path $new -ChildPath 'KeePass.zip') -DestinationPath $new -Force; $TargetFile = Join-Path -Path $new -ChildPath 'KeePass.exe'; $shortcutFile = Join-Path -Path $destination -ChildPath 'KeePass-Portable.lnk'; $wscriptShell = New-Object -ComObject WScript.Shell; $shortcut = $wscriptShell.CreateShortcut($shortcutFile); $shortcut.TargetPath = $TargetFile; $shortcut.Save(); Remove-Item -Path (Join-Path -Path $new -ChildPath 'KeePass.zip') -Force"
		
) else if "%~1"=="uninstall" (
    powershell -Command "$new = '%new%'; $exePath = Join-Path -Path $new -ChildPath 'KeePass.exe'; $arg = '--exit-all'; Start-Process -FilePath $exePath -ArgumentList $arg -NoNewWindow -Wait"
    
	powershell -Command "$new = '%new%'; $destination = '%destination%'; $profiles = Get-ChildItem -Path "C:\Users" -Directory;	foreach ($profile in $profiles) { $shortcutFile = Join-Path -Path $profile.FullName -ChildPath "Desktop\KeePass-Portable.lnk"; if (Test-Path $shortcutFile) { Remove-Item -Path $shortcutFile -Force -Confirm:$false;} }; Remove-Item -Path $new -Recurse -Force"
	
) else (
    echo Invalid command specified. Please use "install" or "uninstall".
)