competitor(sumSum, appy).
smartPhoneTech(galactica_S3).
developed(sumSum, galactica_S3).
steal(stevey, sumSum, Z) :- smartPhoneTech(Z), developed(sumSum, galactica_S3).
%%steal(stevey, sumSum, galactica_S3).
boss(stevey).
unethical(X) :- boss(X), business(Z), company(Y), rival(Y), steal(X, Y, Z).
rival(X) :- competitor(X, appy).
business(X) :- smartPhoneTech(X).
company(sumSum).
company(appy).