# Relógio.dyn

As funções de Dynamo podem ser executadas de modo **Manual, Automático ou Periódico**. A função **Relógio.dyn** exemplifica a execução periódica em Dynamo. Para que o modo de execução periódico fique habilitado, deve haver dentro da função a participação das funções de Tempo (Time, TimeSpan...). Para a função Relogio.dyn, foram criados 3 ponteiros (Horas, Minutos e Segundos) e uma marcação circular de Horas e Minutos com o desenho do tipo de relógio.

Para que os ponteiros se movam angularmente, os módulos angulares devem ser:

 1. Para as horas = 12 => (360 / 12 = 30) 
 2. Para os minutos e segundos = 6 => (360 / 6 = 60)

![Relogio](https://github.com/JLMenegotto/AulasBIM/assets/9437020/ae27a62a-6541-4627-aa92-0322273bf85a)

## Code Block

     1.    tempo;
     2.    ra;
     3.    mh    = 30;
     4.    ms    =  6;
     5.    angHO = 0..360..mh;
     6.    angMS = 0..360..ms;
     7.    p0 = Point.ByCoordinates(0,0,0);
     8.    cs = CoordinateSystem.ByOrigin(p0);
     9.    //Converte em string o Tempo Atual e separa Hora, Min e Seg ------
    10.    hora = String.Substring( tempo+"" , 0 , 2);
    11.    minu = String.Substring( tempo+"" , 3 , 2);
    12.    segu = String.Substring( tempo+"" , 6 , 2);
    13.    //Angulo do Tempo Atual de Hora, minuto e segundo ----------------
    14.    hoa  = String.ToNumber(hora) %12 * -mh+90;
    15.    mia  = String.ToNumber(minu)     * -ms+90;
    16.    sea  = String.ToNumber(segu)     * -ms+90;
    17.    //Marcas de Horas e minutos --------------------------------------
    18.    marh1 = Point.ByCylindricalCoordinates( cs, angHO , 0 , ra*1.6);
    19.    marh2 = Point.ByCylindricalCoordinates( cs, angHO , 0 , ra*1.9);
    20.    marm1 = Point.ByCylindricalCoordinates( cs, angMS , 0 , ra*1.8);
    21.    marm2 = Point.ByCylindricalCoordinates( cs, angMS , 0 , ra*1.9);
    22.    //Ponteiros de Horas Minutos e Segundos --------------------------
    23.    ph    = Point.ByCylindricalCoordinates( cs, hoa   , 0 , ra*1.1);
    24.    pm    = Point.ByCylindricalCoordinates( cs, mia   , 0 , ra*1.4);
    25.    ps    = Point.ByCylindricalCoordinates( cs, sea   , 0 , ra*1.5);
    26.    LmaH = Line.ByStartPointEndPoint      ( marh1 , marh2 );
    27.    LmaM = Line.ByStartPointEndPoint      ( marm1 , marm2 );
    28.    Lpon = Line.ByStartPointEndPoint      ( p0 , [ph, pm, ps] );

