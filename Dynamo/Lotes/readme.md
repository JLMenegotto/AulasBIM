# Lotes

As funções de Dynamo programadas nesta seção definem métodos para analisar as Property_Lines (divisas) de Revit e propor massas edificadas para a ocupação do lote. Para que a função **Locar_No_Terreno.dyn** funcione, deve ser modelado ao menos um lote com o objeto da categoria Property_Line de Revit. Podem ser modelados vários Lotes e utilizar o seletor programado na função para comutar entre eles. As explicações sobre a lógica de funcionamento podem ser encontradas no Canal YouTube nos seguintes vídeos.

  1. Parte 1: https://www.youtube.com/watch?v=YTpLaJNMYeg
  2. Parte 2: https://www.youtube.com/watch?v=m8GhF9alzR0
  3. Parte 3: https://www.youtube.com/watch?v=uCdQVAu4w0k
  4. Parte 4: https://www.youtube.com/watch?v=GEHhLgOuIKw

## Lote_Perimetral.dyn
Exemplifica o aproveitamento das Property_Lines (divisas) de Revit. 

![lote](https://github.com/JLMenegotto/AulasBIM/assets/9437020/cd6b1ff1-e25d-4491-88b6-4c22260cc911)

    1.  Pol_L;
    2.  DAF;
    3.  PRP;
    4.  DMP;
    5.  inv;
    6.  // -------------------------------------------------------------------
    7.  // Inverte valor numérico da profundidade caso a normal seja invertida
    8.  // -------------------------------------------------------------------
    9.  DPR     = inv ? -PRP : PRP;
    10.  // -------------------------------------------------------------------
    11.  // Define as poligonais de ocupação e interna
    12.  // -------------------------------------------------------------------
    13.  Pol_O   = Pol_L.Offset( -DAF );
    14.  Pol_I   = Pol_L.Offset( -DAF - PRP);
    15.  Curv_O  = Pol_O.Explode();
    16.  Curv_I  = Pol_I.Explode();
    17.  // -------------------------------------------------------------------
    18.  // Calcula os pontos
    19.  // -------------------------------------------------------------------
    20.  Normais = Curv_I.NormalAtParameter( 0.5 );
    21.  Pnts_PR = Curv_I.PointAtParameter ( 0.5 );
    22.  Pnts_PT = Curve.PointsAtSegmentLengthFromPoint( Curv_I , Pnts_PR, DMP);
    23.  Divi_PT = Line.ByStartPointDirectionLength    ( Pnts_PT, Normais, DPR);
    24.  // -------------------------------------------------------------------
    25.  //Define superfices usando as poligonais do Lote e de Ocupação
    26.  FaceL   = Surface.ByPatch( Pol_L );
    27.  FaceO   = Surface.ByPatch( Pol_O );
    28.  // -------------------------------------------------------------------
    29.  // Calcula taxa de ocupação
    30.  // -------------------------------------------------------------------
    31.  TxOcup  = Math.Ceiling (FaceO.Area / FaceL.Area *100) + " %";

![Locar_Terreno2](https://github.com/JLMenegotto/AulasBIM/assets/9437020/62c00c0d-deda-4fbe-b0dc-6adb4663e521)

![Locar_Terreno](https://github.com/JLMenegotto/AulasBIM/assets/9437020/fda2ae6b-c259-4eeb-8028-a31baa6ed462)
