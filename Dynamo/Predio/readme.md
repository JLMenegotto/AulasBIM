# Prédio

Nesta pasta as funções definem elementos predias distribuidos em matrizes retangulares. É explicado o uso de **replicadores de DesignScript <n>** como forma alternativa à função de transposição **(Transpose)**.

## Matriz_XY.dyn
Define uma matriz bidimensional XY com a quantidade de módulos estruturais em direções XY. Na função há duas macros
com Watch Image para compreender os índices i j utilizados. Podem ser utilizados os arquivos de imagem 

    1. Matriz_XY_horizontal.png
    2. Matriz_XY_vertical.png
    3. Matriz_XY_Contraventamentos1.png
    4. Matriz_XY_Contraventamentos2.png

![Matriz_XY_horizontal](https://github.com/JLMenegotto/AulasBIM/assets/9437020/acacbf0d-a06f-4a15-a462-ecb00842d77a)
![Matriz_XY_vertical](https://github.com/JLMenegotto/AulasBIM/assets/9437020/c3a1b19f-af57-42c1-87b1-0814b183f745)
![Matriz_XY_Contraventamentos1](https://github.com/JLMenegotto/AulasBIM/assets/9437020/f4eb49cd-2d9e-4bec-ad97-bfbefea578e9)
![Matriz_XY_Contraventamentos2](https://github.com/JLMenegotto/AulasBIM/assets/9437020/88261b0d-08b6-4b09-8b84-14d5d4afb9fc)

## Code Block
        1.    qx;
        2.    qy;
        3.    dx;
        4.    dy;
        5.    //------------------------------------------
        6.    // Centralizar as coordenadas
        7.    //------------------------------------------
        8.    cx  = (qx-1)*dx*0.5;
        9.    cy  = (qy-1)*dy*0.5;
       10.    x   = (0..#qx..dx)-cx;
       11.    y   = (0..#qy..dy)-cy;
       12.    //------------------------------------------
       13.    // Forma as listas de pontos
       14.    //------------------------------------------
       15.    PtX = Point.ByCoordinates ( x<1>, y   , 0 );
       16.    PtY = Point.ByCoordinates ( x   , y<1>, 0 );
       17.    // PtY = Transpose(PtX) pode ser usada;
       18.    //------------------------------------------
       19.    // Indices das Diagonais
       20.    //------------------------------------------
       21.    i   = 0..qx-2;
       22.    j   = i+1;
       23.    k   = 0..qy-2;
       24.    l   = k+1;
       25.    //------------------------------------------
       26.    // Coloca as linhas
       27.    //------------------------------------------
       28.    ViH = Line.ByStartPointEndPoint(PtX[i] , PtX[j]);
       29.    ViV = Line.ByStartPointEndPoint(PtY[k] , PtY[l]);
       30.    //------------------------------------------
       31.    // Definição semântica
       32.    //------------------------------------------
       33.    llave = ["Vigas_H" , "Vigas_V" ];
       34.    valor = [ ViH      ,  ViV      ];
       35.    Dicio = Dictionary.ByKeysValues( llave, valor );

## Matriz_XYZ.dyn

Define uma matriz tridimensional XYZ com a quantidade de módulos estruturais em direções XY e quantidade de Andares
A função cria os andares e os Eixos estruturais.

## Code Block 1
        1.    dx;
        2.    dy;
        3.    dz;
        4.    qx;
        5.    qy;
        6.    qz;
        7.    cotaRN;
        8.    a  = 0..qx;
        9.    b  = 0..qy;
       10.    c  = 0..qz;
       11.    x  = (a * dx);
       12.    y  = (b * dy);
       13.    z  = (c * dz) + cotaRN;
       14.    px = Point.ByCoordinates( x<1> , y    , z<2> );
       15.    py = Point.ByCoordinates( x    , y<1> , z<2> );
       16.    pz = Point.ByCoordinates( x<2> , y    , z<1> );
       17.    vx = Line.ByStartPointEndPoint( px[i] , px[i+1] );
       18.    vy = Line.ByStartPointEndPoint( py[j] , py[j+1] );
       19.    co = Line.ByStartPointEndPoint( pz[k] , pz[k+1] );
       20.    i  = 0..Count(px)-2;
       21.    j  = 0..Count(py)-2;
       22.    k  = 0..Count(pz)-2;

## Code Block 2
        1.    alt;
        2.    vx;
        3.    vy;
        4.    cz;
        5.    //Coloca Andares -------------------------------------------------
        6.    pav  = 0..List.Count( alt )-1;
        7.    max  = pav[-1];
        8.    nome = pav==0 ? "Térreo" : pav==max ? "Cobertura" : pav+"° Andar";
        9.    Pavto = Level.ByElevationAndName  ( alt , nome );
       10.    //Coloca Eixos ---------------------------------------------------
       11.    e    = 2;
       12.    ex1  = vx[  0][0].StartPoint.Translate ( -e ,  0 ,  0 );
       13.    ex2  = vx[ -1][0].EndPoint  .Translate (  e ,  0 ,  0 );
       14.    ey1  = vy[  0][0].StartPoint.Translate (  0 , -e ,  0 );
       15.    ey2  = vy[ -1][0].EndPoint  .Translate (  0 ,  e ,  0 );
       16.    Let  = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"];
       17.    Num   = 1..List.Count(EixoY);
       18.    EixoX = Grid.ByStartPointEndPoint ( ex1 , ex2  );
       19.    EixoY = Grid.ByStartPointEndPoint ( ey1 , ey2  );
       20.    EixoX.SetParameterByName( "Name" , Let      );
       21.    EixoY.SetParameterByName( "Name" , Num + "" );

## Cria_Eixos.dyn
Função de criação de Eixos estruturais (Grids).

## Code Block
        1.    qx;
        2.    qy;
        3.    ds;
        4.    cx  = (qx-1)*dx*0.5;
        5.    cy  = (qy-1)*dy*0.5;
        6.    x   =         (0..#qx..dx)-cx;
        7.    y   = Reverse((0..#qy..dy)-cy);
        8.    nx  = 1..qx;
        9.    ny  = 1..qy;
       10.    i = 0..qx-2;
       11.    j = i+1;
       12.    k = 0..qy-2;
       13.    l = k+1;
       14.    num = Math.Ceiling(nx/1)+"";
       15.    let = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"];
       16.    //-----------------------------------------------------
       17.    // Forma as listas de pontos
       18.    //-----------------------------------------------------
       19.    PtX = Point.ByCoordinates ( x<1>, y   , 0 );
       20.    PtY = Point.ByCoordinates ( x   , y<1>, 0 );
       21.    //-----------------------------------------------------
       22.    // Separa o inicio do Eixo
       23.    //-----------------------------------------------------
       24.    ph1 = PtX[ 0].Translate (-ds,  0, 0);
       25.    ph2 = PtX[-1].Translate ( ds,  0, 0);
       26.    pv1 = PtY[ 0].Translate ( 0 , ds, 0);
       27.    pv2 = PtY[-1].Translate ( 0 ,-ds, 0);
       28.    //-----------------------------------------------------
       29.    // Coloca e Numera o Eixo
       30.    //-----------------------------------------------------
       31.    EiH = Grid.ByStartPointEndPoint ( ph1 , ph2 );
       32.    EiV = Grid.ByStartPointEndPoint ( pv1 , pv2 );
       33.    Grid.SetParameterByName ([EiH , EiV], "Name" , [let , num]);

## Cria_Andares.dyf
Função de criação de Andares (Levels). Repare que a função tem extensão **dyf**. Isso significa que trata-se de um **Custom Node** que deve ser qualificado com um nome, uma descrição e ser integrante de uma biblioteca de funções. Custom Nodes são funções que executam tarefas quando inseridos em funções **dyn**. Eles são subrotinas que contêm processos utilizados com frequência.

## Code Block
        1.    EVI;
        2.    EXI;
        3.    txt = "° Pavto";
        4.    QAT;
        5.    txt;
        6.    NOM;
        7.    CRI = Level.ByElevation          ( 0..#QAT+1..APP );
        8.    NOM = Math.Floor                 ( 0..QAT         );
        9.    APA = List.SetDifference         ( EXI , CRI      );
       10.    Element.Delete                   ( APA            );
       11.    NOV = Element.Delete             ( APA            );
       12.    FamilyInstance.SetParameterByName( CRI      , "Name", (NOM)+txt  );
       13.    FamilyInstance.SetParameterByName( CRI[0]   , "Name", "Térreo"   );
       14.    FamilyInstance.SetParameterByName( CRI[QAT] , "Name", "Cobertura");
       15.    Key = ["Andar", "Nome"   , "Cota"         ];
       16.    Val = [ CRI   , CRI.Name ,  CRI.Elevation ];
       17.    DIC = Dictionary.ByKeysValues ( Key , Val );



## Viga_Tendão.dyn

<img width="1306" height="1274" alt="Viga_Tendão" src="https://github.com/user-attachments/assets/42093c9c-cb83-4bd4-aa2d-c5ed13570815" />

A lista **(i)** passada como parãmetro da função **PolyCurve.ByPoints** contem o esquema dos pontos usados traçar a forma do eerfil da viga.   
Alterando essa lista podem ser obtidos diversos perfis. Por exemplo, a lista [0, 3, 23, 20] define o perfil de uma viga retangular.     
A lista **y** contem os valores paramétricos que são multiplicados pelo valor **b** que representa a largura da viga.
A lista **z** contem os valores paramétricos das alturas do perfil que são multiplicados pelo valor **-h** que é a altura da viga (predimensionada com l/f).

<img width="390" height="800" alt="seção" src="https://github.com/user-attachments/assets/049e0fde-2fca-4763-8513-f70a1ff4875c" />

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
