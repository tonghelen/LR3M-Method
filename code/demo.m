clear
addpath('./lowRank/');

para.beta    = 0.015;
para.omega   = 2;
para.lambda  = 2.5;
para.sigma   = 10;
para.gamma   = 2.2;
para.epsilon = 1;


par.nSig     =   para.sigma;
par.win      =   7;
par.nblk     =   40;
par.c1       =   2.9*sqrt(2);
par.gama     =   0.65;
par.delta    =   0.23;
par.Itr      =   2;
par.S        =   25;
par.step     =   min(6, par.win-1);
para.par     =   par;

files = dir('../data/*.bmp');

for i = 1:length(files)
    img = im2double(imread(['../data/' files(i).name]));
    [I, R, L] = LR3M(img, para);
    imwrite(I, ['../results/seq_' files(i).name]);
    figure,imshow(I)
end
