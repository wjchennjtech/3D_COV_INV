function [result] = safelog(x)
if abs(x)<1e-10
    result = 0;
else
    result = log(x);
end
end

