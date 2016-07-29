%% Removing the approach values and rescaling the z_voltage values and converting to nanometers

% trimm all the arrays to remove approach z values.


% !!! FIRST REMOVE THE APPROACH Z VALUES !!!
% !!! FIRST REMOVE THE APPROACH Z VALUES !!!
% !!! FIRST REMOVE THE APPROACH Z VALUES !!!
% !!! FIRST REMOVE THE APPROACH Z VALUES !!!
% !!! FIRST REMOVE THE APPROACH Z VALUES !!!
% !!! FIRST REMOVE THE APPROACH Z VALUES !!!

a= importdata('q.txt');
b = a.('data');

z_volt = b(:,1);
totlength = length(z_volt);

count = 0;

for i = 1: (totlength-1)
    if (z_volt(i) > z_volt(i+1))
        count = count+1;
    end
end

count;
plot(z_volt)