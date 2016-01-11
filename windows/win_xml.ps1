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

$params = Parse-Args $args;
$result = New-Object PSObject;
Set-Attr $result "changed" $false;

$path = Get-Attr -obj $params -name path -failifempty $true -emptyattributefailmessage "missing required argument: path"
$value = Get-Attr -obj $params -name value -failifempty $true -emptyattributefailmessage "missing required argument: value"
$xpath = Get-Attr -obj $params -name xpath -failifempty $true -emptyattributefailmessage "missing required argument: xpath"
$state = Get-Attr -obj $params -name state -default "present"
if ("present","absent" -notcontains $state)
{
    Fail-Json $result "state is $state; must be present or absent"
}

Try
{
        if (!$path -or !(Test-Path -path $path -PathType Leaf)) {
            Set-Attr $result "xml_error_path" $path
        throw "File not found. $path";
    }

        $xml = [xml](Get-Content $path)
        $nodes = $xml.selectNodes($xpath)

    if ($state -eq "present")
    {
                if($nodes)
                {
                        foreach ($node in $nodes) {
                                if ($node -ne $null) {
                                        if ($node.NodeType -eq "Element") {
                                                $node.InnerXml = $value
                                                $result.changed = $true
                                        }
                                        else {
                                                $node.Value = $value
                                                $result.changed = $true
                                        }
                                }
                        }
                }
                else
                {
                        Set-Attr $result "xml_error_path" $path
                        throw "Node not found. $xpath";
                }
    }
    elseif($nodes)
    {
                foreach ($node in $nodes) {
                        if ($node -ne $null) {
                                if ($node.NodeType -eq "Element") {
                                        $node.ParentNode.RemoveChild($node)
                                }
                                elseif ($node.NodeType -eq "Attribute") {
                                        $node.OwnerElement.RemoveAttribute($node.Name)
                                        $result.changed = $true
                                }
                                else {
                                        Set-Attr $result "xml_error_path" $path
                                        throw "NodeType unsupported not found. $xpath";
                                }
                        }
                }
    }
        if($result.changed)
        {
           $xml.Save($path)
        }

    Exit-Json $result;
}
Catch
{
     Fail-Json $result $_.Exception.Message
}                                                                                             