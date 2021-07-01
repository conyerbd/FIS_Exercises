$Logfile = ".\netsockmon.log"
$net = Get-NetTcpConnection -RemotePort 4888
$netLocalPort = $net.LocalPort
$netRemoteHost = $net.RemoteAddress

# try and grab the last line of the file then the last port numbers
try {
    $lastLine = (Get-Content $Logfile | Select-Object -last 1)

    # throw exception if there isn't any last line
    if ($null -eq $lastLine) {
        throw
    }

    # grab the last 5 digits of the last line
    $lastPort = $lastLine.substring($lastLine.length - 5, 5)
}
catch [Exception]{
    # check to make sure the port we found is the right type
    if ($netLocalPort -is [UInt16]) {

        # No previous connection, starting log
        $time = Get-Date -Format "MM/dd/yyyy HH:mm:ss"
        Add-content $Logfile -value "$time connected to $netRemoteHost on port $netLocalPort"
        exit
    } else {

        # No port connection
        exit
    }
}

# if we aren't connected we just exit
if ($null -eq $netLocalPort) {
    
    # No port connection
    exit
}

# if the current connected port is the same as what's found in the log we exit
# otherwise they are different and we capture to log
if ($netLocalPort -eq $lastPort) {

    # No change found
    exit
} else {

    # We found a change in the port used to connect
    $time = Get-Date -Format "MM/dd/yyyy HH:mm:ss"
    Add-content $Logfile -value "$time connected to $netRemoteHost on port $netLocalPort"
    exit
}