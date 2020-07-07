import sys
import os
import subprocess
from scm import perforce, github, utils

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
    elif locationTypeValue.lower() == 'git':
        print ("-- GIT")
        func = github.localcheckout
    else:
        print (f"Location type {locationTypeValue} not supported.")
        exit(1)

    args = func(normalizedArgs, workspaceDir)

    postFetchScripts = os.listdir ("/post-fetch")

    postArgs = [workspaceDir, locationTypeValue]

    for entry in postFetchScripts:
        if not os.path.isdir(entry) and os.access(entry, os.X_OK):
            code = subprocess.run ([os.path.join("/post-fetch", entry)] + postArgs).returncode
            if code != 0:
                print (f'Execution of {entry} failed with value {code}')

else:
    args = sys.argv[1:]


process = subprocess.run(["/opt/cxcli/runCxConsole.sh"] + args)

# Propagate the CxCLI return code to the caller.
exit (process.returncode)

