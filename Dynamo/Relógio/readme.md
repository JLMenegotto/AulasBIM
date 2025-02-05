
# Relógio.dyn

As funções de Dynamo podem ser executadas de modo **Manual, Automático ou Periódico**. A função **Relógio.dyn** exemplifica a execução periódica em Dynamo. Para habilitar o modo de execução periódica, a função programada deverá chamar alguma funcionalidade Temporal (Time, TimeSpan...). Para a função Relogio.dyn, foram criados 3 ponteiros (Horas, Minutos e Segundos) e uma marcação circular de Horas e Minutos com o desenho do tipo de relógio.
Para que os ponteiros se movam angularmente, os módulos angulares devem ser: 

 1. Para as horas              = **30** => (360 / 30 = 12)
 2. Para os minutos e segundos =  **6** => (360 /  6 = 60)

As linhas 29, 30 e 31 multiplica o modulo angular por -mh+90 e -ms+90. Isso corrige o ângulo inicial da contagem que no relógio aponta para o Norte enquanto o angulo 0 no sistema cartesiano para a direita (Leste). 

https://github.com/JLMenegotto/AulasBIM/assets/9437020/78323b6e-4dca-4119-b439-0cdf0690c727

## Code Block

     1.    tempo;
     2.    ra;
     3.    mh     = 30;
     4.    ms     =  6;
     5.    angHO  = 0..360..mh;
     6.    angMS  = 0..360..ms;
     7.    p0     = Point.ByCoordinates       ( 0, 0, 0);
     8.    cs     = CoordinateSystem.ByOrigin ( p0 );
     9.    //Converte em string o Tempo Atual e separa Hora, Min e Seg ------
    10.    hora   = String.Substring( tempo+"" , 0 , 2);
    11.    minu   = String.Substring( tempo+"" , 3 , 2);
    12.    segu   = String.Substring( tempo+"" , 6 , 2);
    13.    //Angulo do Tempo Atual de Hora, minuto e segundo ----------------
    14.    aho    = String.ToNumber(hora) %12 * -mh+90;
    15.    ami    = String.ToNumber(minu)     * -ms+90;
    16.    ase    = String.ToNumber(segu)     * -ms+90;
    17.    //Marcas de Horas e minutos --------------------------------------
    18.    marh1  = Point.ByCylindricalCoordinates ( cs, angHO , 0 , ra*1.6);
    19.    marh2  = Point.ByCylindricalCoordinates ( cs, angHO , 0 , ra*1.9);
    20.    marm1  = Point.ByCylindricalCoordinates ( cs, angMS , 0 , ra*1.8);
    21.    marm2  = Point.ByCylindricalCoordinates ( cs, angMS , 0 , ra*1.9);
    22.    //Ponteiros de Horas Minutos e Segundos --------------------------
    23.    ph     = Point.ByCylindricalCoordinates ( cs, aho   , 0 , ra*1.1);
    24.    pm     = Point.ByCylindricalCoordinates ( cs, ami   , 0 , ra*1.4);
    25.    ps     = Point.ByCylindricalCoordinates ( cs, ase   , 0 , ra*1.5);
    26.    LmaH   = Line.ByStartPointEndPoint      ( marh1 , marh2 );
    27.    LmaM   = Line.ByStartPointEndPoint      ( marm1 , marm2 );
    28.    Lpon   = Line.ByStartPointEndPoint      ( p0 , [ph, pm, ps] );

**Nota:** A variável tempo deve receber a informação passada por um nodo que retorne um **timeSpan** p.ex o nodo **DateTime.TimeOfDay**

## Crono_Obra.dyn
Esta função exemplifica o uso de funções temporais para extrair uma planilha excel de uma sequência construtiva (com distribuição lineal do tempo associado ao componente) 
Cada rubro da obra pode ser extraído para folhas independentes da mesma planilha. Neste exemplo, na planilha **Modelo_04_4D_Crono.xlsx** cria-se uma folha  **Partes_Crono** onde são armazenadas as datas do planejamento construtivo dos elementos estruturais (Vigas, Lajes e pilares), ordenados por andar e transformados em categoria Parts (Partes). Os dados da planilha podem ser extraídos posteriormente para um formato CSV e transportados para **Navisworks**, onde será criada a linha de tempo.
Repare que a variável **COTA**, que aparece numa declaração na linha 20.  somente é definida na linha 52. Isso demonstra o processamento associativo da linguagem DesignScript.
A variável **ELE** é a lista de elementos (de alguma categoria).
A variável **TTO** significa **Tempo Total de Obra** e deve ser ingressado como um número inteiro. 

![Excell_01](https://github.com/JLMenegotto/AulasBIM/assets/9437020/9dd45b96-e945-40bd-9d1d-99b3a62a6fe6)

## Code Block
        1.    ELE;
        2.    TTO;
        3.    Itens     = List.Count(ELE); 
        4.    drive     = "C:\\";
        5.    pasta     = "JLMenegotto\\Academia\\";
        6.    arqui     = "Modelo_04_4D_Crono.xlsx";
        7.    arquivo   = drive + pasta + arqui;
        8.    tabela    = "Partes_Crono";
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
       41.    Vig           = String.Contains ( TIPO , "V" , true )==1 ? true : false;
       42.    Laj           = String.Contains ( TIPO , "L" , true )==1 ? true : false;
       43.    Pil           = String.Contains ( TIPO , "P" , true )==1 ? true : false;
       44.    ELID          = ELE.Id;
       45.    INXA          = List.IndexOf ( Cotas , COTA )+1;
       46.    INXB          = Vig? 1 : Laj ? 2 : 3;
       47.    DURI          = DPI;
       48.    CATE          = FamilyInstance.GetParameterValueByName (ELE  , "Original Category" );
       49.    TIPO          = FamilyInstance.GetParameterValueByName (ELE  , "Original Type"     );
       50.    LEVL          = FamilyInstance.GetParameterValueByName (ELE  , "Base Level"        );
       51.    NDA           = Level.GetParameterValueByName          (LEVL , "Name"              );
       52.    COTA          = Level.GetParameterValueByName          (LEVL , "Elevation"         );
       53.    //---------------------------------------------------------------------------
       54.    // Forma a lista com as culunas de dados que serão extraídos 
       55.    //---------------------------------------------------------------------------
       56.    kob           = ["INXA","INXB","CATE","TIPO","ANDA","ELID","TARE","DataTI","DataTF"];
       57.    vob           = [ INXA , INXB , CATE , TIPO , ANDA , ELID , TARE , DataTI , DataTF ];
       58.    //---------------------------------------------------------------------------
       59.    //Escreve os dados em Planilha Excel
       50.    //---------------------------------------------------------------------------
       61.    DSOffice.Data.ExportExcel( arquivo , tabela, 0, 0, [kob]          , false);
       62.    DSOffice.Data.ExportExcel( arquivo , tabela, 1, 0, Transpose(vob) , false);  

## Crono_Obra_Metalica.dyn
A função **Crono_Obra_Metalica.dyn** exemplifica o uso de funções temporais para extrair dados em formato CSV de uma sequência construtiva (com distribuição lineal do tempo associado ao componente) A filtragem dos elementos metálicos utiliza o parâmetro **UsoEstrutural** para discriminar a função dos elementos. Os dados em CSV podem ser utilizados em **Navisworks**, para criar a linha de tempo de tarefas automaticamente. São igualadas as datas iniciais e finais de planejamento, com as datas iniciais e finais reais. Em uma situação real, as datas reais devem ser preenchidas de acordo com as medições de obra executada. Comparado com a função que exporta para excel há algumas diferenças em relação à forma de estruturar o cabeçalho e os dados.

![CSV_01](https://github.com/JLMenegotto/AulasBIM/assets/9437020/bfa5eafe-f1c7-4f62-a0f8-738f1856f4d1)

## Code Block
        1.     DRV;
        2.     FUN;
        3.     COL;
        4.     VIG;
        5.     TTO;
        6.     //------------------------------------------------------------------------
        7.     // Define local de gravação do arquivo CSV
        8.     //------------------------------------------------------------------------
        9.     pasta    = DRV+":\\JLMenegotto\\Academia\\";
       10.     arqcsv   = "Modelo_Galpao.csv";
       11.     arquiv   = pasta + arqcsv;
       12.     //------------------------------------------------------------------------
       13.     // Ordena Porticos pela coordenada Y
       14.     //------------------------------------------------------------------------
       15.     FUNY     = List.SortByKey(FUN , FUN.Location.Y           )["sortedList"];
       16.     COLY     = List.SortByKey(COL , COL.Location.StartPoint.Y)["sortedList"];
       17.     VIGY     = List.SortByKey(VIG , VIG.Location.StartPoint.Y)["sortedList"];
       18.     //------------------------------------------------------------------------
       19.     // Separa Vigas e Terças 
       20.     //------------------------------------------------------------------------
       21.     USOE     = FamilyInstance.GetParameterValueByName (VIGY , "UsoEstrutural");
       22.     VIGA     = List.Clean(USOE=="Viga"  ? VIGY : null, false);
       23.     TERC     = List.Clean(USOE=="Terca" ? VIGY : null, false);
       24.     //------------------------------------------------------------------------
       25.     // Unifica as listas ordenadas em uma única lista de Elementos
       26.     // Prepara índices para sequenciar temporalmente e Extrai parâmetro Custo
       27.     //------------------------------------------------------------------------
       28.     Elem     = List.Flatten ( [FUNY , COLY , VIGA , TERC ] , 1);
       29.     IeleI    = List.IndexOf ( Elem , Elem )+1;
       30.     IeleF    = IeleI + 1;
       31.     Qelem    = List.Count   ( IeleI );
       32.     TIPO     = FamilyInstance.GetParameterValueByName(Elem, "Type");
       33.     CUST     = FamilyType.GetParameterValueByName    (TIPO, "Cost");
       34.     //----------------------------------------------------------------------
       35.     // Prepara os tempos
       36.     //----------------------------------------------------------------------
       37.     DltItm   = TTO / Qelem;
       38.     diaIni   = IeleI * DltItm;
       39.     diaFim   = IeleF * DltItm;
       40.     Dia_1    = DSCore.DateTime.Today;
       41.     IniTare  = DSCore.TimeSpan.Create      ( diaIni , 0, 0, 0, 0 );
       42.     FimTare  = DSCore.TimeSpan.Create      ( diaFim , 0, 0, 0, 0 );
       43.     Data_TI  = DSCore.DateTime.AddTimeSpan ( Dia_1  , IniTare    );
       44.     Data_TF  = DSCore.DateTime.AddTimeSpan ( Dia_1  , FimTare    );
       45.     //--------------------------------------------------------------------
       46.     // Prepara os dados a extrair
       47.     //--------------------------------------------------------------------
       48.     INDC     = FamilyInstance.GetParameterValueByName (Elem, "UsoEstrutural");
       49.     NUME     = FamilyInstance.GetParameterValueByName (Elem, "Mark");
       50.     ID       = Elem.Id;
       51.     TIPT     = List.OfRepeatedItem    ( "Construct" , Qelem   );
       52.     TARI     = DSCore.DateTime.Format ( Data_TI , "dd/MM/yyyy");
       53.     TARF     = DSCore.DateTime.Format ( Data_TF , "dd/MM/yyyy");
       54.     //---------------------------------------------------------------------
       55.     // Ordena e Escreve os dados em Arquivo CSV
       56.     //---------------------------------------------------------------------
       57.     cabe     = "TAREFA,ID,TIPOTAREFA,DATAI,DATAF,DATARI,DATARF,CUSTO";
       58.     vals     = [INDC+"_"+NUME+","+ID+","+TIPT+","+TARI+","+TARF+","+TARI+","+TARF+","+CUST];
       59.     dados    = List.AddItemToFront( cabe , List.Flatten( vals , 1));
       60.     DSOffice.Data.ExportCSV( arquiv , dados);

## MUSICA_2020.DLL
A biblioteca contem algumas funções musicais que programei em C# utilizando a biblioteca NAUDIO. As funções podem ser integradas em APIs e em Dynamo. 
Deve ser carregada como **ADD-ONs** em Dynamo. Veja um exemplo. Ative o som do video embaixo para ouvir diversas configurações geométricas e sonoras. 

Para desbloquear o arquivo **Musica_2020.dll** utilize o comando Unblock do Windows PowerShell.

**Unblock-File -Path C:\caminho onde o arquivo foi colocado\Musica_2020.dll**

## Parabolóides 
A seguir algumas sequências sonoras geradas de um parabolóide hiperbólico construído com duas retas. Nos dois primeiros exemplos 
as retas invertidas têm alturas iguais, resultando em um parabolóide simétrico. Para cada interação são modificados o tamanho do 
módulo dimensional e a escala musical utilizada.

https://github.com/JLMenegotto/AulasBIM/assets/9437020/26f4bcbe-942d-45a1-a804-f2dea4b30175

https://github.com/JLMenegotto/AulasBIM/assets/9437020/2fe5071d-7dce-48df-af51-b935822f242c

https://github.com/JLMenegotto/AulasBIM/assets/9437020/9bfdeff1-83e3-43f1-8a0f-7fdd4e808ffa

https://github.com/JLMenegotto/AulasBIM/assets/9437020/d847eb7b-3068-4b7d-a488-49ca33c9e19e

## Mandalas 
Nos exemplos das Mandalas existe uma sutil correspondência visual e sonora que pode ser sentida prestando atenção ao ordenamento visual dos pontos. 
Para as configurações que apresentam uma maior dispersão dos pontos há menor coesão sonora e viceversa.

https://github.com/JLMenegotto/AulasBIM/assets/9437020/e24a8fb7-bc7d-48c8-9be0-5d50efa135e3

Exemplos usando Sons Waves
![Waves_01](https://github.com/JLMenegotto/AulasBIM/assets/9437020/532ae639-a03b-429f-b809-5d4c3fd8eb7b)

Exemplos usando MIDI
![Waves_02](https://github.com/JLMenegotto/AulasBIM/assets/9437020/69f3706a-c1c9-4090-8934-4f6f9887c39e)

## Mandala_Musical.dyn
Neste exemplo, utilizamos a interface MIDI da Biblioteca de **NAUDIO** para incorporar som musical ao processo geométrico. Precisa ser baixada a dll de NAUDIO e incorporada à biblioteca na configuração de Ambiente em Dynamo.

## Code Block
       1.  tempo;
       2.  mio;
       3.  fol;
       4.  //Converte em string o Tempo Atual e separa os segundos ------
       5.  segu = String.Substring( tempo+"" , 6 , 2);
       6.  segs = 0..String.ToNumber(segu);
       7.  a    = 0..#fol..segs;
       8.  x    = segs * Math.Cos( a );
       9.  y    = segs * Math.Sin( a );
      10.  Pt  = Point.ByCoordinates( x , y , 0);
      11.  //Fundamental -----------------------
      12.  f0    = segs% 5==0? 67: 72;
      13.  //Saltos ----------------------------
      14.  s1    = segs%  5==0? 0:  7;
      15.  s2    = segs% 10==0? 0: 11;
      16.  //Instrumento -----------------------
      17.  i1    = segs% 3==0?  68 : segs% 5==0? 116 : 118;
      18.  instr = MidiMessage.RawData(MidiMessage.ChangePatch ( i1 , 1));
      19.  MidiOut.Send ( mio , instr);
      20.  //Nota ------------------------------
      21.  nota  = f0;
      22.  //Tocar -----------------------------
      23.  toca1 = MidiMessage.RawData(MidiMessage.StartNote   ( nota + s2 , 40+segs , 1));
      24.  toca2 = MidiMessage.RawData(MidiMessage.StartNote   ( nota + s1 , 30+segs , 1));
      25.  toca3 = MidiMessage.RawData(MidiMessage.StartNote   ( nota + s2 , 20+segs , 1));
      26.  MidiOut.Send ( mio , segs% 3==0? toca1 : segs% 5==0? toca2 : toca3);

![Mandala_01](https://github.com/JLMenegotto/AulasBIM/assets/9437020/faea2783-41ec-4bb7-b7eb-2db0b22e7c4c)

![Mandala_02](https://github.com/JLMenegotto/AulasBIM/assets/9437020/3376e867-e1cb-41a5-b556-3f4560663d84)

![Exemplo Em Cables - Utilizando arquivo Ifc](https://cables.gl/edit/nBeg_N)

## LISTA DOS NÚMEROS CORRESPONDENTES AOS INSTRUMENTOS MIDI
### Teclados
      1.  Piano de cauda acústico
      2.  Piano brilhante
      3.  Piano de cauda elétrico
      4.  Piano Honky-Tonk
      5.  Piano elétrico 1
      6.  Piano elétrico 2
      7.  Cravo
      8.  Clavinet
### Percussão Cromática
      9.  Celesta
     10.  Glockenspiel
     11.  Caixa de música
     12.  Vibrafone
     13.  Marimba
     14.  Xilofone
 ### Órgãos
     15.  Sinos Tubulares
     16.  Dulcimer	
     17.  Órgão Hammond
     18.  Órgão percussivo
     19.  Órgão de rock
     20.  Órgão da Igreja
     21.  Harmônio
     22.  Acordeão
     23.  Gaita
     24.  Bandoneon  
### Violões	
     25.  Guitarra espanhola
     26.  Violão
     27.  Guitarra elétrica (jazz)
     28.  Guitarra elétrica
     29.  Guitarra elétrica Mute
     30.  Guitarra saturada
     31.  Guitarra com distorção
     32.  Harmônicos de guitarra  
### Baixos	
     33.  Baixo acústico
     34.  Baixo elétrico
     35.  Baixo elétrico (pick)
     36.  Baixo Fretless
     37.  Baixo 1
     38.  Baixo 2
     39.  Baixo sintetizado 1
     40.  Baixo sintetizado 2
### Cordas e conjuntos
     41.  Violino
     42.  Viola
     43.  Violoncelo
     44.  Contrabaixo
     45.  Tremolo
     46.  Pizzicato
     47.  Harpa
     48.  Timbales
     49.  Cordas 1
     50.  Cordas 2
     51.  Cordas sintetizadas 1
     52.  Cordas sintetizadas 2   
### Vozes
     53.  Coro Aahs
     54.  Oohs Vozes
     55.  Voz sintetizada
     56.  Golpe orquestral
### Metais
     57.  Trompete
     58.  Trombone  
     59.  Tuba
     60.  Trompete com mudo
     61.  Chifre
     62.  Naipe de Metais  
     63.  Metais sintetizados 1  
     64.  Metais sintetizados 2
     65.  Saxofone Soprano   
     66.  Saxofone Contralto  
     67.  Saxofone Tenor
     68.  Saxofone Barítono
### Madeiras	
     69.  Oboé 
     70.  Chifre Inglês
     71.  Fagote
     72.  Clarinete	
     73.  Piccolo
     74.  Flauta transversal
     75.  Gravador
     76.  Flauta pan
     77.  Garrafa
     78.  Skakuhachi
     79.  Apito 
     80.  Ocarina
### Sintetizadores
     81.  Onda quadrada
     82.  Dente de serra
     83.  Órgão a vapor
     84.  Chiffer
     85.  Charango
     86.  Voz
     87.  Quinta
     88.  Baixo e chumbo	
     89.  Fantasia / Nova Era
     90.  Quente
     91.  Polissintetizador
     92.  Voz
     93.  Arco de vidro
     94.  Metálico
     95.  Halo
     96.  Varrer 
### Efeitos	
     97.  Chuva 
     98.  Trilha Sonora
     99.  Cristal
    100.  Atmosfera 
    101.  Brilho 
    102.  Duendes
    103.  Ecos
    104.  Tema Estrela
### Étnicos	
    105.  Sitar
    106.  Banjo 
    107.  Shamishen 
    108.  Koto
    109.  Kalimba
    110.  Gaita
    111.  Violín celta
    112.  Shanai
### Percussivos
    113.  Campainhas
    114.  Agogó
    115.  Caixa de Metal
    116.  Caixa de Madeira
    117.  Taiko
    118.  Timbal
    119.  Caixa sintetizada
    120.  Prato (invertido)	
    121.  Traste de guitarra
### Sons
    122.  Respiração
    123.  Praia
    124.  Pássaro
    125.  Telefone
    126.  Helicóptero
    127.  Aplauso
    128.  Disparo    
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
