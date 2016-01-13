#!powershell
# This file is part of Ansible
#
# Copyright 2016, Alex West <alxwest@gmail.com>
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
 
# win_sql_deploy module (Deploy SQL packages made by Ready Roll) 
 
$params = Parse-Args $args;
 
$result = New-Object psobject @{
    changed = $false
}
#path 
If ($params.path) {
    $path = $params.path.toString()
 
    If (-Not (Test-Path (Join-Path $path "Deploy.ps1"))) {
        Fail-Json $result "$path file or directory does not exist on the host"
    }
}
Else {
    Fail-Json $result "missing required argument: path"
}
#server
If ($params.server) {
    $DatabaseServer = $params.server.toString() 
}
Else {
    Fail-Json $result "missing required argument: server"
}
#version
If ($params.release_version) {
    $ReleaseVersion = $params.release_version.toString() 
}
#database_name
If ($params.database_name) {
    $DatabaseName = $params.database_name.toString() 
}
#use_windows_auth
If ($params.use_windows_auth -ne $null) {
    $DatabaseName = $params.use_windows_auth
}
#username
If ($params.username) {
    $DatabaseUserName = $params.username.toString() 
}
#password
If ($params.password) {
    $DatabasePassword = $params.password.toString() 
}
#force_deploy_without_baseline
If ($params.force_deploy_without_baseline -ne $null) {
    $ForceDeployWithoutBaseline = $params.force_deploy_without_baseline
}
#file_prefix
If ($params.file_prefix) {
    $DefaultFilePrefix = $params.file_prefix.toString() 
}
#data_path
If ($params.data_path) {
    $DefaultDataPath = $params.data_path.toString() 
}
#log_path
If ($params.log_path) {
    $DefaultLogPath = $params.log_path.toString() 
}
#backup_path
 If ($params.backup_path) {
    $DefaultBackupPath = $params.backup_path.toString() 
}
Try {

	#Deploy.ps1
	Invoke-Expression (Join-Path $path "Deploy.ps1")

	#PostDeploy.ps1
	Invoke-Expression (Join-Path $path "PostDeploy.ps1")

	$result.changed = $true
}
Catch {
    Fail-Json $result "an error occured when attempting to $state $rights permission(s) on $path for $user"
}
 
Exit-Json $result