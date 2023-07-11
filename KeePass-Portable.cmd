@echo off

set new="C:\Program Files\KeePass-Portable"
set destination="C:\Users\Public\Desktop"
set xmlFile="C:\Program Files\KeePass-Portable\KeePass.config.xml"

if "%~1"=="install" (
	
	mkdir %new%
	REM icacls %new% /inheritance:r /grant:r "Authenticated Users:(OI)(CI)F" /T
    
	powershell -Command "$new = '%new%'; $destination = '%destination%'; Copy-Item -Path .\KeePass.zip -Destination $new -Force; Expand-Archive -Path (Join-Path -Path $new -ChildPath 'KeePass.zip') -DestinationPath $new -Force; $TargetFile = Join-Path -Path $new -ChildPath 'KeePass.exe'; $shortcutFile = Join-Path -Path $destination -ChildPath 'KeePass-Portable.lnk'; $wscriptShell = New-Object -ComObject WScript.Shell; $shortcut = $wscriptShell.CreateShortcut($shortcutFile); $shortcut.TargetPath = $TargetFile; $shortcut.Save(); Remove-Item -Path (Join-Path -Path $new -ChildPath 'KeePass.zip') -Force"
	REM icacls %xmlFile% /grant:r "S-1-5-32-545:(OI)(CI)M"

	REM powershell -Command "$new = '%new%'; $configFile = '%xmlFile%'; if (Test-Path $configFile) { $acl = Get-Acl -Path $configFile; $rule = New-Object System.Security.AccessControl.FileSystemAccessRule("Everyone", "FullControl", "ContainerInherit, ObjectInherit", "None", "Allow"); $acl.SetAccessRule($rule); Set-Acl -Path $filePath -AclObject $acl; } else { Write-Host 'KeePass.config.xml file not found.' }"

	REM takeown /f %xmlFile%

	REM icacls %xmlFile% /grant "Authenticated Users:(OI)(CI)F"
	REM cacls %xmlFile% /E /G "Authenticated Users":F
	REM icacls %xmlFile% /grant:r "Users":F
	REM icacls %xmlFile% /grant "Everyone":F
	REM icacls %xmlFile% /grant "*S-1-5-32-545":F
	REM icacls %xmlFile% /grant "Authenticated Users":F
	
) else if "%~1"=="uninstall" (
    
	powershell -Command "$new = '%new%'; $destination = '%destination%'; $profiles = Get-ChildItem -Path "C:\Users" -Directory;	foreach ($profile in $profiles) { $shortcutFile = Join-Path -Path $profile.FullName -ChildPath "Desktop\KeePass-Portable.lnk"; if (Test-Path $shortcutFile) { Remove-Item -Path $shortcutFile -Force -Confirm:$false;} }; Remove-Item -Path $new -Recurse -Force"
	
) else (
    echo Invalid command specified. Please use "install" or "uninstall".
)