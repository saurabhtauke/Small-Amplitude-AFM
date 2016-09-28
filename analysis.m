% Tiny code for corercting the phase discontinuities in the phase grabbing From the Lockin.
% The discontinuities arrise if the phase of our system exceeds the upper limit of arctan(Y/X) which is 90 degrees.

clear all
%% Experimental constants

Int_sensitivity = 39.73;           	% in mv/A
opamp_gain = 12;
scanner_calib = 22.27;              % nm/V
lockin_sens = 100;                  % in mv

cantilever_stiffness = 0.8486;          % in N/m
free_amplitude = 1.1;                % in Amstrongs
drive_frequency = 2000*2*pi;            % in Hz

npoints = 80;                       % uptil what point do we need to correct the phase data
phasecutoff = -0.139;               % the cutoff point below which the phase would be take to the positive side
datacutoff =115;                    % to trim the redundant part in free amplitude 

density = 2329;                     %density of material of cantilever
area = 8750e-12;                        %surface area of cantilever
cantilever_length = 250e-006;      %length of cantilver SI units


%% Removing the approach values and rescaling the z_voltage values and converting to nanometers

% trimm all the arrays to remove approach z values.

a= importdata('_0x4__data.txt');
b = a.('data');

z = b(:,1);
totlength = length(z);

approach_count = 0;

for i = 1: (totlength-1)
    if (z(i) > z(i+1))
        approach_count = approach_count+1;
    end
end

% count;
% plot(z)

for i=1:approach_count
    b(1,:) = [];
end

for i = datacutoff:length(b)
    b(datacutoff,:) = [];
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
% plot (phi)                      % is the phase column in the consolidated data sheet
% 
phase = phi;
phase = phase - (min(phase)) ;
% 
% 
% for i = 1:npoints
%     
%     if (phase(i) < phasecutoff )
%         phase(i)= phase(i) + 1;
%     end
% end
% 
% phase;
% plot (phase)
% 
% phione = acos(x./amplitude);            
% phitwo = asin(y./amplitude);

%% Stiffness and Damping calculation   


stiffness = double(cantilever_stiffness* ((free_amplitude./amplitude).*(cos(phase)) -1)); 
stiffness = stiffness - min(stiffness);

damping = double(cantilever_stiffness * (1.0) * ((free_amplitude./(amplitude.*(drive_frequency))) .* (sin((pi/2)-phase)))) ;
damping = damping- min(damping);



stiffx = double((-1)*(((0.666*cantilever_stiffness * cantilever_length).*x./free_amplitude)- 0.333*density*10*area*cantilever_length*drive_frequency*drive_frequency));
stiffx = stiffx - min(stiffx);

lever_damping = 10e-006;
dampy = double(0.666*cantilever_stiffness*cantilever_length.*y./(free_amplitude.*drive_frequency)- (0.333*lever_damping*cantilever_length));
dampy = dampy- min(dampy);

retardation_time = double(dampy./(stiffx));


phase = phase .* (180/pi); %converted phase to degrees

%% Plotting

subplot(3,3,1)
plot(z_dist,amplitude,'o-b')
title('Amplitude')
xlabel('Distance(nm)')  
ylabel('Amplitude(Å)')


subplot(3,3,2)
plot(z_dist,x,'o-b')
title('x')
xlabel('Distance(nm)')
ylabel('x')


subplot(3,3,3)
plot(z_dist,y,'o-b')
title('y')
xlabel('Distance(nm)')
ylabel('y')


subplot(3,3,4)
plot(z_dist,phase,'o-b')
title('Phase')
xlabel('Distance(nm)')
ylabel('Phase(degrees)')


subplot(3,3,5)
plot(z_dist,stiffness,'o-b')
title('Stiffness')
xlabel('Distance(nm)') 
ylabel('Stiffness(N/m)')


subplot(3,3,6)
plot(z_dist,damping,'o-b')
title('Damping')
xlabel('Distance(nm)')
ylabel('Damping(Ns/m)')


subplot(3,3,7)
plot(z_dist,retardation_time,'o-b')
title('Retardation Time')
xlabel('Distance(nm)')
ylabel('Retardation Time(s)')


subplot(3,3,8)
plot(z_dist,stiffx,'o-b')
title('stiffx')
xlabel('Distance(nm)')
ylabel('stiffx')


subplot(3,3,9)
plot(z_dist,dampy,'o-b')
title('dampy')
xlabel('Distance(nm)')
ylabel('dampy')


