Const Header = "fill '#FFFFFF' rectangle 0,0 767,127 fill '#000000' font-size 16 font-weight bold text-antialias 0 text 10,23 'name: %N' text 10,51  'copyright: %C' text 10,107 'timeline: %I - %R' "
Const Tile = "image over %X,%Y 0,0 '%T\tmp_%S_%R_%C.png' "
Const Border = "fill '#9a9a9a' rectangle 768,0 799,0 fill '#dfdfdf' rectangle 768,0 798,0 "

Dim IMO, Size, Name, Copy, Intro, Retire, Skip
Dim FSO, TMP, Folder, File, Text, Path
Dim PNG, MPC
Dim RES, DRW
Dim Args, CompileLog, Verbose, SetFilter
Dim s, i, j, k, H, W
Dim Data, V
Set IMO = CreateObject("ImageMagickObject.MagickImage.1")
Set FSO = CreateObject("Scripting.FileSystemObject") 
Set Folder = FSO.GetFolder(".")
If Not FSO.FolderExists(".\output") Then FSO.CreateFolder(".\output")
CompileLog = Array("Compiled:" & vbNewLine, "Skipped:" & vbNewLine)
SetFilter = Array("0", "1", "2", "3", "4", "5", "6", "7", "8", "9")
Verbose = False
Set TMP = Nothing

Set Args = Wscript.Arguments
For Each Data in Args
	V = Split(Data, "=")
	Select Case LCase(V(0))
		Case "-verbose"
			Verbose = True
		Case "-tmp"
			Set TMP = FSO.GetFolder(V(1))
		Case "-set"
			SetFilter = Split(V(1), ",")
	End Select
Next

If	TMP Is Nothing Then
	Set TMP = FSO.CreateFolder(FSO.BuildPath(Folder.Path, FSO.GetTempName))
	For Each File In Folder.Files
		If FSO.GetExtensionName(File.Path) = "png" Then
			Data = Split(FSO.GetBaseName(File.Path), "-")
			If UBound(Data) > 0 Then
				V = Data(Ubound(Data))
				For i = 0 To UBound(SetFilter)
					If (CByte(V) \ 10) = CByte(SetFilter(i)) Then
						MPC = FSO.BuildPath(TMP.Path, FSO.GetBaseName(File.Path) & ".mpc")
						IMO.Convert File.Path, MPC
						s = IMO.Convert(MPC, "-format", "%w %h", "info:")
						Size = Split(s)
						W = Size(0) \ 128
						H = Size(1) \ 128
						For j = 0 To H - 1
							For k = 0 to W - 1
								IMO.Convert MPC, "-crop", "128x128+" & (k * 128) & "+" & (j * 128), TMP.Path & "\tmp_" & V & "_" & j & "_" & k & ".png"
							Next
						Next
					End If
				Next
			End If
		End If
	Next
End If	
	
For Each File In Folder.Files
	If FSO.GetExtensionName(File.Path) = "tdat" Then
		i = 6
		Set Text = File.OpenAsTextStream 
		Do Until Text.AtEndOfStream
			s = Text.ReadLine
			Select Case LCase(Left(s, 4))
				Case "----"
					If (RES <> vbNullString) Then
						If (Not Skip) And (Name <> vbNullString) Then
							With FSO.CreateTextFile(".\output\" & Name & ".dat")
								.Write RES
								.Close
								s = Replace(Header, "%N", UCase(Name))
								s = Replace(s, "%C", Copy)
								s = Replace(s, "%I", Intro)
								s = Replace(s, "%R", Retire)
								If Verbose Then Wscript.Echo DRW
								IMO.Convert "-size", "1024x" & (((i - 1) \ 8) + 1) * 128, "canvas:#E7FFFF", "-draw", s & DRW & Border, "+matte", ".\output\" & Name & ".png"
							End With
							CompileLog(0) = CompileLog(0) & Name & vbNewLine
						Else 
							CompileLog(1) = CompileLog(1) & Name & vbNewLine
						End If
						i = 6
						s = vbNullString
						DRW = vbNullString
						RES = vbNullString
						Intro = vbNullString
						Retire = vbNullString
						Skip = False
					End If
				Case "name"
					Data = Split(s, "=")
					Name = LCase(Data(1))
				Case "copy"
					Data = Split(s, "=")
					Copy = Data(1)
				Case "intr"
					Data = Split(s, "=")
					If Split(Data(0), "_")(1) = "year" Then Intro = Data(1)
				Case "reti"
					Data = Split(s, "=")
					If Split(Data(0), "_")(1) = "year" Then Retire = Data(1)
				Case "#win", "#sum"
					If i mod 8 > 0 Then i = ((i \ 8) + 1) * 8
				Case "#dia", "#fro"
					s = vbNullString
				Case "imag", "back", "fron", "diag", "icon", "curs"
					Data = Split(s, "!")
					Data(1) = Split(Data(1), ",")
					Data(1)(0) = Split(Data(1)(0), ".")
					V = Split(Data(1)(0)(0), "@")
					If UBound(V) = 1 Then k = V(1) Else k = 0
					s = Replace(Tile, "%T", TMP.Path)
					s = Replace(s, "%X", (i mod 8) * 128)
					s = Replace(s, "%Y", (i \ 8) * 128)
					s = Replace(s, "%S", V(0))
					s = Replace(s, "%R", Data(1)(0)(1))
					s = Replace(s, "%C", Data(1)(0)(2) - k)
					PNG = Split(s, "'")(1)
					If FSO.FileExists(PNG) Then 
						V = IMO.Convert(PNG, "-unique-colors", "-format", "%k", "info:")
						If CLng(V) > 1	Then
							DRW = DRW & s
							Data(1)(0)(0) = Name
							Data(1)(0)(1) = i \ 8
							Data(1)(0)(2) = i mod 8
							Data(1)(0) = Join(Data(1)(0), ".")
							Data(1) = Join(Data(1), ",")
							i = i + 1
						Else
							Data(1) = "-"
						End If
						s = Join(Data, vbNullString)
					Else
						Skip = True
					End If
			End Select
			If s <> vbNullString Then RES = RES & s & vbNewLine
		Loop
		Text.Close
	End If
Next
WScript.Echo CompileLog(0) & vbNewLine & CompileLog(1)
Set Folder = Nothing
Set TMP = Nothing
Set FSO = Nothing
Set IMO = Nothing
WScript.Quit(0)