## Aulas PPE 1° Semestre de 2024

No código da função **Aula_PPE_04b.dyn** não foi utilizada a Massa Inplace como prédio. Nesta função, para formar o predio é criado o volume a partir da linha do limite do lote escalada com o fator correspondente à
Taxa de ocupação do terreno (linhas 48. a 54.). Os limites são utilizados para criar uma Surface (linha 51.) que será escalada (linha 52) e finalmente extrudada (linha 54.).
Outro ponto de destaque para analisar da função são as linhas 21 e 25. A declaração da linha 21. permite processar um lote de cada vez, mas com uma pequena alteração, incorporada na linha 25., o processamento pode ser realizado
en todos os lotes, já que a variável LOTE conterá uma lista numérica iniciada em 0 e finalizada com o valor da quantidade de lotes-1.

![Aula_PPE_05_2024-04-19_05-51-36](https://github.com/JLMenegotto/AulasBIM/assets/9437020/fb49122a-3596-4410-bf8e-f1000241c0c6)

### Code Block da função Aula_PPE_05.dyn: 

        1.  divisas;
        2.  n;
        3.  DAF;
        4.  TOC;
        5.  COA;
        6.  AAN;
        7.  //---------------------------------------------
        8.  // Constantes
        9.  //---------------------------------------------
       10.  Vx   = Vector.XAxis();
       11.  Vy   = Vector.YAxis();
       12.  Vz   = Vector.ZAxis();
       13.  Vf   = Vector.ByCoordinates(FTO, 0 , 0);
       14.  ATC  = COA * ALOT;
       15.  ALT  = COA * AAN;
       16.  FTO  = Math.Sqrt(TOC);
       17.  Qdiv = List.Count(divisas);
       18.  //---------------------------------------------
       19.  // Para processar um lote de cada vez
       20.  //---------------------------------------------
       21.  //LOTE = divisas[n % Qdiv];
       22.  //---------------------------------------------
       23.  // Para processar todos os lotes
       24.  //---------------------------------------------
       25.  LOTE = divisas[0..Qdiv-1];
       26.  //---------------------------------------------
       27.  // Processamento
       28.  //---------------------------------------------
       29.  LGEO = LOTE.Geometry (   );
       30.  DIVI = PolyCurve.ByJoinedCurves ( LGEO , 0 );
       31.  ALOT = LOTE.GetParameterValueByName("Area");
       32.  //---------------------------------------------
       33.  // Captura Linhas da divisa e faz offset
       34.  //---------------------------------------------
       35.  OCUP = DIVI.Offset  (-DAF , false );
       36.  LIMI = DIVI.Explode (             );
       37.  AREO = ALOT * TOC;
       38.  LADO = Math.Sqrt    ( AREO        );
       39.  //---------------------------------------------
       40.  // Pontos extremos dos limites da divisa
       41.  // e Eixo Médio do lote
       42.  //---------------------------------------------
       43.  PLIMI = LIMI.PointAtParameter ( 0 );
       44.  EIXOM = Line.ByBestFitThroughPoints ( PLIMI );
       45.  //---------------------------------------------
       46.  // Dimensiona Volume pela taxa de ocupação
       47.  //---------------------------------------------
       48.  BASE = EIXOM.PointAtParameter ( 0.5  );
       49.  Po1  = BASE.Add ( Vx );
       50.  Po2  = BASE.Add ( Vf );
       51.  SULO = Autodesk.Surface.ByPatch ( DIVI );
       52.  EDSU = SULO.Scale  (BASE, Po1, Po2 );
       53.  ARED = EDSU.Area;
       54.  EDVO = EDSU.Thicken( -ALT , 0);
       55.  //---------------------------------------------
       56.  //Extração de resultados utilizando Dicionário
       57.  //---------------------------------------------
       58.  Key = ["Divisa", "Area"  ,"Limites" ,"CoefApr",
       59.         "AreaO" , "Lado"  ,"EixoM"   ,"AlAndar",
       60.         "EdVolu", "EdPeri", "TipoLJ"
       61.       ];
       62.  Val = [ DIVI   , ALOT   , LIMI     , COA ,
       63.          AREO   , LADO   , EIXOM    , AAN ,
       64.          EDVO   , EDSU   , TIP
       65.        ];
       66. DIC = Dictionary.ByKeysValues ( Key , Val );

O seguinte código inicia a função com a recepção e extração dos dados do diccionário preparado no código anterior (linhas 1 a 6). 
Além de diminuir a quantidade de ligações entre os code blocks envolvidos, os dados começam a ganhar significados semânticos 
A função cria os andares nomeando-os linhas 17 a 19. A condicional seguinte **NOM = NUM==0 ? TER : NUM==NUM[-1]? COB : NUM+AND;** faz 
a discriminação dod andares térreo e cobertura.
A linha 24 extrai as elevações de todos os andares, **ALA = LEV[a].Elevation;** preparando os dados para criação das lajes.
A linha 25 extrai a curva que será passada à função **Translate** que copia o perímetro para todos os andares (linhas 25 e 26 ). 
Finalmente, a linha 27 cria as lajes construtivas concretas.

**Importante: Para executar com a linha 27 a função deve ser rodada em modo Manual.** 

### Code Block complementar: Usar em modo Manual para incorporar os Andares: 
        1. Dados;
        2. COA = Dados["CoefApr"];
        3. AAN = Dados["AlAndar"];
        4. VOL = Dados["EdVolu"];
        5. LIM = Dados["EdPeri"];
        6. TIP = Dados["TipoLJ"];
        7. //------------------------------------------------
        8. // Constantes
        9. //------------------------------------------------
       10. COB = "Cobertura";
       11. TER = "Térreo";
       12. AND = "° Pavto";
       13. Vz  = Vector.ZAxis();
       14. //------------------------------------------------
       15. // Define os Andares
       16. //------------------------------------------------
       17. NUM = Math.Floor( 0..COA );
       18. NOM = NUM==0 ? TER : NUM==NUM[-1]? COB : NUM+AND;
       19. LEV = Level.ByElevationAndName ( NUM*AAN , NOM);
       20. //------------------------------------------------
       21. // Coloca poligonais abstratas das Lajes
       22. //------------------------------------------------
       23. a   = 0..COA;
       24. ALA = LEV[a].Elevation;
       25. PER = LIM.PerimeterCurves (            );
       26. PCJ = PER.Translate       ( Vz, ALA<1> );
       27. LAJ = Revit.Floor.ByOutlineTypeAndLevel(PCJ, TIP, LEV);

![PPE_Aula06b_2024-04-20_11-24-03](https://github.com/JLMenegotto/AulasBIM/assets/9437020/9a24509e-5440-447f-ba22-656b429ddeb0)

A função apresenta a treliça no plano XZ, caso prefira trabalhar no plano XY deve ser alterada a declaração da linha 20. 
de **PTS = PTI.Translate ( 0 , 0 , altu);** para **PTS = PTI.Translate ( 0 , altu, 0 );**

### Code Block da função Aula_PPE_06b.dyn: 
        1. vao;
        2. qmo;
        3. ang;
        4. sep;
        5. ina;
        6. tre;
        7. //-----------------------------------------------------
        8. vx   = vao/2;
        9. mx   = vao/qmo;
        10. //-----------------------------------------------------
        11. x    = -vx..vx..#qmo+1;
        12. inc  = Math.Tan( ang );
        13. amax = sep + (vx * inc);
        14. alp  = ina== 0 ?  x * inc : x * -inc;
        15. altu = x  <  0 ? amax+alp : amax-alp;
        16. //-----------------------------------------------------
        17. // Pontos do Banzo inferior e superior
        18. //-----------------------------------------------------
        19. PTI  = Point.ByCoordinates( x , 0 , 0   );
        20. PTS  = PTI.Translate      ( 0 , 0 , altu);
        21. //-----------------------------------------------------
        22. // Indices completo ic e as duas metades i1 e 12
        23. //-----------------------------------------------------
        24. ic   = 0     .. qmo   -1;
        25. i1   = 0     .. qmo/2 -1;
        26. i2   = qmo/2 .. qmo   -1;
        27. //-----------------------------------------------------
        28. // Os indices j e k são invertidos caso o sistema seja
        29. // Pratt ou Howe
        30. //-----------------------------------------------------
        31. j    = tre==0?  i1 : i2;
        32. k    = tre==0?  i2 : i1;
        33. //-----------------------------------------------------
        34. // Barras de Montantes, Banzo Inferior, Banzo Superior
        35. // Diagonais esquerdas e Diagonais direitas
        36. //-----------------------------------------------------
        37. BMO  = Line.ByStartPointEndPoint ( PTI     , PTS       );
        38. BBI  = Line.ByStartPointEndPoint ( PTI[ic] , PTI[ic+1] );
        39. BBS  = Line.ByStartPointEndPoint ( PTS[ic] , PTS[ic+1] );
        40. BDE  = Line.ByStartPointEndPoint ( PTS[j]  , PTI[j+1]  );
        41. BDD  = Line.ByStartPointEndPoint ( PTI[k]  , PTS[k+1]  );
