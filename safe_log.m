function  result = safe_log( x )

    indx = find( abs(x) < 1^-10);
    
    result = log(x);
    
    result(indx) = 0;

end