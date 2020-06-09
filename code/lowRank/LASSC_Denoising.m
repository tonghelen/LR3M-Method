function im_out   =  LASSC_Denoising( par )
time0         =   clock;
nim           =   par.nim;
% ori_im        =   par.I;
b             =   par.win;  % window size
[h, w, ch]    =   size(nim);

N        =   h-b+1;
M        =   w-b+1;
r        =   [1:N];
c        =   [1:M];
% disp(sprintf('PSNR of the noisy image = %f \n', csnr(nim, ori_im, 0, 0) ));

im_out      =   nim;

for iter = 1 : par.Itr
    
    im_out = im_out + par.delta*(nim - im_out);
    dif    = im_out-nim;
    vd     = par.nSig^2-(mean(mean(mean(dif.^2))));
        
    if (iter==1)
        sig_w = sqrt(abs(vd));            
    else
        sig_w = sqrt(abs(vd))*par.gama;
    end    
    
    if (mod(iter,6)==0) || (iter==1)
%         blk_arr = exemplar_matching(im_out, par);
        blk_arr = Block_matching(im_out, par);
    end
    X = Im2Patch(im_out, par);    
    Y = zeros(size(X));        
    W = zeros(size(X));
    L = size(blk_arr,2);
    for  i  =  1 : L
        B  = X(:, blk_arr(:, i));
        mB = repmat(mean(B, 2), 1, size(B, 2));
        B  = B-mB;        
        [Y(:, blk_arr(:,i)), W(:, blk_arr(:,i)), R(i)] = Low_rank_SSC(double(B), par.c1, sig_w, mB);
    end
    %R_save(iter,:)=R;
    im_out = zeros(h,w,3);
    im_wei = zeros(h,w,3);
    k      = 0;
    for i = 1:b
        for j = 1:b
            k = k+1;
            im_out(r-1+i,c-1+j,1) = im_out(r-1+i,c-1+j,1) + reshape(Y(k,:)', [N M]);
            im_wei(r-1+i,c-1+j,1) = im_wei(r-1+i,c-1+j,1) + reshape(W(k,:)', [N M]);
            k = k+1;
            im_out(r-1+i,c-1+j,2) = im_out(r-1+i,c-1+j,2) + reshape(Y(k,:)', [N M]);
            im_wei(r-1+i,c-1+j,2) = im_wei(r-1+i,c-1+j,2) + reshape(W(k,:)', [N M]);
            k = k+1;
            im_out(r-1+i,c-1+j,3) = im_out(r-1+i,c-1+j,3) + reshape(Y(k,:)', [N M]);
            im_wei(r-1+i,c-1+j,3) = im_wei(r-1+i,c-1+j,3) + reshape(W(k,:)', [N M]);
        end
    end
    im_out = im_out./(im_wei+eps);
    
    if isfield(par,'I')
        PSNR  = csnr( im_out, par.I, 0, 0 );
        SSIM  = cal_ssim( im_out, par.I, 0, 0 );
    end
    
%     fprintf( 'Iteration %d : nSig = %2.2f, PSNR = %2.2f, SSIM = %2.4f\n', iter, sig_w, PSNR, SSIM );
end
if isfield(par,'I')
   PSNR = csnr( im_out, par.I, 0, 0 );
   SSIM = cal_ssim( im_out, par.I, 0, 0 );
end
% disp(sprintf('Total elapsed time = %f min\n', (etime(clock,time0)/60) ));
return;



%------------------------------------------------------------------
% Re-weighted SV Thresholding
% Sigma = argmin || Y-U*Sigma*V' ||^2 + tau * || Sigma ||_*
%------------------------------------------------------------------
function  [X W r]   =   Low_rank_SSC(Y, c1, sig_w, m)
[U,Sigma,V] = svd(full(Y),'econ');
Sigma = diag(Sigma);
sig_i = max( Sigma.^2/size(Y, 2) - sig_w^2, 0 );
%S                 =   max( Sigma0.^2/sqrt(size(Y,1)*size(Y, 2)) - nsig^2, 0 );
tao = c1*sig_w^2./ ( sqrt(sig_i) + eps );
sig_i = soft(Sigma, tao);
r = sum(sig_i>0);

U = U(:,1:r);
V = V(:,1:r);
X = U*diag(sig_i(1:r))*V';

if r==size(Y,1)
    wei = 1/size(Y,1);
else
    wei = (size(Y,1)-r)/size(Y,1);
end
W = wei*ones(size(X));
X = (X + m)*wei;
return;

