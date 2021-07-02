$passwordLength = $args[0]

# error checking
if ($passwordLength -lt 8) {
    write-host "You must choose an integer equal to or larger than 8"
    pause
    exit
}

$WebResponse = Invoke-WebRequest "https://en.wikipedia.org/wiki/Rome"

# look for all text contained in paragraph blocks
$WebText = $WebResponse.ParsedHtml.all.tags("p") | ForEach-Object -MemberName innertext

# regex for cleaning out symbols
$CleanWebText = $WebText -replace '[^a-zA-Z0-9\\n]',' '

# split the words into an array
$FullDictionary = $CleanWebText.Split(" ")

# remove duplicate items
$FullDictionary = $FullDictionary | select -Unique

# build our main dictionary of words larger than or eq to 4
$Dictionary = @()
foreach ($word in $FullDictionary) {
    if ($word.length -ge 4) {
        $Dictionary = $Dictionary + $word
    }
}

# iterate until the needed length is zero
while ($passwordLength -ne 0) {
    $PickerDict = @()

    # during 4 or 8 length we MUST use a 4 character word
    # we then build a picked dictionary of words 4 characters long
    if ($passwordLength -eq 4 -Or $passwordLength -eq 8) {
        foreach ($word in $Dictionary) {
            if ($word.length -eq 4) {
                $PickerDict = $PickerDict + $word
            }
        }

        # grab a random word from our picked words
        $newWord = $PickerDict | Get-Random

        # add it to the password
        $password = $password += $newWord

        # count down
        $passwordLength = $passwordLength - 4

    # for large numbers we just pick a random word
    } elseif ($passwordLength -gt 8) {
        $newWord = $Dictionary | Get-Random
        $password = $password += $newWord

        # count down by the size of the word we chose
        $passwordLength = $passwordLength - $newWord.length

    # for number between 4 and 8
    } else {

        # create our picked dictionary of words with length
        # of our last needed word
        foreach ($word in $Dictionary) {
            if ($word.length -eq $passwordLength) {
                $PickerDict = $PickerDict + $word
            }
        }
        $newWord = $PickerDict | Get-Random
        $password = $password += $newWord

        # we have chosen our last word so we can set the 
        # length to zero
        $passwordLength = 0
    }
}

$password
pause