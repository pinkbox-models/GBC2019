load('FRA3500Hz.mat');

figure(5); cla; hold on;
set(gcf, 'PaperPositionMode', 'auto');
set(gcf, 'Position', [100 100 800 300 ]);
set(gcf, 'DefaultAxesFontSize',8);

% AN
subplot(1,2,1); cla; hold on; 
imagesc(log(Freqs),Levels,ANrate',[0,220]);
colorbar; xlim([5.2,9.65]); ylim([0,100]);
set(gca,'Xdir','normal'); set(gca,'Ydir','normal');
% xticks
xt = [ 200, 400, 900, 1800, 3500, 7000, 14000 ];
for i = 1:length(xt); plot( [ log(xt(i)), log(xt(i)) ] ,[0,2],'k-'); end
set(gca,'XTick',log(xt)); set(gca,'XtickLabel',xt);
title('AN model');

% GBC
subplot(1,2,2); cla; hold on; 
imagesc(log(Freqs),Levels,GBCrate',[0,550]);
colorbar; xlim([5.2,9.65]); ylim([0,100]);
set(gca,'Xdir','normal'); set(gca,'Ydir','normal');
% xticks
xt = [ 200, 400, 900, 1800, 3500, 7000, 14000 ];
for i = 1:length(xt); plot( [ log(xt(i)), log(xt(i)) ] ,[0,2],'k-'); end
set(gca,'XTick',log(xt)); set(gca,'XtickLabel',xt);
title('GBC model');

