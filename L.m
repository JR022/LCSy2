%The 'recursive' L_{m,n} function.
function l = L(m,n,matchGrid, LGrid)
    %Base case
    if m == 1 && n == 1
        l = matchGrid(m,n);
    elseif m == 1
        l = LGrid(m,n-1);
    elseif n == 1
        l = LGrid(m-1,n);
    else %Neither m nor n is 1.
    %The 'recursive' step - this version relies on row-by-row,
    %left-to-right execution so that previous L-values may be used.  This
    %significantly increases performance.
    l = max([uint16(matchGrid(m,n))+LGrid(m-1,n-1),LGrid(m,n-1),LGrid(m-1,n)]);
end