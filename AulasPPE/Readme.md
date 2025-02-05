## Aulas PPE


## Lotes: Função Aula_PPE_05.dyn
No código da função **Aula_PPE_04b.dyn** não foi utilizada a Massa Inplace como prédio. Nesta função, para formar o predio é criado o volume a partir da linha do limite do lote escalada com o fator correspondente à
Taxa de ocupação do terreno (linhas 48. a 54.). Os limites são utilizados para criar uma Surface (linha 51.) que será escalada (linha 52) e finalmente extrudada (linha 54.).
Outro ponto de destaque para analisar da função são as linhas 21 e 25. A declaração da linha 21. permite processar um lote de cada vez, mas com uma pequena alteração, incorporada na linha 25., o processamento pode ser realizado
en todos os lotes, já que a variável LOTE conterá uma lista numérica iniciada em 0 e finalizada com o valor da quantidade de lotes-1.

![Aula_PPE_05_2024-04-19_05-51-36](https://github.com/JLMenegotto/AulasBIM/assets/9437020/fb49122a-3596-4410-bf8e-f1000241c0c6)

### Lotes: code block da função Aula_PPE_05.dyn 

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

### Lotes: função complementar para incorporar andares: Usar em modo Manual 
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


## Treliças Planas. Função Aula_PPE_06b.dyn
As seguintes funções têm como objetivo trabalhar com a manipulação de listas de coordenadas (X Y Z) para gerar 
diversas configurações formais como treliças planas e espaciais, matrizes de colunas e vigas. Alguns exemplos  
utilizam a função Remainder (%) para gerar variação formal. 

![PPE_Aula06b_2024-04-23_09-20-58](https://github.com/JLMenegotto/AulasBIM/assets/9437020/a325ed82-a450-4283-bb6a-056971726325)
![Treliças](https://github.com/JLMenegotto/AulasBIM/assets/9437020/368b7c16-3297-4a82-a4af-7f49f6be83ad)

A função apresenta a marcação da treliça no plano XZ, caso prefira trabalhar sobre o plano XY devem ser alteradas as declarações das linhas
27. e 28. de **PTI = Point.ByCoordinates( x , 0 , albi );** para **PTI = Point.ByCoordinates( x , albi , 0 );** 

### Treliças: code block da função Aula_PPE_06b.dyn: 
         1.   vao;
         2.   qmo;
         3.   ang;
         4.   alt;
         5.   agu;
         6.   par;
         7.   tre;
         8.   //-----------------------------------------------------
         9.   vx   = vao/2;
        10.   qme  = qmo/2;
        11.   inc  = Math.Tan( ang );
        12.   //-----------------------------------------------------
        13.   // Formação das listas de índices
        14.   //-----------------------------------------------------
        15.   x    = vx..-vx..#qmo+1;
        16.   i    = List.Flatten([ qme..0   , 1..qme] , 1 );
        17.   j    = List.Flatten([ 0..qme-1 , qme..0] , 1 );
        18.   w    = List.Flatten([ qmo..0           ] , 1 );
        19.   indi = agu== 1 ? w :  agu== 2 ? i : j;
        20.   vzi  = x   * inc;
        21.   vzs  = vzi + alt;
        22.   //-----------------------------------------------------
        23.   albi = par== 0 ? 0         : vzi[indi];
        24.   albs = par== 0 ? vzs[indi] : vzs[indi];
        25.   //-----------------------------------------------------
        26.   // Pontos do Banzo inferior e superior
        27.   //-----------------------------------------------------
        28.   PTI = Point.ByCoordinates( x , 0 , albi );
        29.   PTS = Point.ByCoordinates( x , 0 , albs );
        30.   //-----------------------------------------------------
        31.   // Indices das metades esquerda e direita
        32.   //-----------------------------------------------------
        33.   i1  = 0  ..qme-1;
        34.   i2  = qme..qmo-1;
        35.   //-----------------------------------------------------
        36.   // Os indices k l são invertidos caso o sistema seja
        37.   // Pratt ou Howe. Indice m usado em treliça de 1 água
        38.   //-----------------------------------------------------
        39.   k   = tre==0? i1 : i2;
        40.   l   = tre==0? i2 : i1;
        41.   m   = 0..qmo-1;
        42.   //-----------------------------------------------------
        43.   // Barras de Montantes, Banzo Inferior, Banzo Superior
        44.   // Diagonais esquerdas e direitas ou todas
        45.   //-----------------------------------------------------
        46.   BMO =        Line.ByStartPointEndPoint ( PTI    , PTS      );
        47.   BDE = agu>1? Line.ByStartPointEndPoint ( PTS[k] , PTI[k+1] ) : null;
        48.   BDD = agu>1? Line.ByStartPointEndPoint ( PTI[l] , PTS[l+1] ) : null;
        49.   BDA = agu<2? Line.ByStartPointEndPoint ( PTS[m] , PTI[m+1] ) : null;
        50.   BBI =        Line.ByStartPointEndPoint ( PTI[m] , PTI[m+1] );
        51.   BBS =        Line.ByStartPointEndPoint ( PTS[m] , PTS[m+1] );

Veja outros exemplos de treliças em: https://github.com/JLMenegotto/AulasBIM/tree/master/Dynamo/Treli%C3%A7as        

## Matrizes regulares para Vigamentos. Função PPE_Aula06d.dyn
![PPE_Aula06d_2024-04-22_02-42-35](https://github.com/JLMenegotto/AulasBIM/assets/9437020/660a59a9-cdd0-4d47-8773-98084810e79d)
![Matriz_01](https://github.com/JLMenegotto/AulasBIM/assets/9437020/7f3f7ca8-0741-4a60-9593-3c3a1a27c548)

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

### Complemento para colocar contraventamentos em X. Função Função PPE_Aula06d.dyn

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

## Treliças planas. Função PPE_Aula06c.dyn
![PPE_Aula06c_2024-04-23_11-09-55](https://github.com/JLMenegotto/AulasBIM/assets/9437020/ef966be4-8f0d-4ea7-886b-d5a5aade2181)
![Shed_03](https://github.com/JLMenegotto/AulasBIM/assets/9437020/cc917de6-93b8-4243-8a62-77a315817887)

         1.   qx;
         2.   dx;
         3.   dy;
         4.   ai;
         5.   az;
         6.   m;
         7.   pa;
         8.   inv;
         9.   //---------------------------------------------------
        10.   // Listas e Indices
        11.   //---------------------------------------------------
        12.   x   = 0..qx;
        13.   i   = 0..qx-1;
        14.   j   = 0..qx-1..2;
        15.   k   = 1..qx-1..2;
        16.   cx  = dx *  x;
        17.   mo  = x % m;
        18.   yi  = ai + (dy * mo);
        19.   ys  = yi + az;
        20.   //---------------------------------------------------
        21.   // Pontos e Linhas das barras
        22.   //---------------------------------------------------
        23.   LPS = Point.ByCoordinates ( cx ,     ys    , 0 );
        24.   LPI = Point.ByCoordinates ( cx , pa? yi:ai , 0 );
        25.   //---------------------------------------------------
        26.   MON = Line.ByStartPointEndPoint ( LPI          , LPS              );
        27.   VSH = Line.ByStartPointEndPoint ( LPS[     i ] , LPS[      i+1  ] );
        28.   VIH = Line.ByStartPointEndPoint ( LPI[     i ] , LPI[      i+1  ] );
        29.   DI1 = Line.ByStartPointEndPoint ( LPI[inv?k:j] , LPS[(inv?k:j)+1] );
        30.   DI2 = Line.ByStartPointEndPoint ( LPS[inv?j:k] , LPI[(inv?j:k)+1] );

## Treliça plana de triângulos equiláteros. Função PPE_Aula07.dyn
![PPE_Aula07_2024-04-23_04-51-55](https://github.com/JLMenegotto/AulasBIM/assets/9437020/6902a5d6-b9f8-452f-85f9-9f94b5b18b06)
![Treliça_05](https://github.com/JLMenegotto/AulasBIM/assets/9437020/5d0851e1-ade3-4b87-a2af-efbac2507d89)

         1.   l;
         2.   q;
         3.   //---------------------------------------------------
         4.   // Constantes
         5.   //---------------------------------------------------
         6.   s30 = Math.Sin(30) * l;
         7.   c30 = Math.Cos(30) * l;
         8.   //---------------------------------------------------
         9.   // Indices
        10.   //---------------------------------------------------
        11.   i   = 0..q+1;
        12.   j   = 0..Count(PTI)-3;
        13.   k   = 0..Count(PTI)-2;
        14.   //---------------------------------------------------
        15.   // Coordenadas X e Y
        16.   //---------------------------------------------------
        17.   x   = i   * s30;
        18.   y   = i%2 * c30;
        19.   //---------------------------------------------------
        20.   // Pontos e Barras
        21.   //---------------------------------------------------
        22.   PTI = Point.ByCoordinates      ( x  ,   y  ,   0 );
        23.   BZO = Line.ByStartPointEndPoint( PTI[j] , PTI[j+2] );
        24.   DIA = Line.ByStartPointEndPoint( PTI[k] , PTI[k+1] );
        
## Matrizes e Tramas Moduladas. Função PPE_Aula08.dyn
![PPE_Aula08_2024-04-24_07-07-08](https://github.com/JLMenegotto/AulasBIM/assets/9437020/b1c759b4-93b9-4854-acd7-3034911190d0)

**Tramas moduladas em uma direção.**
![Trama_M1](https://github.com/JLMenegotto/AulasBIM/assets/9437020/2e8f1d52-74fc-48cb-bc37-484b3f200659)

A declaração da linha 8. define o valor da coordenada X, regulando-o de acordo ao valor modular do índice i.

         1.   d;
         2.   p;
         3.   q;
         4.   mod;
         5.   ///-----------------------------------
         6.   m  = d * p;
         7.   i  = 0..q-1;
         8.   x  = i%mod ? (i * d+m) : (i * d);
         9.   y  = i+1;
        10.   //------------------------------------
        11.   PT = Point.ByCoordinates ( x<1> , y );

**Tramas moduladas em duas direções.**
![Trama_M2](https://github.com/JLMenegotto/AulasBIM/assets/9437020/3851cfb9-beaf-483b-a3e1-739f7df02893)

Para produzir uma trama dupla podem ser alteradas as declarações das linhas 9. e 11 de acordo ao seguinte code block

         1.   d;
         2.   p;
         3.   q;
         4.   mod;
         5.   ///-----------------------------------
         6.   m  = d * p;
         7.   i  = 0..q-1;
         8.   x  = i%mod ? (i * d+m) : (i * d);
         9.   y  = x;
        10.   //------------------------------------
        11.   PT = Point.ByCoordinates ( x<1> , y );


## Treliça Espacial Equilátera. Função PPE_Aula10.dyn
![Aula_PPE_10_2024-04-26_08-32-50](https://github.com/JLMenegotto/AulasBIM/assets/9437020/98335c61-ed74-43d2-b387-2c72f2e65d8d)

![Treli3d](https://github.com/JLMenegotto/AulasBIM/assets/9437020/266b1a7d-10b4-452f-9d41-210cd3ccfe47)

         1.   qx;
         2.   qy;
         3.   di;
         4.   ap;
         5.   dm  = di/2;
         6.   qi  = qy<=qx ? qx-1 : qy-1;
         7.   qj  = qy<=qx ? qx-1 : qy-1;
         8.   qk  = qy<=qx ? qx-1 : qy-1;
         9.   ql  = qy<=qx ? qx-2 : qy-2;
        10.   //-----------------------------------------------------
        11.   alt = Math.Cos(60)*Math.Sqrt(2) * di;
        12.   i   = 0..qi;
        13.   j   = 0..qj;
        14.   k   = 0..qk;
        15.   l   = 0..ql;
        16.   //-----------------------------------------------------
        17.   // Vetores das Diagonais
        18.   //-----------------------------------------------------
        19.   V1  = Vector.ByCoordinates( dm ,  dm , -alt);
        20.   V2  = Vector.ByCoordinates(-dm ,  dm , -alt);
        21.   V3  = Vector.ByCoordinates(-dm , -dm , -alt);
        22.   V4  = Vector.ByCoordinates( dm , -dm , -alt);
        23.   LVE = [V1,V2,V3,V4];
        24.   DVE = V1.Length;
        25.   //-----------------------------------------------------
        26.   // Posicionamento dos Pontos
        27.   //-----------------------------------------------------
        28.   cxi = 0..( di * qx )..di;
        29.   cyi = 0..( di * qy )..di;
        30.   cxs = List.DropItems      ( cxi , 1 ) - dm;
        31.   cys = List.DropItems      ( cyi , 1 ) - dm;
        32.   //-----------------------------------------------------
        33.   phi = Point.ByCoordinates ( cxi<1> , cyi ,  0  );
        34.   phs = Point.ByCoordinates ( cxs<1> , cys , alt );
        35.   pvi = List.Transpose      ( phi                );
        36.   pvs = List.Transpose      ( phs                );
        37.   //-----------------------------------------------------
        38.   // Barras do Banzo Inferior
        39.   //-----------------------------------------------------
        40.   BHI = Line.ByStartPointEndPoint( phi[i] , phi[i+1] );
        41.   BVI = Line.ByStartPointEndPoint( pvi[j] , pvi[j+1] );
        42.   //-----------------------------------------------------
        43.   // Barras do Banzo Superior
        44.   //-----------------------------------------------------
        45.   BHS = Line.ByStartPointEndPoint( phs[k] , phs[k+1] );
        46.   BVS = Line.ByStartPointEndPoint( pvs[l] , pvs[l+1] );
        47.   //-----------------------------------------------------
        48.   // Barras das Diagonais
        49.   //-----------------------------------------------------
        50.   DIA = Line.ByStartPointDirectionLength(phs,LVE<1>,DVE);
        51.   //-----------------------------------------------------
        52.   // Extração de resultados utilizando Dicionário
        53.   //-----------------------------------------------------
        54.   Key = [ "Apoios", "Quan-X", "Quan-Y", "PntosH"];
        55.   Val = [  ap     ,  qx     ,  qy     ,  phi    ];
        56.   DIC = Dictionary.ByKeysValues ( Key ,  Val ); 


O dicionário preparado por esta função é passado para o segundo Code Block, cuja função é localizar a posição 
dos futuros apóios. O esquema de índices indicados na figura, são declarados nas declarações 16. e 17. Com eles
é formada a lista LAP que será processada na última declaração que coloca um círculo apenas para visualizar 
a posição. Os apóios foram programados para ser posicionados desde as quatro quinas da treliça modimentando-se 
diagonalmente para dentro. 

![trama](https://github.com/JLMenegotto/AulasBIM/assets/9437020/183a5d0c-aff0-4433-8311-afc7411a3a8f)

         1.  Dados;
         2.  ap  = Dados[ "Apoios" ];
         3.  qx  = Dados[ "Quan-X" ];
         4.  qy  = Dados[ "Quan-Y" ];
         5.  phi = Dados[ "PntosH" ];
         6.  //-----------------------------------------
         7.  // Índices de marcação
         8.  //-----------------------------------------
         9.  r   = 0.25;
        10.  i   =   ap;
        11.  j   = -1-i;
        12.  k   = qy-i;
        13.  //-----------------------------------------
        14.  // Pontos dos Apóios
        15.  //-----------------------------------------
        16.  LAP = [ phi[i][k], phi[j][k],
        17.          phi[i][i], phi[j][i]];
        18.  AP1 = Circle.ByCenterPointRadius( LAP , r );

