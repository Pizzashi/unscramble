#Requires AutoHotkey v2.0

baseDirectory := A_ScriptDir . "\"
groupsDirectory := baseDirectory . "WordGroups\"
letterArray :=["a","b","c","d","e","f","g","h","i","j","k","l","m"
              ,"n","o","p","q","r","s","t","u","v","w","x","y","z"]

mainGui := Gui(, "Unscrambler")
    mainGui.AddText("x10 w20", "Input: ")

; The current "longest" (i.e., word that contains the most unique letters)
; is blepharoconjunctivitis (with 16 unique characters)
; This results in a total iterations of 65536 at worst case
inputText := mainGui.AddEdit("x+10 yp-3 w265")
longestWordOption := mainGui.AddRadio("x10 Checked", "Same length as input string (faster)")
allwordsOptions := mainGui.AddRadio("x10", "Get all possible words (including sub-words)")
    mainGui.AddButton("x60 y+10 w200 +default", "Unscramble!").OnEvent("Click", Unscramble)
    mainGui.AddText("x10 y+10", "Results")
resultWindow := mainGui.AddEdit("x10 y+10 w300 h300 +ReadOnly", "Waiting for input...")
    mainGui.Show("w320")

Unscramble(*)
{
    resultWindow.Value := "Working..."
    startTime := A_TickCount

    filesContainingWord := []
    , longestWord := longestWordOption.Value
    , allWords := allwordsOptions.Value
    , scrambledText := inputText.Value
    , scrambledTextLen := StrLen(scrambledText)
    
    ; Much faster
    if (longestWord) {
        letterCount := getLetterCount(scrambledText)
        matchingFile := buildFileName(letterCount)

        endTime := A_TickCount - startTime

        if FileExist(matchingFile) {
            resultWindow.Value := "Matching words:`n" . FileRead(matchingFile)
                            . "`nTime elapsed: " . endTime . " milliseconds."
        } else {
            resultWindow.Value := "No words found. Please try another word."
        }
    }

    ; Much slower, but it covers all words, including sub-words
    else if (allWords) {
        resultText := ""
        , letterCount := getLetterCount(scrambledText)
        
        ; Use the longest word algorithm to get the same-length words
        matchingFile := buildFileName(letterCount)
        if FileExist(matchingFile) {
            resultText .= scrambledTextLen . " letter words:`n" . FileRead(matchingFile)
        }
        
        ; For the other lengths, use brute force method
        dictionary := FileRead(baseDirectory . "dictionary.txt")
        ; Ignore 1,2,3-letter words
        Loop (scrambledTextLen - 4) {
            workingLength := scrambledTextLen - A_Index
            loopWords := ""
            Loop Parse, dictionary, "`n", "`r"
            {
                wordLen := StrLen(A_LoopField)
                if (wordLen != workingLength)
                    continue
                
                currWord := A_LoopField
                , currWordLtrCount := getLetterCount(A_LoopField)

                notMatch := 0
                Loop (letterCount.Length) {
                    if (letterCount[A_Index] = 0 && currWordLtrCount[A_Index] = 0)
                        continue

                    if (letterCount[A_Index] = 0 && currWordLtrCount[A_Index] != 0) {
                        notMatch := 1
                        break
                    }
                    
                    if (currWordLtrCount[A_Index] > letterCount[A_Index]) {
                        notMatch := 1
                        break
                    }
                }
                
                if (!notMatch)
                    loopWords .= currWord . "`n"
            }

            if (loopWords != "") {
                resultText .= "`n`n" . workingLength . " letter words:`n" . loopWords
                loopWords := ""
            }
        }


        endTime := A_TickCount - startTime
        if (resultText)
            resultWindow.Value := LTrim(resultText . "`n`nTime elapsed: " . endTime . " milliseconds.", "`n`r")
        else
            resultWindow.Value := "No words found. Please try another word."
    }
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

; Supply an array of directories to get an array of directories in ascending elements
sortByElementCount(dirArray)
{
    dirSzArray := []
    Loop dirArray.Length {   
        dir := Trim(dirArray[A_Index], "`n")
        StrReplace(FileRead(dir), "`n",,, &elemCount)
        dirSzArray.InsertAt(A_Index, elemCount)
    }

    Loop {
        ; Check if sorted already
        Loop (dirSzArray.Length - 1) {
            if !isSorted(dirSzArray[A_Index], dirSzArray[A_Index + 1])
                break
            if (A_Index = dirSzArray.Length - 1)
                break 2 ; Completely sorted; break the outer loop
        }
        
        index := 1
        ; Arrange elements in ascending order
        Loop {
            notSorted := 0
            
            if !isSorted(dirSzArray[index], dirSzArray[index + 1]) {
                ; Swap the sizes
                tempVal := dirSzArray[index]
                dirSzArray[index] := dirSzArray[index + 1]
                dirSzArray[index + 1] := tempVal
                ; ...and swap the file directories as well
                tempVal := dirArray[index]
                dirArray[index] := dirArray[index + 1]
                dirArray[index + 1] := tempVal

                notSorted := 1
            }
            
            if (index = dirSzArray.Length - 1 && !notSorted)
                break

            index := (index = dirSzArray.Length - 1) ? 1 : index + 1
        }
    }
    
    for key in dirArray {
        dirArray[A_Index] := StrReplace(key, "`n")
    }

    return dirArray ; dirArray is now sorted
    ; Loop dirSzArray.Length
    ; {
    ;     s .= dirArray[A_Index] "; size: " dirSzArray[A_Index] "`n"
    ; }

    ; msgbox s
}

; Returns true if lower is less than or equal to higher
isSorted(lower, higher) => lower <= higher ? 1 : 0

; Returns the file name containing the resulting words from the letter count
buildFileName(letterCount)
{
    fileName := groupsDirectory
    Loop letterCount.Length {
         ; is non-zero
        if (letterCount[A_Index]) {
            fileName .= letterArray[A_Index] . letterCount[A_Index]
        }
    }

    return fileName . ".txt"
}