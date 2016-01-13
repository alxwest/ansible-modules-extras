#!powershell
# This file is part of Ansible
#
# Copyright 2015, Alex West <alxwest@gmail.com>
#
# Ansible is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ansible is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Ansible.  If not, see <http://www.gnu.org/licenses/>.

# WANT_JSON
# POWERSHELL_COMMON

$exefolder = "$env:programdata\nuget"
$params = Parse-Args $args;
$result = New-Object PSObject;
Set-Attr $result "changed" $false;

$package = Get-Attr -obj $params -name name -failifempty $true -emptyattributefailmessage "missing required argument: name"
$outputdirectory = Get-Attr -obj $params -name outputdirectory --emptyattributefailmessage "missing required argument: outputdirectory"
if ($outputdirectory) {$outputdirectory = $outputdirectory.Tolower()}

$version = Get-Attr -obj $params -name version -default $null

$source = Get-Attr -obj $params -name source -default $null

$state = Get-Attr -obj $params -name state -default "present"

$customexe = $false
$nugetexe = Get-Attr -obj $params -name nugetexe -default $null

if ($nugetexe) 
{
    $nugetexe = $nugetexe.Tolower()
    $customexe = $true
} 
else 
{
    $nugetexe = "$exefolder\nuget.exe"
}

if ("present","absent" -notcontains $state)
{
    Fail-Json $result "state is $state; must be present or absent"
}

function Test-Administrator  
{  
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)  
}

if(Test-Administrator -eq $false -and ($env:path -match [regex]::escape($exefolder)) = $false )
{      
    #This is temporary.
    $env:Path += ";$exefolder"
}


Function Nuget-Install-Upgrade
{
    [CmdletBinding()]

    param()

    $NugetAlreadyInstalled = get-command nuget -ErrorAction 0
    if ($NugetAlreadyInstalled -eq $null)
    {
        #We need to install Nuget
        New-Item -Path $exefolder  -Force -ItemType directory
        Invoke-WebRequest "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe"  -OutFile $nugetexe
        if(Test-Administrator -eq $true -and ($env:path -match [regex]::escape($exefolder)) = $false)
        {
            [Environment]::SetEnvironmentVariable("Path", $env:Path + ";$exefolder", [EnvironmentVariableTarget]::Machine)
        }
        $result.changed = $true
        $script:executable = $nugetexe
    }
    else
    {
        $script:executable = $nugetexe

        if ($customexe -eq $false -and (Get-Item $nugetexe).VersionInfo.FileVersion -notmatch '3.3.0' )
        {
            #TODO Upgrade nuget
        }
    }
}

Function Nuget-PackageVersion
{
    [CmdletBinding()]
         
    param(
        [Parameter(Mandatory=$true, Position=1)]
        [string]$package
    )

    if($script:version -eq $null)
    {
       $cmd = "$script:executable list $package"
       $results = invoke-expression $cmd
       if ($LastExitCode -ne 0)
       {
           Set-Attr $result "nuget_error_cmd" $cmd
           Set-Attr $result "nuget_error_log" "$results"
       
           Throw "Error checking package version for $package" 
       }
       if($results -is [system.array])
       {
           Set-Attr $result "nuget_error_cmd" $cmd
           Set-Attr $result "nuget_error_log" "More that one package returned"
       
           Throw "Error checking package version for $package" 
       }
       $script:version = $results.Substring($package.Length+1)    
    }
    $script:version
}

Function Nuget-IsInstalled
{
    [CmdletBinding()]
    
    param(
        [Parameter(Mandatory=$true, Position=1)]
        [string]$package, 
        [Parameter(Mandatory=$true, Position=2)]
        [string]$outputdirectory
    )

    $version = Nuget-PackageVersion $package

    return Test-Path "$outputdirectory\$package.$version\*.nupkg"    
}

Function Nuget-Install 
{
    [CmdletBinding()]
    
    param(
        [Parameter(Mandatory=$true, Position=1)]
        [string]$package,
        [Parameter(Mandatory=$false, Position=2)]
        [string]$version,
        [Parameter(Mandatory=$false, Position=3)]
        $source,
        [Parameter(Mandatory=$false, Position=4)]
        [string]$outputdirectory
    )

    if (Nuget-IsInstalled $package $outputdirectory)
    {
        return
    }

    $cmd = "$script:executable install $package -verbosity detailed -noninteractive"

    if ($version)
    {
        $cmd += " -version $version"
    }
	if($source -is [system.array])
	{
		foreach ($s in $source) {
			  $cmd += " -source $s"
			}
	}
	elseif ($source)
    {
        $cmd += " -source $source"
    }

    if ($outputdirectory)
    {
        $cmd += " -outputdirectory $outputdirectory"
    }
    
    $results = invoke-expression $cmd

    if ($LastExitCode -ne 0)
    {
        Set-Attr $result "nuget_error_cmd" $cmd
        Set-Attr $result "nuget_error_log" "$results"
        Throw "Error installing $package" 
    }

     $result.changed = $true
     Set-Attr $result "install_path" "$outputdirectory\$package.$version"
}

Try
{
    Nuget-Install-Upgrade

    if ($state -eq "present")
    {
        Nuget-Install -package $package -version $version -source $source -outputdirectory $outputdirectory 
    }
    elseif (Nuget-IsInstalled $package $outputdirectory)
    {
            Remove-Item $outputdirectory
            $result.changed = $true
    }      
    
    Exit-Json $result;
}
Catch
{
     Fail-Json $result $_.Exception.Message
}

