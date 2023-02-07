#Requires AutoHotkey v2.0

StartTime := A_TickCount
baseDirectory := A_ScriptDir . "\"
groupsDirectory := baseDirectory . "WordGroups\"
if !FileExist(groupsDirectory)
    DirCreate(groupsDirectory)
englishWords := FileRead(baseDirectory . "dictionary.txt")

a:=0,b:=0,c:=0,d:=0,e:=0,f:=0,g:=0,h:=0,i:=0,j:=0,k:=0,l:=0,m:=0,n:=0,o:=0,p:=0,q:=0,r:=0,s:=0,t:=0,u:=0,v:=0,w:=0,x:=0,y:=0,z:=0

Loop Parse, englishWords, "`n"
{
    currentWord := Trim(A_LoopField)
    Loop Parse, currentWord
    {
        switch A_LoopField, 0
        {
            case "a": a++
            case "b": b++
            case "c": c++
            case "d": d++
            case "e": e++
            case "f": f++
            case "g": g++
            case "h": h++
            case "i": i++
            case "j": j++
            case "k": k++
            case "l": l++
            case "m": m++
            case "n": n++
            case "o": o++
            case "p": p++
            case "q": q++
            case "r": r++
            case "s": s++
            case "t": t++
            case "u": u++
            case "v": v++
            case "w": w++
            case "x": x++
            case "y": y++
            case "z": z++
        }
    }

    fileName := ""
    if (a)
        fileName .= "a" a
    if (b)
        fileName .= "b" b
    if (c)
        fileName .= "c" c
    if (d)
        fileName .= "d" d
    if (e)
        fileName .= "e" e
    if (f)
        fileName .= "f" f
    if (g)
        fileName .= "g" g
    if (h)
        fileName .= "h" h
    if (i)
        fileName .= "i" i
    if (j)
        fileName .= "j" j
    if (k)
        fileName .= "k" k
    if (l)
        fileName .= "l" l
    if (m)
        fileName .= "m" m
    if (n)
        fileName .= "n" n
    if (o)
        fileName .= "o" o
    if (p)
        fileName .= "p" p
    if (q)
        fileName .= "q" q
    if (r)
        fileName .= "r" r
    if (s)
        fileName .= "s" s
    if (t)
        fileName .= "t" t
    if (u)
        fileName .= "u" u
    if (v)
        fileName .= "v" v
    if (w)
        fileName .= "w" w
    if (x)
        fileName .= "x" x
    if (y)
        fileName .= "y" y
    if (z)
        fileName .= "z" z

    fileName .= ".txt"
    FileAppend(currentWord . "`n", groupsDirectory . fileName)
    a:=0,b:=0,c:=0,d:=0,e:=0,f:=0,g:=0,h:=0,i:=0,j:=0,k:=0,l:=0,m:=0,n:=0,o:=0,p:=0,q:=0,r:=0,s:=0,t:=0,u:=0,v:=0,w:=0,x:=0,y:=0,z:=0
}

ElapsedTime := A_TickCount - StartTime
Msgbox "Sorted word groups in " (ElapsedTime/1000) " seconds."