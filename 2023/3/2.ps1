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

$cogs = @{}
$totalRatio = 0

function lookForSymbol {
    param(
        $xCord,
        $yCord,
        $board
    )

    $cogsFound = @()


    if($board[$($xCord),$($yCord-1)] -and $board[$($xCord),$($yCord-1)] -match "\*") {
        $cogsFound += "$($xCord),$($yCord-1)"
    }

    if($board[$($xCord),$($yCord+1)] -and $board[$($xCord),$($yCord+1)] -match "\*") {
        $cogsFound += "$($xCord),$($yCord+1)"
    }
    
    if($board[$($xCord-1),$($yCord)] -and $board[$($xCord-1),$($yCord)] -match "\*") {
        $cogsFound += "$($xCord-1),$($yCord)"
    }
    
    if($board[$($xCord+1),$($yCord)] -and $board[$($xCord+1),$($yCord)] -match "\*") {
        $cogsFound += "$($xCord+1),$($yCord)"
    }
    
    if($board[$($xCord-1),$($yCord-1)] -and $board[$($xCord-1),$($yCord-1)] -match "\*") {
        $cogsFound += "$($xCord-1),$($yCord-1)"
    }

    if($board[$($xCord-1),$($yCord+1)] -and $board[$($xCord-1),$($yCord+1)] -match "\*") {
        $cogsFound += "$($xCord-1),$($yCord+1)"
    }

    if($board[$($xCord+1),$($yCord+1)] -and $board[$($xCord+1),$($yCord+1)] -match "\*") {
        $cogsFound += "$($xCord+1),$($yCord+1)"
    }

    if($board[$($xCord+1),$($yCord-1)] -and $board[$($xCord+1),$($yCord-1)] -match "\*") {
        $cogsFound += "$($xCord+1),$($yCord-1)"
    }

    if($cogsFound) {
        return $cogsFound
    }
    return $false
}


$board = initiateBoard -inputList $inputList

For($i = 0; $i -lt $inputList.Count; $i++) {
    $currentNumber = ""
    $cogsFound = @()
    for($j = 0; $j -lt $inputList[0].Length; $j++) {
        if($board[$i,$j] -match "\d") {
            $currentNumber += $board[$i,$j]
            $currentCogsFound = @()
            
            $currentCogsFound = lookForSymbol -xCord $i -yCord $j -board $board
            if($currentCogsFound) {
                $cogsFound += $currentCogsFound
            }
            
        } else {
            if($cogsFound) {
                foreach($cog in $cogsFound) {
                    if($cogs.$cog -notcontains [int]$currentNumber) {
                        $cogs.$cog += @([int]$currentNumber)    
                    }
                }
            }
            $currentNumber = ""
            $cogsFound = @()
        }
    }
    if($cogsFound -and $currentNumber) {
        if($cogsFound) {
            foreach($cog in $cogsFound) {
                if($cogs.$cog -notcontains [int]$currentNumber) {
                    $cogs.$cog += @([int]$currentNumber)    
                }
            }
        }
    }
}

foreach($cog in $cogs.GetEnumerator()) {
    if($cog.Value.Count -gt 1) {
        $ratio = 1
        ForEach($value in $cog.Value) {
            $ratio *= $value
        }
        $totalRatio += $ratio
    }
}

Write-Host $totalRatio