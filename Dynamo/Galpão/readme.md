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
       1.   x1 = 0;
       2.   y1 = 0;
       3.   z0 = 0;
       4.   vlivr;
       5.   cumee;
       6.   z1;
       7.   y2 = y1 +  vlivr;
       8.   ym = y1 + (vlivr / 2 );
       9.   z2 = z1 + cumee;
       10.  //-----------------------------------------------------
       11.  // Ajusta o level
       12.  //-----------------------------------------------------
       13.  LVL = Level.SetParameterByName (And, "Elevation", z1 );
       14.  //-----------------------------------------------------
       15.  //Forma do perfil Inicial
       16.  //-----------------------------------------------------
       17.  Lx  = [x1 , x1 , x1,  x1 , x1 ];
       18.  Ly  = [y1 , y1 , ym,  y2 , y2 ];
       19.  Lz  = [z0 , z1 , z2,  z1 , z0 ];
       20.  Pts = Point.ByCoordinates(Lx, Ly, Lz);





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
