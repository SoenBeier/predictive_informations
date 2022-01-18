data{1} = load("number_cell-" + 5 + "datamutual_information.mat");
data{2} = load("number_cell-" + 10 + "datamutual_information.mat");
data{3} = load("number_cell-" + 20 + "datamutual_information.mat");
data{4} = load("number_cell-" + 40 + "datamutual_information.mat");
data{5} = load("number_cell-" + 70 + "datamutual_information.mat");
data{6} = load("number_cell-" + 100 + "datamutual_information.mat");

figure("name","mutual_information_different_cell_number");
hold on
for i = 1:6
    plot(data{i}.Delta_t_array,data{i}.mutual_information_array);
end
legend('5','10','20','40','70','100');


