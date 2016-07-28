% Tiny code for corercting the phase discontinuities in the phase grabbing From the Lockin.
% The discontinuities arrise if the phase of our system exceeds the upper limit of arctan(Y/X) which is 90 degrees.



x= importdata('podata.txt');
y= getfield(x,'data');
p = y(:,3);                         % Third column is the Phase.
for i = 1:200
    
    if (p(i) <  0.5)
        p(i)= p(i) + 3.14;
    end
end
p;
plot (p)
