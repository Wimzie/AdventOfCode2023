$inputList = Get-Content .\input.txt

function checkWord {
    param(
        $word
    )

    switch -regex ($word) {
        ".*one$" {
            return "1e"
        }
        ".*two$" {
            return "2o"
        }
        ".*three$" {
            return "3e"
        }
        ".*four$" {
            return "4r"
        }
        ".*five$" {
            return "5e"
        }
        ".*six$" {
            return "6x"
        }
        ".*seven$" {
            return "7n"
        }
        ".*eight$" {
            return "8t"
        }
        ".*nine$" {
            return "9e"
        }
        default {
            return $word
        }
    }
}
<#
    $line = $line -replace "one", 1 `
            -replace "two", 2 `
            -replace "three", 3 `
            -replace "four", 4 `
            -replace "five", 5 `
            -replace "six", 6 `
            -replace "seven", 7 `
            -replace "eight", 8 `
            -replace "nine", 9

    return $line
} #>


$sum = 0
ForEach($line in $inputList) {
    $currentWord = ""
    $actualLine = ""
    $numberToAdd = 0
    For($i = 0; $i -lt $line.Length; $i++) {
        if($line[$i] -match "[A-Z]|[a-z]") {
            $currentWord += $line[$i]
            $numberCheck = checkWord -word $currentWord
            if($numberCheck -match "\d[a-z]") {
                $actualLine += $numberCheck[0]
                $currentWord = $numberCheck[1]
            }
        } else {
            $actualLine += ($currentWord + $line[$i])
            $currentWord = ""
        }
        
    }
    #$line = fixDigits -line $line
    $numbers = $actualLine -split "" | Where-Object {$_ -match "\d"}
    #if($numbers.Count -gt 1) {
    [int]$numberToAdd = "$($numbers[0])$($numbers[-1])"
    #} else {
    #    $numberToAdd = $numbers
    #}
    
    $sum += $numberToAdd
}



Write-Host $sum