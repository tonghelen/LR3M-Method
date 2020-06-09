function  X  =  Im2Patch(im, par)
f = par.win;
N = size(im,1)-f+1;
M = size(im,2)-f+1;
L = N*M;
X = zeros(f*f*3, L, 'single');
k = 0;
for i = 1:f
    for j = 1:f
        k = k+1;
        blk = im(i:end-f+i,j:end-f+j,1);
        X(k,:) = blk(:)';
        k = k+1;
        blk = im(i:end-f+i,j:end-f+j,2);
        X(k,:) = blk(:)';
        k = k+1;
        blk = im(i:end-f+i,j:end-f+j,3);
        X(k,:) = blk(:)';
    end
end