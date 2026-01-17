% input your data into these arrays

calibration_weights = [0 1.707 2.965 5.014 10.02 12.069 13.327 15.034]; % in kilograms
calibration_adcs = [7.1 44.6 73.8 121.3 237.2 284.8 314.2 354.1];
calibration_axis = 3; % the axis which was used to calibrate
calibration_gain = 1100; % the gain set on the axis used to calibrate

set_gains = [11000 11000 2200];
g = 9.81;

% values provided by tacuna systems calibration
given_gains = [10.014*10.986 10.011*10.981 10.012*10.985];
given_sensitivities = [0.9436e-3 0.9173e-3 1.0008e-3];

% linear regression
x = calibration_adcs;
X = [ones(length(x), 1) x'];
y = calibration_weights';
b = X\y;

fity = [ones(length(x), 1) x'] * b;
Rsq = 1 - sum((y - fity).^2)/sum((y-mean(y)).^2)


hold on
plot(x,fity)
scatter(x, y)
hold off

adc_to_newtons = ((ones(1,3)*calibration_gain)./set_gains) ...
                .* ((ones(1,3)*given_gains(calibration_axis)./given_gains) ...
                .* ((ones(1,3)*given_sensitivities(calibration_axis))./given_sensitivities)) ...
                .* b(2) .* g
