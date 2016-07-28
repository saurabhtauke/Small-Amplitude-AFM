

x= importdata('testp.txt');

p = x
for i = 1:200
    
    if (p(i)< 0)
        p(i)= p(i) + 20.000000
    end
end
p
plot (p)