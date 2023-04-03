from urllib.request import urlopen
from xml.etree.ElementTree import parse
var_url = urlopen('https://www.w3schools.com/xml/plant_catalog.xml')
xmldoc = parse(var_url)
for item in xmldoc.iterfind('channel/item'):
    title = item.findtext('title')
    link = item.findtext('link')
    description= item.findtext('description')
    print(title)
    print(link)
    print(description)
    print()
