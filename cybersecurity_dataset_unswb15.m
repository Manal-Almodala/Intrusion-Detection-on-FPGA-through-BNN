%% Create UNSWB SET 
clear all;

for selp = 0:1
close all hidden;

SEL_ORIGINAL = selp; % 1 = original partition, 0 = new random partition

s = ["datasets/cybersecurity/UNSW_NB15_testing-set.csv", "datasets/cybersecurity/UNSW_NB15_training-set.csv"]; %The names are the other way around

opts = detectImportOptions(char(s(1)));
T0 = readtable(char(s(1)),opts);
opts = detectImportOptions(char(s(2)));
T1 = readtable(char(s(2)),opts);
T = [T0; T1];

binfeat = [];
for i = 1:size(T,2)
    if i == 1 || i == (size(T,2)-1) %% ADD IP???
        continue;
    end

    M = table2array(T(:,i));

    if iscell(M)
        ue = string(unique(M));
        for j = 1:length(ue)
          new_M(strcmp(string(M),(ue(j)))) = j-1;    
        end
        M = new_M;
    end

    m = min(M(M~=0));
    m = 1/m;
    if m > 1
        M = M*m;
    end

    b = ceil(log2(double(max(M))+1));
    feat = de2bi(uint32(M),b,'left-msb');
    binfeat = [binfeat feat];
end

if SEL_ORIGINAL == 1
    binfeat = binfeat(randperm(length(binfeat)),:);

    btran = binfeat(1:height(T0),:);
    btest = binfeat(height(T0)+1:end,:);
    infeat_test = btest;
    id = round(length(btran)-length(btran)/10);
    infeat_train = btran(1:id,:);
    infeat_valid = btran(id+1:end,:);
else
    binfeat = binfeat(randperm(length(binfeat)),:);
    pause(2.0);
    id  = round(2*length(binfeat)/3);
    id6 = round(2*length(binfeat)/3/6);
    infeat_train = binfeat(1:id-id6,:);
    infeat_valid = binfeat((id-id6+1):id,:);
    infeat_test  = binfeat(id+1:end,:);
end

% infeat_train = infeat_train(1:round(size(infeat_train,1)/10),:);
% infeat_valid = infeat_valid(1:round(size(infeat_valid,1)/10),:);
% infeat_test  = infeat_test(1:round(size(infeat_test,1)/10),:);

dataset_size = [length(infeat_train)+length(infeat_valid)+length(infeat_test) length(infeat_train) length(infeat_valid) length(infeat_test)]

if SEL_ORIGINAL == 1 
    dlmwrite('formatted_datasets/cybersecurity/unswb15_train_fullR.txt',infeat_train,'delimiter',' ');
    dlmwrite('formatted_datasets/cybersecurity/unswb15_test_fullR.txt',infeat_test,'delimiter',' ');
    dlmwrite('formatted_datasets/cybersecurity/unswb15_valid_fullR.txt',infeat_valid,'delimiter',' ');
else
    dlmwrite('formatted_datasets/cybersecurity/unswb15_train_full.txt',infeat_train,'delimiter',' ');
    dlmwrite('formatted_datasets/cybersecurity/unswb15_test_full.txt',infeat_test,'delimiter',' ');
    dlmwrite('formatted_datasets/cybersecurity/unswb15_valid_full.txt',infeat_valid,'delimiter',' ');
end
end