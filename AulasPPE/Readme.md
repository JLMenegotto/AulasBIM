## Aulas PPE 1° Semestre de 2024

## Code Block 1:

       1.  divisas;
       2.n;
       3.DAF;
       4.TOC;
       5.COA;
       6.AAN;
       7.//---------------------------------------------
       8.// Constantes
       9.//---------------------------------------------
       10.Vx   = Vector.XAxis();
       11.Vy   = Vector.YAxis();
       12.Vz   = Vector.ZAxis();
       13.Vf   = Vector.ByCoordinates(FTO, 0 , 0);
       14.ATC  = COA * ALOT;
       15.ALT  = COA * AAN;
       16.FTO  = Math.Sqrt(TOC);
       17.Qdiv = List.Count(divisas);
       18.//---------------------------------------------
       19.// Para processar um lote de cada vez
       20.//---------------------------------------------
       21.//LOTE = divisas[n % Qdiv];
       22.//---------------------------------------------
       23.// Para processar todos os lotes
       24.//---------------------------------------------
       25.LOTE = divisas[0..Qdiv-1];
       26.//---------------------------------------------
       27.// Processamento
       28.//---------------------------------------------
       29.LGEO = LOTE.Geometry (   );
       30.DIVI = PolyCurve.ByJoinedCurves ( LGEO , 0 );
       31.ALOT = LOTE.GetParameterValueByName("Area");
       32.//---------------------------------------------
       33.// Captura Linhas da divisa e faz offset
       34.//---------------------------------------------
       35.OCUP = DIVI.Offset  (-DAF , false );
       36.LIMI = DIVI.Explode (             );
       37.AREO = ALOT * TOC;
       38.LADO = Math.Sqrt    ( AREO        );
       39.//---------------------------------------------
       40.// Pontos extremos dos limites da divisa
       41.// e Eixo Médio do lote
       42.//---------------------------------------------
       43.PLIMI = LIMI.PointAtParameter ( 0 );
       44.EIXOM = Line.ByBestFitThroughPoints ( PLIMI );
       45.//---------------------------------------------
       46.// Dimensiona Volume pela taxa de ocupação
       47.//---------------------------------------------
       48.BASE = EIXOM.PointAtParameter ( 0.5  );
       49.Po1  = BASE.Add ( Vx );
       50.4Po2  = BASE.Add ( Vf );
       51.SULO = Autodesk.Surface.ByPatch ( DIVI );
       52.SUED = Geometry.Scale  (SULO, BASE, Po1, Po2 );
       53.ARED = SUED.Area;
       54.VOED = Autodesk.Surface.Thicken(SUED, -ALT, false);
       55.//---------------------------------------------
       56.//Extração de resultados utilizando Dicionário
       57.//---------------------------------------------
       58.Key = ["Divisa", "Area" ,"Limites" ,
       59."AreaO" , "Lado" ,"EixoM"   ,
       60."VoEd"
       61.];
       62.Val = [ DIVI   , ALOT   , LIMI     ,
       63. AREO   , LADO   , EIXOM    ,
       64. VOED
       65.];
       66.DIC = Dictionary.ByKeysValues ( Key , Val );
       
