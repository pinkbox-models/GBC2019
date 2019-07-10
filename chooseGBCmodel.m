function [Me,Ae,We,Tr,Ta,Sa] = chooseGBCmodel(N)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% chooseGBCmodel.m 
%  Code for assigning model parameters of globular bushy cells 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input
%  N : Depending on the value of this input argument, this code returns 
%      different parameter values. 
% (N =  0) Use the default GBC parameters
% (N = -1) Randomly choose a parameter set that produces PLN outputs
% (N = -2) Randomly choose a parameter set that produces OnL outputs
% (N = -3) Randomly choose a parameter set that produces either PLN or OnL outputs
% (N = 9, 12, 16, 20, 25, 30, or 36) Randomly choose a parameter set that has Me=N inputs and produces PLN outputs 
% (N = none of the values above) Will give an error 
%
% Output
%  Me : number of inputs 
%  Ae : input amplitude (relative to threshold) 
%  We : [ms] input time length (coincidence window)
%  Tr : [ms] refractory period 
%  Ta : [ms] adaptation time constant 
%  Sa : adaptation strength 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Written by Go Ashida (go.ashida@uni-oldenburg.de), June/July 2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% ranges of parameters and default values

% GBC parameter ranges 
MeRange = [ 9, 12, 16, 20, 25, 30, 36 ]; 
AeRange = [ 0.24, 0.28, 0.32, 0.36, 0.40, 0.44, 0.48, 0.52, 0.56 ]; 
WeRange = [ 0.08, 0.16, 0.24, 0.32, 0.40, 0.48, 0.56, 0.64, 0.72, 0.80 ]; 
TrRange = [ 0.7,  0.8,  0.9,  1.0,  1.1,  1.2,  1.3,  1.4,  1.5 ]; 
TaRange = [ 0.05, 0.10, 0.15, 0.20, 0.25, 0.30, 0.35, 0.40, 0.45, 0.50 ]; 
SaRange = [ 0.4,  0.5,  0.6,  0.7,  0.8,  0.9,  1.0,  1.1,  1.2,  1.3 ]; 

% check if N is a valid number
if(~ismember(N,[0,-1,-2,-3,MeRange]))
 error('invalid input argument');
end

% if N=0, then use the default values
if(N==0)
  Me = 20; 
  Ae = 0.40; 
  We = 0.32; 
  Tr = 1.20; 
  Ta = 0.25; 
  Sa = 0.80; 
  return;
end

%% loading PLN/OnL indices

if(N==-1) % use PLN
  load('PLNindex.mat'); % index for PLN units
  GBCidx = PLNindex;
elseif(N==-2) % use OnL
  load('OnLindex.mat'); % index for OnL units
  GBCidx = OnLindex;
elseif(N==-3) % use PLN+OnL
  load('PLNindex.mat'); % index for PLN units
  load('OnLindex.mat'); % index for OnL units
  GBCidx = PLNindex | OnLindex;
else 
  load('PLNindex.mat'); % index for PLN units
  % make logical index array for Me=N inputs
  MeNindex = true(size(PLNindex));
  MeNindex( (MeRange~=N),:,:,:,:,:) = false; 
  % get PLN parameters with Me=N inputs
  GBCidx = PLNindex & MeNindex; 
end


%% choose one parameter set 

Ntotal = sum(sum(sum(sum(sum(sum(GBCidx)))))); % total number of candidates
LinAll = find(GBCidx); % linear index for GBC candidates
LinIdx = LinAll(1+floor(Ntotal*rand(1,1))); % randomly choose one
[ iMe,iAe,iWe,iTr,iTa,iSa ] = ind2sub(size(GBCidx),LinIdx); % get 6-dim indices

% assign output values
Me = MeRange(iMe);
Ae = AeRange(iAe);
We = WeRange(iWe);
Tr = TrRange(iTr);
Ta = TaRange(iTa);
Sa = SaRange(iSa);
