function out = chi2(data, dy, model)
  % function out = chi2(data, dy, model)
  % Calcola il chi^2 del set di dati fornito in ingresso come:
  % 
  % chi^2 = sum((model - data).^2 ./ dy.^2)
  % 
  % data    Vettore con i valori misurati
  % dy      Vettore con incertezza per i valori misurati
  % model   Vettore con i valori previsti in base al modello
  % 
  % M Hueller 18/03/2013
  %
  % $Id: chi2.m 3921 2013-03-28 16:23:12Z mauro.hueller $
  
  out = sum((model - data).^2 ./ dy.^2);
  
end