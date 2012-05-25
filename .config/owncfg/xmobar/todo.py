#!/usr/bin/env python
import sys
import os
import fileinput

def initialize_activities():
# Initiate a list of all the activities {{{    
    global activities_list
    global activities_completed
    todo = open(directory + "/todo.txt", "r")
    for line in todo:
        index = line.rfind('=')
        activities_list.append(line[:index])
        if "=1" in line:
            index = line.rfind('=')
            activities_completed.append(line[:index])
    todo.close()
# }}}

# Get dir path of where this script resides, so that todo.txt
# can be opened when script is run from another dir.
directory = os.path.dirname(__file__)
activities_completed = []
activities_list = []
initialize_activities()

if len(sys.argv) == 2 and sys.argv[1] == "reset":
    for line in fileinput.input([directory + '/todo.txt'], inplace=True):
        # print(line.replace('=1', '=0').rstrip("\n"))
        print(line.rstrip("\n"))
        if "=1" in line:
            index = line.rfind('=')
            activities_completed.append(line[:index])
    
    # TODO: Add database code
    print(activities_completed)


if len(sys.argv) == 3:
    if sys.argv[1] == "done" and sys.argv[2] in activities_list:
        pass
    if sys.argv[1] == "undone" and sys.argv[2] in activities_list:
        pass

print("L: ", activities_list)
print("C: ", activities_completed)
