function [m, dm] = media_pesata(dati, pesi)
  % function [m, dm] = media_pesata(dati, pesi) 
  % Calcola la media pesata del vettore dati, pesata sul vettore pesi:
  %         m  = sum(dati .* pesi) ./ sum(pesi);
  % E l'incertezza: 
  %         dm = sqrt(1 ./ sum(pesi));
  %
  % M Hueller 19/02/2014
  %
  % $Id: media_pesata.m 5211 2014-09-11 09:33:06Z mauro.hueller $
  
  % Verifico che il vettore pesi non sia vuoto
  if ~isempty(pesi)
    % Controllo le dimensioni del vettore pesi
    if ~isequal(size(dati), size(pesi))
      error('Vettore pesi e vettore dati devono avere le stesse dimensioni!')
    else
      % Tutto bene
      m  = sum(dati .* pesi) ./ sum(pesi);
      dm = sqrt(1 ./ sum(pesi));
    end
  else
    % Nel caso il vettore pesi sia vuoto, ritorno la media 'classica'
    warning('Vettore pesi vuoto. Applico la media! L''incertezza e'' la deviazione standard della media.');
    m  = mean(dati);
    dm = sqrt(1/numel(dati)) * std(dati);
  end
end