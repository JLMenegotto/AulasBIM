## Aulas PPE 1° Semestre de 2024


divisas;
n;
DAF;
TOC;
COA;
AAN;
//---------------------------------------------
// Constantes
//---------------------------------------------
Vx   = Vector.XAxis();
Vy   = Vector.YAxis();
Vz   = Vector.ZAxis();
Vf   = Vector.ByCoordinates(FTO, 0 , 0);
ATC  = COA * ALOT;
ALT  = COA * AAN;
FTO  = Math.Sqrt(TOC);
Qdiv = List.Count(divisas);
//---------------------------------------------
// Para processar um lote de cada vez
//---------------------------------------------
//LOTE = divisas[n % Qdiv];
//---------------------------------------------
// Para processar todos os lotes
//---------------------------------------------
LOTE = divisas[0..Qdiv-1];
//---------------------------------------------
// Processamento
//---------------------------------------------
LGEO = LOTE.Geometry (   );
DIVI = PolyCurve.ByJoinedCurves ( LGEO , 0 );
ALOT = LOTE.GetParameterValueByName("Area");
//---------------------------------------------
// Captura Linhas da divisa e faz offset
//---------------------------------------------
OCUP = DIVI.Offset  (-DAF , false );
LIMI = DIVI.Explode (             );
AREO = ALOT * TOC;
LADO = Math.Sqrt    ( AREO        );
//---------------------------------------------
// Pontos extremos dos limites da divisa
// e Eixo Médio do lote
//---------------------------------------------
PLIMI = LIMI.PointAtParameter ( 0 );
EIXOM = Line.ByBestFitThroughPoints ( PLIMI );
//---------------------------------------------
// Dimensiona Volume pela taxa de ocupação
//---------------------------------------------
BASE = EIXOM.PointAtParameter ( 0.5  );
Po1  = BASE.Add ( Vx );
Po2  = BASE.Add ( Vf );
SULO = Autodesk.Surface.ByPatch ( DIVI );
SUED = Geometry.Scale  (SULO, BASE, Po1, Po2 );
ARED = SUED.Area;
VOED = Autodesk.Surface.Thicken(SUED, -ALT, false);
//---------------------------------------------
//Extração de resultados utilizando Dicionário
//---------------------------------------------
Key = ["Divisa", "Area" ,"Limites" ,
       "AreaO" , "Lado" ,"EixoM"   ,
       "VoEd"
      ];
Val = [ DIVI   , ALOT   , LIMI     ,
        AREO   , LADO   , EIXOM    ,
        VOED
      ];
DIC = Dictionary.ByKeysValues ( Key , Val );
