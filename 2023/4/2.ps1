$inputList = Get-Content .\input.txt

$winningNumbersPerLine = @{}
$amountOfTickets = @{}
for($i = 0; $i -lt $inputList.Count; $i++) {
    $amountOfTickets.$i = 1
}

$totalAmountOfTickets = $inputList.Count
$i = 0
ForEach($line in $inputList) {
    $winningNumbers = $line.Split("|")[0].Split(":")[-1].Split(" ") | Where-Object {$_ -ne ""}
    $numbersToCheck = $line.Split("|")[-1].Split(" ") | Where-Object {$_ -ne ""}

    $matchedWinningNumbers = @(Compare-Object -ReferenceObject $winningNumbers -DifferenceObject $numbersToCheck -IncludeEqual -ExcludeDifferent)
    $winningNumbersPerLine.$i = $matchedWinningNumbers.Count    
    $i++
}

$i = 0
While($totalAmountOfTickets -gt 0) {
    $totalAmountOfTickets += $($winningNumbersPerLine.$i) * $($amountOfTickets.$i)
    for($j = $i +1; $j -le $($winningNumbersPerLine.$i) + $i; $j++) {
        $amountOfTickets.$j += 1 * $amountOfTickets.$i
    }
    $totalAmountOfTickets -= $amountOfTickets.$i
    $i++
}

$finalAmount = 0
ForEach($amount in $amountOfTickets.GetEnumerator()) {
    $finalAmount += $amount.Value
}

Write-host $finalAmount