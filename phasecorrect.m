% Tiny code for corercting the phase discontinuities in the phase grabbing From the Lockin.
% The discontinuities arrise if the phase of our system exceeds the upper limit of arctan(Y/X) which is 90 degrees.

clear all
%% Experimental constsnts

Int_sensitivity = 40;           	% in mv/A
opamp_gain = 12;
scanner_calib = 22.27;

npoints = 80;                      % uptil what point do we need to correct the phase data
phasecutoff = -0.139;               % the cutoff point below which the phase would be take to the positive side

%% data allocation

a= importdata('q.txt');
b = a.('data');

z = b(:,1);
x = b(:,7)*(10/Int_sensitivity);
y = b(:,8)*(10/Int_sensitivity);
amplitude = b(:,2)*(10/Int_sensitivity);
phi = b(:,3);                        % Third column is the Phase.

%% Removing the approach values and rescaling the z_voltage values and converting to nanometers

% trimm all the arrays to remove approach z values.


% !!! FIRST REMOVE THE APPROACH Z VALUES !!!
% !!! FIRST REMOVE THE APPROACH Z VALUES !!!
% !!! FIRST REMOVE THE APPROACH Z VALUES !!!
% !!! FIRST REMOVE THE APPROACH Z VALUES !!!
% !!! FIRST REMOVE THE APPROACH Z VALUES !!!
% !!! FIRST REMOVE THE APPROACH Z VALUES !!!

z_dist = z * scanner_calib * opamp_gain;
start_point = z_dist(1);
z_dist = z_dist - start_point ;


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
plot (phase)

phione = acos(x./amplitude);            
phitwo = asin(y./amplitude);

%% Stiffness and Damping calculation   =1.987*(((1.163114/Q3)*V3)-1)

t1 = 1.7./amplitude;
t2 = cos(phase);
t3 = t2.*t1;
stiffness = 0.8*(t3-1);


%(1.987*t4)*t5

t4 = 1.7./(amplitude.*2000);
t5 = sin(phase);
t6 = t4.*t5 ;
damping = 0.8 * t6 ;
