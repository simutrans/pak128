Const WaysFolderPath = "..\"
Const BridgesFolderPath = "..\"
Const ElevatedFolderPath = "..\"
Const TunnelsFolderPath = "..\"
Const CmdOptiPng = "optipng" '"optipng -o7" for highest compression

Const Author = "Fabio Gonella"

Dim FSO, Folder, File, WayType, Path, V
Dim ScriptLog, Args, Execute
Set FSO = CreateObject("Scripting.FileSystemObject") 
Set Folder = FSO.GetFolder(".\output")
If Not FSO.FolderExists(".\output") Then FSO.CreateFolder(".\output")

Execute = True
ScriptLog = Array("Updated:" & vbNewLine, "Skipped:" & vbNewLine)

Set Args = Wscript.Arguments
For Each Data in Args
	V = Split(Data, "=")
	Select Case LCase(V(0))
		Case "-s"
			Execute = False
	End Select
Next

For Each File In Folder.Files
	V = Split(FSO.GetBaseName(File.Path), "_")
	WayType = LCase(V(UBound(V)))
	Select Case WayType
		Case "bridge"	: Path = BridgesFolderPath
		Case "elevated"	: Path = ElevatedFolderPath
		Case "tunnel"	: Path = TunnelsFolderPath
		Case Else		: Path = WaysFolderPath
	End Select
	Select Case FSO.GetExtensionName(File.Path) 
		Case "dat"
			Path = FSO.BuildPath(Path, FSO.GetFileName(File.Path))
			If FSO.FileExists(Path) Then
				If CompareFiles(File.Path, Path) Then
					ScriptLog(1) = ScriptLog(1) & File.Name & vbNewLine
					If Execute Then
						File.Delete
					End If
				Else
					ScriptLog(0) = ScriptLog(0) & File.Name & vbNewLine
					If Execute Then
						FSO.DeleteFile(Path)
						File.Move Path
					End If
				End If
			End If
		Case "png"
			Path = FSO.BuildPath(Path, FSO.GetFileName(File.Path))
			If FSO.FileExists(Path) Then
				If CompareImages(File.Path, Path) Then
					ScriptLog(1) = ScriptLog(1) & File.Name & vbNewLine
					If Execute Then 
						File.Delete
					End If
				Else
					ScriptLog(0) = ScriptLog(0) & File.Name & vbNewLine
					If Execute Then
						OptiPng File.Path
						FSO.DeleteFile(Path)
						File.Move Path
					End If
				End If
			End If
	End Select
Next
WScript.Echo ScriptLog(0) & vbNewLine & ScriptLog(1)
Set FSO = Nothing
WScript.Quit(0)

Private Function CompareFiles(ByVal Path1, ByVal Path2)
	Dim FSO, s1, s2
	Set FSO = CreateObject("Scripting.FileSystemObject") 	
	With FSO.OpenTextFile(Path1)
		s1 = .ReadAll
		.Close
	End With
	With FSO.OpenTextFile(Path2)
		s2 = .ReadAll
		.Close
	End With
	CompareFiles = (s1 = s2)
	Set FSO = Nothing	
End Function

Private Function CompareImages(ByVal Path1, ByVal Path2)
	Dim FSO, IMO, V
	Set FSO = CreateObject("Scripting.FileSystemObject") 	
	Set IMO = CreateObject("ImageMagickObject.MagickImage.1")
	V = IMO.Convert(Path1, Path2, "-compose", "difference", "-composite", "-threshold", 0, "-unique-colors", "-format", "%k", "info:")
	CompareImages = (CByte(V) = 1)
	Set FSO = Nothing
	Set IMO = Nothing	
End Function

Private Function OptiPng(ByVal Path1)
	Dim objShell
	Set objShell = CreateObject ("WScript.shell")
	objShell.Run CmdOptiPng & " """ & Path1 & "", 1, True
	Set objShell = Nothing
End Function