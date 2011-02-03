function [f,g,H] = autoHess(x,useComplex,funObj,varargin)
% Numerically compute Hessian of objective function from gradient values

p = length(x);

if useComplex % Use Complex Differentials
    mu = 1e-150;

    diff = zeros(p);
    for j = 1:p
        e_j = zeros(p,1);
        e_j(j) = 1;
        [f(j) diff(:,j)] = funObj(x + mu*i*e_j,varargin{:});
    end
    f = mean(real(f));
    g = mean(real(diff),2);
    H = imag(diff)/mu;
else % Use finite differencing
    mu = 2*sqrt(1e-12)*(1+norm(x))/norm(p);
    
    [f,g] = funObj(x,varargin{:});
    diff = zeros(p);
    for j = 1:p
        e_j = zeros(p,1);
        e_j(j) = 1;
        [f diff(:,j)] = funObj(x + mu*e_j,varargin{:});
    end
    H = (diff-repmat(g,[1 p]))/mu;
end

% Make sure H is symmetric
H = (H+H')/2;

if 0 % DEBUG CODE
    [fReal gReal HReal] = funObj(x,varargin{:});
    [fReal f]
    [gReal g]
    [HReal H]
    pause;
end