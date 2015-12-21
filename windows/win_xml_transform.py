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
module: win_xml_transform
version_added: "1.9"
short_description: Installs packages using Nuget
description:
    - Transforms an XML file given instructions from an XDT file.
options:
  xmlpath:
    description:
      - Path to the XML file to be transformed
    required: true
  xdtpath:
    description:
      - Path to the XTD file with the tranformation instructions
    required: true
author: "Alex West (@alxwest)"
'''

EXAMPLES = '''
  # Tranform XML
  win_xml_transform:
    xmlpath: /path/to/xmlFile.xml
	xdtpath: /path/to/xdtFile.xdt
'''
