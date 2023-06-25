
# Geométricas

As funções geométricas exemplificam usos de traçados geométricos para o projeto. As explicações dos códigos e das formas podem ser vistas nestes vídeos. 

  1. Oval de 4 Centros:       https://youtu.be/h-NVtklN2mU
  2. Uso da Ciclóide:         https://youtu.be/7UbUaqYFVvs
  3. Espirais de n centros:   https://youtu.be/Swo7Bw9D8ZY

Sugere-se que os alunos modifiquem as funções incorporando-lhes novas possibilidades formais.

## Oval4Centros.dyn
Esta função exemplifica o uso formal de uma figura plana como a Oval de 4 Centros para iniciar o processo de busca formal de um 
projeto. A oval de 4 centros é construída a partir de losangos dimétricos ou isométricos que permitem a construção com compasso
de 4 arcos tangentes ao losango e conconcordantes entre si. O processo de construção inicia pela definição das mediatrizes que
permitirão encontrar os quatro centros dos 4 arcos que cumprem as condições de tangencias e concordâncias.

![o4c](https://github.com/JLMenegotto/AulasBIM/assets/9437020/fb9f37b6-173e-4d5b-82f1-bb098d3571df)

## Code Block 1:

       1.  Dx;
       2.  Dy;
       3.  p1 = Point.ByCoordinates(Dx , 0  , 0);
       4.  p2 = Point.ByCoordinates(0  , Dy , 0);
       5.  p3 = Point.ByCoordinates(-Dx, 0  , 0);
       6.  p4 = Point.ByCoordinates(0  , -Dy, 0);
       7.  LP = [p1,p2,p3,p4];
       8.  LPS = List.ShiftIndices(LP, 3);
       9.  Lad = Line.ByStartPointEndPoint(LP, LPS);
      10.  Pme = Line.PointAtParameter  (Lad , 0.5);
      11.  Nor = Line.NormalAtParameter (Lad , 0.5);
      12.  Tng = Line.TangentAtParameter(Lad , 0.5);
      13.  Pms = List.ShiftIndices(Pme, 3);
      14.  O4C = Arc.ByStartPointEndPointStartTangent(Pme, Pms, Tng);
      15.  Cen = O4C.CenterPoint;
      16.  Lin = Line.ByStartPointEndPoint(Cen, Pme);

## Code Block 2:
       1.  o4c;
       2.  dx;
       3.  dy;
       4.  i1  = [0, 2];
       5.  i2  = i1+1;
       6.  A1  = Arc.Offset(o4c[i1], dy);
       7.  A2  = Arc.Offset(o4c[i2], dx);
       8.  LP1 = [A1[0].EndPoint  , A1[0].StartPoint, A1[1].EndPoint  , A1[1].StartPoint];
       9.  LP2 = [A2[0].StartPoint, A2[1].EndPoint  , A2[1].StartPoint, A2[0].EndPoint  ];
      10.  Lin = Line.ByStartPointEndPoint(LP1 , LP2);
      11.  Con = [A1[0], Lin[0], A2[0], Lin[1], A1[1], Lin[2], A2[1], Lin[3]];
      12.  Bor = PolyCurve.ByJoinedCurves(Con, 0.0);
      13.  Sup = Autodesk.Surface.ByPatch( Bor );
      14.  Are = Sup.Area;

## Forma_Cicloide_01.dyn
Esta função exemplifica a construção e o uso formal de uma Ciclóide, utilizada como lei formal de uma estrutura cíclica.  

![Cicloide](https://github.com/JLMenegotto/AulasBIM/assets/9437020/15731552-3b55-41f7-a398-ac2d0ad7974c)

![Cicloide2](https://github.com/JLMenegotto/AulasBIM/assets/9437020/1c0a0aaa-993f-4e48-ac13-f4947621b362)

## Code Block 1:
        1.    Dis;
        2.    cic;
        3.    q;
        4.    s;
        5.    m;
        6.    r  = Dis / Math.PiTimes2;
        7.    qt = q*cic;
        8.    //------------------------------------------------
        9.    //Mecanismo Cicloide Paramétrica
       10.    //------------------------------------------------
       11.    c   = Math.PiTimes2;
       12.    t   = (0..c..#qt) * cic;
       13.    a   = Math.RadiansToDegrees ( t );
       14.    x   = r * (  t - Math.Sin   ( a ));
       15.    y   = r * (  1 - Math.Cos   ( a ));
       16.    //------------------------------------------------
       17.    //Variação modular
       18.    //------------------------------------------------
       19.    mod = List.IndexOf( x , x ) % m ? 1.25 : 0.95; 
       20.    //------------------------------------------------
       21.    //Listas da Estrutura Formal
       22.    //------------------------------------------------
       23.    //Ordenadas
       24.    y1  = s + 0.1 +( y  * mod     );
       25.    y0  =          ( y  * mod     );
       26.    YC  =          ( y  * 0       );
       27.    //alturas
       28.    h1  = Math.Abs (     y1 * 0.0 );
       29.    h2  = Math.Abs (     y1 * 0.2 );
       30.    HC  = Math.Abs ( s*0.5 + y0 * 0.8 );
       31.    //------------------------------------------------
       32.    Ly  = [ y1 , y1 , YC , -y1 , -y1 ];
       33.    Lz  = [ h1 , h2 , HC ,  h2 ,  h1 ];
       34.    //------------------------------------------------
       35.    //Lançamento dos Pontos
       36.    //------------------------------------------------
       37.    PO  = Point.ByCoordinates ( x , Ly<1> , Lz<1> );
       38.    //------------------------------------------------
       39.    //Lançamento das Curvas
       40.    //------------------------------------------------
       41.    POL = PolyCurve.ByPoints  ( PO              , false);
       42.    POT = PolyCurve.ByPoints  ( Transpose( PO ) , false);
       43.    //NCT = NurbsCurve.ByPoints ( Transpose( PO ), 1);
       44.    //------------------------------------------------
       45.    //Lançamento das Superficies
       46.    //------------------------------------------------
       47.    //SUT = Surface.ByLoft      ( POT                );
       48.    //------------------------------------------------
       49.    //Definição do plano do Piso
       50.    //------------------------------------------------
       51.    LPI = List.SetUnion       ( PO[0] , Reverse(PO[-1]));
       52.    POP = PolyCurve.ByPoints  ( LPI   , true           );
       53.    SUP = Surface.ByPatch     ( POP                    );

## Forma_Espiral_NCentros.dyn
Esta função exemplifica a construção e o uso formal de Espirais de n Centros. Embaixo, duas espirais, com 6 e 8 centros.

![Espirais](https://github.com/JLMenegotto/AulasBIM/assets/9437020/604a1d98-30c1-4c88-a420-4e3480b25063)

## Code Block 1:
        1.  q; 
        2.  r; 
        3.  g;
        4.  vz  = Vector.ZAxis();
        5.  // Calcula o módulo angular (ma) e o angulo de giro (g) ----
        6.  ma  = 360/q;
        7.  ra  = ma/2 + g;
        8.  // Indices dos vértices ------------------------------------
        9.  i   = 0..q-1;
       10.  j   = List.ShiftIndices ( i , 1 );
       11.  // Calcula os angulos aplicando o giro ---------------------
       12.  an  = (0..#q..ma) + ra;
       13.  // Calcula coordenadas XY dos pontos do polígono gerador ---
       14.  x   = Math.Cos ( an ) * r;
       15.  y   = Math.Sin ( an ) * r;
       16.  cen = Point.ByCoordinates ( x , y , 0 );
       17.  // Dimensão do Lado e Acumulada do Lado --------------------
       18.  lad = Point.DistanceTo    ( cen[0] , cen[1] );
       19.  da  = lad + (lad * i);
       20.  Vij = Vector.ByTwoPoints ( cen[i] , cen[j]   );
       21.  sp  = Point.Translate    ( cen[i] , Vij , da );
       22.  //Desenha a espiral  ---------------------------------------
       23.  pol = PolyCurve.ByPoints ( cen    , true );
       24.  arc = Arc.ByCenterPointStartPointSweepAngle(cen, sp, ma, vz);
       25.  epa = Arc.PointAtParameter      (arc , 1);
       26.  rad = Line.ByStartPointEndPoint (cen , epa); 
