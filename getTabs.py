#!/usr/bin/env python3


from sys import argv
import json
from mako.template import Template

# Print title and URL for each tab of each window of the specified Firefox profile.
def makeLines(path):
    """
    Create the lines of the table, with a counter, the title and a link to the opened tab.
    :param path: path to the json file with the wanted information
    """
    lines = []
    with open(path, "r") as tabs:
        jdata = json.load(tabs)
        for w in jdata['windows']:
            for t in w['tabs']:
                line = []
                i = t['index'] - 1
                line.append(t["entries"][i]["title"])
                line.append(t["entries"][i]["url"])
                line.append(t["entries"][i]["url"][0:50])
                lines.append(line)
    return lines

pathOut = argv[1]
lines = makeLines(pathOut)

mytemplate = Template(filename='template.html')
print(mytemplate.render(lines=(lines)))
