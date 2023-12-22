$inputList = Get-Content .\input.txt

function initiateBoard {
    param(
        [array]$inputList
    )

    $board = New-Object 'object[,]' $inputList.Count,$inputList[0].Length

    for($i = 0; $i -lt $inputList.Count; $i++) {
        $line = $inputList[$i] -split "" | Where-Object {$_ -ne ""}
        for($j = 0; $j -lt $line.Count; $j++) {
            if([string]($line[$j]) -eq "S") {
                $startPosition = "$i,$j"
            }
            $board[$i,$j] = [string]($line[$j])
        }
    }
    , @($board, $startPosition)
}

function checkPosition {
    param(
        $board,
        $position,
        $symbol,
        $previousDirection
    )

    $yCord = $position.split(",")[1]
    $xCord = $position.Split(",")[0]

    $validUpPipes = "7|F|\|"
    $validDownPipes = "L|J|\|"
    $validLeftPipes = "L|F|-"
    $validRightPipes = "7|J|-"

    switch($symbol) {
        "S" {
            #Check up
            if($xCord -gt 0 -and $board[$([int]$xCord-1),$yCord] -and $board[$([int]$xCord-1),$yCord] -match $validUpPipes) {
                return "$([int]$xCord-1),$yCord", $board[$([int]$xCord-1),$yCord], "up"
            }
            #Check down
            if(($xCord -lt $inputList.Count -1) -and $board[$([int]$xCord+1),$yCord] -and $board[$([int]$xCord+1),$yCord] -match $validDownPipes) {
                return "$([int]$xCord+1),$yCord", $board[$([int]$xCord+1),$yCord], "down"
            }
            #Check left
            if($yCord -gt 0 -and $board[$xCord,$([int]$yCord-1)] -and $board[$xCord,$([int]$yCord-1)] -match $validLeftPipes) {
                return "$xCord,$([int]$yCord-1)", $board[$xCord,$([int]$yCord-1)], "left"
            }
            #Check right
            if(($yCord -lt $inputList[0].Length -1) -and $board[$xCord,$([int]$yCord+1)] -and $board[$xCord,$([int]$yCord+1)] -match $validRightPipes) {
                return "$($xCord,$([int]$yCord+1))", $board[$xCord,$([int]$yCord+1)], "right"
            }
        }
        "|" {
            if($previousDirection -eq "up") {
                return "$([int]$xCord-1),$yCord", $board[$([int]$xCord-1),$yCord], "up"
            } else {
                return "$([int]$xCord+1),$yCord", $board[$([int]$xCord+1),$yCord], "down"
            }
        }
        "-" {
            if($previousDirection -eq "left") {
                return "$xCord,$([int]$yCord-1)", $board[$xCord,$([int]$yCord-1)], "left"
            } else {
                return "$xCord,$([int]$yCord+1)", $board[$xCord,$([int]$yCord+1)], "right"
            }
        }
        "L" {
            if($previousDirection -eq "left") { 
                return "$([int]$xCord-1),$yCord", $board[$([int]$xCord-1),$yCord], "up"
            } else {
                return "$xCord,$([int]$yCord+1)", $board[$xCord,$([int]$yCord+1)], "right"
            }
        }
        "J" {
            if($previousDirection -eq "right") { 
                return "$([int]$xCord-1),$yCord", $board[$([int]$xCord-1),$yCord], "up"
            } else {
                return "$xCord,$([int]$yCord-1)", $board[$xCord,$([int]$yCord-1)], "left"
            }
        }
        "7" {
            if($previousDirection -eq "right") { 
                return "$([int]$xCord+1),$yCord", $board[$([int]$xCord+1),$yCord], "down"
            } else {
                return "$xCord,$([int]$yCord-1)", $board[$xCord,$([int]$yCord-1)], "left"
            }
        }
        "F" {
            if($previousDirection -eq "left") { 
                return "$([int]$xCord+1),$yCord", $board[$([int]$xCord+1),$yCord], "down"
            } else {
                return "$xCord,$([int]$yCord+1)", $board[$xCord,$([int]$yCord+1)], "right"
            }
        }
    }
}



$boardInitiation = initiateBoard -inputList $inputList
$board = $boardInitiation[0]
$startPosition = $boardInitiation[1]

$loop = @($startPosition)

$currentPosition = $startPosition
$init = checkPosition -board $board -position $startPosition -symbol "S"
$currentPosition = $init[0]
$previousSymbol = $init[1]
$previousDirection = $init[2]
$loop += $currentPosition
While($true) {
    $newPos = checkPosition -board $board -position $currentPosition -symbol $previousSymbol -previousDirection $previousDirection
    $currentPosition = $newPos[0]
    $previousSymbol = $newPos[1]
    $previousDirection = $newPos[2]

    if($currentPosition -eq $startPosition) {
        break
    }
    $loop += $currentPosition
}

$enclosedDots = 0


$pipeSymbols = "L|J|7|F|S"
$rowsWithPipes = @()
ForEach($pos in $loop) {
    $rowsWithPipes += $pos.Split(",")[0]
}
$rowsWithPipes = $rowsWithPipes | Select-Object -Unique

ForEach($row in $rowsWithPipes) {
    $rowString = ""
    for($i = 0; $i -lt $inputList[0].Length; $i++) {
        $rowString += $board[$row, $i]
    }
    #if($rowString -match ".*\..*") {
    #    $indexOfDots = (0..($rowString.Length-1)) | Where-Object {$rowString[$_] -eq "."}
    For($i = 0; $i -lt $rowString.Length; $i++) {
        if($loop -contains "$row,$i") {
            continue
        }
        $edgesLeft = 0
        $symbolsFound = ""
        for($j = 0; $j -lt $i; $j++) {
            if($rowString[$j] -eq "|" -and $loop -contains "$row,$j") {
                $edgesLeft += 1
            } elseif($rowString[$j] -match $pipeSymbols -and $loop -contains "$row,$j") {
                $symbolsFound += $rowString[$j]
            }
        }

        if($symbolsFound -match "F-*7" -or $symbolsFound -match "L-*J") {
            $edgesLeft += (2 * ((((($symbolsFound -replace "F-*7", "1") -replace "L-*J", "1") -replace "[A-Z]","") -replace "7","").toCharArray()).Count)
        } 
        if($symbolsFound -match "F-*J" -or $symbolsFound -match "L-*7") {
            $edgesLeft += (1 * ((((($symbolsFound -replace "L-*7", "1") -replace "F-*J", "1") -replace "[A-Z]","") -replace "7","").toCharArray()).Count)
        }

        if($edgesLeft -eq 0 -or [Math]::Floor($edgesLeft) % 2 -eq 0) {
            continue
        }

        $edgesRight = 0
        $symbolsFound = ""
        for($j = $i+1; $j -lt $rowString.Length; $j++) {
            if($rowString[$j] -eq "|" -and $loop -contains "$row,$j") {
                $edgesRight += 1
            } elseif($rowString[$j] -match $pipeSymbols -and $loop -contains "$row,$j") {
                $symbolsFound += $rowString[$j]
            }
        }

        if($symbolsFound -match "F-*7" -or $symbolsFound -match "L-*J") {
            $edgesRight += (2 * ((((($symbolsFound -replace "F-*7", "1") -replace "L-*J", "1") -replace "[A-Z]","") -replace "7","").toCharArray()).Count)
        }
        if($symbolsFound -match "F-*J" -or $symbolsFound -match "L-*7") {
            $edgesRight += (1 * ((((($symbolsFound -replace "L-*7", "1") -replace "F-*J", "1") -replace "[A-Z]","") -replace "7","").toCharArray()).Count)
        }

        if($edgesRight -eq 0 -or [Math]::Floor($edgesRight) % 2 -eq 0) {
            continue
        }
        $enclosedDots++
    }
    #}
}

Write-Host $enclosedDots