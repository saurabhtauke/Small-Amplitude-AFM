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
phase = b(:,3);                        % Third column is the Phase.
DC = b(:,4);

offset_phase = (min(phase));
new_phase = 30*(pi/180);

n= zeros(length(phase),1);
for i = 1:length(phase)
    if phase(i)< 0
        n(i)=-1;
    else 
        n(i)=1;
    end
end

% true_x = (x);
true_x = (x)/cos(offset_phase);

true_y = (y);- min(y);

%  true_x = real(x/cos(offset_phase));
%   true_y =real(sqrt((-1*(x.^2)*((tan(offset_phase))^2))+ (y.^2)));
 %true_y = 
%  %true_y = true_y- min(true_y);

z_dist = (z_volt - min(z_volt) )* (scanner_calib * opamp_gain) ; 


%% Stiffness and Damping calculation   


stiffness = double(cantilever_stiffness* ((free_amplitude./amplitude).*(cos(phase)) -1)); 
%stiffness = stiffness - min(stiffness);

damping = double(cantilever_stiffness * (1.0) * ((free_amplitude./(amplitude.*(drive_frequency))) .* (sin((phase))))) ;
%damping = damping- min(damping);



stiffx = double((-1)*(((0.666*cantilever_stiffness * cantilever_length).*true_x./free_amplitude)- 0.333*density*10*area*cantilever_length*drive_frequency*drive_frequency));
stiffx = stiffx - min(stiffx);

lever_damping = 10e-006;
dampy = double(0.666*cantilever_stiffness*cantilever_length.*true_y./(free_amplitude.*drive_frequency))- (0.333*lever_damping*cantilever_length);
dampy = dampy- min(dampy);

retardation_time = double(dampy./(stiffx));

rsq = true_x.^2 + true_y.^2;
asq = amplitude.^2;


%% Plotting

phase = phase .* (180/pi); %converted phase to degrees

subplot(4,2,1)
plot(z_dist,amplitude,'o-b')
title('Amplitude')
xlabel('Distance(nm)')  
ylabel('Amplitude(Å)')

subplot(4,2,2)
plot(z_dist,phase,'o-b')
title('Phase(Deg.)')
xlabel('Distance(nm)')
ylabel('Phase(degrees)')


subplot(4,2,3)
plot(z_dist,true_x,'o-b')
title('X')
xlabel('Distance(nm)')
ylabel('X(Å)')


subplot(4,2,4)
plot(z_dist,true_y,'o-b')
title('Y')
xlabel('Distance(nm)')
ylabel('Y(Å)')

subplot(4,2,5)
plot(z_dist,stiffx,'o-b')
title('Stiffness by Altered Boundary Condition')
xlabel('Distance(nm)')
ylabel('Stiffness(N/m)')

subplot(4,2,6)
plot(z_dist,dampy,'o-b')
title('Damping by Altered Boundary Condition')
xlabel('Distance(nm)')
ylabel('Damping(Kg/s)')

subplot(4,2,7)
plot(z_dist,stiffness,'o-b')
title('Stiffness By Point-Mass Model')
xlabel('Distance(nm)') 
ylabel('Stiffness(N/m)')


subplot(4,2,8)
plot(z_dist,damping,'o-b')
title('Damping by Point-Mass Model')
xlabel('Distance(nm)')
ylabel('Damping(Kg/s)')


% subplot(4,2,7)
% plot(z_dist,DC,'o-b')
% title('Retardation Time')
% xlabel('Distance(nm)')
% ylabel('Retardation Time(s)')
