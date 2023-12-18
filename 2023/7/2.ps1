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

    $firstHandChars = $firstHand.ToCharArray() | ForEach {$_ -replace "A",14 -replace "K",13 -replace "Q",12 -replace "J",1 -replace "T",10}
    $secondHandChars = $SecondHand.ToCharArray() | ForEach {$_ -replace "A",14 -replace "K",13 -replace "Q",12 -replace "J",1 -replace "T",10}

    for($i = 0; $i -lt 5; $i++) {
        if([int]$firstHandChars[$i] -gt [int]$secondHandChars[$i]) {
            return $false
        } elseif ([int]$secondHandChars[$i] -gt [int]$firstHandChars[$i]) {
            return $true
        }
    }
}

function GetHandRanking {
    Param (
        $hand
    )

    $jokerCount = 0

    if($hand -like "*J*") {
        $duplicateJokers = (($hand.ToCharArray() | Group-Object) | Where-Object {$_.Count -gt 1 -and $_.Name -eq "J"}).Count
        if(!$duplicateJokers) {
            $jokerCount = 1
        } else {
            $jokerCount = $duplicateJokers
        }
    }

    if($jokerCount -eq 5) {
        return 7
    }

    $duplicateCharacters = ($hand.ToCharArray() | Group-Object) | Where-Object {$_.Count -gt 1 -and $_.Name -ne "J"}

    if($duplicateCharacters -is [Object[]]) {
        if(($duplicateCharacters[0].Count -eq 3) -or ($duplicateCharacters[1].Count -eq 3) -or ($jokerCount -eq 1)) {
            return 5
        }
        return 3
    }

    #Five of a kind: 7
    #Four of a kind: 6
    #Full house: 5
    #Three of a kind: 4
    #Two pair: 3
    #Pair: 2
    #High card: 1
    
    switch ($duplicateCharacters.Count) {
        5 {
            return 7
        }
        4 {
            if($jokerCount -eq 1) {
                return 7
            }
            return 6
        }
        3 {
            if($jokerCount -eq 2) {
                return 7
            }
            if($jokerCount -eq 1) {
                return 6
            }
            return 4
        }
        2 {
            if($jokerCount -eq 3) {
                return 7
            }
            if($jokerCount -eq 2) {
                return 6
            }
            if($jokerCount -eq 1) {
                return 4
            }
            return 2
        }
        default {
            if($jokerCount -eq 4) {
                return 7
            }
            if($jokerCount -eq 3) {
                return 6
            }
            if($jokerCount -eq 2) {
                return 4
            }
            if($jokerCount -eq 1) {
                return 2
            }
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

