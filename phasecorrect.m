% Tiny code for corercting the phase discontinuities in the phase grabbing From the Lockin.
% The discontinuities arrise if the phase of our system exceeds the upper limit of arctan(Y/X) which is 90 degrees.

clear all
%% Experimental constsnts

Int_sensitivity = 40;           	% in mv/A
opamp_gain = 12;
scanner_calib = 22.27;              % nm/V
lockin_sens = 100;                  % in mv


npoints = 80;                       % uptil what point do we need to correct the phase data
phasecutoff = -0.139;               % the cutoff point below which the phase would be take to the positive side

%% Removing the approach values and rescaling the z_voltage values and converting to nanometers

% trimm all the arrays to remove approach z values.

a= importdata('q.txt');
b = a.('data');

z = b(:,1);
totlength = length(z);

count = 0;

for i = 1: (totlength-1)
    if (z(i) > z(i+1))
        count = count+1;
    end
end

% count;
% plot(z)

for i=1:count
    b(1,:) = [];
end

%length(b)

%% data allocation

z_volt = b(:,1);
x = b(:,7)*(lockin_sens/(Int_sensitivity*10));
y = b(:,8)*(lockin_sens/(Int_sensitivity*10));
amplitude = b(:,2)*(lockin_sens/(Int_sensitivity*10));
phi = b(:,3);                        % Third column is the Phase.
DC = b(:,4);

z_dist = (z_volt - min(z_volt) )* (scanner_calib * opamp_gain) ; 

%% The phase correction part
%plot (phi)                      % is the phase column in the consolidated data sheet

phase = phi;

% for i = 1:npoints
%     
%     if (phase(i) < phasecutoff )
%         phase(i)= phase(i) + 1;
%     end
% end

%phase;
%plot (phase)

phione = acos(x./amplitude);            
phitwo = asin(y./amplitude);

%% Stiffness and Damping calculation   


stiffness = 0.8* ((1.7./amplitude).*(cos(phase)) -1); 

damping = 0.8 * ((1.7./(amplitude.*2000)) .* (sin(phase))) ;

relaxation_time = damping./stiffness;

stiff2 = (0.8*1.7).*(x./(amplitude.*amplitude));   % calculated by x/A^2

%% Plotting

subplot(3,2,1)
plot(z_dist,amplitude)
title('Amplitude')


subplot(3,2,2)
plot(z_dist,phase)
title('Phase')


subplot(3,2,3)
plot(z_dist,stiffness)
title('Stiffness')


subplot(3,2,4)
plot(z_dist,damping)
title('Damping')

subplot(3,2,5)
plot(z_dist,DC)
title('DC')

subplot(3,2,6)
plot(z_dist,relaxation_time)
title('relaxation time')
