[1mdiff --git a/windows/win_hosts.py b/windows/win_hosts.py[m
[1mindex 44f0812..b66fc9a 100644[m
[1m--- a/windows/win_hosts.py[m
[1m+++ b/windows/win_hosts.py[m
[36m@@ -39,7 +39,7 @@[m [moptions:[m
     required: true[m
   state:[m
     description:[m
[31m-      - present to ensure environment variable is set, or absent to ensure it is removed[m
[32m+[m[32m      - Present to ensure HOST record is present, or absent to ensure it is removed[m
     required: false[m
     default: present[m
     choices:[m
[36m@@ -54,7 +54,7 @@[m [moptions:[m
     description:[m
       - HOSTS file to edit[m
     required: false[m
[31m-    default: %WINDIR%\system32\drivers\etc\hosts [m
[32m+[m[32m    default: "$env:Windir\system32\drivers\etc\hosts"[m[41m [m
 author: "Alex West (@alxwest)"[m
 '''[m
 [m
[36m@@ -62,10 +62,9 @@[m [mEXAMPLES = '''[m
 ---[m
 # Example from an Ansible Playbook[m
 - win_hosts:[m
[31m-   name: locahost.local[m
[31m-   ip: 127.0.0.1[m
[31m-   state: present[m
[31m-   comments: This is a comment[m
[31m-[m
[32m+[m[32m    name: locahost.local[m
[32m+[m[32m    ip: 127.0.0.1[m
[32m+[m[32m    state: present[m
[32m+[m[32m    comments: This is a comment[m
 '''[m
 [m
