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
     7.    p0    = Point.ByCoordinates       ( 0, 0, 0);
     8.    cs    = CoordinateSystem.ByOrigin ( p0 );
     9.    //Converte em string o Tempo Atual e separa Hora, Min e Seg ------
    10.    hora  = String.Substring( tempo+"" , 0 , 2);
    11.    minu  = String.Substring( tempo+"" , 3 , 2);
    12.    segu  = String.Substring( tempo+"" , 6 , 2);
    13.    //Angulo do Tempo Atual de Hora, minuto e segundo ----------------
    14.    hoa   = String.ToNumber(hora) %12 * -mh+90;
    15.    mia   = String.ToNumber(minu)     * -ms+90;
    16.    sea   = String.ToNumber(segu)     * -ms+90;
    17.    //Marcas de Horas e minutos --------------------------------------
    18.    marh1 = Point.ByCylindricalCoordinates ( cs, angHO , 0 , ra*1.6);
    19.    marh2 = Point.ByCylindricalCoordinates ( cs, angHO , 0 , ra*1.9);
    20.    marm1 = Point.ByCylindricalCoordinates ( cs, angMS , 0 , ra*1.8);
    21.    marm2 = Point.ByCylindricalCoordinates ( cs, angMS , 0 , ra*1.9);
    22.    //Ponteiros de Horas Minutos e Segundos --------------------------
    23.    ph    = Point.ByCylindricalCoordinates ( cs, hoa   , 0 , ra*1.1);
    24.    pm    = Point.ByCylindricalCoordinates ( cs, mia   , 0 , ra*1.4);
    25.    ps    = Point.ByCylindricalCoordinates ( cs, sea   , 0 , ra*1.5);
    26.    LmaH  = Line.ByStartPointEndPoint      ( marh1 , marh2 );
    27.    LmaM  = Line.ByStartPointEndPoint      ( marm1 , marm2 );
    28.    Lpon  = Line.ByStartPointEndPoint      ( p0 , [ph, pm, ps] );

**Nota:** A variável tempo deve receber a informação passada por um nodo que retorne um **timeSpan** p.ex o nodo **DateTime.TimeOfDay**

## Crono_Obra.dyn
Esta função exemplifica o uso de funções temporais para extrair uma planilha excel de uma sequência construtiva (com distribuição lineal do tempo associado ao componente) 
Cada rubro da obra pode ser extraído para folhas independentes da mesma planilha. Neste exemplo, na planilha **Modelo_04_4D_Crono.xlsx** cria-se uma folha  **Partes_Crono** onde são armazenadas as datas do planejamento construtivo dos elementos estruturais (Vigas, Lajes e pilares), ordenados por andar e transformados em categoria Parts (Partes). Os dados da planilha podem ser extraídos posteriormente para um formato CSV e transportados para **Navisworks**, onde será criada a linha de tempo.
Repare que a variável **COTA**, que aparece numa declaração na linha 20.  somente é definida na linha 52. Isso demonstra o processamento associativo da linguagem DesignScript.

## Code Block
        1.    ELE;
        2.    TTO;
        3.    Itens   = List.Count(ELE); 
        4.    drive   = "C:\\";
        5.    pasta   = "JLMenegotto\\Academia\\";
        6.    arqui   = "Modelo_04_4D_Crono.xlsx";
        7.    arquivo = drive + pasta + arqui;
        8.    tabela  = "Partes_Crono";
        9.    //---------------------------------------------------------------------------
       10.    // Define os tempos e Formata o modo de escrita
       11.    //---------------------------------------------------------------------------
       12.    CronoTotal    = DSCore.TimeSpan.Create      ( TTO , 0, 0, 0, 0   );
       13.    CronoItem     = DSCore.TimeSpan.Create      ( DPI , 0, 0, 0, 0   );
       14.    CronoAndae    = DSCore.TimeSpan.Create      ( TPA , 0, 0, 0, 0   );
       15.    d_Iobra       = DSCore.DateTime.Today;
       16.    d_Fobra       = DSCore.DateTime.AddTimeSpan ( d_Iobra , CronoTotal  );
       17.    d_Iobra_txt   = DSCore.DateTime.Format      ( d_Iobra , "dd/MM/yyyy");
       18.    DPI           = TTO / Itens;
       19.    TPA           = TTO / QAndares;
       20.    L_Niveis      = List.UniqueItems ( List.IndexOf ( COTA , COTA ));
       21.    QAndares      = List.Count(L_Niveis);
       22.    qniv          = 1..QAndares-2;
       23.    L_EleNiv      = L_Niveis[qniv+1] - L_Niveis[qniv];
       24.    Qniveis       = List.UniqueItems( List.IndexOf ( COTA , COTA ))+1;
       25.    DTCota        = Math.Floor      ( List.IndexOf ( COTA , COTA )/100);
       26.    DeltaT        = TPA * INXA;
       27.    ItarefaI      = DTCota;
       28.    ItarefaF      = DTCota +2;
       29.    NumerTI       = ItarefaI + DeltaT;
       30.    NumerTF       = ItarefaF + DeltaT;
       31.    CronoTI       = DSCore.TimeSpan.Create      ( NumerTI , 0, 0, 0, 0 );
       32.    CronoTF       = DSCore.TimeSpan.Create      ( NumerTF , 0, 0, 0, 0 );
       33.    DataTI        = DSCore.DateTime.AddTimeSpan ( d_Iobra , CronoTI    );
       34.    DataTF        = DSCore.DateTime.AddTimeSpan ( d_Iobra , CronoTF    );
       35.    TARE          = List.OfRepeatedItem ( "Construct" , Itens);
       36.    Cotas         = List.UniqueItems    ( List.Sort ( COTA ));
       37.    QNIV          = List.Count(Cotas);
       38.    //---------------------------------------------------------------------------
       39.    // Condicionais de filtragem
       40.    //---------------------------------------------------------------------------
       41.    Vig    = String.Contains ( TIPO , "V" , true )==1 ? true : false;
       42.    Laj    = String.Contains ( TIPO , "L" , true )==1 ? true : false;
       43.    Pil    = String.Contains ( TIPO , "P" , true )==1 ? true : false;
       44.    ELID   = ELE.Id;
       45.    INXA   = List.IndexOf ( Cotas , COTA )+1;
       46.    INXB   = Vig? 1 : Laj ? 2 : 3;
       47.    DURI   = DPI;
       48.    CATE   = FamilyInstance.GetParameterValueByName (ELE  , "Original Category" );
       49.    TIPO   = FamilyInstance.GetParameterValueByName (ELE  , "Original Type"     );
       50.    LEVL   = FamilyInstance.GetParameterValueByName (ELE  , "Base Level"        );
       51.    NDA    = Level.GetParameterValueByName          (LEVL , "Name"              );
       52.    COTA   = Level.GetParameterValueByName          (LEVL , "Elevation"         );
       53.    //---------------------------------------------------------------------------
       54.    // Forma a lista com as culunas de dados que serão extraídos 
       55.    //---------------------------------------------------------------------------
       56.    kob    = ["INXA","INXB","CATE","TIPO","ANDA","ELID","TARE","DataTI","DataTF"];
       57.    vob    = [ INXA , INXB , CATE , TIPO , ANDA , ELID , TARE , DataTI , DataTF ];
       58.    //---------------------------------------------------------------------------
       59.    //Escreve os dados em Planilha Excel
       50.    //---------------------------------------------------------------------------
       61.    DSOffice.Data.ExportExcel( arquivo , tabela, 0, 0, [kob]          , false);
       62.    DSOffice.Data.ExportExcel( arquivo , tabela, 1, 0, Transpose(vob) , false);  
