
function velocityanalysis(handles)
curvdata=handles.curvdata;
 T1 = str2num(get(handles.edit_T1, 'String'));
T2 = str2num(get(handles.edit_T2, 'String'));
T3 = str2num(get(handles.edit_T3, 'String'));



%Find Wave Velocity: 
%Note nu is in units of percent body length per frame
v=findWaveVel(curvdata,5,1);

%We would like to get that into fractional body length per second
%So we must multpily by (1/(100))*(1/ ( seconds /frame) );
tstamp=handles.sElapsed_data+handles.msRemElapsed_data./1000;
spf=(tstamp(end)-tstamp(1))/length(tstamp); %seconds per frame
nu=v.*(1/100).*(1/spf);

%Find the Corners:
[tanhCoef,tanhGOF, c1, c2]= findcorners(nu);
 x=1:length(nu);
 
 
 %Plot Output:
 figure(3); clf; hold on;
 A=tanhCoef.A;
 beta=tanhCoef.beta;
 x0=tanhCoef.x0;
 B=tanhCoef.B;
 y=A*tanh(beta.*(x-x0))+B;

 hold on;
 subplot(1,2,1)
 imagesc(curvdata*size(curvdata,2), [-10,10]);
 colormap(redbluecmap(1)); 
 title('Curvature')
 xlabel('<- Head     Tail->')
 ylims=get(gca,'Ylim');
hold on;
if T2 > T1
    plot([0 size(curvdata,2)], [T2-T1 T2-T1], '--w');
end
if T3 > T1
    plot([0 size(curvdata,2)], [T3-T1 T3-T1], '--w');
end




 
 subplot(1,2,2)
 hold on;
 plot(nu,x)
 plot(y,x,'m','linewidth',2)
 plot([A+B B-A],[x0+1/beta x0-1/beta],'ro','linewidth',3);
set(gca,'YDir','reverse');
set(gca,'Ylim',ylims);
title('Wave velocity')
xlabel('body length / second')

if T2 > T1
    plot([min(nu) max(nu)], [T2-T1 T2-T1], '--r');
end
if T3 > T1
    plot([min(nu) max(nu)], [T3-T1 T3-T1], '--r');
end

plot([0 0],[0, length(nu)],'--b')



 set(gca,'Box','off');
axesPosition = get(gca,'Position');          %# Get the current axes position
hNewAxes = axes('Position',axesPosition,...  %# Place a new axes on top...
                'Color','none',...           %#   ... with no background color 
                'YLim',[ handles.frameindex(str2num(get(handles.edit_T1, 'String')),1);...
                handles.frameindex(str2num(get(handles.edit_T4, 'String')),1)],...            %#   ... and a different scale
                'YAxisLocation','right',...  %#   ... located on the right
                'XTick',[],...                  %#   ... and with no x tick marks
               'YDir','reverse',...
                'Box','off');                 %ylabel(hNewAxes,'hframe');  %# Add a label to the right y axis
