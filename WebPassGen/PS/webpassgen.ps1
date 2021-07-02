rv * -ea SilentlyContinue; rmo *; $error.Clear(); cls

$passwordLength = $args[0]

if ($passwordLength -lt 8) {
    write-host "You must choose an integer equal to or larger than 8"
    pause
    exit
}

$WebResponse = Invoke-WebRequest "https://en.wikipedia.org/wiki/Rome"

$WebText = $WebResponse.ParsedHtml.all.tags("p") | ForEach-Object -MemberName innertext

$CleanWebText = $WebText -replace '[^a-zA-Z0-9\\n]',' '

$FullDictionary = $CleanWebText.Split(" ")

$FullDictionary = $FullDictionary | select -Unique

$Dictionary = @()
foreach ($word in $FullDictionary) {
    if ($word.length -ge 4) {
        $Dictionary = $Dictionary + $word
    }
}

while ($passwordLength -ne 0) {
    $PickerDict = @()
    if ($passwordLength -eq 4 -Or $passwordLength -eq 8) {
        foreach ($word in $Dictionary) {
            if ($word.length -eq 4) {
                $PickerDict = $PickerDict + $word
            }
        }
        $newWord = $PickerDict | Get-Random
        $password = $password += $newWord
        $passwordLength = $passwordLength - 4
    } elseif ($passwordLength -gt 8) {
        $newWord = $Dictionary | Get-Random
        $password = $password += $newWord
        $passwordLength = $passwordLength - $newWord.length
    } else {
        foreach ($word in $Dictionary) {
            if ($word.length -eq $passwordLength) {
                $PickerDict = $PickerDict + $word
            }
        }
        $newWord = $PickerDict | Get-Random
        $password = $password += $newWord
        $passwordLength = 0
    }
}

$password
pause