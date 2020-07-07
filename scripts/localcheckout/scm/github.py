from . import utils
import subprocess
import os
from yarl import URL


def localcheckout (args, workspaceDir):

    gitArray = ['git', 'clone', '--depth', '1']

    locationUserIndex = utils.indexof ('-locationuser', args)
    locationPasswordIndex = utils.indexof ('-locationpassword', args)
    locationPathIndex = utils.indexof ('-locationpath', args)
    locationBranchIndex = utils.indexof ('-locationbranch', args)
    locationPortIndex = utils.indexof ('-locationport', args)
    locationUrlIndex = utils.indexof ('-locationurl', args)

    port = args[locationPortIndex + 1] if locationPortIndex != None else None 
    user = args[locationUserIndex + 1] if locationUserIndex != None else None
    password = args[locationPasswordIndex + 1] if locationPasswordIndex != None else None


    if locationUrlIndex == None:
        print ("Unknown location URL, use -locationurl")
        exit(1)
    else:
        url = URL(args[locationUrlIndex + 1])
        if user != None:
            url = url.with_user(user)
        else:
            url = url.with_user("git")
        if password != None:
            url = url.with_password(password)
        if port != None: 
            url = url.with_port (port) 

    
    if locationPathIndex == None:
        args.append ("-locationpath")
        path = f"{workspaceDir}/"
        args.append (path)
    else:
        path = args[locationPathIndex + 1] = f"{workspaceDir}/"


    if locationBranchIndex == None:
        print ("Unknown branch, use -locationbranch")
        exit(1)
    else:
        gitArray.append ('--branch')
        gitArray.append (os.path.basename(args[locationBranchIndex + 1]))
    
    gitArray.append (str(url))
    gitArray.append (path)

    cloneResult = subprocess.run (gitArray)
    if cloneResult.returncode != 0:
        print (f"Clone failed.")
        exit(cloneResult.returncode)

    
    return args
