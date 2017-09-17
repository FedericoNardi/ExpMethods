function setbarsize(h, x, xlim, y, ylim)
% SETBARSIZE  Set width of errorbars in plots produced by XYERRORBAR.
%
% SETBARSIZE(HANDLE, XVALS, WIDTH, YVALS, HEIGHT)
%
%   HANDLE - errorbar plot handle as returned by XYERRORBAR
%   XVALS  - x values of the data points in the plot
%   WIDTH  - half width of errobars. can be specified as a single
%            scalar or as a vector with the same lenght as XVALS.
%   YVALS  - y values of the data points in the plot
%   HEIGHT - half heigth of errobars. can be specified as a single
%            scalar or as a vector with the same lenght as YVALS.
%
% See also XYERRORBAR.
%
% Code courtesy of D. Nicolodi and Matlab Central
%
% $Id: setbarsize.m 5477 2015-03-23 16:31:17Z mauro.hueller $

h0 = h(2);
bx = get(h0, 'Xdata');% Mah?
by = get(h0, 'Ydata');% Mah?

switch length(xlim)
    case 1
        xlim = xlim * ones(size(x));
    case length(x)
        % nothing to do
    otherwise
        error('WIDTH should be a scalar or have the same size as XVALS')
end

switch length(ylim)
    case 1
        ylim = ylim * ones(size(y));
    case length(y)
        % do nothing
    otherwise
        error('HEIGHT should be a scalar or have the same size as YVALS');
end

% Update the values of the x coordinates
for kk = 1:length(x)
  temp_line = bx(18*(kk-1)+1 : 18*(kk));
  temp_line(14) = x(kk) - xlim(kk);
  temp_line(15) = x(kk) + xlim(kk);
  temp_line(17) = x(kk) - xlim(kk);
  temp_line(18) = x(kk) + xlim(kk);
  bx(18*(kk-1)+1 : 18*(kk)) = temp_line;
end

% Update the values of the y coordinates
for kk = 1:length(y)
  temp_line = by(18*(kk-1)+1 : 18*(kk));
  temp_line(5) = y(kk) - ylim(kk);
  temp_line(6) = y(kk) + ylim(kk);
  temp_line(8) = y(kk) - ylim(kk);
  temp_line(9) = y(kk) + ylim(kk);
    by(18*(kk-1)+1 : 18*(kk)) = temp_line;
end

assert(all(size(get(h0, 'Ydata')) == size(bx)));
assert(all(size(get(h0, 'Xdata')) == size(by)));

set(h0, 'Xdata', bx)
set(h0, 'Ydata', by)