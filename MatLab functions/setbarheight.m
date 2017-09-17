function setbarheight(h, y, ylim)
% SETBARHEIGHT Set heigth of errorbars in plots produced by HERRORBAR.
%
% SETBARHEIGHT(HANDLE, YVALS, HEIGHT)
%
%   HANDLE - errorbar plot handle as returned by HERRORBAR
%   YVALS  - y values of the data points in the plot
%   HEIGHT - half heigth of errobars. can be specified as a single
%            scalar or as a vector with the same lenght as YVALS.
%
% See also HERRORBAR.
%
% Code courtesy of D. Nicolodi and Matlab Central
%
% $Id: setbarheight.m 3921 2013-03-28 16:23:12Z mauro.hueller $

h0 = h;
b = get(h0(1), 'Ydata');

switch length(ylim)
    case 1
        ylim = ylim * ones(size(y));
    case length(y)
        % do nothing
    otherwise
        error('HEIGHT should be a scalar or have the same size as YVALS');
end

for kk = 1:length(y)
  temp_line = b(9*(kk-1)+1 : 9*(kk));
  temp_line(2) = y(kk) - ylim(kk);
  temp_line(1) = y(kk) + ylim(kk);
  temp_line(8) = y(kk) - ylim(kk);
  temp_line(7) = y(kk) + ylim(kk);
  b(9*(kk-1)+1 : 9*(kk)) = temp_line;
end

assert(all(size(get(h0(1), 'Xdata')) == size(b)));

set(h0(1),'Ydata', b)
