% Tiny code for corercting the phase discontinuities in the phase grabbing From the Lockin.
% The discontinuities arrise if the phase of our system exceeds the upper limit of arctan(Y/X) which is 90 degrees.


Int_sensitivity = 40;  	% in mv/A
npoints = 150;	% uptil what point do we need to correct the phase data
phasecutoff = -0.139; % the cutoff point below which the phase would be take to the positive side

a= importdata('q.txt');
b = getfield(a,'data');

%plot (b(:,3)) % is the phase column in the consolidated data sheet
%p = b(:,3);                         % Third column is the Phase.

for i = 1:npoints
    
    if (p(i) < phasecutoff )
        p(i)= p(i) + 3.14;
    end
end

%p;
%plot (p)

x= b(:,7);
y= b(:,8);

amplitude = b(:,2)*0.25;

phione = acos(x./amplitude);
phitwo = asin(y./amplitude);
