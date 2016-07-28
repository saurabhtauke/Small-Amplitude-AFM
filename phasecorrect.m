
% Tiny code for corercting the phase discontinuities in the phase grabbing From the Lockin.
% The discontinuities arrise if the phase of our system exceeds the upper limit of arctan(Y/X) which is 90 degrees.



x= importdata('testp.txt');

p = x
for i = 1:200
    
    if (p(i)< 0)
        p(i)= p(i) + 20.000000
    end
end
p
plot (p)
