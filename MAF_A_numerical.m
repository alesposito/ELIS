k0 = (0:5e5:80e6);

td = [eps 5 10 20 40 80 160 ]*1e-9;


figure
set(gcf,'color','w')
hold all

delta = (0:.2:1);
sn=length(delta);

for si=1:sn
    
    delta1=delta(si);
    td1=delta1./(k0*(1-delta1));
    
    plot(k0,delta1./td1,'color',[1 1 1]*.9,'linewidth',2)
    
end

axis square
box on
xlabel('available count rate')
ylabel('relative acquisition speed')

sn=length(td);

for si=1:sn
    
    td0 = td(si);
    delta0 = k0*td0./(1+k0*td0);
    
    plot(k0,delta0./td0,'k','linewidth',2)
    
end

axis square
box off
xlabel('available count rate')
ylabel('relative acquisition speed')

set(gca,'ytick',(0:max(k0)/4:max(k0)),'xtick',(0:max(k0)/4:max(k0)),'tickdir','out')






