function distance = hamming_distance(x1,x2)
distance = sum(xor(x1,x2));
end