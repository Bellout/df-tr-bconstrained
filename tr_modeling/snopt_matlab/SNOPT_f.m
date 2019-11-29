function [ f, g ] = SNOPT_f( x )

  H = [ 1 0; 0 1 ];

  f = 0.5 * x' * H * x;

  g = H * x;

end