# Torres

## Torre.dyn
Esta função exemplifica o uso de coordenadas cilíndricas aplicadas para construir torres a partir de polígonos regulares de n lados (limitados entre 3 e 12).
É utilizada a técnica de aritmética modular para criar variações da forma. A função Remainder (%) e a condicional fazem esse trabalho.  

**ra = e%2==0 ? r : r*1.5;**    O aluno pode variar esta declaração para incorporar valores modulares diferentes de 2. 

## Code Block
        1.    r;
        2.    q;
        3.    l;
        4.    e    = 0..q;
        5.    //Condicional de variação do raio ------------------------------------------
        6.    ra   = e%2==0 ? r : r*1.5;
        7.    //Definição dos pontos -----------------------------------------------------
        8.    cs   = CoordinateSystem.Identity();
        9.    a    = 0..360..(360/l);
       10.    al   = e * (r * Math.Sqrt(3));
       11.    po   = Point.ByCylindricalCoordinates ( cs , a<1> , al , ra );
       12.    i    = 0..l-1;
       13.    //Barras Horizontais e transposição ----------------------------------------  
       14.    bah  = Line.ByStartPointEndPoint      ( po[i] , po[i+1]    );
       15.    bav  = Transpose( bah );
       16.    //Barras verticais e Diagonais ---------------------------------------------
       17.    j    = 0..List.Count(bav)-2;
       18.    BarV = Line.ByStartPointEndPoint( bav[j].StartPoint , bav[j+1].StartPoint );
       19.    Dia1 = Line.ByStartPointEndPoint( bav[j].StartPoint , bav[j+1].EndPoint   );
       20.    Dia2 = Line.ByStartPointEndPoint( bav[j].EndPoint   , bav[j+1].StartPoint );

![torre](https://github.com/JLMenegotto/AulasBIM/assets/9437020/b451badd-5201-4e8e-b187-5553ffa24cd7)

