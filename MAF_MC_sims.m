close all
clear all

tau = 3.  % simulated lifetime
T = 12.5; % laser period
td = 80;   % dead time
tn = 128; % number of buns

nrep = 1000000; % number of laser pulses     
PN   = 1;       % average photon/laserpulse

sig = 0.1;  % std dev irf (fwhm=2.36sigma=120ps)
t0  = 10;   % irf position (bin number) ~1ns

nhit = 1;   % number of hit per period
freq_div = 1; % freq devider tdc


tmh =  freq_div*tn; % period of multi hit limit  
tbin = T/(tn-1);        % bin size
time = (0:tn-1)*tbin;   % microtimes


%pdf = @(ti) PN*exp(-ti*T/(tn*tau))*( exp(T/(tn*tau))-1  )/(1-exp(-T/tau));


pdf0 = @(ti) PN*exp(-ti*T/(tn*tau))*( exp(T/(tn*tau))-1  )/(1-exp(-T/tau));
irf  = @(ti)(1/sqrt(2*3.14*sig^2))*exp(-(ti-t0).^2/(2*sig^2));
pdf  = conv(irf(1:tn),pdf0(1:tn),'full');

%
ti=0; tp = -1;
trace0=zeros(tn,1);
trace=zeros(tn,1);
tic



multihit=zeros(ceil(nrep*tn/tmh)+1,1);
while ti<=nrep*tn
    ti=ti+1;
    
    tm = mod(ti,tn)+1;
    
    timh = ceil(ti/tmh);
    
    photon = rand<=pdf(tm);
    if photon
       % no dead time
       trace0(tm) = trace0(tm) + 1;
      
       
        if ti>tp+td/tbin % reset system
                tp = -1;
        end  
        if tp<0% systen is ok, it becomes blind at titi
           
            
            tp = ti; 
            if multihit(timh)<nhit
                trace(tm) = trace(tm) + 1;
            end
            multihit(timh) = multihit(timh) + 1; 
        end
       
       
       
    end
    
    
    
end
beep

%
toc
figure
subplot(1,2,1)
hold all
plot(time,trace0)
plot(time,trace)
set(gca,'yscale','log','ylim',[1 max(trace0)])

subplot(1,2,2)
plot(time,trace./trace0)
set(gca,'ylim',[0 1])

%%countrate
rate0 = sum(trace0)/(ti*tbin*1e-9)
rate = sum(trace)/(ti*tbin*1e-9)
max_rate = 1e9/td
max(multihit)