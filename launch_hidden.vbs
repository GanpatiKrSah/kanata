Dim shell, cmd
Set shell = CreateObject("WScript.Shell")
cmd = WScript.Arguments(0)
shell.Run cmd, 0
