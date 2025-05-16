# Torres

## Torre.dyn
Esta função exemplifica o uso de **coordenadas cilíndricas** em Dynamo (função **Point.ByCylindricalCoordinates**) aplicadas para construir torres a partir de polígonos regulares de n lados (limitados entre 3 e 12).
Também é recomendável prestar atenção à utilização da **aritmética modular** como técnica de criação de variações formal. 
A função Remainder (%) e a condicional fazem esse trabalho.  

**ra = e%2==0 ? r : r*1.5;**    O aluno pode variar esta declaração para incorporar valores modulares diferentes de 2. 

![torre](https://github.com/JLMenegotto/AulasBIM/assets/9437020/b451badd-5201-4e8e-b187-5553ffa24cd7)

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
       
## Torre2.dyn
Esta função exemplifica o uso de dicionário. 

![Torre2_2025-05-16_03-45-10](https://github.com/user-attachments/assets/05131189-4a4f-42db-a663-6e84e5558eb3)


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

