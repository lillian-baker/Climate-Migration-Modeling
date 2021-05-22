%Testing new parameters

t0 = 15;
dt = .005;
t_final = 100; %t0 ~ 15 y.o.
t = t0:dt:t_final;

%Initialize p vector
p2 = zeros(size(t));

%Define initial conditions
p_0 = 0.3;

%Define equilibrium
p_eq = 0.6;

%Define parameters
mu2 = 1.9;
sigma2 = 0.8;

trials2 = 100000;
t_stop2 = zeros(trials2, 1);

%Build the function by Euler's Method
for r =1:trials2
    p2 = zeros(size(t));
    p2(1) = p_0;
for i = 1:length(t)-1
p2(i+1) = p2(i) + dt*mu2*p2(i)*(p_eq-p2(i))+sqrt(dt)*sigma2*(p2(i)^2)*randn; %Adding dp to each p(i) to find p(i+1)
if p2(i+1) > 1 %First passage time
    t_stop2(r) = t(i+1);
    break
end

end
end


%Plots distribution against original parameters
load standard_param.mat
load Parameters_mu_1.4_sigma_0.8.mat
test_counts = counts2;
test_center = center2;
load Parameters_mu_2.4_sigma_0.8.mat
figure
hold on
%hist(data, either number of bins OR bin centers)
%[counts2, center2] = hist(t_stop2, linspace(t0,t_final, 100)); %try with different bin numbers
%counts2 = counts2/sum(counts2); %Normalize to sum to 1
plot(center, counts, 'o', center2, counts2, 'go', test_center, test_counts, 'ro')


title('Distribution of Age of Migration for Shifts in \mu')
xlabel('Age of Migration')
ylabel('Normalized Frequency')
xlim([t0 100])
upper = max([max(counts) max(counts2) max(test_counts)]);
ylim([0 0.06])
legend('\mu=1.95', '\mu=2.4', '\mu=1.4')


filename1 = ['ParameterComparison_mu_', num2str(mu2),'_sigma_', num2str(sigma2),'.png'];
saveas(gcf, filename1)

filename2 = ['Parameters_p_eq_', num2str(p_eq), '.mat'];
save(filename2,'p_0', 'p_eq', 'sigma2', 'mu2', 'p2', 't_stop2',  'center2', 'counts2') 

