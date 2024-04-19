## Aulas PPE 1° Semestre de 2024

No código da função **Aula_PPE_04b.dyn** não foi utilizada a Massa Inplace como prédio. Nesta função, para formar o predio é criado o volume a partir da linha do limite do lote escalada com o fator correspondente à
Taxa de ocupação do terreno (linhas 48. a 54.). Os limites são utilizados para criar uma Surface (linha 51.) que será escalada (linha 52) e finalmente extrudada (linha 54.).
Outro ponto de destaque para analisar da função são as linhas 21 e 25. A declaração da linha 21. permite processar um lote de cada vez, mas com uma pequena alteração, incorporada na linha 25., o processamento pode ser realizado
en todos os lotes, já que a variável LOTE conterá uma lista numérica iniciada em 0 e finalizada com o valor da quantidade de lotes-1.

![Aula_PPE_04b](https://github.com/JLMenegotto/AulasBIM/assets/9437020/310eeb73-fc90-4a57-a3f2-bbfa3ce7b741)

### Code Block da função Aula_PPE_04b.dyn: 

        1.  divisas;
        2.  n;
        3.  DAF;
        4.  TOC;
        5.  COA;
        6.  AAN;
        7.  //---------------------------------------------
        8.  // Constantes
        9.  //---------------------------------------------
       10.  Vx   = Vector.XAxis();
       11.  Vy   = Vector.YAxis();
       12.  Vz   = Vector.ZAxis();
       13.  Vf   = Vector.ByCoordinates(FTO, 0 , 0);
       14.  ATC  = COA * ALOT;
       15.  ALT  = COA * AAN;
       16.  FTO  = Math.Sqrt(TOC);
       17.  Qdiv = List.Count(divisas);
       18.  //---------------------------------------------
       19.  // Para processar um lote de cada vez
       20.  //---------------------------------------------
       21.  //LOTE = divisas[n % Qdiv];
       22.  //---------------------------------------------
       23.  // Para processar todos os lotes
       24.  //---------------------------------------------
       25.  LOTE = divisas[0..Qdiv-1];
       26.  //---------------------------------------------
       27.  // Processamento
       28.  //---------------------------------------------
       29.  LGEO = LOTE.Geometry (   );
       30.  DIVI = PolyCurve.ByJoinedCurves ( LGEO , 0 );
       31.  ALOT = LOTE.GetParameterValueByName("Area");
       32.  //---------------------------------------------
       33.  // Captura Linhas da divisa e faz offset
       34.  //---------------------------------------------
       35.  OCUP = DIVI.Offset  (-DAF , false );
       36.  LIMI = DIVI.Explode (             );
       37.  AREO = ALOT * TOC;
       38.  LADO = Math.Sqrt    ( AREO        );
       39.  //---------------------------------------------
       40.  // Pontos extremos dos limites da divisa
       41.  // e Eixo Médio do lote
       42.  //---------------------------------------------
       43.  PLIMI = LIMI.PointAtParameter ( 0 );
       44.  EIXOM = Line.ByBestFitThroughPoints ( PLIMI );
       45.  //---------------------------------------------
       46.  // Dimensiona Volume pela taxa de ocupação
       47.  //---------------------------------------------
       48.  BASE = EIXOM.PointAtParameter ( 0.5  );
       49.  Po1  = BASE.Add ( Vx );
       50.  Po2  = BASE.Add ( Vf );
       51.  SULO = Autodesk.Surface.ByPatch ( DIVI );
       52.  EDSU = SULO.Scale  (BASE, Po1, Po2 );
       53.  ARED = EDSU.Area;
       54.  EDVO = EDSU.Thicken( -ALT , 0);
       55.  //---------------------------------------------
       56.  //Extração de resultados utilizando Dicionário
       57.  //---------------------------------------------
       58.  Key = ["Divisa", "Area"  ,"Limites" ,"CoefApr",
       59.         "AreaO" , "Lado"  ,"EixoM"   ,"AlAndar",
       60.         "EdVolu", "EdPeri", "TipoLJ"
       61.       ];
       62.  Val = [ DIVI   , ALOT   , LIMI     , COA ,
       63.          AREO   , LADO   , EIXOM    , AAN ,
       64.          EDVO   , EDSU   , TIP
       65.        ];
       66. DIC = Dictionary.ByKeysValues ( Key , Val );

### Code Block complementar: Usar para incorporar os Andares: 

        1. Dados;
        2. COA = Dados["CoefApr"];
        3. AAN = Dados["AlAndar"];
        4. VOL = Dados["EdVolu"];
        5. LIM = Dados["EdPeri"];
        6. TIP = Dados["TipoLJ"];
        7. //------------------------------------------------
        8. // Constantes
        9. //------------------------------------------------
       10. COB = "Cobertura";
       11. TER = "Térreo";
       12. AND = "° Pavto";
       13. Vz  = Vector.ZAxis();
       14. //------------------------------------------------
       15. // Define os Andares
       16. //------------------------------------------------
       17. NUM = Math.Floor( 0..COA );
       18. NOM = NUM==0 ? TER : NUM==NUM[-1]? COB : NUM+AND;
       19. LEV = Level.ByElevationAndName ( NUM*AAN , NOM);
       20. //------------------------------------------------
       21. // Coloca poligonais abstratas das Lajes
       22. //------------------------------------------------
       23. a   = 0..COA;
       24. ALA = LEV[a].Elevation;
       25. PER = LIM.PerimeterCurves     (  );
       26. POL = PolyCurve.ByJoinedCurves( PER , 0.0, true, 0);
       27. PCJ = POL.Translate ( Vz, ALA<1> );
        
