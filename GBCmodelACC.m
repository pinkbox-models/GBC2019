function [spOut, vmOut, thOut] = GBCmodelACC(sE, DT, Ae, We, Tr, Ta, Sa)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Adaptive Coincidence Counting Model of Globular Bushy Cells (ver 2019)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input 
%  sE : excitatory input spike array ({0,1}-sequence for each fiber at each time step) 
%  DT : size of time step [ms] 
%  Ae : amplitude of excitatory inputs (for each input fiber) 
%  We : excitatory input time window [ms] 
%  Tr : refractory period [ms] 
%  Ta : threshold adaptation time constant [ms]
%  Sa : threshold adaptation strength 
%
% Output 
%  spOut : number of output spikes at each time step 
%  vmOut : internal state (virtual membrane potential) at each time step 
%  thOut : value of adaptive threshold at each time step 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Notes
%  Default static threshold is fixed to one. This means that the 
%  input amplitude is normalized with respect to this threshold. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reference 
% Ashida G, Heinermann HT, Kretzberg J (2019) Submitted 
% "Neuronal Population Modeling of Globular Bushy Cells"
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Revisions
% Created (ver 0.90): Aug 01, 2018 by Go Ashida 
% Revised (ver 0.99): Jul 07, 2019 by Go Ashida -- initial upload on GitHub
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% If you find a bug, please report to GA at go.ashida@uni-oldenburg.de
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%% Copyright 2019 Go Ashida (go.ashida@uni-oldenburg.de) %%%%%%%%%%%%%
% Permission is hereby granted under the Apache License, Version 2.0; 
% Users of this file must be in compliance with this license, a copy of 
% which may be obtained at http://www.apache.org/licenses/LICENSE-2.0
% This file is provided on an "AS IS" basis, WITHOUT WARRANTIES OR 
% CONDITIONS OF ANY KIND, either express or implied.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% pre-defined parameters
[Mex,Nsteps] = size(sE); % get the numbers of fibers and time steps 
spEx = sum(sE,1);

% threshold and time parameters
eTh = exp(-DT/Ta); % exponential decay of threshold
fTh = ( 1-eTh ) * Sa;  % threshold increase factor
dTh = 0.0; % threshold increase (= dynamic threshold)
sTh = 1.0; % static threshold 
Nw = round(We/DT); % steps
Nr = round(Tr/DT); % steps

%% data vectors
spOut = zeros(1,Nsteps);
vmOut = zeros(1,Nsteps);
thOut = zeros(1,Nsteps);
spSum = 0; % input spike counter
refC = 0;  % refractory counter

%% main loop 
for t = 1:Nsteps

  % add excitatory inputs at time t 
  spSum = spSum + Ae*spEx(t); 
  % remove just-expired excitatory inputs 
  if(t-Nw>0); spSum = spSum - Ae*spEx(t-Nw); end

  % check for threshold crossing 
  % (0) if in refractory period, then decrement counter 
  if(refC>0); 
   spOut(t)=0; refC = refC-1;  
  % (1) if threshold is reached, generate a spike and set refractory counter
  elseif(spSum>=sTh+dTh) 
   spOut(t) = 1; refC = Nr; 
  % (2) if no threshold crossing happened, then no spike output 
  else 
   spOut(t)=0; 
  end 

  % save internal state and threshold at time t 
  vmOut(t) = spSum;
  thOut(t) = sTh+dTh;

  % threshold decay + increase
  dTh = eTh * dTh + fTh * spSum; 

end
