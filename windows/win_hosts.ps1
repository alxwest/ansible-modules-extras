#!powershell
#
# (c) 2015, alxwest <alxwest@gmail.com>
#
# Powershell script for adding/removing/showing entries to the hosts file.
#
# Inspired by https://gist.github.com/markembling/173887
#
# Known limitations:
# - assumes all hosts are on seperate lines.
#
# WANT_JSON
# POWERSHELL_COMMON

$file = "$env:Windir\system32\drivers\etc\hosts"

$params = Parse-Args $args
$result = New-Object PSObject;
Set-Attr $result "changed" $false;

function add-host([string]$filename, [string]$ip, [string]$hostname, [string]$comment) {
        remove-host $filename $hostname
        $ip + "`t`t" + $hostname + $comment| Out-File -encoding ASCII -append $filename
        $result.changed = $true
}

function remove-host([string]$filename, [string]$hostname) {
        $c = Get-Content $filename
        $newLines = @()

        foreach ($line in $c) {
                $bits = [regex]::Split($line, "\t+")
                if ($bits.count -eq 2) {
                        if ($bits[1] -ne $hostname) {
                                $newLines += $line
                        }else
                        {
                                $result.changed = $true
                        }
                } else {
                        $newLines += $line
                }
        }

        # Write file
        Clear-Content $filename
        foreach ($line in $newLines) {
                $line | Out-File -encoding ASCII -append $filename
        }
}

# name
$name = Get-Attr $params "name" $FALSE
If ($name -eq $FALSE)
{
   Fail-Json $result "missing required argument: name"
}

# ip
$ip = Get-Attr $params "ip" $FALSE
If ($ip -eq $FALSE)
{
   Fail-Json $result "missing required argument: ip"
}

# state
$state = Get-Attr $params "state" $FALSE
If ($state -eq $FALSE)
{
  $state = "present"
}

# comment
$comment = Get-Attr $params "comment" $FALSE
If ($comment -eq $FALSE)
{
        $comment = ""
} else {
        $comment = "`t#" + $comment
}

# file
$filePath = Get-Attr $params "file" $FALSE
If ($filePath -ne $FALSE)
{
        $file = $filePath
}

try {
        if ($state -eq "present") {
                add-host $file $ip $name $comment
        } elseif ($state -eq "absent") {
                remove-host $file $name
        }

} catch  {
     Fail-Json $result $_.Exception.Message
}
Exit-Json $result

