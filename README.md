# Case fatality rate for COVID-19 in South Africa
This is a case fatality ratio for COVID-19 in South Africa.
It is for tutorial purposes and helps the user (me) to solve organizational issues of projects and 
appreciate the importance of implementing a structure for a project.

The project includes three folders:
- Code: has all the R scripts
- Data: The data used by the project
- Output: where the output (ideally graphics) are stored

## Code folder
This has the following script:
- epicurve plots.R: This script uses the downloaded data from the data folder (owid-rsa.csv: data has been downloaded from our world in data) to plot the reported cases, reported deaths and the case fatality rate (CFR) with zero lag, 15 day lag and a function that chooses the maximum lag based on the user input to plot the CFR.
