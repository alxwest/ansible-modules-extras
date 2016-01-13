#!/usr/bin/python
# -*- coding: utf-8 -*-

# (c) 2015, Alex West <alxwest@gmail.com>
#
# This file is part of Ansible
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

# this is a windows documentation stub.  actual code lives in the .ps1
# file of the same name

DOCUMENTATION = '''
---
module: win_sql_deploy
version_added: "1.9"
short_description: Deploys SQL scripts to a database
description:
    - Deploys SQL scripts prepared by ReadyRoll and packaged by Octopack.
options:
  path:
    description:
      - Path to SQL deployment package
    required: true
  server:
    description:
      - Name of the server that holds the database 
    required: true
  release_version:
    description:
      - Release version of the SQL deployment package to deploy
    required: false
    default: null  
  database_name:
    description:
      - Name of the server to deploy to.
    required: false
    default: Whatever is specified in the SQL deployment package
  use_windows_auth:
    description:
      - Use windows authentication
    required: false
    choices:
      - true
      - false
    default: true
  username:
    description:
      - SQL user name to run the scripts against
    required: only if use_windows_auth is false
    default: null
  password:
    description: 
      - SQL password for authentication
    required: only if use_windows_auth is false
    default: null
  force_deploy_without_baseline:
    description:
      - Force a deployment without a baseline
    require: false
    choices:
      - true
      - false
    default: false
  file_prefix:
    description:
      - ?
    required: false
    default: Whatever is specified in the SQL deployment package
  data_path:
    description:
      - Path for the SQL data files
    required: false    
    default: Whatever the server is set to
  log_path:
    description:
      - Path for the SQL log files
    required: false    
    default: Whatever the server is set to
  backup_path:
    description:
      - Path for the SQL backups
    required: false    
    default: Whatever the server is set to
author: "Alex West (@alxwest)"
'''

EXAMPLES = '''
  # Install package
  win_sql_deploy:
    path: /path/to/deployed/package
    server: locahost
    database_name: AdventureWorks

'''
