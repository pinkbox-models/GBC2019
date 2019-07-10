function DataStr = calcVSstats(SPin, DTms, Fq, TA, TS)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% script for calculating PSTH, rate, VS, etc. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input 
%  SPin : input spike array ({0,1}-sequence for each trial at each time step) 
%  DTms : size of time step [ms] 
%  Fq : reference frequency [Hz] for calculating VS and EI 
%  TA : two-element vector indicating [start,end] time (in ms) of analysis window for calculating rate, VS, etc.
%  TS : two-element vector indicating [start,end] time (in ms) of analysis window for calculating spontaneous rate
%
% Output 
%  DataStr : structure containing result data 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Written by Go Ashida (go.ashida@uni-oldenburg.de), June/July 2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% get useful numbers 
[Nreps, Nall] = size(SPin); % get the numbers of repetitions and time steps 
tvms = (0:Nall-1)*DTms; % time vector (stimulus starts at time zero)

%% PSTH
PSTHraw = sum(SPin,1); 
PSTHbinW = 0.1; % [ms] PSTH bin width
PSTHbinM = round(PSTHbinW/DTms); % number of time steps in each PSTH bin
PSTHbinN = floor(Nall/PSTHbinM); % number of PSTH bins
PSTHtv = (0:PSTHbinN-1) * PSTHbinW; % [ms] time vector for PSTH
PSTHtmp = sum(reshape( PSTHraw(1:PSTHbinM*PSTHbinN),[PSTHbinM,PSTHbinN] ))...
            / Nreps * 1000 / PSTHbinW; % normalize to get [spikes/sec] 
PSTHout = zeros(1,length(PSTHtmp));

for i = 3:length(PSTHtmp)-2 % 5-point smoothing
  PSTHout(i) = ( PSTHtmp(i-2) + 2*PSTHtmp(i-1) + 3*PSTHtmp(i) ...
                 + 2*PSTHtmp(i+1) + PSTHtmp(i+2) )/9;
end
PSTHout(1) = ( 3*PSTHtmp(1) + 2*PSTHtmp(2) + PSTHtmp(3) )/6;
PSTHout(2) = ( 2*PSTHtmp(1) + 3*PSTHtmp(2) + 2*PSTHtmp(3) + PSTHtmp(4) )/8;
PSTHout(end-1) = ( PSTHtmp(end-3) + 2*PSTHtmp(end-2) + 3*PSTHtmp(end-1) + 2*PSTHtmp(end) )/8;
PSTHout(end)   = ( PSTHtmp(end-2) + 2*PSTHtmp(end-1) + 3*PSTHtmp(end) )/6;

%% analysis time window
AnalyT0 = TA(1);
AnalyT1 = TA(2);
AnalyN0 = round(AnalyT0 / DTms); 
AnalyN1 = round(AnalyT1 / DTms);
AnalyL = [ zeros(1,AnalyN0), ones(1,AnalyN1-AnalyN0), zeros(1,Nall-AnalyN1) ]; % analysis window

%% spike times and ISIs 
spikesA = []; 
isisA = []; 
for i=1:Nreps
  a = tvms( logical( SPin(i,:).*AnalyL )); % spike times at rep i
  spikesA = [spikesA, a];  
  if(length(a)>1); isisA = [isisA, a(2:end)-a(1:end-1)]; end
end

%% mean sound-driven rate
DRout = 1000*length(spikesA)/(AnalyT1-AnalyT0)/Nreps; % [spikes/sec] 

%% VS
VSfq = Fq;
VSnn = length(spikesA); 
VScc = sum( cos( 2 * pi * VSfq * spikesA / 1000 ));
VSss = sum( sin( 2 * pi * VSfq * spikesA / 1000 ));
VSout = sqrt(VScc*VScc + VSss*VSss) / VSnn;

%% phase histogram
PrdHfq = Fq; % [Hz] frequency
PrdHbinN = 41; % number of bins 
PrdHtv = (0:PrdHbinN-1)/PrdHbinN;
PrdHidx = floor( mod((PrdHfq * spikesA / 1000), 1) * PrdHbinN) +1; % phase index vector
PrdHraw = zeros(1,PrdHbinN); 
for i=1:length(PrdHidx)
  PrdHraw(PrdHidx(i)) = PrdHraw(PrdHidx(i))+1;
end
PrdHout = zeros(1,PrdHbinN); 

for i = 3:length(PrdHout)-2 % 5-point smoothing
  PrdHout(i) = ( PrdHraw(i-2) + 2*PrdHraw(i-1) + 3*PrdHraw(i) ...
                 + 2*PrdHraw(i+1) + PrdHraw(i+2) )/9;
end
PrdHout(2)    = ( PrdHraw(end)  + 2*PrdHraw(1)    + 3*PrdHraw(2)    + 2*PrdHraw(3)   + PrdHraw(4) )/9;
PrdHout(1)    = ( PrdHraw(end-1)+ 2*PrdHraw(end)  + 3*PrdHraw(1)    + 2*PrdHraw(2)   + PrdHraw(3) )/9;
PrdHout(end)  = ( PrdHraw(end-2)+ 2*PrdHraw(end-1)+ 3*PrdHraw(end)  + 2*PrdHraw(1)   + PrdHraw(2) )/9;
PrdHout(end-1)= ( PrdHraw(end-3)+ 2*PrdHraw(end-2)+ 3*PrdHraw(end-1)+ 2*PrdHraw(end) + PrdHraw(1) )/9;

%% entrainment
EIfq = Fq; % [Hz] frequency
EInn = length(isisA); 
EImin = 0.5*1000/EIfq; 
EImax = 1.5*1000/EIfq; 
EIcount = sum((isisA>=EImin) & (isisA<=EImax));
EIout = EIcount/EInn; 

%% regularity
CVoffset = 0.5; % [ms] 
CVave = mean(isisA);
CVstd = std(isisA);
CVout = CVstd / ( CVave - CVoffset ); 

%% ISIH
ISIHbinW = 0.1; % [ms] binwidth
ISIHbinN = 100; % [ms] number of bins
ISIHtv = ((1:ISIHbinN)-0.5)*ISIHbinW; 
ISIHraw = zeros(1,ISIHbinN); 
ISIHout = zeros(1,ISIHbinN); 
for i=1:length(isisA)
  j = min([ floor(isisA(i)/ISIHbinW)+1, ISIHbinN ]);
  ISIHraw(j) = ISIHraw(j) + 1;
end
for i = 3:length(ISIHout)-2 % 5-point smoothing
  ISIHout(i) = ( ISIHraw(i-2) + 2*ISIHraw(i-1) + 3*ISIHraw(i) ...
                 + 2*ISIHraw(i+1) + ISIHraw(i+2) )/9;
end
ISIHout(1) = ( 3*ISIHraw(1) + 2*ISIHraw(2) + ISIHraw(3) )/6;
ISIHout(2) = ( 2*ISIHraw(1) + 3*ISIHraw(2) + 2*ISIHraw(3) + ISIHraw(4) )/8;
ISIHout(end-1) = ( ISIHraw(end-3) + 2*ISIHraw(end-2) + 3*ISIHraw(end-1) + 2*ISIHraw(end) )/8;
ISIHout(end)   = ( ISIHraw(end-2) + 2*ISIHraw(end-1) + 3*ISIHraw(end) )/6;

%% spontaneous rate
SpontT0 = TS(1);
SpontT1 = TS(2);
SpontN0 = round(SpontT0 / DTms); 
SpontN1 = round(SpontT1 / DTms);
SpontL = [ zeros(1,SpontN0), ones(1,SpontN1-SpontN0), zeros(1,Nall-SpontN1) ]; % analysis window
% spike times (and ISIs) within analysis window (in ms)
spontA = []; 
for i=1:Nreps
  a = tvms( logical( SPin(i,:).*SpontL )); % spike times at rep i
  spontA = [spontA, a];  
end
SRout = 1000*length(spontA)/(SpontT1-SpontT0)/Nreps; % [spikes/sec] mean rate

%% assigning data
DataStr = struct;
DataStr.DR = DRout;
DataStr.VS = VSout;
DataStr.EI = EIout; 
DataStr.CV = CVout; 
DataStr.SR = SRout; 
DataStr.PSTH = PSTHout; 
DataStr.PrdH = PrdHout; 
DataStr.ISIH = ISIHout; 
DataStr.PSTHtv = PSTHtv;
DataStr.PrdHtv = PrdHtv;
DataStr.ISIHtv = ISIHtv;
