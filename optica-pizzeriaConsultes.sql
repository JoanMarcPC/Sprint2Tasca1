USE optica;
-- Llista el total de factures d'un client/a en un període determinat.
SELECT * FROM comanda c JOIN client cl ON c.Idclient = cl.Idclient WHERE cl.Idclient = 1 AND c.Data_compra BETWEEN '2022-01-01' AND '2022-12-31';
-- Llista els diferents models d'ulleres que ha venut un empleat/da durant un any.
SELECT DISTINCT m.Nom FROM marca m JOIN ulleres u ON m.Idmarca = u.Idmarca JOIN comanda_te_ulleres cu ON u.Idulleres= cu.Idulleres JOIN comanda c ON cu.Idcomanda= c.Idcomanda JOIN empleat e ON e.IdEmpleat = c.Idempleat WHERE e.IdEmpleat = 1 AND c.Data_compra BETWEEN '2022-01-01' AND '2022-12-31';
-- Llista els diferents proveïdors que han subministrat ulleres venudes amb èxit per l'òptica.
SELECT DISTINCT P.Nom FROM PROveidor p JOIN MARca m ON p.IdpRoveidor = m.IdmArca JOIN ULLeres u ON m.IdmArca= u.IdmArca JOIN COManda_te_ulleres cu ON cU.iduLleres = u.IduLleres;
-- el format UCASE de les KEYWORDS NO FUNCIONA MOLT BE, PER AIXO VEURAS MAJUS PER TOT ARREU, SORRY
USE PIZzeria;
-- Llista quants productes de categoria 'Begudes' s'han venut en una determinada localitat.
SELECT COUnT(CP.QuaNtitat) AS total_begudes frOm COManda_te_productes cp join PROducte p on p.IdpRoducte = cp.idpRoducte join COManda c on cP.idcOmanda = c.IdcOmanda join CLIents cl on c.IdcLients = cl.idcLients join LOCalitat l on l.IdlOcalitat = cl.idlOcalitat AND L.IdpRovincia = cl.idpRovincia where p.tipus = 'B' AND l.nom = 'BARCELONA';
-- entenc que el meu disseny dificulta aquest tipus de consulta.
-- Llista quantes comandes ha efectuat un determinat empleat/da.
SELECT count(c.idcomanda) AS total_comandes from comanda c join empleat e on c.idempleat = e.idempleat where e.nom = 'Manel';