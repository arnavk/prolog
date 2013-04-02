user-edit(File) :-
   name(File, FileString), 
   name('open -a TextEdit ', TextEditString), %% Edit this line for your favorite editor
   append(TextEditString, FileString, EDIT),
   name(E,EDIT),
   shell(E).
