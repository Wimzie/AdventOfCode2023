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
            if(($xCord -lt $board.Count -1) -and $board[$([int]$xCord+1),$yCord] -and $board[$([int]$xCord+1),$yCord] -match $validDownPipes) {
                return "$([int]$xCord+1),$yCord", $board[$([int]$xCord+1),$yCord], "down"
            }
            #Check left
            if($yCord -gt 0 -and $board[$xCord,$([int]$yCord-1)] -and $board[$xCord,$([int]$yCord-1)] -match $validLeftPipes) {
                return "$xCord,$([int]$yCord-1)", $board[$xCord,$([int]$yCord-1)], "left"
            }
            #Check right
            if(($yCord -lt $inputList[0].Count -1) -and $board[$xCord,$([int]$yCord+1)] -and $board[$xCord,$([int]$yCord+1)] -match $validRightPipes) {
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

Write-Host ($loop.Count / 2)





