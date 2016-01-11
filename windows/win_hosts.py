#!/usr/bin/python
# -*- coding: utf-8 -*-

# (c) 2012, Michael DeHaan <michael.dehaan@gmail.com>, and others
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
module: win_hosts
version_added: "1.9"
short_description: Add and remove hosts
description:
  - Edits the windows HOSTS file
options:
  name:
    description:
      - The name of the Hostname
    required: true
  ip:
    description:
      - The IP address
    required: true
  state:
    description:
      - Present to ensure HOST record is present, or absent to ensure it is removed
    required: false
    default: present
    choices:
      - present
      - absent
  comment:
    description:
      - The comment is appended to the end of the HOSTS entry
    required: false
    default: null
  file:
    description:
      - HOSTS file to edit
    required: false
    default: "$env:Windir\system32\drivers\etc\hosts" 
author: "Alex West (@alxwest)"
'''

EXAMPLES = '''
---
# Example from an Ansible Playbook
- win_hosts:
    name: locahost.local
    ip: 127.0.0.1
    state: present
    comments: This is a comment
'''

