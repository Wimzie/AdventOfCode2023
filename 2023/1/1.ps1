$inputList = Get-Content .\inputTest.txt


function fixDigits {
    param(
        $line
    )

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
}

$sum = 0
ForEach($line in $inputList) {
    $line = fixDigits -line $line
    $numbers = $line -split "" | Where-Object {$_ -match "\d"}
    [int]$numberToAdd = "$($numbers[0])$($numbers[-1])"
    $sum += $numberToAdd
}



Write-Host $sum