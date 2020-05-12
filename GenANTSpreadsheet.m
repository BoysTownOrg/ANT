numreps=2;
ispractice=1;
ANTPracTable = GenANTtable(numreps,ispractice);
ANTPracTable = ANTPracTable(...
    ANTPracTable.attop==1&ANTPracTable.spatial==0&ANTPracTable.nocue==1,:);
%the above is an ad hoc solution to generating the desired number of
%practice trials, which are always cued and in the middle
numreps=10;
ispractice=0;
ANTTestTable = GenANTtable(numreps,ispractice);
outtable = [ANTPracTable;ANTTestTable];
writetable(outtable,'.\data\ANT.csv');