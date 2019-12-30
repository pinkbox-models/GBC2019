----------------------------------------------------------------------------------
 Neuronal Population Model of Globular Bushy Cells -- Matlab Implementation 
----------------------------------------------------------------------------------

%%% Versions %%% 

+ Ver. 0.99 (July 07, 2019): Initial release of the code on GitHub. 


%%% Author %%% 

Go Ashida (University of Oldenburg) go.ashida@uni-oldenburg.de


%%% Contents %%% 

testGBCmodel.m   : Sample code for using the GBC model 
GBCmodelACC.m    : Adaptive Coincidence Counting model of GBC 

calcVSstat.m     : Code for calculating rate, vector strength, PSTH, ISIH, etc. 
chooseGBCmodel.m : Code for generating GBC model parameters 

PLNindex.mat : Data index for PLN-type GBC instances (used by chooseGBCmodel.m) 
OnLindex.mat : Data index for OnL-type GBC instances (used by chooseGBCmodel.m) 

PopulationData : Folder for population GBC data used in the paper 

+ Notes: See each program file and the reference below for more detailed descriptions. 


%%% Requirements %%% 

The GBC test script internally uses the Bruce-Erfani-Zilany-2018 model 
of auditory nerves, which is available at Ian Bruce's website, 
http://www.ece.mcmaster.ca/~ibruce/zbcANmodel/zbcANmodel.htm 
(accessed June 2019; URL may change in the future). 
You first need to set up the AN model (for which you may need a 
Matlab-compatible C/C++ compiler). Then you should set your PATH to 
the functions "model_IHC_BEZ2018" and "model_Synapse_BEZ2018". 


%%% Reference %%% 

Ashida G, Heinermann HT, Kretzberg J (2019) 
"Neuronal Population Model of Globular Bushy Cells Covering Unit-to-unit Variability"
PLoS Comput Biol 15: e1007563 
https://doi.org/10.1371/journal.pcbi.1007563


%%% Copyright/License %%% 

Apache 2.0 Lisence. See GBCmodelACC.m for the statement. 


