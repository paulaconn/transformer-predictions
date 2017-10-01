# transformer-predictions
Linear and logistic regression applied to the prediction of electrical transformer statuses, for more effective maintenance. Requires Matlab for use.

##Files:
- linearRegression.m: Calculates the r values and simple linear regression. You only need to run this file.
- logisticRegression.m: Used by linearRegression.m, calculates the results for logistic regression.
- multipleLinRession.m: Used by linearRegression.m, calculates the results for multivariable linear regression.
- IF1-FEB22-detailed.csv: Private information that cannot be shared. However, the matlab code is usable with your own data. Columns include Year, Water content measured (ppm), Total acid number (mgKOH/g), Breakdown voltage, Dissipation factor, Colour, Interfacial tension (mN/m), and Class. 

##Usage:
1. Clone repository to a local folder
2. Open linearRegression.m in Matlab and run file

##Outputs:
Outputs results for linear and logistic regression. Graphs are used to illustrate and inform the results.