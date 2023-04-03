import openpyxl 
wb = openpyxl.load_workbook("sample.xlsx")  
sheet = wb.active
c = sheet['A3']
c.value = "New Data"
wb.save("sample.xlsx")
