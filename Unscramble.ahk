#Requires AutoHotkey v2.0
/* Thanks to Freepik - Flaticon for the app's icon!
 * https://www.flaticon.com/free-icons/scrambled-eggs
 */
;====================Compiler directives====================;
;@Ahk2Exe-SetName Unscramble
;@Ahk2Exe-SetDescription Unscramble
;@Ahk2Exe-SetMainIcon Unscramble.ico
;@Ahk2Exe-SetCopyright Copyright © 2023 Pizzashi
;@Ahk2Exe-SetVersion 1.0.0.0
;===========================================================;
/*@Ahk2Exe-Keep
    #SingleInstance Off
    #NoTrayIcon
    Listlines False   
*/

#Include "WordCombinations.ahk"
#Include "WordCounts.ahk"

baseDirectory := A_ScriptDir . "\"
groupsDirectory := baseDirectory . "WordGroups\"

mainGui := Gui(, "Unscrambler")
    ; 312 for the unscramble button's lower Y val plus 10 for padding
    mainGui.Opt("+Resize +MinSize750x312")
    mainGui.SetFont("s11", "Segoe UI")
    mainGui.AddText("x10 y10 w20 cBlue", "Input")
inputText := mainGui.AddEdit("xp+0 y+10 w300 -Wrap")
    mainGui.AddText("x10 y+20 cBlue", "Result type")
longestWordOption := mainGui.AddRadio("x10 y+10 Checked", "Same length as input string")
allwordsOption := mainGui.AddRadio("x10", "Get all possible words (including sub-words)")
    mainGui.AddText("x10 y+20 cBlue", "Options")
ignoreWordsOption := mainGui.AddCheckBox("x10 y+10", "Ignore")
ignoreWordsUnder := mainGui.AddEdit("x+5 yp-3 w30", "3")
ignoreWordsOptionCont := mainGui.AddText("x+5 yp+3", "letter words and below")
    mainGui.AddButton("x60 y+30 w200 +default", "Unscramble!").OnEvent("Click", Unscramble)
    mainGui.AddText("x340 y10 cBlue", "Results")
    mainGui.SetFont("s11", "Lucida Sans Typewriter")
resultWindow := mainGui.AddEdit("xp+0 y+5 w400 h300 +ReadOnly", "Waiting for input...")
    mainGui.OnEvent("Size", onWindowResize)
    mainGui.Show("w750") ; 740 + 10 for padding

; This stuff works wonders, lol
; Zero (or minimal, if ever) performance drop as well
EmptyMem()

; The entire purpose of this application
Unscramble(*)
{
    longestWord := longestWordOption.Value
    allWords := allwordsOption.Value
    scrambledText := inputText.Value
    scrambledTextLen := StrLen(scrambledText)
    ignoreWordCount := ignoreWordsOption.Value && ignoreWordsUnder.Value ? ignoreWordsUnder.Value : 0

    if (scrambledTextLen < 1)
        return

    resultWindow.Value := "Working..."
    startTime := A_TickCount

    ; Much faster
    if (longestWord) {
        scrambledLetterCount := getLetterCount(scrambledText)
        matchingVar := buildVarName(scrambledLetterCount)
        endTime := A_TickCount - startTime

        if IsSet(%matchingVar%) {
            wordList := ""
            Loop Parse, %matchingVar%, ","
            {
                if Mod(A_Index, 2) {
                    wordList .= A_LoopField . "`t`t"
                } else {
                    wordList .= A_LoopField . "`n"
                }
            }
            resultWindow.Value := "Matching words:`n" . wordList
                            . "`n`nTime elapsed: " . endTime . " milliseconds."
        } else {
            resultWindow.Value := "No words found. Please try another word."
        }
    }
    ; Slower, but it covers all words, including sub-words
    else if (allWords) {
        finalResult := ""
        scrambledLetterCount := getLetterCount(scrambledText)
        
        ; Use the longest word algorithm to get the same-length words
        matchingVar := buildVarName(scrambledLetterCount)
        if IsSet(%matchingVar%) {
            wordList := ""
            Loop Parse, %matchingVar%, "," {
                wordList .= Mod(A_Index, 2) ? A_LoopField . "`t`t" : A_LoopField . "`n"
            }

            finalResult .= scrambledTextLen . " letter words:`n" . wordList
        }
        ; And for the other word lengths...
        Loop (scrambledTextLen - 1 - ignoreWordCount) {
            workingLength := scrambledTextLen - A_Index
            workingVar := "lettercount_" . workingLength
            loopWords := ""

            if IsSet(%workingVar%) {
                Loop Parse, %workingVar%, "`n", "`r"
                {
                    resultText := ""
                    currWord := A_LoopField
                    , currWordLtrCount := getLetterCount(A_LoopField)

                    notMatch := 0
                    Loop (scrambledLetterCount.Length) {
                        ; If the scrambled text and the current english word both do not contain the specific letter
                        ; then it's still acceptable
                        if (scrambledLetterCount[A_Index] = 0 && currWordLtrCount[A_Index] = 0)
                            continue
                        
                        ; If the current english word contains a letter that the scrambled text does not have
                        ; then it's a non-subword
                        if (scrambledLetterCount[A_Index] = 0 && currWordLtrCount[A_Index] != 0) {
                            notMatch := 1
                            break
                        }
                        
                        ; If the current english word contains more of a specific letter than the scrambled text
                        ; then it's a non-subword
                        if (currWordLtrCount[A_Index] > scrambledLetterCount[A_Index]) {
                            notMatch := 1
                            break
                        }
                    }

                    ; If the current english word passed the tests above, then it's a subword
                    if (!notMatch)
                        loopWords .= currWord . ","
                }

                if (loopWords != "") {
                    resultWords := ""
                    Loop Parse, loopWords, "," {
                        resultWords .= Mod(A_Index, 2) ? A_LoopField . "`t`t" : A_LoopField . "`n"
                    }
                    
                    finalResult .= "`n`n" . workingLength . " letter words:`n" . RTrim(resultWords, "`n`t ")
                    loopWords := ""
                }
            }
        }

        endTime := A_TickCount - startTime
        if (finalResult)
            resultWindow.Value := LTrim(finalResult . "`n`nTime elapsed: " . endTime . " milliseconds.", "`n")
        else
            resultWindow.Value := "No words found. Please try another word. Time elapsed: " . endTime . " milliseconds."
    }

    ; Release memory after each operation
    EmptyMem()
}

; Returns a 26-item array
getLetterCount(whatWord)
{
    a:=0,b:=0,c:=0,d:=0,e:=0,f:=0,g:=0,h:=0,i:=0,j:=0,k:=0,l:=0,m:=0
    ,n:=0,o:=0,p:=0,q:=0,r:=0,s:=0,t:=0,u:=0,v:=0,w:=0,x:=0,y:=0,z:=0
    Loop Parse, whatWord
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
    return [a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z]
}

; Returns the variable name containing the resulting words from the letter count
buildVarName(letterCount)
{
    static letterArray :=["a","b","c","d","e","f","g","h","i","j","k","l","m"
              ,"n","o","p","q","r","s","t","u","v","w","x","y","z"]

    varName := ""
    Loop letterCount.Length {
         ; is non-zero
        if (letterCount[A_Index]) {
            varName .= letterArray[A_Index] . letterCount[A_Index]
        }
    }

    return "wordcomb_" . varName
}

onWindowResize(guiObj, minMax, newWidth, newHeight)
{
    if (minMax = -1) ; The window is minimized
        return
    ; The edit width is 
    ; Testing shows that the result window is at (340, 35)
    resultWindow.Move(,, newWidth - 340 - 10, newHeight - 35 - 10)
}

; https://www.autohotkey.com/board/topic/30042-run-ahk-scripts-with-less-half-or-even-less-memory-usage/
EmptyMem(){
    pid:=DllCall("GetCurrentProcessId")
    h:=DllCall("OpenProcess", "UInt", 0x001F0FFF, "Int", 0, "Int", pid)
    DllCall("SetProcessWorkingSetSize", "UInt", h, "Int", -1, "Int", -1)
    DllCall("CloseHandle", "Int", h)
}