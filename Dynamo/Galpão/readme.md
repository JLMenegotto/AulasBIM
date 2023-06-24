# Galpão

## Galpão_Tipo1_Modulo.dyn

![Galpão_Tipo1_Modulo](https://github.com/JLMenegotto/AulasBIM/assets/9437020/acbfe248-8fab-4c12-a7f0-f08c25185cbe)

## Galpão_Tipo1.dyn

![Galpão_Tipo1](https://github.com/JLMenegotto/AulasBIM/assets/9437020/f3c9def8-91ff-434a-a64a-5a3d4ffd6a14)

## Estrutura_Analitica_2023_A.dyn

Na versão 2023 de Revit foi modificada a forma de realizar o modelo estrutural analítico do projeto. Até a versão 2022, os eixos e nodos analíticos eram elementos que estavam integrados às familias  de componentes estrururais (Structural_Columns, Structural_Framming, etc.) e que deviam ser incorporados ao criar as famílias. A partir da versão 2023, o modelo analítico pode ser lançado de modo **independente** dos elementos estruturais físicos, para logo depois ser associados a esses elementos, ou, de modo inverso, ser lançado aproveitando os elementos físicos já modelados. As duas funções a seguir ilustram esses processos.  

A função **Galpao_Analitico_2023.dyn** exemplifica o lançamento e uso das categorias dos elementos analíticos.

![Galpão_analitico_2023](https://github.com/JLMenegotto/AulasBIM/assets/9437020/f479b408-6cd8-4a7d-89e5-2ae98294d5d1)  

## Code Block1:  (Define os pontos da forma)
        1.    x1 = 0;
        2.    y1 = 0;
        3.    z0 = 0;
        4.    vlivr;
        5.    cumee;
        6.    z1;
        7.    y2 = y1 +  vlivr;
        8.    ym = y1 + (vlivr / 2 );
        9.    z2 = z1 + cumee;
       10.    //-----------------------------------------------------
       11.    // Ajusta o level
       12.    //-----------------------------------------------------
       13.    LVL = Level.SetParameterByName (And, "Elevation", z1 );
       14.    //-----------------------------------------------------
       15.    //Forma do perfil Inicial
       16.    //-----------------------------------------------------
       17.    Lx  = [x1 , x1 , x1,  x1 , x1 ];
       18.    Ly  = [y1 , y1 , ym,  y2 , y2 ];
       19.    Lz  = [z0 , z1 , z2,  z1 , z0 ];
       20.    Pts = Point.ByCoordinates(Lx, Ly, Lz);
       
## Code Block2:  (Define a forma e o seu diccionário)
        1.    Pts;
        2.    Qm;
        3.    Dm;
        4.    mo;
        5.    //----------------------------------------------------------------
        6.    //Definição da translação
        7.    //----------------------------------------------------------------
        8.    Tx    = 0..(Qm*Dm)..Dm;
        9.    Ty    = Tx * 0;
       10.    Tz    = Tx * 0;
       11.    PT    = Point.Translate   ( Pts<1> , Tx , Ty , Tz );
       12.    POL   = PolyCurve.ByPoints( PT );
       13.    POT   = PolyCurve.ByPoints( List.Transpose( PT ));
       14.    i     = 0..Qm;
       15.    j     = 0..Qm-1;
       16.    k     = 1..Qm-0;
       17.    p00   = PT[ 0][i];
       18.    p01   = PT[ 1][i];
       19.    p02   = PT[ 2][i];
       20.    p03   = PT[ 3][i];
       21.    p04   = PT[ 4][i];
       22.    p05   = Point.ByCoordinates(p02.X, p02.Y, p01.Z);
       23.    Pf11  = PT[ 0][j];
       24.    Pf12  = PT[ 1][k];
       25.    Pf13  = PT[ 1][j];
       26.    Pf14  = PT[ 0][k];
       27.    pp01  = PT[ 0][j];
       28.    pp02  = PT[-1][j];
       29.    pp11  = PT[-1][k];
       30.    pp12  = PT[ 0][k];
       31.    ptlaj = List.Transpose([pp01, pp02, pp11, pp12]);
       32.    LAJE  = Autodesk.Surface.ByPerimeterPoints(ptlaj);
       33.    pc1   = PT[ 2][j];
       34.    pc2   = PT[ 2][k];
       35.    Pf21  = PT[ 3][j];
       36.    Pf22  = PT[ 4][k];
       37.    Pf23  = PT[ 4][j];
       38.    Pf24  = PT[ 3][k];
       39.    //----------------------------------------------------------------
       40.    //Colunas
       41.    //----------------------------------------------------------------
       42.    COLF1 = Line.ByStartPointEndPoint( p00 , p01 );
       43.    COLF2 = Line.ByStartPointEndPoint( p04 , p03 );
       44.    //----------------------------------------------------------------
       45.    //Vigas do telhado
       46.    //----------------------------------------------------------------
       47.    VIFT1 = Line.ByStartPointEndPoint( p01 , p02 );
       48.    VIFT2 = Line.ByStartPointEndPoint( p02 , p03 );
       49.    //----------------------------------------------------------------
       50.    //Cumeeira, Banzo inferior e pendural
       51.    //----------------------------------------------------------------
       52.    CUMEE = Line.ByStartPointEndPoint( pc1 , pc2 );
       53.    BANZO = Line.ByStartPointEndPoint( p01 , p03 );
       54.    PENDU = Line.ByStartPointEndPoint( p05 , p02 );
       55.    //----------------------------------------------------------------
       56.    //Contraventamentos
       57.    //----------------------------------------------------------------
       58.    CXF11 = i%mo == 0 ? Line.ByStartPointEndPoint( Pf11 , Pf12 ) : null;
       59.    CXF12 = i%mo == 0 ? Line.ByStartPointEndPoint( Pf13 , Pf14 ) : null;
       60.    CXF21 = i%mo == 0 ? Line.ByStartPointEndPoint( Pf21 , Pf22 ) : null;
       61.    CXF22 = i%mo == 0 ? Line.ByStartPointEndPoint( Pf23 , Pf24 ) : null;
       62.    //----------------------------------------------------------------
       63.    //Travessas longitudinais
       64.    //----------------------------------------------------------------
       65.    VTRF10 = Line.ByStartPointEndPoint( Pf11 , Pf14 );
       66.    VTRF11 = Line.ByStartPointEndPoint( Pf12 , Pf13 );
       67.    VTRF20 = Line.ByStartPointEndPoint( Pf21 , Pf24 );
       68.    VTRF21 = Line.ByStartPointEndPoint( Pf22 , Pf23 );
       69.    //----------------------------------------------------------------
       70.    // Semântica com o diccionário de elementos ordenados
       71.    //----------------------------------------------------------------
       72.    Chave  = ["ColF1" , "ColF2" , "Cumeeira" , "Banzo" , "Pendural", "VigT1", "VigT2",       "XF1"       ,       "XF2"      ,       "VTF1"       ,      "VTF2"  ,     "Laje"];
       73.    Valor  = [ COLF1  ,  COLF2  ,  CUMEE     ,  BANZO  , PENDU     ,  VIFT1 ,  VIFT2 , [CXF11 , CXF12  ] , [CXF21 , CXF22 ] , [VTRF10 , VTRF11 ] , [VTRF20 , VTRF21] , LAJE ];
       74.    Dados  = Dictionary.ByKeysValues( Chave , Valor ); 

## Code Block3:  (Define elementos analíticos a partir do dicionário)
        1.    RoleCol;
        2.    RoleVig;
        3.    RolePis;
        4.    RolePar;
        5.    Dados;
        6.    //----------------------------------------------------------------
        7.    //Cria os eixos analíticos
        8.    //----------------------------------------------------------------
        9.    ACOLF1 = AnalyticalMember.ByCurve ( Dados["ColF1"]   );
       10.    ACOLF2 = AnalyticalMember.ByCurve ( Dados["ColF2"]   );
       11.    AVITF1 = AnalyticalMember.ByCurve ( Dados["VigT1"]   );
       12.    AVITF2 = AnalyticalMember.ByCurve ( Dados["VigT2"]   );
       13.    ACUME  = AnalyticalMember.ByCurve ( Dados["Cumeeira"]);
       14.    ABNZO  = AnalyticalMember.ByCurve ( Dados["Banzo"]   );
       15.    APEND  = AnalyticalMember.ByCurve ( Dados["Pendural"]);
       16.    AVTR1  = AnalyticalMember.ByCurve ( Dados["VTF1"]    );
       17.    AVTR2  = AnalyticalMember.ByCurve ( Dados["VTF2"]    );
       18.    ACXF1  = AnalyticalMember.ByCurve ( Dados["XF1" ]    );
       19.    ACXF2  = AnalyticalMember.ByCurve ( Dados["XF2" ]    );
       20.    ALAJE  = AnalyticalPanel.BySurface( Dados["Laje"]    );
       21.    //----------------------------------------------------------------
       22.    //Estabelece o Rol
       23.    //----------------------------------------------------------------
       24.    AnalyticalMember.SetStructuralRole ( [ACOLF1 , ACOLF2                 ] , RoleCol );
       25.    AnalyticalMember.SetStructuralRole ( [AVITF1 , AVITF2 , AVTR1 , AVTR2 ] , RoleVig );
       26.    AnalyticalMember.SetStructuralRole ( [ACXF1  , ACXF2                  ] , RoleVig );
       27.    AnalyticalMember.SetStructuralRole ( [ACUME  , ABNZO  , APEND         ] , RoleVig );
       28.    AnalyticalPanel.SetStructuralRole  ( [ALAJE                           ] , RolePis );  

## Estrutura_Analitica_2023_B.dyn

A função **Estrutura_Analitica_2023_B.dyn** exemplifica o process inverso, ou seja, o lançamento dos elementos estruturais analíticos a partir dos elementos estruturais do modelo físico. Repare que neste exemplo, as colunas estão sem eixo analítico. Isto se deve a que as colunas do modelo físico ainda são colunas arquitetônicas (categoria Columns) ao invés de colunas estruturais (categoria Structural_Columns). 

![Galpão_analitico_2024](https://github.com/JLMenegotto/AulasBIM/assets/9437020/d8f022d8-0749-46c5-b6a4-aeb42409efeb)

## Code Block:
      1.   Colunas;
      2.   Vigas;
      3.   Lajes;
      4.   RoleCol;
      5.   RoleVig;
      6.   RoleLaj;
      7.   //--------------------------------------------------------------
      8.   //Cria os Elementos analíticos
      9.   //--------------------------------------------------------------
      10.  AnaC = AnalyticalMember.ByElement (Colunas , true, true );
      11.  AnaV = AnalyticalMember.ByElement (Colunas , true, true );
      12.  AnaP = AnalyticalPanel.ByElement  (Lajes   , true, true, true);
      13.  //--------------------------------------------------------------
      14.  //Define o Rol estrutural de cada elemento analítico
      15.  //--------------------------------------------------------------
      16.  RolC = AnalyticalMember.SetStructuralRole ( AnaC , RoleCol );
      17.  RolV = AnalyticalMember.SetStructuralRole ( AnaV , RoleVig );
      18.  RolP = AnalyticalPanel.SetStructuralRole  ( AnaP , RoleLaj );

      **Nota:** As variáveis RoleCol, RoleVig e RoleLaj se referem às funções estruturais. Há um nodo Dynamo específico para selecionar essa função (Structural Role)]
