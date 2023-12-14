$inputList = Get-Content .\input.txt

function initiateBoard {
    param(
        [array]$inputList
    )

    $board = New-Object 'object[,]' $inputList.Count,$inputList[0].Length

    for($i = 0; $i -lt $inputList.Count; $i++) {
        $line = $inputList[$i] -split "" | Where-Object {$_ -ne ""}
        for($j = 0; $j -lt $line.Count; $j++) {
            $board[$i,$j] = [string]($line[$j])
        }
    }
    , $board
}

function lookForSymbol {
    param(
        $xCord,
        $yCord,
        $board
    )


    if($board[$($xCord),$($yCord-1)] -and $board[$($xCord),$($yCord-1)] -notmatch "\.|\d") {
        return $true
    }

    if($board[$($xCord),$($yCord+1)] -and $board[$($xCord),$($yCord+1)] -notmatch "\.|\d") {
        return $true
    }
    
    if($board[$($xCord-1),$($yCord)] -and $board[$($xCord-1),$($yCord)] -notmatch "\.|\d") {
        return $true
    }
    
    if($board[$($xCord+1),$($yCord)] -and $board[$($xCord+1),$($yCord)] -notmatch "\.|\d") {
        return $true
    }
    
    if($board[$($xCord-1),$($yCord-1)] -and $board[$($xCord-1),$($yCord-1)] -notmatch "\.|\d") {
        return $true
    }

    if($board[$($xCord-1),$($yCord+1)] -and $board[$($xCord-1),$($yCord+1)] -notmatch "\.|\d") {
        return $true
    }

    if($board[$($xCord+1),$($yCord+1)] -and $board[$($xCord+1),$($yCord+1)] -notmatch "\.|\d") {
        return $true
    }

    if($board[$($xCord+1),$($yCord-1)] -and $board[$($xCord+1),$($yCord-1)] -notmatch "\.|\d") {
        return $true
    }

    return $false

}
$partSum = 0
$board = initiateBoard -inputList $inputList

For($i = 0; $i -lt $inputList.Count; $i++) {
    $currentNumber = ""
    $symbolFound = $false
    for($j = 0; $j -lt $inputList[0].Length; $j++) {
        if($board[$i,$j] -match "\d") {
            $currentNumber += $board[$i,$j]
            if(!$symbolFound) {
                $symbolFound = lookForSymbol -xCord $i -yCord $j -board $board
            }
        } else {
            if($symbolFound) {
                $partSum += [int]$currentNumber
            }
            $currentNumber = ""
            $symbolFound = $false
        }
    }
    if($symbolFound -and $currentNumber) {
        $partSum += [int]$currentNumber
    }
}

Write-Host $partSum