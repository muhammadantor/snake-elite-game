' ================================================================
'  Snake Elite — Desktop Launcher  |  AutomateIQ Labs
'  Fixed Version — No Environ() error
' ================================================================

Dim oShell, oFSO, sDir, sGame, sURL, sBrowser, sArgs
Dim PF, PF86, LOCAL, i

Set oShell = CreateObject("WScript.Shell")
Set oFSO   = CreateObject("Scripting.FileSystemObject")

' -- Common paths ---------------------------------------------
PF    = oShell.ExpandEnvironmentStrings("%ProgramFiles%")
PF86  = oShell.ExpandEnvironmentStrings("%ProgramFiles(x86)%")
LOCAL = oShell.ExpandEnvironmentStrings("%LocalAppData%")

' -- Find snake_elite.html (same folder as this .vbs) ---------
sDir  = oFSO.GetParentFolderName(WScript.ScriptFullName)
sGame = sDir & "\snake_elite.html"

If Not oFSO.FileExists(sGame) Then
    MsgBox "ERROR: snake_elite.html not found!" & vbCrLf & vbCrLf & _
           "Make sure both files are in the same folder:" & vbCrLf & _
           "  snake_elite.html" & vbCrLf & _
           "  SnakeElite.vbs", _
           vbCritical, "Snake Elite"
    WScript.Quit
End If

' -- Build file URL -------------------------------------------
sURL = "file:///" & Replace(Replace(sGame, "\", "/"), " ", "%20")

' -- Browser paths to try (Edge first, then Chrome, Brave) ----
Dim aPaths(7)
aPaths(0) = PF86  & "\Microsoft\Edge\Application\msedge.exe"
aPaths(1) = PF    & "\Microsoft\Edge\Application\msedge.exe"
aPaths(2) = LOCAL & "\Microsoft\Edge\Application\msedge.exe"
aPaths(3) = PF    & "\Google\Chrome\Application\chrome.exe"
aPaths(4) = PF86  & "\Google\Chrome\Application\chrome.exe"
aPaths(5) = LOCAL & "\Google\Chrome\Application\chrome.exe"
aPaths(6) = PF    & "\BraveSoftware\Brave-Browser\Application\brave.exe"
aPaths(7) = PF86  & "\BraveSoftware\Brave-Browser\Application\brave.exe"

sBrowser = ""
For i = 0 To 7
    If oFSO.FileExists(aPaths(i)) Then
        sBrowser = aPaths(i)
        Exit For
    End If
Next

' -- Launch ---------------------------------------------------
If sBrowser <> "" Then
    sArgs = "--app=""" & sURL & """" & _
            " --window-size=780,690" & _
            " --window-position=80,40" & _
            " --disable-extensions" & _
            " --no-first-run" & _
            " --disable-default-apps"
    oShell.Run """" & sBrowser & """ " & sArgs, 0, False
Else
    MsgBox "Edge / Chrome / Brave not found." & vbCrLf & _
           "Opening in your default browser instead.", _
           vbInformation, "Snake Elite"
    oShell.Run "explorer """ & sGame & """", 1, False
End If

Set oShell = Nothing
Set oFSO   = Nothing