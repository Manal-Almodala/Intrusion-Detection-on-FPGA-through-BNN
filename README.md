# Intrusion-Detection-on-FPGA-through-BNN

Files and code for 'Genetically Optimized Massively Parallel Binary Neural Networks for Intrusion Detection Systems' T.Murovič, A.Trost

Net_Params/ --> Includes the trained BNN parameters per layer for the UNSW-NB15 and NSLKDD dataset, both in the original partition (FULL) and the new, randomly permutted partition (RAND). (_w are binary weights, _t are integer comparison thresholds). 

Verilog/ --> Includes the Verilog modules of BNN layers for the UNSW-NB15 (dataset_0) and NSLKDD (dataset_1) dataset, both in the original partition (partition_1) and the new, randomly permutted partition (partition_0). Can be used as is in the desired HDL project. 



https://www.unsw.adfa.edu.au/unsw-canberra-cyber/cybersecurity/ADFA-NB15-Datasets/

https://www.unb.ca/cic/datasets/nsl.html

10.5281/zenodo.3768048

