$inputList = Get-Content .\input.txt

function CompareHands {
    Param (
        $firstHand,
        $secondHand
    )

    $firstHandRanking = GetHandRanking -hand $firstHand
    $secondHandRanking = GetHandRanking -hand $secondHand

    if($firstHandRanking -gt $secondHandRanking) {
        return $false
    } elseif($secondHandRanking -gt $firstHandRanking) {
        return $true
    }

    $firstHandChars = $firstHand.ToCharArray() | ForEach {$_ -replace "A",14 -replace "K",13 -replace "Q",12 -replace "J",11 -replace "T",10}
    $secondHandChars = $SecondHand.ToCharArray() | ForEach {$_ -replace "A",14 -replace "K",13 -replace "Q",12 -replace "J",11 -replace "T",10}

    for($i = 0; $i -lt 5; $i++) {
        if($firstHandChars[$i] -gt $secondHandChars[$i]) {
            return $false
        } elseif ($secondHandChars[$i] -gt $firstHandChars[$i]) {
            return $true
        }
    }
}

function GetHandRanking {
    Param (
        $hand
    )

    $duplicateCharacters = ($hand.ToCharArray() | Group-Object) | Where-Object {$_.Count -gt 1}

    if($duplicateCharacters -is [Object[]]) {
        if(($duplicateCharacters[0].Count -eq 3) -or ($duplicateCharacters[1] -eq 3)) {
            return 5
        }
        return 3
    }
    
    switch ($duplicateCharacters.Count) {
        5 {
            return 7
        }
        4 {
            return 6
        }
        3 {
            return 4
        }
        2 {
            return 2
        }
        default {
            return 1
        }
    
    }
}



$hands = @()

ForEach($line in $inputList) {
    $hands += "$($line.Split(" ")[0]),$($line.Split(" ")[1])"
}

$n = $hands.Count

for($i = 0; $i -lt $n; $i++) {
    for($j = 0; $j -lt $n-1; $j++) {
        $actualFirstHand = $hands[$j].Split(",")[0]
        $actualSecondHand = $hands[$j+1].Split(",")[0]
        if(CompareHands -firstHand $actualFirstHand -secondHand $actualSecondHand) {
            $temp = $hands[$j+1]
            $hands[$j+1] = $hands[$j]
            $hands[$j] = $temp
        }
    }
}

$totalWinnings = 0

For($i = $hands.Count -1; $i -ge 0; $i--) {
    [int]$bet = $hands[$i].Split(",")[1]
    
    $totalWinnings += ($bet * ($hands.Count - $i))
}

Write-Host $totalWinnings


<#
ForEach($hand in $hands) {
    $actualHand = $hand.Split(",")[0]
    $actualHand.ToCharArray() | Group-Object
} #>

