/* Code by Mik-el
wwww.github.com/Mik-el*/

/* A multiline comment
*/

CREATE DATABASE bib3;

USE bib3;


/* To rename a coloumn
ALTER TABLE tableName CHANGE `oldcolname` `newcolname`
*/


CREATE TABLE autori (
  cod_au varchar(100) PRIMARY KEY,
  nome_au varchar(50) NOT NULL,
  cogn_au varchar(50) NOT NULL,
  paese_au varchar(50) NOT NULL,
  nascita_au year(4) NOT NULL,
  morte_au year(4) DEFAULT NULL CHECK (morte_au > nascita_au),
  bio varchar(1000) NOT NULL
);


CREATE TABLE libri (
  isbn char(13) PRIMARY KEY,
  tipoLib varchar(50) NOT NULL,
  titolo varchar(100) NOT NULL,.
  editore varchar(50) NOT NULL,
  edizione year(4) NOT NULL,
  donazione char(20) NOT NULL,
  
  FOREIGN KEY(donazione) REFERENCES donazioni(pi_)
  
  ON UPDATE CASCADE ON DELETE CASCADE
  
);

CREATE TABLE collocazioni (
  libro char(13) NOT NULL,
  posiz1 int(5) NOT NULL CHECK (posiz1<99),
  posiz2 int(5) NOT NULL CHECK (posiz2<99),
  
  
  PRIMARY KEY(posiz1, posiz2),
  
  FOREIGN KEY(libro) REFERENCES libri(isbn)
  
  ON UPDATE CASCADE ON DELETE CASCADE
);


CREATE TABLE case_editrici (
  cod_edit char(15) NOT NULL,
  nome_edit varchar(50) NOT NULL,
  nome_ref varchar(50) NOT NULL,
  cogn_ref varchar(50) NOT NULL,
  mail_edit varchar(30) UNIQUE,
  tel_edit int(10) UNSIGNED UNIQUE,
  citta varchar(50) NOT NULL,
  via varchar(150) NOT NULL,
  civico int(10) NOT NULL,
  
  primary key (citta, via, civico)
);



CREATE TABLE donazioni(
  pi_ char(20) PRIMARY KEY,
  cpa_int int(10) UNSIGNED UNIQUE,
  annoDono year(4) NOT NULL CHECK (annoDono >2006),
  motivo text NOT NULL
);



CREATE TABLE finanziamenti (
  ptc_fin int(20) UNSIGNED PRIMARY KEY,
  concess_fin date NOT NULL,
  acquisiz_fin date NULL CHECK (acquisiz_fin > '2006-01-01'),
  somma_fin double(6,0) NOT NULL,
  motivo_fin varchar(300) NOT NULL,
  citta_ist varchar(50) NOT NULL,
  via_ist varchar(150) NOT NULL,
  civico_ist int(10) NOT NULL,
  
  FOREIGN KEY(citta_ist, via_ist, civico_ist) REFERENCES istituzioni(citta, via, civico)
  
  ON UPDATE CASCADE ON DELETE CASCADE
  
);



CREATE TABLE individui (
  codFisc_idv char(16) NOT NULL,
  nome_idv varchar(50) NOT NULL,
  cognome_idv varchar(50) NOT NULL,
  tel_idv int(10) UNSIGNED NOT NULL,
  citta varchar(50) NOT NULL,
  via varchar(150) NOT NULL,
  civico int(10) NOT NULL,
  
  primary key (citta, via, civico)
);




CREATE TABLE istituzioni (
  nome_ist varchar(50) NOT NULL,
  rappr_ist varchar(50) NOT NULL,
  pec_ist varchar(100) UNIQUE,
  citta varchar(150) NOT NULL,
  via varchar(50) NOT NULL,
  civico int(10) NOT NULL,
  
  primary key (citta, via, civico)
  
 
);






CREATE TABLE prestiti (
  numProg int(10) UNSIGNED PRIMARY KEY,
  richiesta date NOT NULL,
  noleggio date NOT NULL,
  scadenza date NOT NULL CHECK (scadenza>noleggio),
  riconsegna date DEFAULT NULL CHECK (riconsegna>noleggio),
  libro CHAR(13) NOT NULL,
  utente INT(10) UNSIGNED NOT NULL,
  
  
  
  FOREIGN KEY(libro) REFERENCES libri(isbn)
  ON UPDATE CASCADE ON DELETE CASCADE, 
  
  FOREIGN KEY(utente) REFERENCES utenti(cif_ut)
  ON UPDATE CASCADE ON DELETE CASCADE 
  
);



CREATE TABLE scritture (
  libro char(13) NOT NULL,
  autore varchar(100) NOT NULL,
  
  PRIMARY KEY(libro, autore),
  
  FOREIGN KEY(libro) REFERENCES libri(isbn),
  FOREIGN KEY(autore) REFERENCES autori(cod_au) 
  
  ON UPDATE CASCADE ON DELETE CASCADE
);









CREATE TABLE utenti (
  cif_ut int(10) UNSIGNED PRIMARY KEY,
  nome_ut varchar(50) NOT NULL,
  cogn_ut varchar(50) NOT NULL,
  ind_ut varchar(50) NOT NULL,
  tel_ut int(10) UNIQUE,
  mail_ut varchar(50) UNIQUE
);


CREATE TABLE provenienze_caseed (
  donaz char(20) NOT NULL,
  cittaeditore varchar(50) NOT NULL,
  viaeditore varchar(150) NOT NULL,
  civicoeditore int(10) NOT NULL,
  
  PRIMARY KEY(donaz, cittaeditore, viaeditore, civicoeditore),

  FOREIGN KEY(donaz) REFERENCES donazioni(pi_),
  FOREIGN KEY(cittaeditore, viaeditore, civicoeditore) REFERENCES case_editrici(citta, via, civico)
  
  ON UPDATE CASCADE ON DELETE CASCADE
);




CREATE TABLE provenienze_istituzioni (
  donaz char(20) NOT NULL,
  cittaistituzione varchar(50) NOT NULL,
  viaistituzione varchar(150) NOT NULL,
  civicoistituzione int(10) NOT NULL,
  
  PRIMARY KEY(donaz, cittaistituzione, viaistituzione, civicoistituzione),
  
  FOREIGN KEY(donaz) REFERENCES donazioni(pi_),
  FOREIGN KEY(cittaistituzione, viaistituzione, civicoistituzione) REFERENCES istituzioni(citta, via, civico)
  
  ON UPDATE CASCADE ON DELETE CASCADE
);


CREATE TABLE provenienze_individui (
  donaz char(20) NOT NULL,
  cittaindividuo varchar(50) NOT NULL,
  viaindividuo varchar(150) NOT NULL,
  civicoindividuo int(10) NOT NULL,
  
  PRIMARY KEY(donaz, cittaindividuo, viaindividuo, civicoindividuo),
  
  FOREIGN KEY(donaz) REFERENCES donazioni(pi_),
  FOREIGN KEY(cittaindividuo, viaindividuo, civicoindividuo) REFERENCES individui(citta, via, civico)
  
  ON UPDATE CASCADE ON DELETE CASCADE
);





/* ***********************POPOLAMENTO *************************/

INSERT INTO autori (`cod_au`, `nome_au`, `cogn_au`, `paese_au`, `nascita_au`, `morte_au`, `bio`) VALUES
('ajvj362x32', 'Marco', 'Rossi', 'Firenze', 1940, 1999, 'Diventa professore a soli 22 anni'),
('akht734bow', 'Gianmarco', 'Silvestri', 'Roma', 1991, NULL, 'Nato e cresciuto a Roma, intraprende da subito la carriera di fumettista e successivamente decide di dedicarsi alla scrittura.'),
('akht734ghy', 'Alessandro', 'Maiello', 'Aosta', 1987, 2009, 'Nato e cresciuto in Valle d\' Aosta, intraprende da subito la carriera di scrittore.'),
('byev572\'bhr', 'Riccardo', 'Palumbo', 'Benevento', 1933, 2003, 'Nato e cresciuto in Campania, intraprende da subito la carriera di professore unversitario e successivamente decide di dedicarsi alla scrittura.'),
('ediv926hpb', 'Paolo', 'Verdi', 'Roma', 1956, NULL, 'Nato e cresciuto a Roma, intraprende da subito la carriera di musicista e successivamente decide di dedicarsi alla scrittura.'),
('fhve365hnd', 'Annamaria', 'Lodato', 'Teramo', 1923, 1990, 'Nata e cresciuta in Abruzzo, intraprende da subito la carriera di imprenditrice e successivamente decide di dedicarsi alla scrittura.'),
('hdri842knh', 'Agnese', 'Bartolini', 'Napoli', 1978, 2006, 'Di origini e spirito partenopeo, intraprende da subito la carriera di scrittrice.'),
('qovs451mbr', 'Antonio', 'Bianchi', 'Torino', 1987, NULL, 'Nato a Torino ma cresciuto a Roma, intraprende da subito la carriera di musicista e successivamente decide di dedicarsi alla scrittura.'),
('rlsu935ghf', 'Pasquale', 'Rea', 'Benevento', 1981, NULL, 'Nato e cresciuto a Benevento, intraprende da subito la carriera di fotografo e successivamente decide di dedicarsi alla scrittura.'),
('ryot734bow', 'Giacomo', 'Petrucci', 'Milano', 1923, 1977, 'Nato e cresciuto a Milano, intraprende da subito la carriera di regista per poi dedicarsi alla scrittura'),
('sxte855knf', 'Marco', 'Alberti', 'Siracusa', 1973, NULL, 'Nato e cresciuto a Siracusa, intraprende da subito la carriera di disegnatore e successivamente decide di dedicarsi alla scrittura.');


INSERT INTO case_editrici (`cod_edit`, `nome_edit`, `nome_ref`, `cogn_ref`, `mail_edit`, `tel_edit`, `citta`, `via`, `civico`) VALUES
('ALMTH85201LKFFT', 'Garzanti', 'Matteo', 'Orlandi', 'garzanti2@gmail.com', 3478567649, 'Bari', 'Viale degli Atlantici', 303),
('WNTLF03214LKGTN', 'Garzanti', 'Matteo', 'Gizi', 'gizi@gmail.com', 3765986790, 'Benevento', 'viale Atlantici', 33),
('UTNSL42670CJSYV', 'Rizzoli', 'Stefano', 'Bianchi', 'rizzoli@gmail.com', 3475208065, 'Bologna', 'Via della Resurrezione', 203),
('AKTNF52419KTHDT', 'laFeltrinelli', 'Anna', 'Palmieri', 'lafeltrinelli@gmail.com', 3885209106, 'Milano', 'Via Corso Garibaldi', 105),
('LKDNR89745ALKTN', 'Hoepli', 'Marica', 'Spagnuolo', 'hoepli@mail.com', 3285234234, 'Napoli', 'Via del porto', 22),
('CFHTL41036LDTMG', 'Fabbri Editori', 'Giulia', 'Borrelli', 'fabbrieditori@gmail.com', 3285234987, 'Napoli', 'Via Toledo', 170),
('SKVUR42685VUEHS', 'Mondadori', 'Mario', 'Rossi', 'mondadori@gmail.com', 3294528520, 'Roma', 'Via Cavour\'', 65),
('LDHYL85206ARTOL', 'Mondadori', 'Antonio', 'Lombardi', 'antlombardi@gmail.com', 3294823520, 'Roma', 'Via Mazzini', 63),
('PSYTM03549KTHAM', 'laFeltrinelli', 'Antonio', 'Russo', 'feltinellitorino@gmail.com', 3885203765, 'Torino', 'Via Corso Garibaldi', 81),
('LBTMH41025LOTRN', 'Rizzoli', 'Gabriele', 'Rinaldi', 'rinaldi@gmail.com', 3752678065, 'Torino', 'Via della luna ', 35);


INSERT INTO donazioni (`cpa_int`, `annoDono`, `motivo`, `pi_`) VALUES
(125452145, 2009, 'Ampliamento della mole di libri', 'ALHSGS8205GKSBF41605'),
(1359752097, 2006, 'Far conoscere il libro in questione', 'ALKTM45963MHTLS78025'),
(1410852042, 2017, 'Lasciare un ricordo nella mente di chi lo legge', 'DXSHJS9202AJCHY82033'),
(1943618679, 2010, 'Promuovere il libro in questione', 'ALKTM45963sjfjsuetop'),
(2956132587, 2020, 'Promuovere il libro in questione', '5s8t6ccuioshjk8456we'),
(3014565896, 2011, 'Ampliamento della mole di libri', 'NXTGN78950LKTSM85201'),
(3410852014, 2010, 'Lasciare un ricordo nella mente di chi lo legge', 'DNTPG45297LFTWB78920'),
(3521075204, 2007, 'Far conoscere il libro in questione', 'ALTBH74108LJTDB96301'),
(3620174528, 2020, 'Aggiornamento della biblioteca', 'ALMCG78945LKJDT85201'),
(3632074520, 2019, 'Far conoscere il libro in questione', 'ENITHF5205AKFHS74101'),
(1254527894, 2009, 'Ampliamento della mole di libri', 'ALHSGS8205UFNFI41605'),
(1359728509, 2006, 'Far conoscere il libro in questione', 'ALKTM45963MHTLS88932'),
(3620136784, 2020, 'Aggiornamento della biblioteca', 'ALMCG78945LKJDT09436'),
(3014587465, 2011, 'Ampliamento della mole di libri', 'NXTGN78950LKTSM98126'),
(3014589045, 2011, 'Aumento del numero di libri', 'NXTGN78950LKTSM94556'),
(3014582876, 2011, 'Aumento del numero di libri', 'NXTGN78950LKTSM78745')
;



INSERT INTO finanziamenti (`ptc_fin`, `concess_fin`, `acquisiz_fin`, `somma_fin`, `motivo_fin`, `citta_ist`, `via_ist`, `civico_ist`) VALUES
(2874214512, '2005-07-12', '2005-07-15', 720, 'Aggiornamento della biblioteca', 'Milano', 'Via Campanile', 23),
(1202342593, '2020-03-01', '2020-04-01', 305, 'Ampliamento della biblioteca' ,  'Padova', 'Piazza della Vittoria', 43),
(1206829036, '2020-03-01', '2020-07-03', 982, 'Rilancio della biblioteca' , 'Pisa', 'Via Spagna', 23),
(1206842593, '2020-03-01', '2020-04-01', 100, 'Ampliamento della biblioteca', 'Roma', 'via Cesare', 15),
(1563002890, '2018-06-07', '2018-06-12', 925, 'Donazione per acquisto di nuovi testi' , 'Roma', 'Via Crasso', 18),
(1563005520, '2018-06-07', '2006-01-02', 925, 'Donazione per acquisto di nuovi testi' , 'Roma', 'via Giulia', 16),
(1863148752, '2009-12-12', '2009-12-17', 582, 'Miglioramento servizi della biblioteca' , 'Roma', 'Via Pompeo', 32),
(1866348752, '2009-12-12', '2009-12-17', 582, 'Miglioramento servizi della biblioteca' , 'Roma', 'via Sempronio', 3),
(2874156878, '2017-12-10', '2018-01-01', 208, 'Acquisto materiale per la biblioteca' , 'Torino', 'San Bartolomeo', 12),
(3146251238, '2007-08-08', '2007-08-10', 320, 'Acquisto accessori per la biblioteca' , 'Torino', 'Via Grande', 29),
/*rimossa una linea*/
(3146251278, '2007-08-08', '2007-08-10', 320, 'Acquisto accessori per la biblioteca'),
(3539520410, '2009-03-15', '2009-03-15', 405, 'Miglioramento qualitĂ  della biblioteca'),
(3874156427, '2006-06-23', '2006-06-29', 320, 'Acquisto materiale per la biblioteca');






INSERT INTO individui (`codFisc_idv`, `nome_idv`, `cognome_idv`, `citta`, `via`, `civico`, `tel_idv`) VALUES
('ajk989djko967dhi', 'Raffaella', 'Conte', 'San Giorgio del Sannio', 'Corso Vivaldi', 17, 3405697158),
('skju489gjk982h65', 'Laura', 'Guadagno', 'San Leucio del Sannio', 'Sant\'Angelo a Cupolo', 16, 3206541587),
('cjudkj387ckj98d6', 'Antonio', 'Formisano', 'Ceppaloni', 'Via Attila', 32, 3331451446),
('sasjk987adjka289', 'Maria', 'Impavido', 'San Leucio del Sannio', 'Via Cavour', 65, 3479520654),
('skj87fko367sdkj9', 'Luca', 'Durante', 'San Nicola Manfredi', 'Via Collina', 110, 3291582647),
('kjhui389jko8r78f', 'Luca', 'Caporaso', 'Benevento', 'Via del Tratturo', 12, 3405874552),
('kjhui389jko8r78f', 'Luca', 'Caporaso', 'Benevento', 'Via del Tratturo', 13, 3405874552),
('skjdui3874hck837', 'Giovanna', 'Prete', 'Cusano Mutri', 'Via della Resurrezione', 203, 3478265498),
('ajski4876sjk98dh', 'Fabrizio', 'Cusano', 'Ceppaloni', 'Via martiri della resistenza', 12, 3381261240),
('sjudj284jsh783k9', 'Mario', 'Rossi', 'Cusano Mutri', 'Via Principe', 17, 3205264987),
('asdiuvk387vl90j8', 'Giuseppe', 'Sanzari', 'Sant\'Angelo a Cupolo', 'Viale Antico', 21, 3294585321);



INSERT INTO istituzioni (`nome_ist`, `rappr_ist`, `pec_ist`, `citta`, `via`, `civico` ) VALUES
('Istituzione cultura classica', 'Marco Antonelli', 'marcoant@postecert.it', 'Milano', 'Via Campanile', 23),
('Istituzione cultura e lettura ', 'Antonio Socci', 'socciant@postecert.it', 'Padova', 'Piazza della Vittoria', 43),
('Istituzione cultura italiana', 'Antonio Greco', 'agreco@postecert.it', 'Pisa', 'Via Spagna', 23),
('La Camera', 'Giovanni Bosco', 'lacamera@postecert.it', 'Roma', 'via Cesare', 15),
('Il Senato', 'Antonio Verdi', 'ilsenato@postecert.it', 'Roma', 'Via Crasso', 18),
('Ministero Istruzione', 'Anna Di Carlo', 'iministri@postecert.it', 'Roma', 'via Giulia', 16),
('La Presidenza della Repubblica', 'Marco Rossi', 'larepubblica@postecert.it', 'Roma', 'Via Pompeo', 32),
('Il Governo', 'Pasquale Ricci', 'ilgoverno@postecert.it', 'Roma', 'via Sempronio', 3),
('Istituzione promozione cultura ', 'Carlo Giannini', 'giannini@postecert.it', 'Torino', 'San Bartolomeo', 12),
('Istituzione cultura romana', 'Massimo Verdi', 'maxverdi@postecert.it', 'Torino', 'Via Grande', 29);



INSERT INTO libri (`isbn`, `tipoLib`, `titolo`, `editore`, `edizione`, `donazione`) VALUES
('0249015812005', 'avventura', 'Moby Dick', 'Fabbri Editori', 1993 ,'5s8t6ccuioshjk8456we' ),
('1486204862145', 'giallo', 'I cerchi nell\'acqua', 'laFeltrinelli', 1999 , 'ALHSGS8205GKSBF41605'),
('1953764829548', 'fantasy', 'Il signore degli Anelli- La compagnia dell\'anello', 'Garzanti', 2009, 'ALHSGS8205UFNFI41605'),
('2464789630488', 'fantasy', 'Harry potter e la pietra filosofale', 'Mondadori', 2002 , 'ALKTM45963MHTLS78025'),
('2648584201985', 'romanzo storico', 'Nebbia', 'Fabbri Editori', 1989 ,'ALKTM45963MHTLS88932' ),
('2793619462966', 'biografia', 'Steve Jobs, lezioni di leadership', 'Mondadori', 2004 , 'ALKTM45963sjfjsuetop'),
('2876789633857', 'fantasy', 'Harry potter e la camera dei segreti', 'Mondadori', 2003 , 'ALMCG78945LKJDT09436'),
('4839365825683', 'giallo', 'Assasinio sull\'Orient Express', 'Rizzoli', 2010 ,'ALMCG78945LKJDT85201' ),
('6800548610046', 'thriller', 'La casa delle voci', 'Mondadori', 1997 , 'ALTBH74108LJTDB96301' ),
('9841398520896', 'biografia', 'Woody Allen, A proposito di niente', 'laFeltrinelli', 2003 , 'DNTPG45297LFTWB78920' );




/*ATTENZIONE  un valore inserito è 1 out of range*/


INSERT INTO prestiti (`numProg`, `richiesta`, `noleggio`, `scadenza`, `riconsegna`, `libro`, `utente`) VALUES
(156364525, '2017-09-03', '2017-09-03', '2017-10-03', '2017-10-10' , '0249015812005', 124214541),
(257521455, '2020-07-20', '2020-07-21', '2020-07-31', NULL, '1486204862145', 369874110),
(612457889, '2008-07-10', '2008-07-12', '2008-07-19', '2008-07-13', '1953764829548' , 512048052),
(1258963248, '2014-07-01', '2014-07-09', '2014-07-19', '2014-07-20', '2464789630488', 652074108),
(1265566652, '2009-04-07', '2009-04-10', '2009-04-20', '2009-04-30', '2648584201985' , 1268524565),
(1528514455, '2019-12-31', '2019-01-03', '2019-01-13', NULL, '2793619462966' , 1489646525),
(1583649725, '2010-08-12', '2010-08-21', '2010-08-27', '2010-08-25', '2876789633857' , 1698205643),
(2652085205, '2019-12-28', '2019-01-03', '2019-01-03', '2019-01-10', '4839365825683' , 2110962025),
(3410256335, '2020-07-17', '2020-07-31', '2020-08-10', '2020-08-20', '6800548610046' , 2289413675),
(3555255965, '2010-06-11', '2010-06-21', '0000-00-00', '2010-06-22', '9841398520896' , 2410962025);



INSERT INTO utenti (`cif_ut`, `nome_ut`, `cogn_ut`, `ind_ut`, `tel_ut`, `mail_ut`) VALUES
(124214541, 'Maria', 'Rossi', 'Piazza Garibaldi 12, Sant\'Angelo a Cupolo', 347058962, 'mariarossi@libero.it'),
(369874110, 'Angela', 'Franco', 'Corso Como 32, Sant\' Angelo a Cupolo', 388145352, 'angelafranco@gmail.com'),
(512048052, 'Giulia', 'Verdi', 'Viale Mellusi 32, Benevento', 329852061, 'giuliaverdi@hotmail.it'),
(652074108, 'Carlo', 'Rondinella', 'Viale Antico 32, Ceppaloni', 320562895, 'carlorondinella@libero.it'),
(1268524565, 'Giulio', 'Socci', 'Via Andrea Costa 23, Cusano Mutri', 349750158, 'giuliosocci@gmail.com'),
(1489646525, 'Stefano', 'Sorega', 'Piazza liberty 23, Cusano Mutri', 328506925, 'stefanosorega@hotmail.it'),
(1698205643, 'Rodolfo', 'Grandi', 'Via dei Longobardi 23, Benevento, ', 329556247, 'rodolfograndi@yahoo.it'),
(2110962025, 'Paolo', 'Rea', 'Via borgo casale 63, Ceppaloni', 329856987, 'paolorea@hotmail.com'),
(2289413675, 'Carlo', 'Rolandi', 'Via delle Puglie 33, Benevento,', 333426907, 'carlorolandi@hotmail.it'),
(2410962025, 'Luisa', 'Conte', 'Via Cupiello 21,  ', 328452147, 'luisaconte@gmail.com');



INSERT INTO provenienze_caseed (donaz, cittaeditore, viaeditore, civicoeditore) VALUES
('ALHSGS8205GKSBF41605' , 'Bari', 'Viale degli Atlantici', 303),
('ALKTM45963MHTLS78025',  'Benevento', 'viale Atlantici', 33),
('DXSHJS9202AJCHY82033' , 'Bologna', 'Via della Resurrezione', 203),
('ALKTM45963sjfjsuetop' , 'Milano', 'Via Corso Garibaldi', 105),
('5s8t6ccuioshjk8456we' , 'Napoli', 'Via del porto', 22);

INSERT INTO provenienze_individui (donaz, cittaindividuo, viaindividuo, civicoindividuo) VALUES
('NXTGN78950LKTSM85201', 'San Giorgio del Sannio', 'Corso Vivaldi', 17),
('DNTPG45297LFTWB78920', 'Ceppaloni', 'Via Attila', 32),
('ALTBH74108LJTDB96301', 'San Leucio del Sannio', 'Via Cavour', 65),
('ALMCG78945LKJDT85201', 'San Nicola Manfredi', 'Via Collina', 110),
('ENITHF5205AKFHS74101', 'Benevento', 'Via del Tratturo', 12);


INSERT INTO provenienze_istituzioni (donaz, cittaistituzione, viaistituzione, civicoistituzione) VALUES
('ALHSGS8205UFNFI41605', 'Milano', 'Via Campanile', 23),
('ALKTM45963MHTLS88932', 'Padova', 'Piazza della Vittoria', 43),
('ALMCG78945LKJDT09436', 'Pisa', 'Via Spagna', 23),
('NXTGN78950LKTSM98126', 'Roma', 'via Cesare', 15),
('NXTGN78950LKTSM94556', 'Roma', 'Via Crasso', 18),
('NXTGN78950LKTSM78745', 'Roma', 'via Giulia', 16);






INSERT INTO scritture (`libro`, `autore`) VALUES
('0249015812005', 'ajvj362x32'),
('1486204862145', 'akht734bow'),
('1953764829548', 'akht734ghy'),
('2464789630488', 'byev572\'bhr'),
('2648584201985', 'ediv926hpb'),
('2793619462966', 'fhve365hnd'),
('2876789633857', 'hdri842knh'),
('4839365825683', 'qovs451mbr'),
('6800548610046', 'rlsu935ghf'),
('9841398520896', 'ryot734bow');




INSERT INTO collocazioni (libro, posiz1, posiz2) VALUES
('0249015812005', 24, 12),
('1486204862145', 12, 87),
('1953764829548', 12, 65),
('2464789630488', 2, 7),
('2648584201985', 7, 3),
('2793619462966', 15, 78),
('2876789633857', 23, 89),
('4839365825683', 45, 54),
('6800548610046', 90, 11),
('9841398520896', 3, 32);



INSERT INTO provenienze_caseed (donaz, cittaeditore, viaeditore, civicoeditore) VALUES
('ALHSGS8205GKSBF41605' , 'Bari', 'Viale degli Atlantici', 303),
('ALKTM45963MHTLS78025',  'Benevento', 'viale Atlantici', 33),
('DXSHJS9202AJCHY82033' , 'Bologna', 'Via della Resurrezione', 203),
('ALKTM45963sjfjsuetop' , 'Milano', 'Via Corso Garibaldi', 105),
('5s8t6ccuioshjk8456we' , 'Napoli', 'Via del porto', 22);

INSERT INTO provenienze_individui (donaz, cittaindividuo, viaindividuo, civicoindividuo) VALUES
('NXTGN78950LKTSM85201', 'San Giorgio del Sannio', 'Corso Vivaldi', 17),
('DNTPG45297LFTWB78920', 'Ceppaloni', 'Via Attila', 32),
('ALTBH74108LJTDB96301', 'San Leucio del Sannio', 'Via Cavour', 65),
('ALMCG78945LKJDT85201', 'San Nicola Manfredi', 'Via Collina', 110),
('ENITHF5205AKFHS74101', 'Benevento', 'Via del Tratturo', 12);


INSERT INTO provenienze_istituzioni (donaz, cittaistituzione, viaistituzione, civicoistituzione) VALUES
('ALHSGS8205UFNFI41605', 'Milano', 'Via Campanile', 23),
('ALKTM45963MHTLS88932', 'Padova', 'Piazza della Vittoria', 43),
('ALMCG78945LKJDT09436', 'Pisa', 'Via Spagna', 23),
('NXTGN78950LKTSM98126', 'Roma', 'via Cesare', 15),
('NXTGN78950LKTSM94556', 'Roma', 'Via Crasso', 18),
('NXTGN78950LKTSM78745', 'Roma', 'via Giulia', 16);



/* ************QUERIES************************ */

/* 1)	Mostrare tutti gli attributi dei libri di genere fantasy presenti nella biblioteca ad esclusione dell’ isbn. */

SELECT libri.tipoLib, libri.titolo, libri.edizione
FROM bib3.libri
WHERE libri.tipoLib = 'fantasy';

/* 2)	Mostrare tutti gli autori di Libri residenti a Benevento ordinandoli dal più giovane */

SELECT *
FROM bib3.autori
WHERE autori.paese_au = 'Benevento'
ORDER BY nascita_au DESC;

/* 3)	Mostrare tutte le informazioni sui libri della biblioteca che si trovano, per ogni scaffale, nella prima metà dello scaffale (quindi dalla posizione 1 alla posizione 50) e ordinarli in base allo scaffale */

SELECT collocazioni.libro, collocazioni.posiz1, collocazioni.posiz2
FROM bib3.collocazioni
WHERE posiz2 BETWEEN 1 and 50
ORDER BY collocazioni.posiz1;

/* 4)	Mostrare tutte le informazioni associate ai libri utilizzando il criterio di filtraggio della query precedente */

SELECT collocazioni.libro, collocazioni.posiz2, libri.tipoLib, libri.titolo, libri.editore, libri.edizione
FROM bib3.collocazioni
INNER JOIN libri ON collocazioni.libro = libri.isbn
WHERE collocazioni.posiz2 BETWEEN 1 and 50
ORDER BY collocazioni.posiz1;



/* 5)	Mostrare le motivazioni e gli anni di donazione di tutte le donazioni effettuate dal 2006 al 2008 */

SELECT annoDono, motivo 
FROM donazioni
WHERE donazioni.annoDono BETWEEN 2006 and 2008;


/* 6)	Mostrare tutte le donazioni effettuate dopo il 2006 da case editrici */


SELECT donazioni.*, provenienze_caseed.* 
FROM donazioni 
INNER JOIN provenienze_caseed ON provenienze_caseed.donaz = donazioni.pi_ 
WHERE donazioni.annoDono > '2006';



/* 7)	Mostrare tutte le donazioni effettuate prima del 2020 da Individui OK */

SELECT don.*, provenienze_individui.*
FROM donazioni as don
INNER JOIN provenienze_individui ON provenienze_individui.donaz = don.pi_ 
WHERE don.annoDono < '2020';



/* 8)	Mostrare tutti i libri ottenuti da donazioni effettuate nel 2006, 2009 e 2020 da Individui */

SELECT utenti.nome_ut, utenti.cogn_ut, donazioni.annoDono, provenienze_istituzioni.*
FROM prestiti
INNER JOIN utenti ON utenti.cif_ut = prestiti.utente
INNER JOIN libri ON libri.isbn = prestiti.libro
INNER JOIN donazioni ON donazioni.pi_ = libri.donazione
INNER JOIN provenienze_istituzioni ON provenienze_istituzioni.donaz = donazioni.pi_


WHERE donazioni.annoDono = '2006'
OR (donazioni.annoDono = '2009')
OR (donazioni.annoDono = '2020');


/* 9)	Ripetere la query precedente mostrano anche il nome delle istituzioni coinvolte */

SELECT utenti.nome_ut, utenti.cogn_ut, istituzioni.nome_ist, donazioni.annoDono, provenienze_istituzioni.*
FROM prestiti
INNER JOIN utenti ON utenti.cif_ut = prestiti.utente
INNER JOIN libri ON libri.isbn = prestiti.libro
INNER JOIN donazioni ON donazioni.pi_ = libri.donazione
INNER JOIN provenienze_istituzioni ON provenienze_istituzioni.donaz = donazioni.pi_

INNER JOIN istituzioni ON istituzioni.citta =  provenienze_istituzioni.cittaistituzione
AND istituzioni.via =  provenienze_istituzioni.viaistituzione
AND istituzioni.civico =  provenienze_istituzioni.civicoistituzione


WHERE donazioni.annoDono = '2006'
OR (donazioni.annoDono = '2009')
OR (donazioni.annoDono = '2020')
;


/* 10)	Mostrare in ordine alfabetico tutti gli utenti che hanno richiesto un libro dal 14 febbraio 2016 al 27 settembre 2019 */


SELECT u.cogn_ut , u.nome_ut , p.*
FROM utenti as u
INNER JOIN prestiti p ON p.utente = u.cif_ut
WHERE p.noleggio > "2006-02-14" AND p.noleggio < "2019-09-27"
GROUP by u.cif_ut
ORDER BY u.cogn_ut, u.nome_ut;



/* 11)	Mostrare Tutti gli utenti che hanno restituito un libro che ad oggi si trova in uno scaffale tra il  3 e 10 o tra il 23 e il 99 */


SELECT ut.nome_ut, ut.cogn_ut, lib.titolo, coll.*
FROM prestiti as pre

INNER JOIN utenti ut ON ut.cif_ut = pre.utente
INNER JOIN libri lib ON lib.isbn = pre.libro
INNER JOIN collocazioni coll ON coll.libro = lib.isbn

WHERE coll.posiz1 > 3 
AND coll.posiz1 <10
OR  coll.posiz1 >23 
AND coll.posiz1 < 99

ORDER BY coll.posiz1;


/* 12)Ordinare le istituzioni da quelle che hanno donato somme maggiori a quelle che hanno effettuato somme minori e calcolare il valore medio di tutti i finanziamenti che la bibilioteca ha ricevuto, stampare questo valore inoltre in una colonna appositamente creata */ 

SELECT istituzioni.nome_ist, finanziamenti.ptc_fin, finanziamenti.somma_fin,( 
SELECT avg (somma_fin)
FROM finanziamenti)
AS media


FROM finanziamenti

INNER JOIN istituzioni ON istituzioni.citta = finanziamenti.citta_ist
AND istituzioni.via = finanziamenti.via_ist
AND istituzioni.civico = finanziamenti.civico_ist


ORDER BY finanziamenti.somma_fin
;


/* 13)	Mostrare tutti gli utenti che tra il 2006 e il 2019 hanno ricevuto in concessione libri donati da Case Editrici tra il 2007 e il 2020, mostrare anche il nome delle case editrici coinvolte */

SELECT utenti.nome_ut, utenti.cogn_ut, prestiti.noleggio, case_editrici.nome_edit, donazioni.annoDono
FROM prestiti
INNER JOIN utenti ON utenti.cif_ut = prestiti.utente
INNER JOIN libri ON libri.isbn = prestiti.libro
INNER JOIN donazioni ON donazioni.pi_ = libri.donazione
INNER JOIN provenienze_caseed ON provenienze_caseed.donaz = donazioni.pi_

INNER JOIN case_editrici ON case_editrici.citta =  provenienze_caseed.cittaeditore
AND case_editrici.via =  provenienze_caseed.viaeditore
AND case_editrici.civico =  provenienze_caseed.civicoeditore

WHERE prestiti.noleggio > '2016-01-01'
AND prestiti.noleggio < '2020-12-31'
AND donazioni.annoDono > '2007'
AND donazioni.annoDono < '2020'
;

/* 14)	Mostrare tutti gli utenti che hanno restituito un libro donato da Case Editrici rispettando la scadenza e riconsegnandolo dopo meno di 21 giorni 
(Utilizzo della funzione datediff() ) */



SELECT utenti.nome_ut, utenti.cogn_ut, prestiti.*
FROM prestiti
INNER JOIN utenti ON utenti.cif_ut = prestiti.utente
INNER JOIN libri ON libri.isbn = prestiti.libro
INNER JOIN donazioni ON donazioni.pi_ = libri.donazione
INNER JOIN provenienze_caseed ON provenienze_caseed.donaz = donazioni.pi_

WHERE prestiti.riconsegna IS NOT NULL
AND prestiti.scadenza < prestiti.riconsegna
AND datediff(prestiti.riconsegna, prestiti.scadenza) <20
;




/* 15)Mostrare una nuova colonna che mostrerà una classifica degli utenti della biblioteca che hanno restituito libri nel minor tempo possibile (escludendo gli utenti che non hanno affatto restituito libri) stampare anche i titoli dei libri coinvolti nella riconsegna  */ 

SELECT p.numProg, p.noleggio, p.riconsegna, p.libro, l.titolo, (datediff(p.riconsegna, p.noleggio)) as giorni 

FROM prestiti as p

INNER JOIN libri AS l ON l.isbn = p.libro
WHERE (p.riconsegna IS NOT NULL)

ORDER BY giorni
;
