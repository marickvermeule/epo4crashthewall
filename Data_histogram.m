% Data histogram
clear variables
avg = 0;
sigma = 0;
error = [10, 20, 20, 30, 40, 40, 40, 50, 50, 60, 70, 80, 90, 90, 90, 100, 110, 140]';
length(error)
nbins = 50;
histogram(error,nbins)
title('Error of integrated design for challenge a')
xlabel('Error')
ylabel("Occurance")
for i = 1:18
    avg = avg + error(i);
end
avg = avg/length(error)
for i = 1:18
    sigma = sigma + abs(avg-error(i));
end
sigma = sigma/length(error)
