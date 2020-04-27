%% Create NSLKDD SET 
clear all;

for selp = 0:1
close all hidden;

SEL_ORIGINAL = selp; % 1 = original partition, 0 = new random partition

%d = load("datasets/cybersecurity/KDDTest+.txt"); 
d = importdata("datasets/cybersecurity/KDDTest+.arff");
dt = importdata("datasets/cybersecurity/KDDTrain+.arff");
datanf = [d(45:end);dt(45:end)];
for i = 1:length(datanf)
    split = i/length(datanf)
    tmp = strsplit(string(table2array(datanf(i))),',');
    data(i,:) = tmp;    
end

bits = 0;
binfeat = [];
for i = 1:size(data,2)
    v = strsplit(string(table2array(d(i+1)))," ");
    v = v(3)
    if v == "real" % Integer
       vals = str2num(char(data(:,i)));
       decimals = vals-floor(vals);
       if sum(decimals) == 0
         tv = max(vals);
         if tv == 0
             continue;
         end
         bc = ceil(log2(tv+1));
         bfv = de2bi(vals,bc,'left-msb');
       else
         tv = 100; 
         bc = ceil(log2(tv+1));
         bfv = de2bi(round(vals*100),bc,'left-msb');
       end      
       bits = bits + bc;
       binfeat = [binfeat bfv];
    end
    if v == "{'0'," % Binary
       bc = 1;
       bits = bits + bc;
       bfv = str2num(char(data(:,i)));
       binfeat = [binfeat bfv];
    end
    if v == "{'tcp','udp'," % Protocol
       tmp = zeros(length(data(:,i)),1);
       tmp(data(:,i) == "icmp") = 1;
       tmp(data(:,i) == "udp") = 2;
       bc = 2;
       bfv = de2bi(tmp,bc,'left-msb');
       bits = bits + bc;
       binfeat = [binfeat bfv];
    end
    if v == "{'aol'," % Service
        un = unique(data(:,i));
        unl = length(un);
        tmp = zeros(length(data(:,i)),1);
        for j = 2:length(un)
            tmp(data(:,i)==un(j)) = j-1;
        end
        bc = ceil(log2(unl));
        bfv = de2bi(tmp,bc,'left-msb');
        bits = bits + bc;
        binfeat = [binfeat bfv];
    end
    if v == "{" % Flag
        un = unique(data(:,i));
        unl = length(un);
        tmp = zeros(length(data(:,i)),1);
        for j = 2:length(un)
            tmp(data(:,i)==un(j)) = j-1;
        end
        bc = ceil(log2(unl));
        bfv = de2bi(tmp,bc,'left-msb');
        bits = bits + bc;
        binfeat = [binfeat bfv];
    end
    if v == "{'normal',"
        tmp = zeros(length(data(:,i)),1); 
        tmp(data(:,i)=="anomaly") = 1;
        binfeat = [binfeat tmp];
    end
    bitsvec(i) = bc;
end
bits

if SEL_ORIGINAL == 0
    binfeat = binfeat(randperm(length(binfeat)),:);
    pause(2.0);
    id  = round(2*length(binfeat)/3);
    id6 = round(2*length(binfeat)/3/6);
    infeat_train = binfeat(1:id-id6,:);
    infeat_valid = binfeat((id-id6+1):id,:);
    infeat_test  = binfeat(id+1:end,:);
else
    btest = binfeat(1:length(d(45:end)),:);
    btran = binfeat(length(d(45:end))+1:end,:);
    infeat_test = btest;
    id = round(length(btran)-length(btran)/10);
    infeat_train = btran(1:id,:);
    infeat_valid = btran(id+1:end,:);
end

% infeat_train = infeat_train(1:round(size(infeat_train,1)/10),:);
% infeat_valid = infeat_valid(1:round(size(infeat_valid,1)/10),:);
% infeat_test  = infeat_test(1:round(size(infeat_test,1)/10),:);
dataset_size = [length(infeat_train)+length(infeat_valid)+length(infeat_test) length(infeat_train) length(infeat_valid) length(infeat_test)]

if SEL_ORIGINAL == 0
    dlmwrite('formatted_datasets/cybersecurity/nslkdd_train_fullR.txt',infeat_train,'delimiter',' ');
    dlmwrite('formatted_datasets/cybersecurity/nslkdd_test_fullR.txt',infeat_test,'delimiter',' ');
    dlmwrite('formatted_datasets/cybersecurity/nslkdd_valid_fullR.txt',infeat_valid,'delimiter',' ');
else
    dlmwrite('formatted_datasets/cybersecurity/nslkdd_train_full.txt',infeat_train,'delimiter',' ');
    dlmwrite('formatted_datasets/cybersecurity/nslkdd_test_full.txt',infeat_test,'delimiter',' ');
    dlmwrite('formatted_datasets/cybersecurity/nslkdd_valid_full.txt',infeat_valid,'delimiter',' ');
end
end
