% hs25.m
function f =  hs25(x)

f = 0.0;

  for ii = 1 : 99; 

    u = 25.0 + (-50.0*log(i/100))^(2/3);

    f = f + pow(  exp(-u-x(1)^x(2)/x(0)) - i/100, 2);

  end

end


