import sys
import os
import subprocess
from scm import perforce, utils

workspaceDir = "/workspace"

if sys.argv[1].lower() == 'localcheckout':
    print ("-- LOCAL CHECKOUT --")

    args = sys.argv[2:]
    normalizedArgs = [x.lower() if x[0] == '-' else x for x in args]

    locationTypeArgIndex = utils.indexof ('-locationtype', normalizedArgs)
    if locationTypeArgIndex == None:
        print ("Unknown location type, use the '-locationtype' argument.")
        exit (1)
    else:
        locationTypeValue = normalizedArgs[locationTypeArgIndex + 1]
        normalizedArgs[locationTypeArgIndex + 1] = 'folder'

    if locationTypeValue.lower() == 'perforce':
        print ("-- PERFORCE")
        func = perforce.localcheckout
    else:
        print (f"Location type {locationTypeValue} not supported.")
        exit(1)
    # elif locationTypeValue.lower() == 'git':
    #     print ("-- GIT")
    #     func = None
# TODO: Git and SVN


    args = func(normalizedArgs, workspaceDir)

#  -locationpath <arg> - add this to set the path to the local folder, changes for perforce, new for git
#  -locationbranch <arg>  - required for Git, not for perforce but appeanded to end of sync - should default to #head
#  -locationurl <arg> - remove when changing it to folder
#  -locationuser <arg> - remove and incorporate into the url
#  -locationpassword <arg> - remove and incorporate into the url


else:
    args = sys.argv[1:]


postFetchScripts = os.listdir ("/post-fetch")

postArgs = [workspaceDir, locationTypeValue]

for entry in postFetchScripts:
    if not os.path.isdir(entry):
        code = subprocess.run ([os.path.join("/post-fetch", entry)] + postArgs).returncode
        if code != 0:
            print (f'Execution of {entry} failed with value {code}')

process = subprocess.run(["/opt/cxcli/runCxConsole.sh"] + args)
