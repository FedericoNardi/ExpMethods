function text_reg_lin(fit_struct);
% function text_reg_lin(fit_struct)
% 
% funzione banale che vomita a video l'informazione del fit con 
%   "regressione_lineare"
%   unico argomento è la structure output di "regressione_lineare"
%

disp([' ********************************************************* '])
disp([' Regressione y = m*x + b ']);
disp(['     m = ' num2str(fit_struct.m) ' +/- ' num2str(fit_struct.dm) ]);
disp(['     b = ' num2str(fit_struct.b) ' +/- ' num2str(fit_struct.db) ]);
disp(['     chi^2 = ' num2str(fit_struct.chi2) ' (' int2str(fit_struct.dof) ' DOF)']);
disp(['     ']);
disp([' ********************************************************* '])
