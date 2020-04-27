# Intrusion-Detection-on-FPGA-through-BNN

Files and code for 'Genetically Optimized Massively Parallel Binary Neural Networks for Intrusion Detection Systems' T.Murovič, A.Trost

Original datasets are taken from:
1. https://www.unsw.adfa.edu.au/unsw-canberra-cyber/cybersecurity/ADFA-NB15-Datasets/ [UNSW-NB15 dataset]
2. https://www.unb.ca/cic/datasets/nsl.html [NSLKDD dataset]

They are also tagged at [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.3768048.svg)](https://doi.org/10.5281/zenodo.3768048).

-------------------------------------------------------------------------------------------------------------------------------
The cybersecurity_dataset_x.m scripts take the original datasets and binarize them and format them as explained in the paper. The outputs are also available at [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.3768070.svg)](https://doi.org/10.5281/zenodo.3768070)

--------------------------------------------------------------------------------------------------------------------------------
BNNs are then trained on the new datasets using the scripts from [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.3258669.svg)](https://doi.org/10.5281/zenodo.3258669).

Net_Params/ --> Includes the trained BNN parameters per layer for the UNSW-NB15 and NSLKDD dataset, both in the original partition (FULL) and the new, randomly permutted partition (RAND). (_w are binary weights, _t are integer comparison thresholds). 

--------------------------------------------------------------------------------------------------------------------------------
Scripts build_layers.m and hamming_genetic.m are then used to automatically build the optimized BNN combinational HDL (Verilog) modules.

Verilog/ --> Includes the Verilog modules of BNN layers for the UNSW-NB15 (dataset_0) and NSLKDD (dataset_1) dataset, both in the original partition (partition_1) and the new, randomly permutted partition (partition_0). Can be used as is in the desired HDL project. 






