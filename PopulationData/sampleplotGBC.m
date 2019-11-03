%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sample code for plotting data
% written by Go Ashida (go.ashida@uni-oldenburg.de), Nov 2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% loading data
load('GBCinstances.mat');


%% tone VS and EI
% get max and min values
PLN_toneVSmax = max(PLN_toneVS,[],1);
PLN_toneVSmin = min(PLN_toneVS,[],1);
OnL_toneVSmax = max(OnL_toneVS,[],1);
OnL_toneVSmin = min(OnL_toneVS,[],1);

% open figure window
figure(1); clf; 
set(gcf, 'PaperPositionMode', 'auto');
set(gcf, 'Position', [100 100 800 400]);
set(gcf, 'DefaultAxesFontSize',10);

% PLN
subplot(1,3,1); cla; hold on; 
plot(ToneFreqs,1-PLN_toneVSmax,'b-');
plot(ToneFreqs,1-PLN_toneVSmin,'c-');
xr=[100,5000]; xlim(xr); ylim([0.01,1]);
plot(xr,[0.1,0.1],'k:'); plot(xr,[0.05,0.05],'k:'); plot(xr,[0.5,0.5],'k:');
set(gca,'Xscale','log'); set(gca,'Yscale','log'); set(gca,'Ydir','reverse');
set(gca,'YTick',[0.01:0.01:0.10, 0.2:0.1:1.0]);
set(gca,'YTickLabel',{'0.99','','','','0.95','','','','','0.9','0.8','0.7','0.6','0.5','','','','','0.0'} );
xlabel('frequency [Hz]'); ylabel('VS'); title('PLN 70dB tone');

% OnL
subplot(1,3,2); cla; hold on; 
plot(ToneFreqs,1-OnL_toneVSmax,'g-');
plot(ToneFreqs,1-OnL_toneVSmin,'y-');
xr=[100,5000]; xlim(xr); ylim([0.01,1]);
plot(xr,[0.1,0.1],'k:'); plot(xr,[0.05,0.05],'k:'); plot(xr,[0.5,0.5],'k:');
set(gca,'Xscale','log'); set(gca,'Yscale','log'); set(gca,'Ydir','reverse');
set(gca,'YTick',[0.01:0.01:0.10, 0.2:0.1:1.0]);
set(gca,'YTickLabel',{'0.99','','','','0.95','','','','','0.9','0.8','0.7','0.6','0.5','','','','','0.0'} );
xlabel('frequency [Hz]'); ylabel('VS'); title('OnL 70dB tone');

% AN
subplot(1,3,3); cla; hold on; 
plot(ToneFreqs,1-AN_toneVS,'r-');
xr=[100,5000]; xlim(xr); ylim([0.01,1]);
plot(xr,[0.1,0.1],'k:'); plot(xr,[0.05,0.05],'k:'); plot(xr,[0.5,0.5],'k:');
set(gca,'Xscale','log'); set(gca,'Yscale','log'); set(gca,'Ydir','reverse');
set(gca,'YTick',[0.01:0.01:0.10, 0.2:0.1:1.0]);
set(gca,'YTickLabel',{'0.99','','','','0.95','','','','','0.9','0.8','0.7','0.6','0.5','','','','','0.0'} );
xlabel('frequency [Hz]'); ylabel('VS'); title('AN 70dB tone');


%% tone EI
PLN_toneEImax = max(PLN_toneEI,[],1);
PLN_toneEImin = min(PLN_toneEI,[],1);
OnL_toneEImax = max(OnL_toneEI,[],1);
OnL_toneEImin = min(OnL_toneEI,[],1);

% open figure window
figure(2); clf; 
set(gcf, 'PaperPositionMode', 'auto');
set(gcf, 'Position', [200 200 800 200]);
set(gcf, 'DefaultAxesFontSize',10);

% PLN
subplot(1,3,1); cla; hold on;
plot(ToneFreqs,PLN_toneEImax,'b-');
plot(ToneFreqs,PLN_toneEImin,'c-');
xlim([0,1000]); ylim([0,1]);
xlabel('frequency [Hz]'); ylabel('EI'); title('PLN 70dB tone');

% PLN
subplot(1,3,2); cla; hold on;
plot(ToneFreqs,OnL_toneEImax,'g-');
plot(ToneFreqs,OnL_toneEImin,'y-');
xlim([0,1000]); ylim([0,1]);
xlabel('frequency [Hz]'); ylabel('EI'); title('OnL 70dB tone');

% AN
subplot(1,3,3); cla; hold on;
plot(ToneFreqs,AN_toneEI,'r-');
xlim([0,1000]); ylim([0,1]);
xlabel('frequency [Hz]'); ylabel('EI'); title('AN 70dB tone');


%% tail VS
% get max and min values
PLN_tailVSmax = max(PLN_tailVS,[],1);
PLN_tailVSmin = min(PLN_tailVS,[],1);
OnL_tailVSmax = max(OnL_tailVS,[],1);
OnL_tailVSmin = min(OnL_tailVS,[],1);

% open figure window
figure(3); clf; 
set(gcf, 'PaperPositionMode', 'auto');
set(gcf, 'Position', [300 300 800 400]);
set(gcf, 'DefaultAxesFontSize',10);

% PLN
subplot(1,3,1); cla; hold on; 
plot(Tail_CFs,1-PLN_tailVSmax,'b-');
plot(Tail_CFs,1-PLN_tailVSmin,'c-');
xr=[800,13000]; xlim(xr); ylim([0.01,1]);
plot(xr,[0.1,0.1],'k:'); plot(xr,[0.05,0.05],'k:'); plot(xr,[0.5,0.5],'k:');
set(gca,'Xscale','log'); set(gca,'Yscale','log'); set(gca,'Ydir','reverse');
set(gca,'YTick',[0.01:0.01:0.10, 0.2:0.1:1.0]);
set(gca,'YTickLabel',{'0.99','','','','0.95','','','','','0.9','0.8','0.7','0.6','0.5','','','','','0.0'} );
xlabel('CF [Hz]'); ylabel('VS'); title('PLN tail 500Hz 95dB');

% OnL
subplot(1,3,2); cla; hold on; 
plot(Tail_CFs,1-OnL_tailVSmax,'g-');
plot(Tail_CFs,1-OnL_tailVSmin,'y-');
xr=[800,13000]; xlim(xr); ylim([0.01,1]);
plot(xr,[0.1,0.1],'k:'); plot(xr,[0.05,0.05],'k:'); plot(xr,[0.5,0.5],'k:');
set(gca,'Xscale','log'); set(gca,'Yscale','log'); set(gca,'Ydir','reverse');
set(gca,'YTick',[0.01:0.01:0.10, 0.2:0.1:1.0]);
set(gca,'YTickLabel',{'0.99','','','','0.95','','','','','0.9','0.8','0.7','0.6','0.5','','','','','0.0'} );
xlabel('CF [Hz]'); ylabel('VS'); title('OnL tail 500Hz 95dB');

% AN
subplot(1,3,3); cla; hold on; 
plot(Tail_CFs,1-AN_tailVS,'r-');
xr=[800,13000]; xlim(xr); ylim([0.01,1]);
plot(xr,[0.1,0.1],'k:'); plot(xr,[0.05,0.05],'k:'); plot(xr,[0.5,0.5],'k:');
set(gca,'Xscale','log'); set(gca,'Yscale','log'); set(gca,'Ydir','reverse');
set(gca,'YTick',[0.01:0.01:0.10, 0.2:0.1:1.0]);
set(gca,'YTickLabel',{'0.99','','','','0.95','','','','','0.9','0.8','0.7','0.6','0.5','','','','','0.0'} );
xlabel('CF [Hz]'); ylabel('VS'); title('AN tail 500Hz 95dB');


%% SAM VS
PLN_SAM_VSmax = max(PLN_SAM_VS,[],1);
PLN_SAM_VSmin = min(PLN_SAM_VS,[],1);
OnL_SAM_VSmax = max(OnL_SAM_VS,[],1);
OnL_SAM_VSmin = min(OnL_SAM_VS,[],1);

% open figure window
figure(4); clf; 
set(gcf, 'PaperPositionMode', 'auto');
set(gcf, 'Position', [400 400 800 200]);
set(gcf, 'DefaultAxesFontSize',10);

% PLN
subplot(1,3,1); cla; hold on;
plot(SAM_CFs,PLN_SAM_VSmax,'b-');
plot(SAM_CFs,PLN_SAM_VSmin,'c-');
xlim([0,13000]); ylim([0,1]);
xlabel('CF [Hz]'); ylabel('VS'); title('PLN SAM 100 Hz');

% PLN
subplot(1,3,2); cla; hold on;
plot(SAM_CFs,OnL_SAM_VSmax,'g-');
plot(SAM_CFs,OnL_SAM_VSmin,'y-');
xlim([0,13000]); ylim([0,1]);
xlabel('CF [Hz]'); ylabel('VS'); title('OnL SAM 100 Hz');

% AN
subplot(1,3,3); cla; hold on;
plot(SAM_CFs,AN_SAM_VS,'r-');
xlim([0,13000]); ylim([0,1]);
xlabel('CF [Hz]'); ylabel('VS'); title('AN SAM 100 Hz');

