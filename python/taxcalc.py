"""
Revised Income Tax Slabs for the New Tax Regime (default) FY 2023–24:

Up to Rs.3 lakh - 0% (Nil)
Rs 3 lakh to 6 lakh - 5%
Rs 6 lakh to 9 lakh - 10%
Rs 9 lakh to Rs 12 lakh - 15%
Rs 12 lakh to Rs 15 lakh - 20%
Above Rs 15 lakh - 30%
"""
print("--------------------------------------------")
Income=int(input("Please enter your CTC(in digits ie for 1 Lakh it should 100000):"))
if Income < 300000:
 print("Your imcome is less than 3 Lakhs, you don't need to pay tax")
 exit()

TaxSlab = int((Income/300000 - 1))
Incomeextratoslab=Income%300000
Tax = 0
Proftax=3000

for Slab in range(TaxSlab):
 Slab=Slab+1
 Taxpercentage = Slab * 5
 print("Tax for slab %", Taxpercentage)
 Taxperslab=(300000*(Taxpercentage/100))
 Tax=Tax+Taxperslab
 print("Tax for %",Taxpercentage," slab", Taxperslab)

print("-------------------------------------------------------")
# Tax outside the slab
Slab=Slab+1
Taxpercentage = Slab * 5
Taxperslab=(Incomeextratoslab*(Taxpercentage/100))
Tax=Tax+Taxperslab

print("Income extra", Incomeextratoslab)
print("Tax total", Tax)
Total_Tax=Tax+(Tax*.04)

print("-------------------------------------------------------")
print("Your highgest tax slab%", Taxpercentage)
print("Tax based on your income slab:", Tax)
print("Total Cess",(Tax*.04))
print("As per this test calculation, you would need to pay tax of Rs: ", Total_Tax)
print("-------------------------------------------------------")
Takehome=(Income - Total_Tax)/12
print("Monthly take home assuming no variable pay(excluding prof. tax and PF deductions):", Takehome)
print("-------------------------------------------------------")

