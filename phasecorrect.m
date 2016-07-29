% Tiny code for corercting the phase discontinuities in the phase grabbing From the Lockin.
% The discontinuities arrise if the phase of our system exceeds the upper limit of arctan(Y/X) which is 90 degrees.

clear all
%% Initialize data into arrays
Int_sensitivity = 40;           	% in mv/A
npoints = 80;                      % uptil what point do we need to correct the phase data
phasecutoff = -0.139;               % the cutoff point below which the phase would be take to the positive side

a= importdata('q.txt');
b = a.('data');

x= b(:,7);
y= b(:,8);

amplitude = b(:,2)*0.25;
phi = b(:,3);                        % Third column is the Phase.

%% The phase correction part
%plot (phi)                      % is the phase column in the consolidated data sheet

phase = phi;

for i = 1:npoints
    
    if (phase(i) < phasecutoff )
        phase(i)= phase(i) + 3.14;
    end
end

%phase;
plot (phase)

phione = acos(x./amplitude);            
phitwo = asin(y./amplitude);

%% Stiffness and Damping calculation

