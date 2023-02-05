#Requires AutoHotkey v2.0

words := FileRead("words_alpha.txt")
longestWord := ""
longestLength :=  0

Loop Parse, words, "`n"
{
    uniqueLetters := 0
    wordLen := StrLen(A_LoopField)

    if InStr(A_LoopField, "a")
        uniqueLetters++
    if InStr(A_LoopField, "b")
        uniqueLetters++
    if InStr(A_LoopField, "c")
        uniqueLetters++
    if InStr(A_LoopField, "d")
        uniqueLetters++
    if InStr(A_LoopField, "e")
        uniqueLetters++
    if InStr(A_LoopField, "f")
        uniqueLetters++
    if InStr(A_LoopField, "g")
        uniqueLetters++
    if InStr(A_LoopField, "h")
        uniqueLetters++
    if InStr(A_LoopField, "i")
        uniqueLetters++
    if InStr(A_LoopField, "j")
        uniqueLetters++
    if InStr(A_LoopField, "k")
        uniqueLetters++
    if InStr(A_LoopField, "l")
        uniqueLetters++
    if InStr(A_LoopField, "m")
        uniqueLetters++
    if InStr(A_LoopField, "n")
        uniqueLetters++
    if InStr(A_LoopField, "o")
        uniqueLetters++
    if InStr(A_LoopField, "p")
        uniqueLetters++
    if InStr(A_LoopField, "q")
        uniqueLetters++
    if InStr(A_LoopField, "r")
        uniqueLetters++
    if InStr(A_LoopField, "s")
        uniqueLetters++
    if InStr(A_LoopField, "t")
        uniqueLetters++
    if InStr(A_LoopField, "u")
        uniqueLetters++
    if InStr(A_LoopField, "v")
        uniqueLetters++
    if InStr(A_LoopField, "w")
        uniqueLetters++
    if InStr(A_LoopField, "x")
        uniqueLetters++
    if InStr(A_LoopField, "y")
        uniqueLetters++
    if InStr(A_LoopField, "z")
        uniqueLetters++

    if (uniqueLetters > longestLength) {
        longestWord := A_LoopField
        , longestLength := uniqueLetters
    }
}

Msgbox "Longest unique: " longestWord . ", " longestLength . " characters long."