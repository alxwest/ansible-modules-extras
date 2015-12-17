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
module: win_nuget
version_added: "1.9"
short_description: Installs packages using Nuget
description:
    - Installs packages using Nuget (http://nuget.org/). If Nuget is missing from the system, the module will install it.
options:
  name:
    description:
      - Name of the package to be installed
    required: true
  state:
    description:
      - State of the package on the system
    required: false
    choices:
      - present
      - absent
    default: present
  version:
    description:
      - Specific version of the package to be installed. The latest version will install if none is specified
    required: false
    default: null
  source:
    description:
      - Specify source rather than using default nuget repository
    require: false
    default: null
  outputdirectory:
    description:
      - Specifies the directory for the created NuGet package file. If not specified, uses the current directory.
    require: false
    default: null 
author: "Alex West (@alxwest)"
'''

EXAMPLES = '''
  # Install package
  win_nuget:
    name: my.first.package

  # Install package version 6.6
  win_nuget:
    name: my.first.package
    version: 1.2.0

  # remove package
  win_nuget:
    name: my.first.package
    state: absent

  # Install package from specified repository
  win_nuget:
    name: my.first.package
    source: https://locahost/api/v2/
'''
