$inputList = Get-Content .\input.txt

$totalPoints = 0

ForEach($line in $inputList) {
    $winningNumbers = $line.Split("|")[0].Split(":")[-1].Split(" ") | Where-Object {$_ -ne ""}
    $numbersToCheck = $line.Split("|")[-1].Split(" ") | Where-Object {$_ -ne ""}

    $matchedWinningNumbers = @(Compare-Object -ReferenceObject $winningNumbers -DifferenceObject $numbersToCheck -IncludeEqual -ExcludeDifferent)
    if($matchedWinningNumbers) {
        $totalPoints += [math]::Pow(2, ($matchedWinningNumbers.Count)-1)
    }
}

Write-Host $totalPoints