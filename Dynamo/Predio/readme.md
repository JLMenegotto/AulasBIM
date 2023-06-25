# Predio

Nesta pasta as funções definem elementos predias.

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


## Matriz_XYZ.dyn

Define uma matriz tridimensional XYZ com a quantidade de módulos estruturais em direções XY e quantidade de Andares
A função cria os andares e os Eixos estruturais.

## Cria_Eixos.dyn

Função de criação de Eixos estruturais (Grids).

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

Função de criação de Andares (Levels). Repare que a função tem extensão **dyf**. Isso sifnifica que se trata de um Custom Node que deve ser qualificado com um nome, uma descrição e pertencer a uma biblioteca de nodos. Os custom nodes serão inseridos em funções **dyn** como subrotinas.



