## Aulas PPE


## Lotes
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


## Treliças
![PPE_Aula06b_2024-04-21_10-42-48](https://github.com/JLMenegotto/AulasBIM/assets/9437020/73120887-f960-4404-b421-f87e2d0f9c96)

![Treliça_01](https://github.com/JLMenegotto/AulasBIM/assets/9437020/42c81c28-1034-4e6f-93a7-7ea39010751a)

![Treliça_02](https://github.com/JLMenegotto/AulasBIM/assets/9437020/8ec317c5-1ab8-4094-9e30-262d7c7841ac)

A função apresenta a marcação da treliça no plano XZ, caso prefira trabalhar sobre o plano XY devem ser alteradas as declarações das linhas
27. e 28. de **PTI = Point.ByCoordinates( x , 0 , albi );** para **PTI = Point.ByCoordinates( x , albi , 0 );** 

### Code Block da função Aula_PPE_06b.dyn: 
         1.  vao;
         2.  qmo;
         3.  ang;
         4.  alt;
         5.  inv;
         6.  par;
         7.  tre;
         8.  //-----------------------------------------------------
         9.  vx   = vao/2;
        10.  qme  = qmo/2;
        11.  inc  = Math.Tan( ang );
        12.  //-----------------------------------------------------
        13.  // Formação das listas de índices
        14.  //-----------------------------------------------------
        15.  x    = vx..-vx..#qmo+1;
        16.  i    = List.Flatten([ qme..0   , 1..qme] ,1);
        17.  j    = List.Flatten([ 0..qme-1 , qme..0] ,1);
        18.  indi = inv== 0 ? i : j;
        19.  vzi  = x   * inc;
        20.  vzs  = vzi + alt;
        21.  //-----------------------------------------------------
        22.  albi = par== 0 ? 0         : vzi[indi];
        23.  albs = par== 0 ? vzs[indi] : vzs[indi];
        24.  //-----------------------------------------------------
        25.  // Pontos do Banzo inferior e superior
        26.  //-----------------------------------------------------
        27.  PTI  = Point.ByCoordinates( x , 0 , albi );
        28.  PTS  = Point.ByCoordinates( x , 0 , albs );
        29.  //-----------------------------------------------------
        30.  // Indices completo ic e as duas metades i1 e 12
        31.  //-----------------------------------------------------
        32.  ic   = 0  ..qmo-1;
        33.  i1   = 0  ..qme-1;
        34.  i2   = qme..qmo-1;
        35.  //-----------------------------------------------------
        36.  // Os indices j e k são invertidos caso o sistema seja
        37.  // Pratt ou Howe
        38.  //-----------------------------------------------------
        39.  k    = tre==0?  i1 : i2;
        40.  l    = tre==0?  i2 : i1;
        41.  //-----------------------------------------------------
        42.  // Barras de Montantes, Banzo Inferior, Banzo Superior
        43.  // Diagonais esquerdas e Diagonais direitas
        44.  //-----------------------------------------------------
        45.  BMO  = Line.ByStartPointEndPoint ( PTI     , PTS       );
        46.  BBI  = Line.ByStartPointEndPoint ( PTI[ic] , PTI[ic+1] );
        47.  BBS  = Line.ByStartPointEndPoint ( PTS[ic] , PTS[ic+1] );
        48.  BDE  = Line.ByStartPointEndPoint ( PTS[k ] , PTI[k +1] );
        49.  BDD  = Line.ByStartPointEndPoint ( PTI[l ] , PTS[l +1] ); 

Veja outros exemplos de treliças em: https://github.com/JLMenegotto/AulasBIM/tree/master/Dynamo/Treli%C3%A7as        

## Matrizes regulares para Vigamentos. Função PPE_Aula06a.dyn

![PPE_Aula06d_2024-04-22_02-42-35](https://github.com/JLMenegotto/AulasBIM/assets/9437020/660a59a9-cdd0-4d47-8773-98084810e79d)
![Matriz_01](https://github.com/JLMenegotto/AulasBIM/assets/9437020/0f7a35f4-d06b-4d52-8ebf-7db50c771f95)

         1.   qx;
         2.   qy;
         3.   qz = 0;
         4.   dx;
         5.   dy;
         6.   ang;
         7.   inc = Math.Tan ( ang );
         8.   vic = Vector.ByCoordinates( 0 , cy , 0 );
         9.   cx  = ( 0..qx ) * dx;
        10.   cy  = ( 0..qy ) * dy;
        11.   //--------------------------------------------------
        12.   // Indices
        13.   //--------------------------------------------------
        14.   h   = 0..qx-1;
        15.   v   = 0..qy-1;
        16.   hh  = h+1;
        17.   vv  = v+1;
        18.   //--------------------------------------------------
        19.   // Pontos da matriz
        20.   //--------------------------------------------------
        21.   LPI = Point.ByCoordinates ( cx, cx*inc , qz);
        22.   LPH = Point.Add           ( LPI<1> ,   vic );
        23.   LPV = List.Transpose      ( LPH            );
        24.   //--------------------------------------------------
        25.   // Linhas horizontais e verticais
        26.   //--------------------------------------------------
        27.   VIH = Line.ByStartPointEndPoint ( LPH[h], LPH[hh] );
        28.   VIV = Line.ByStartPointEndPoint ( LPV[v], LPV[vv] );
        29.   //--------------------------------------------------
        30.   //Extração de resultados utilizando Dicionário
        31.   //--------------------------------------------------
        32.   Key = ["PontosH", "PontosV", "VigasH", "VigasV"];
        33.   Val = [   LPH   ,    LPV   ,   VIH   ,    VIV  ];
        34.   DIC = Dictionary.ByKeysValues ( Key , Val );

## Complemento para colocar contraventamentos em X. Função Função PPE_Aula06d.dyn
![Contraventamento](https://github.com/JLMenegotto/AulasBIM/assets/9437020/a727c311-9961-40ce-986a-d7ca5ea6e8a2)

         1.  Dic;
         2.  qx  = Dic["Col"]+1;
         3.  qy  = Dic["Fil"];
         4.  PTV = Dic["PntV"];
         5.  //---------------------------------------------------
         6.  PtC = List.Flatten( PTV , 1);
         7.  //---------------------------------------------------
         8.  // Indices das Diagonais
         9.  //---------------------------------------------------
        10.  ic  =  0..qx-2;
        11.  ir  =  0..qy-1;
        12.  i   = List.Flatten(ic<1> + (qx*ir) , 1);
        13.  j   = i+qx+1;
        14.  //---------------------------------------------------
        15.  // Coloca as linhas
        16.  //---------------------------------------------------
        17.  Di1 = Line.ByStartPointEndPoint(PtC[i  ] , PtC[j  ]);
        18.  Di2 = Line.ByStartPointEndPoint(PtC[i+1] , PtC[j-1]);

## Matrizes regulares para Treliças. Função PPE_Aula06c.dyn
![PPE_Aula06c_2024-04-22_10-53-43](https://github.com/JLMenegotto/AulasBIM/assets/9437020/4a96e051-030b-4313-91bc-d7214dde236f)
![Shed_01](https://github.com/JLMenegotto/AulasBIM/assets/9437020/c57cd049-be32-4185-86e8-88e069c62381)

         1.   qx;
         2.   dx;
         3.   dy;
         4.   al;
         5.   m;
         6.   //---------------------------------------------------
         7.   // Listas e Indices
         8.   //---------------------------------------------------
         9.   x   =  0..qx;
        10.   i   =  0..qx-1;
        11.   cx  =  dx *  x;
        12.   mo  =  x % m;
        13.   cy  =  dy * mo + al - 2*mo;
        14.   //---------------------------------------------------
        15.   // Pontos e Linhas das barras
        16.   //---------------------------------------------------
        17.   LPS = Point.ByCoordinates ( cx , cy , 0 );
        18.   LPI = Point.ByCoordinates ( cx , 0  , 0 );
        19.   //---------------------------------------------------
        20.   MON = Line.ByStartPointEndPoint ( LPI   , LPS      );
        21.   VSH = Line.ByStartPointEndPoint ( LPS[i], LPS[i+1] );
        22.   VIH = Line.ByStartPointEndPoint ( LPI[i], LPI[i+1] );
        23.   DIA = Line.ByStartPointEndPoint ( LPI[i], LPS[i+1] );
