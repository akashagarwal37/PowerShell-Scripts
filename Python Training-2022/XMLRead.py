import xml.etree.ElementTree as xml
students=[{'name':'John','age':25,'result':'A+'},{'name':'Bob','age':24,'result':'A'}]
root = xml.Element("students")
print(root.tag)
print(root.attrib)
for student in students:
       child=xml.Element("student")
       root.append(child)
       nm = xml.SubElement(child, "name")
       nm.text = student.get('name')
       age = xml.SubElement(child, "age")
       age.text = str(student.get('age'))
       mark=xml.SubElement(child, "result")
       mark.text=str(student.get('result'))
tree = xml.ElementTree(root)
with open('studentdata.xml', "wb") as fh:
       tree.write(fh)
print("Successfully created")
