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
module: win_xml
version_added: "1.9"
short_description: Edits XML files
description:
    - Edits XML files
options:
  path:
    description:
      - Name of the file to be edited
    required: true
  value:
    description:
      - The value for the XPath node or attribute.
    require: true
  xpath:
    description:
      - Xpath of value or node to be edited
    required: false
    default: null
  state:
    description:
      - State of the XML specified in the XPath
    required: false
    choices:
      - present
      - absent
    default: present
author: "Alex West (@alxwest)"
'''

EXAMPLES = '''
    xml:
      file: "path/to/some/website/web.config"
      state: present
      xpath: "//appSettings/add[key='DefaultLoginRedirect']/@value"
      value: "https://website/login"
'''