# Treliças
As seguintes funções foram desenvolvidas para exemplificar o traçado de sistemas de treliças metálicas em projetos BIM utilizando uma aplicação como Dynamo.
A bibliografia utilizada para verificar os parâmetros formais das treliças foi **"Treliças tipo Steel Joist"** de Flávio Correa D'alembert e Marcelo Brisola Pinheiro, Publicado pelo IBS/CBCA, 2007.

## Treliças_Joist_CBCA_Tipo1-2.dyn

![Treliça_Tipo_1-2](https://github.com/JLMenegotto/AulasBIM/assets/9437020/128fb83a-f2a9-49ee-afdd-2f1fee1b008a)

## Code Block 1

        1.    And;
        2.    TiTr;
        3.    DimL;
        4.    DimH;
        5.    qpai;
        6.    lap;
        7.    ebi;
        8.    tiv;
        9.    tip;
       10.    tit;
       11.    Tipo2 = TiTr==2 ? true : DimL>12000 ? true : false;
       12.    LVL   = Level.SetParameterByName (And, "Elevation", DimH );
       13.    vx    = DimL/2;
       14.    vy    = 0;
       15.    vz    = DimH;
       16.    x0    = -(vx-lap)..(vx-lap)..#(qpai*2)+1;
       17.    y0    = 0;
       18.    //-------------------------------------------------------------
       19.    // Altura de Triângulo Equilátero
       20.    //-------------------------------------------------------------
       21.    dimP = x0[2]-x0[0];
       22.    Altu = (dimP * Math.Sqrt(3))/2;
       23.    zs   = DimH; 
       24.    zi   = DimH - Altu;
       25.    //------------------------------------------------------------
       26.    //  Indices para lançamento dos elementos da treliça
       27.    //------------------------------------------------------------
       28.    q    = List.Count( x0 );
       29.    i    = 0..q-1..2;
       30.    j    = 1..q-2..2;
       31.    k    = 2..q-1..2;
       32.    m    = 2..q-2..2;
       33.    //------------------------------------------------------------
       34.    //  Pontos iniciais do Banzo Superior e Inferior
       35.    //------------------------------------------------------------
       36.    PtBS  = Point.ByCoordinates(x0 , y0 , zs);
       37.    PtBI  = Point.ByCoordinates(x0 , y0 , zi);
       38.    //------------------------------------------------------------
       39.    // Linhas dos Banzos
       40.    //------------------------------------------------------------
       41.    LiBZS   = Line.ByStartPointEndPoint(PtBS[0] , PtBS[-1]);
       42.    LiBZI   = Line.ByStartPointEndPoint(PtBI[1] , PtBI[-2]);
       43.    LiBZSE1 = Line.ExtendStart( LiBZS , lap );
       44.    LiBZSE2 = Line.ExtendEnd  ( LiBZS , lap );
       45.              Line.ExtendStart( LiBZI , ebi );
       46.              Line.ExtendEnd  ( LiBZI , ebi );
       47.    //------------------------------------------------------------
       48.    // Linhas das Diagonais e Montantes só no caso Tipo 2
       49.    //------------------------------------------------------------
       50.    LiDIA1  =        Line.ByStartPointEndPoint( PtBS[i] , PtBI[j] );
       51.    LiDIA2  =        Line.ByStartPointEndPoint( PtBI[j] , PtBS[k] );
       52.    LiMONT  = Tipo2? Line.ByStartPointEndPoint( PtBS[m] , PtBI[m] ):null;
       53.    //------------------------------------------------------------
       54.    // Pontos e Linhas dos pilares
       55.    //------------------------------------------------------------
       56.    Pt1     = LiBZSE1.StartPoint;
       57.    Pt2     = LiBZSE2.EndPoint;
       58.    Pt01    = Point.ByCoordinates ( Pt1.X , Pt1.Y , 0 );
       59.    Pt02    = Point.ByCoordinates ( Pt2.X , Pt2.Y , 0 );
       60.    LiPIE   = Line.ByStartPointEndPoint( Pt01, Pt1 );
       61.    LiPID   = Line.ByStartPointEndPoint( Pt02, Pt2 );
       62.    //------------------------------------------------------------
       63.    chaves  = [ "Diag1"       , "Diag2"       , "Mont" ];
       64.    valores = [ LiDIA1.Length , LiDIA2.Length , LiMONT.Length ]; 
       65.    Dictionary.ByKeysValues(chaves, valores);

## Code Block 2
        1.    Dados;
        2.    arqE;
        3.    Vdia1  =  Dados["Diag1"];
        4.    Vdia2  =  Dados["Diag2"];
        5.    Vmont  =  Dados["Mont"];
        6.    //------- -----------------------------------------------------------------
        7.    //Escrever dados no Excel
        8.    //------------------------------------------------------------------------
        9.    dadosD1 = DSOffice.Data.ExportToExcel (arqE  , "Treliça", 0 , 0, Vdia1, false , false );
       10.    dadosD2 = DSOffice.Data.ExportToExcel (arqE  , "Treliça", 0 , 1, Vdia2, false , false );
       11.    Montant = DSOffice.Data.ExportToExcel (arqE  , "Treliça", 0 , 2, Vmont, false , false );

![Treliça_CBCA_Tipos1-2](https://github.com/JLMenegotto/AulasBIM/assets/9437020/058aefb0-afff-4141-8efb-ef47f43713dd)

## 
[**Canal YouTube:** Videos com explicação dos conteúdos e metodologias das funções](https://www.youtube.com/channel/UCCN58u2BP38F09aswlJrILA)
#### **Consulte outros projetos**
  
   1. [**OntologiaBIM:** Construtor de ontologias OWL](https://github.com/JLMenegotto/OntologiaBIM)
   2. [**Acustica2024 e Parla:** Integração do Simulador Acústico BRASS com Revit](https://github.com/JLMenegotto/Acustica_2024)
   3. [**RIO:** Reformatação de acervos digitais](https://github.com/JLMenegotto/Rio)
   4. [**Promenade:** Sistema IoT para microlocalização](https://github.com/JLMenegotto/Promenade)
   5. [**Sistemas Projetivos:** Funções para o ensino de Geometria Descritiva em Revit](https://github.com/JLMenegotto/SistemasProjetivos)
   6. [**Atratores:** Funções AutoLISP para geração de pontos](https://github.com/JLMenegotto/Atratores)
   7. [**EGC:** Funções em AutoLISP para representação e formalização do projeto](https://github.com/JLMenegotto/EGC)
   8. [**Funções Geométricas:** Funções Dynamo para geometria plana](https://github.com/JLMenegotto/AulasBIM/tree/master/Dynamo/Geometricas)
   9. [**Funções de Análise de Lotes:** Funções Dynamo para o projeto conceptual a partir do lote](https://github.com/JLMenegotto/AulasBIM/tree/master/Dynamo/Lotes)
  10. [**Funções Obras Paradigmáticas:** Funções Dynamo de projetos paradigmáticos]( https://github.com/JLMenegotto/AulasBIM/tree/master/Dynamo/Obras)
  11. [**Funções Gerais de Predios:** Funções Dynamo para automatizar o projeto](https://github.com/JLMenegotto/AulasBIM/tree/master/Dynamo/Predio)
  12. [**Funções Periódicas Temporais:** Funções Dynamo para trabalhar com o tempo](https://github.com/JLMenegotto/AulasBIM/tree/master/Dynamo/Relógio)
  13. [**Funções para Galpões:** Funções Dynamo para automatizar o projeto de Gapões de aço](https://github.com/JLMenegotto/AulasBIM/tree/master/Dynamo/Galpão)
  14. [**Funções para Treliças:** Funções Dynamo para automatizar o projeto de treliças](https://github.com/JLMenegotto/AulasBIM/tree/master/Dynamo/Treliças)
  15. [**Funções para Ambientes:** Funções Dynamo para automatizar o projeto a partir do objeto Room em Revit](https://github.com/JLMenegotto/AulasBIM/tree/master/Dynamo/Rooms)
  16. [**Funções para Advance Steel:** Funções para gerar perfis customizados em AdvanceSteel](https://github.com/JLMenegotto/AulasBIM/tree/master/AdvanceSteel)
  17. [**Funções para torres:** Funções para Dynamo gerar estruturas verticais](https://github.com/JLMenegotto/AulasBIM/tree/master/Dynamo/Torres)
      
  18. [**Bibliografia**](https://jlmenegotto.wixsite.com/jlmenegotto-bim/pesquisa)
  19. [**Publicações**](https://jlmenegotto.wixsite.com/jlmenegotto-bim/jlm-public)
