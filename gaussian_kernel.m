function kernel = gaussian_kernel(sigma)

halfwidth = 3;
filter_size_gaussian = 2*halfwidth+ceil(sigma);
meu = floor(filter_size_gaussian/2);
A = 1 / (2*pi*sigma);
B = 2*sigma^2;
gaussian_kernel = zeros(filter_size_gaussian);
for i = 1:filter_size_gaussian
    for j = 1:filter_size_gaussian
        temp = -((i-meu-1)^2 + (j-meu-1)^2) / B;
        gaussian_kernel(i,j) = A * exp(temp);
    end
end
kernel = gaussian_kernel ./ sum(sum(gaussian_kernel));

end