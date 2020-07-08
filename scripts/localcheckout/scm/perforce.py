from . import utils
import subprocess


def localcheckout (args, workspaceDir):

    p4Array = ['p4']

    locationUserIndex = utils.indexof ('-locationuser', args)
    locationPasswordIndex = utils.indexof ('-locationpassword', args)
    locationPathIndex = utils.indexof ('-locationpath', args)
    locationBranchIndex = utils.indexof ('-locationbranch', args)
    locationPortIndex = utils.indexof ('-locationport', args)
    locationUrlIndex = utils.indexof ('-locationurl', args)

    if locationUrlIndex == None:
        print ("Unknown location URL, use -locationurl")
        exit(1)
    else:
        url = args[locationUrlIndex + 1]

    if locationPathIndex == None:
        print ("Unknown location path, use -locationpath")
        exit(1)
    else:
        path = args[locationPathIndex + 1]
        args[locationPathIndex + 1] = f"{workspaceDir}/"

    port = args[locationPortIndex + 1] if locationPortIndex != None else '1666' 

    p4Array.append ('-p')
    p4Array.append (f'{url}:{port}')

    if locationUserIndex != None:
        p4Array.append ('-u')
        p4Array.append (args[locationUserIndex + 1])

    if locationPasswordIndex != None:
        p4Array.append ('-P')
        p4Array.append (args[locationPasswordIndex + 1])

    if locationBranchIndex == None:
        branch = "#head"
    else:
        branch = args[locationBranchIndex + 1]

    print("Making workspace...")

    workspaceResult = subprocess.run (p4Array + ['client', '-i'], encoding='UTF8', input = f'Client: docker\nRoot: {workspaceDir}\nView:\n\t{path}... //docker/...')

    if workspaceResult.returncode != 0:
        print ("Workspace was not created.")
        exit(workspaceResult.returncode)

    print("Syncing workspace...")

    syncResult = subprocess.run (p4Array + ['-c', 'docker', 'sync', f'{path}/...{branch}'])
    if syncResult.returncode != 0:
        print ("Sync failed.")
        exit(syncResult.returncode)

    print("Deleting workspace...")
    workspaceResult = subprocess.run (p4Array + ['client', '-d', 'docker'], )
    if workspaceResult.returncode != 0:
        print ("Workspace was not deleted.")
        exit(workspaceResult.returncode)


    return args
    
