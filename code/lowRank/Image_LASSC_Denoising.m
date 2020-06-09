%----------------------------------------------------
% Blur: 9x9 Uniform kernel; AGWN std Varance = 2^0.5
% Data: May 20th, 2010
% Author: Weisheng Dong, wsdong@mail.xidian.edu.cn
%----------------------------------------------------
function  xx=Image_LASSC_Denoising(y, x,  nSig)
pre           =   'LASSC_';
par.nSig      =   nSig;
if nSig<=15
    par.win       =   6;
    par.nblk      =   40;
    par.c1        =   2.8*sqrt(2);   % 1.7
    par.gama      =   0.63;
    par.delta     =   0.23; 
    par.Itr       =   10; % iteration time
    par.S         =   21; % block matching search size
elseif nSig <= 30
    par.win       =   7;
    par.nblk      =   60;
    par.c1        =   2.9*sqrt(2);   % 2.6
    par.gama      =   0.65;
    par.delta     =   0.23;
    par.Itr       =   11;
    par.S         =   21;
elseif nSig<=50
    par.win       =   8;
    par.nblk      =   75;
    par.c1        =   3.0*sqrt(2);   % 2.6
    par.gama      =   0.67;
    par.delta     =   0.23;    
    par.Itr       =   12;
    par.S         =   21;
else
    par.win       =   9;
    par.nblk      =   90;
    par.c1        =   3.1*sqrt(2);   % 1.6
    par.gama      =   0.64;
    par.delta     =   0.23;    
    par.Itr       =   14;    
    par.S         =   21;
end
par.step      =   min(6, par.win-1);

    
%     par.I        =   x;
    par.nim      =   y;
    
     par.Itr       =   2;
    
    xx   =   LASSC_Denoising(par);
    
   %disp( sprintf('%s: PSNR = %3.2f  SSIM = %f\n', im_dir(i).name, PSNR, SSIM) );
    

