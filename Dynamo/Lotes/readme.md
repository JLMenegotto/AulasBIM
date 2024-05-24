# Lotes

As funções de Dynamo programadas nesta seção definem métodos para analisar as Property_Lines (divisas) de Revit e propor massas edificadas para a ocupação do lote. Para que a função **Locar_No_Terreno.dyn** funcione, deve ser modelado ao menos um lote com o objeto da categoria Property_Line de Revit. Podem ser modelados vários Lotes e utilizar o seletor programado na função para comutar entre eles. As explicações sobre a lógica de funcionamento podem ser encontradas no Canal YouTube nos seguintes vídeos.

  1. Parte 1: https://www.youtube.com/watch?v=YTpLaJNMYeg
  2. Parte 2: https://www.youtube.com/watch?v=m8GhF9alzR0
  3. Parte 3: https://www.youtube.com/watch?v=uCdQVAu4w0k
  4. Parte 4: https://www.youtube.com/watch?v=GEHhLgOuIKw

## Lote_Perimetral.dyn
Exemplifica o aproveitamento das Property_Lines (divisas) de Revit. 

![lote](https://github.com/JLMenegotto/AulasBIM/assets/9437020/cd6b1ff1-e25d-4491-88b6-4c22260cc911)

## Code Block
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

## Lote_Linhas_Forca.dyn 
Exemplifica o aproveitamento das Property_Lines (divisas) de Revit utilizando a ideia de linhas de força de um lote, ou seja, as direções que são geometricamente significativas (Eixos principais ou transversais, direções de penetração normais a cada linha da divisa, etc.). A função precisa dos seguintes nodos customizados complementares.

     1. Analisar_Divisas.dyf
     2. Cria_Andares.dyf
     3. Seleção_de_Lotes.dyf
     4. Predio_Estudo.dyf
     
![Locar_Terreno2](https://github.com/JLMenegotto/AulasBIM/assets/9437020/62c00c0d-deda-4fbe-b0dc-6adb4663e521)
![Locar_Terreno](https://github.com/JLMenegotto/AulasBIM/assets/9437020/fda2ae6b-c259-4eeb-8028-a31baa6ed462)

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
      
  17. [**Bibliografia**](https://jlmenegotto.wixsite.com/jlmenegotto-bim/pesquisa)
  18. [**Publicações**](https://jlmenegotto.wixsite.com/jlmenegotto-bim/jlm-public)
