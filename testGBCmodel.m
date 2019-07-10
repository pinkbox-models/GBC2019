%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% testGBCmodel.m 
%  Sample code for testing the adapting coincidence counting model 
%  of globular bushy cells 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Requirement: 
%  This script internally calls the Bruce-Erfani-Zilany-2018 model  
%  of auditory nerves. Before using this code, you need to (compile 
%  and) set up the AN model and set your PATH to the functions 
%  "model_IHC_BEZ2018" and "model_Synapse_BEZ2018". 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Caution: Running this script may take several minutes (or even longer 
%          depending on your system). Be patient. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Written by Go Ashida (go.ashida@uni-oldenburg.de), June/July 2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% simulation parameters

% stimulus sound parameters 
FqLo =  350; % [Hz] low-frequency stimulation 
FqHi = 7000; % [Hz] high-frequency stimulation 
LvdB = 70;  % sound level [dBSPL]
LvPa = 10^(LvdB/20)*20e-6; % [Pa] calculated from dB SPL re 20 uPa
phase = 0; % [rad] initial phase

% time steps
DTms  = 0.01; % [ms] time step -- 100kHz sampling rate 
DTsec = DTms*1e-3; % [sec] time step -- for BEZ2018 AN model

% number of repetitions
NrepsBC = 500; 

% time lengths
Tall  = 50; % [ms] entire duration of simulation
Tinit = 15; % [ms] starting time of stimulus
Tstim = 25; % [ms] duration of entire stimulus
Tramp = 3.9;% [ms] duration of stimulus ramp
Nall  = round(Tall /DTms); 
Ninit = round(Tinit/DTms); 
Nstim = round(Tstim/DTms); 
Nramp = round(Tramp/DTms); 
tvms = (0:Nall-1)*DTms-Tinit; % time vector (stimulus starts at time zero)

%% model parameters 
% AN model parameters
ANspont = 70; % spontaneous rate [spikes/sec]
ANtabsmax = 1.5*461e-6; ANtabsmin = 1.5*139e-6; % taken from the AN model sample
ANtrelmax = 894e-6; ANtrelmin = 131e-6; % taken from the AN model sample
ANtabs = (ANtabsmax - ANtabsmin)*0.5 + ANtabsmin; % absolute refractory period
ANtrel = (ANtrelmax - ANtrelmin)*0.5 + ANtrelmin; % relative refractory period

% GBC model parameters (see chooseGBCmodel.m for detail)
[Me,Ae,We,Tr,Ta,Sa] = chooseGBCmodel(0); % example A: using default GBC model values 
%[Me,Ae,We,Tr,Ta,Sa] = chooseGBCmodel(-1); % example B: using a model randomly chosen from PLN population 
%[Me,Ae,We,Tr,Ta,Sa] = chooseGBCmodel(-2); % example C: using a model randomly chosen from OnL population 
%[Me,Ae,We,Tr,Ta,Sa] = chooseGBCmodel(-3); % example D: using a model randomly chosen from PLN+OnL population 
%[Me,Ae,We,Tr,Ta,Sa] = chooseGBCmodel(20); % example E: using a model randomly chosen from PLN population with with Me=20 inputs

%% constructing sound stimuli 
disp('Making sound stimuli'); 
% stimulus sound envelope (ramp)
SoundEnv = zeros(1,Nall);
SoundEnv(Ninit+1            :Ninit+Nramp+1) = (0:Nramp)/Nramp; % upward ramp
SoundEnv(Ninit+Nramp+1      :Ninit+Nstim-Nramp+1) = 1; % stimulus
SoundEnv(Ninit+Nstim-Nramp+1:Ninit+Nstim+1) = (Nramp:-1:0)/Nramp; % downward ramp

% stimulus sound waveforms
CarriLo = sin( 2 * pi * FqLo * ((tvms-Tinit)/1000) + phase); % carrier sine wave
CarriHi = sin( 2 * pi * FqHi * ((tvms-Tinit)/1000) + phase); % carrier sine wave
SoundLo = sqrt(2) * LvPa * SoundEnv .* CarriLo; % apply ramp and scale to Pa 
SoundHi = sqrt(2) * LvPa * SoundEnv .* CarriHi; % apply ramp and scale to Pa 

%% calling AN/GBC models

% number of repetitions (for AN)
NrepsAN = Me * NrepsBC; 

% making output data vectors
ANoutLo = zeros(NrepsAN,Nall); 
BCoutLo = zeros(NrepsBC,Nall);
ANoutHi = zeros(NrepsAN,Nall); 
BCoutHi = zeros(NrepsBC,Nall);

% calling IHC model 
disp('Calling IHC model'); 
vIHClo = model_IHC_BEZ2018(SoundLo,FqLo,1,DTsec,Tall/1000,1,1,1);
vIHChi = model_IHC_BEZ2018(SoundHi,FqHi,1,DTsec,Tall/1000,1,1,1);

% calling AN model
for i=1:NrepsAN
 % show progress
 if(mod(i,1000)==0); disp(sprintf('AN model: reps = %d / %d',i,NrepsAN)); end 
 % get AN model responses
 ANoutLo(i,:) = model_Synapse_BEZ2018(vIHClo,FqLo,1,DTsec,1,0,ANspont,ANtabs,ANtrel);
 ANoutHi(i,:) = model_Synapse_BEZ2018(vIHChi,FqHi,1,DTsec,1,0,ANspont,ANtabs,ANtrel);
end

% calling BC model
 disp('GBC model'); 
for i=1:NrepsBC
 idxE = (i-1)*Me + (1:Me); % index for loop i
 % get GBC model response (low-freq)
 spLo = ANoutLo(idxE,:); 
 [BCoutLo(i,:), vdum, tdum] = GBCmodelACC(spLo,DTms,Ae,We,Tr,Ta,Sa); 
 % get GBC model response (high-freq)
 spHi = ANoutHi(idxE,:); 
 [BCoutHi(i,:), vdum, tdum] = GBCmodelACC(spHi,DTms,Ae,We,Tr,Ta,Sa); 
end 

% spike statistics  
Tdrive = Tinit+[10,25]; % [ms] analysis window for sound-driven response
Tspont = Tinit+[-10,0]; % [ms] analysis window for spontaneous rate
ANstatLo = calcVSstats(ANoutLo, DTms, FqLo, Tdrive, Tspont); 
BCstatLo = calcVSstats(BCoutLo, DTms, FqLo, Tdrive, Tspont); 
ANstatHi = calcVSstats(ANoutHi, DTms, FqHi, Tdrive, Tspont); 
BCstatHi = calcVSstats(BCoutHi, DTms, FqHi, Tdrive, Tspont); 


%% plotting
disp('Plotting'); 
figure; clf; 
set(gcf, 'Position', [20 20 560*2.0 420*2.0]);
set(gcf, 'DefaultAxesFontSize',8);
set(gcf, 'DefaultTextFontSize',8);

% AN PSTH (low-freq)
subplot(3,4,1); cla; hold on; 
plot(ANstatLo.PSTHtv-Tinit, ANstatLo.PSTH,'r-');
xlim([-5,30]); ylim([0,3300]); xlabel('time [ms]'); ylabel('rate [spikes/sec]');
text(20,2800,sprintf('DR %.1f\nSR %.1f\nCV %.3f', ANstatLo.DR,ANstatLo.SR,ANstatLo.CV));
title(sprintf('AN PSTH: %.0fHz %.0fdB %.0f reps',FqLo,LvdB,NrepsAN));

% GBC PSTH (low-freq)
subplot(3,4,2); cla; hold on; 
plot(BCstatLo.PSTHtv-Tinit, BCstatLo.PSTH,'b-');
xlim([-5,30]); ylim([0,3300]); xlabel('time [ms]'); ylabel('rate [spikes/sec]');
title(sprintf('GBC PSTH:  %.0fHz %.0fdB %.0f reps',FqLo,LvdB,NrepsBC));
text(20,2800,sprintf('DR %.1f\nSR %.1f\nCV %.3f', BCstatLo.DR,BCstatLo.SR,BCstatLo.CV));

% AN PSTH (high-freq)
subplot(3,4,3); cla; hold on; 
plot(ANstatHi.PSTHtv-Tinit, ANstatHi.PSTH,'r-');
xlim([-5,30]); ylim([0,3300]); xlabel('time [ms]'); ylabel('rate [spikes/sec]');
title(sprintf('AN PSTH: %.0fHz %.0fdB %.0f reps',FqHi,LvdB,NrepsAN));
text(20,2800,sprintf('DR %.1f\nSR %.1f\nCV %.3f', ANstatHi.DR,ANstatHi.SR,ANstatHi.CV));

% GBC PSTH (high-freq)
subplot(3,4,4); cla; hold on; 
plot(BCstatHi.PSTHtv-Tinit, BCstatHi.PSTH,'b-');
xlim([-5,30]); ylim([0,3300]); xlabel('time [ms]'); ylabel('rate [spikes/sec]');
title(sprintf('GBC PSTH:  %.0fHz %.0fdB %.0f reps',FqHi,LvdB,NrepsBC));
text(20,2800,sprintf('DR %.1f\nSR %.1f\nCV %.3f', BCstatHi.DR,BCstatHi.SR,BCstatHi.CV));

% AN period histogram (low-freq)
subplot(3,4,5); cla; hold on; 
plot(ANstatLo.PrdHtv, ANstatLo.PrdH/sum(ANstatLo.PrdH)*length(ANstatLo.PrdHtv),'r-');
text(0.1,9,sprintf('VS %.3f\n', ANstatLo.VS));
title('AN period histogram'); xlim([0,1]); ylim([0,10]); xlabel('period [cycle]');

% GBC period histogram (low-freq)
subplot(3,4,6); cla; hold on; 
plot(BCstatLo.PrdHtv, BCstatLo.PrdH/sum(BCstatLo.PrdH)*length(BCstatLo.PrdHtv),'b-');
text(0.1,9,sprintf('VS %.3f\n', BCstatLo.VS));
title('GBC period histogram'); xlim([0,1]); ylim([0,10]); xlabel('period [cycle]');

% AN period histogram (low-freq)
subplot(3,4,7); cla; hold on; 
plot(ANstatHi.PrdHtv, ANstatHi.PrdH/sum(ANstatHi.PrdH)*length(ANstatHi.PrdHtv),'r-');
text(0.1,9,sprintf('VS %.3f\n', ANstatHi.VS));
title('AN period histogram'); xlim([0,1]); ylim([0,10]); xlabel('period [cycle]');

% GBC period histogram (low-freq)
subplot(3,4,8); cla; hold on; 
plot(BCstatHi.PrdHtv, BCstatHi.PrdH/sum(BCstatHi.PrdH)*length(BCstatHi.PrdHtv),'b-');
text(0.1,9,sprintf('VS %.3f\n', BCstatHi.VS));
title('GBC period histogram'); xlim([0,1]); ylim([0,10]); xlabel('period [cycle]');

% AN ISIH (low-freq)
subplot(3,4,9); cla; hold on; 
plot(ANstatLo.ISIHtv, ANstatLo.ISIH/sum(ANstatLo.ISIH)*length(ANstatLo.ISIHtv),'r-');
title('AN ISIH'); xlim([0,8]); ylim([0,20]); xlabel('time [ms]');
text(6,18,sprintf('EI %.3f\n', ANstatLo.EI));

% GBC ISIH (low-freq)
subplot(3,4,10); cla; hold on; 
plot(BCstatLo.ISIHtv, BCstatLo.ISIH/sum(BCstatLo.ISIH)*length(BCstatLo.ISIHtv),'b-');
title('GBC ISIH'); xlim([0,8]); ylim([0,20]); xlabel('time [ms]');
text(6,18,sprintf('EI %.3f\n', BCstatLo.EI));

% AN ISIH (high-freq)
subplot(3,4,11); cla; hold on; 
plot(ANstatHi.ISIHtv, ANstatHi.ISIH/sum(ANstatHi.ISIH)*length(ANstatHi.ISIHtv),'r-');
title('AN ISIH'); xlim([0,8]); ylim([0,20]); xlabel('time [ms]');
text(6,18,sprintf('EI %.3f\n', ANstatHi.EI));

% GBC ISIH (high-freq)
subplot(3,4,12); cla; hold on; 
plot(BCstatHi.ISIHtv, BCstatHi.ISIH/sum(BCstatHi.ISIH)*length(BCstatHi.ISIHtv),'b-');
title('GBC ISIH'); xlim([0,8]); ylim([0,20]); xlabel('time [ms]');
text(6,18,sprintf('EI %.3f\n', BCstatHi.EI));

% show model parameters
text(6,15.0,sprintf('Me = %.0f\n', Me));
text(6,13.5,sprintf('Ae = %.2f\n', Ae));
text(6,12.0,sprintf('We = %.2f\n', We));
text(6,10.5,sprintf('Tr = %.2f\n', Tr));
text(6, 9.0,sprintf('Ta = %.2f\n', Ta));
text(6, 7.5,sprintf('Sa = %.2f\n', Sa));

