competitor(appy, sumsum).
smartPhoneTechnology(galactica_s3).
developed(sumsum, galactica_s3).
stole(stevey, galactica_s3, sumsum).
boss(stevey).
company(appy).
company(sumsum).
unethical(X):- boss(X), business(Y), company(Z), rival(Z), stole(X, Y, Z).
rival(X):- competitor(appy, X).
business(X):- smartPhoneTechnology(X).
