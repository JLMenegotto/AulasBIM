using System;
using System.Linq;
using System.Runtime.Remoting.Messaging;
using System.Threading;
using System.Threading.Tasks;


using Autodesk.Revit;
using Autodesk.Revit.DB;
using Autodesk.Revit.DB.Analysis;
using Autodesk.Revit.DB.Structure;
using Autodesk.Revit.DB.Architecture;
using Autodesk.Revit.DB.ExtensibleStorage;
using Autodesk.Revit.UI;
using Autodesk.Revit.UI.Events;
using Autodesk.Revit.UI.Selection;
using Autodesk.Revit.ApplicationServices;
using Autodesk.Revit.Attributes;
using Autodesk.Revit.Exceptions;

using NAudio.Midi;
using NAudio.Wave;
using NAudio.Wave.SampleProviders;
using System.Collections.Generic;
using System.Security.Cryptography;

namespace Musica_2020
{
    public class Musica_2020
    {
         private static UIApplication _app;  
         public  static UIApplication  Rev { get { return _app; } set { _app = value; } }

         public static void       Msj               ( string m                 ) 
         {
                                       System.Windows.Forms.MessageBox.Show(m);
         }
         public static double     Dec               ( double a                 ) 
         {
                                    return a / 0.3048;
         } // Converte de polegada a métrico um doble
         public static double     D10               ( double a                 ) 
         {
            return a / 3.048;
         } // Converte de polegada a métrico um doble e div 10
         public static double     Pip               ( double a                 ) 
         {
                                    return a / 304.8;
         } // Converte de polegada tubos dados em milimetros 
         public static double     Dme               ( double a                 ) 
         {
                                    return a * 0.3048;
         } // Convierte para métrico as Distancias 
         public static string[]   MIDI_Dispositivos (                          ) 
         {
                                 string[] midis = new string[MidiOut.NumberOfDevices];
                                 string   msg   = "";
                                 for (int devic = 0; devic < midis.Length; devic++)
                                 {
                                          midis[devic]  = MidiOut.DeviceInfo(devic).ProductName;
                                          msg          += MidiOut.DeviceInfo(devic).ProductName + "\n";
                                 }
                                 System.Windows.Forms.MessageBox.Show( msg ,  "Lista de MIDIS" );
                                 return midis;
         }
         public static MidiOut    MIDI_MIDI         ( int n                    ) 
         {
                                 return new MidiOut ( n );
         }
         public static async void MIDI_Testar       ( int n                    ) 
         {
                                 try
                                 { 
                                      MidiOut midi  = MIDI_Ativar( n );
                                      midi.Volume   = 65535;
                                 
                                      int[] Croma   = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 };
                                      int[] Maior   = { 0, 2, 4, 5, 7, 9, 11                 };
                                      int[] Menor   = { 0, 2, 3, 5, 7, 8, 10                 };
                                      int[] Penta   = { 0, 2, 5, 7, 9                        };
                                      int[] Doric   = { 0, 2, 4, 6, 7, 9, 11                 };
                                      int[] TonsP   = { 0, 2, 4, 6, 8, 10                    };
                                      int[] TonsI   = { 1, 3, 5, 7, 9, 11                    };

                                      await Tocar_Escala ( midi , 60 , 500 , 127 , 1 , 1 , 1 , Maior);
                                      MIDI_Desativar     ( midi );
                                 }
                                 catch  { }
                                 finally{ }
         }
         public static MidiOut    MIDI_Ativar       ( int n                    ) 
         {
                                 MidiOut midi = null;
                                 try
                                 {
                                         midi = new MidiOut( n );
                                 }
                                 catch  { }
                                 finally{ }
                                 return midi;

         } // 2 Teclado Casa - 1 Poli - 0 Windows
         public static string     MIDI_Desativar    ( MidiOut midi             ) 
         {
                                 try
                                 {
                                      if ( midi != null )
                                      {
                                           midi.Close();
                                           midi.Dispose();
                                      }
                                 }
                                 catch  { }
                                 finally{ }
                                 return "MIDI desativado";
         }
         public static int        Tocar_NotaRVT     ( UIApplication Rev , MidiOut midi , int funda = 60, int dura = 1000 , int dina = 127 , int canal = 1, int instru = 1 , int toca = 0, double x = 0, double y = 0, double z = 0 ) 
         {
                                       Document   doc  = Rev.ActiveUIDocument.Document;
				                       UIDocument Uid  = Rev.ActiveUIDocument;
		                               
		                               if (toca == 1)
                                       { 
                                              MidiMessage Instru = MidiMessage.ChangePatch ( instru ,        canal );
                                              MidiMessage Notaon = MidiMessage.StartNote   ( funda  , dina , canal );
                                              MidiMessage Notaof = MidiMessage.StopNote    ( funda  ,    0 , canal );

                                              midi.Send ( Instru.RawData );
                                              midi.Send ( Notaon.RawData ); Thread.Sleep( dura);
                                              midi.Send ( Notaof.RawData );

				                              XYZ p = new XYZ( Dec(x) , Dec(y) , Dec(z) );
                                              Obj_Esfera ( Rev , p );

                                              return Notaon.RawData;
                                       }
                                       else { return toca; }
         }
         public static int        Tocar_Nota        (                     MidiOut midi , int funda = 60, int dura = 1000 , int dina = 127 , int canal = 1, int instru = 1 , int toca = 1                                           ) 
         {                                
                                  if (toca == 1)
                                  { 
                                           MidiMessage Instru = MidiMessage.ChangePatch ( instru ,        canal );
                                           MidiMessage Notaon = MidiMessage.StartNote   ( funda  , dina , canal );
                                           MidiMessage Notaof = MidiMessage.StopNote    ( funda  ,    0 , canal );

                                           midi.Send ( Instru.RawData );
                                           midi.Send ( Notaon.RawData ); Thread.Sleep( dura );
                                           midi.Send ( Notaof.RawData );
                                          			
										   return Notaon.RawData; 
                                  }
                                  else { return toca; }
         }
         public static async Task Tocar_Escala      (                     MidiOut midi , int funda = 60, int dura = 1000 , int dina = 127 , int canal = 1, int instru = 1 , int inv = 1, int[] Escala = null                       ) 
         {
                                 TimeSpan d = new TimeSpan(0, 0, 0, 0, dura);
                                 midi.Send ( MidiMessage.ChangePatch ( instru , canal ).RawData );
                                 foreach (int i in inv > 0 ? Escala : Escala.Reverse())
                                 {
                                          await Tocar_Acorde( midi , funda + i, dura , dina , canal , instru); 
                                          await Task.Delay(d).ConfigureAwait(false);
                                 }
         }
         public static async Task Tocar_Acorde      (                     MidiOut midi , int funda = 60, int dura = 1000 , int dina = 127 , int canal = 1, int instru = 1                                                          ) 
         {
                                 TimeSpan d = new TimeSpan(0, 0, 0, 0, dura);
                                 midi.Send ( MidiMessage.ChangePatch (instru, canal).RawData);
                                 midi.Send ( MidiMessage.StartNote ( funda +  0 , dina , canal ).RawData);
                                 midi.Send ( MidiMessage.StartNote ( funda +  4 , dina , canal ).RawData);
                                 midi.Send ( MidiMessage.StartNote ( funda +  7 , dina , canal ).RawData);
                                 midi.Send ( MidiMessage.StartNote ( funda + 10 , dina , canal ).RawData); await Task.Delay ( d ).ConfigureAwait(false);
                                 midi.Send ( MidiMessage.StopNote  ( funda +  0 , dina , canal ).RawData);
                                 midi.Send ( MidiMessage.StopNote  ( funda +  4 , dina , canal ).RawData);
                                 midi.Send ( MidiMessage.StopNote  ( funda +  7 , dina , canal ).RawData);
                                 midi.Send ( MidiMessage.StopNote  ( funda + 10 , dina , canal ).RawData);
         }
         public static async Task Tocar_Arpejo      (                     MidiOut midi , int funda = 60, int dura = 1000 , int dina = 127 , int canal = 1, int instru = 1                                                          ) 
         {
                               TimeSpan d = new TimeSpan(0 , 0 , 0 , 0 , dura);
                               midi.Send ( MidiMessage.ChangePatch ( instru , canal).RawData);
 
                               midi.Send ( MidiMessage.StartNote   ( funda +  0 , dina , canal ).RawData); await Task.Delay( d ).ConfigureAwait(false);
                               midi.Send ( MidiMessage.StartNote   ( funda +  4 , dina , canal ).RawData); await Task.Delay( d ).ConfigureAwait(false);
                               midi.Send ( MidiMessage.StartNote   ( funda +  7 , dina , canal ).RawData); await Task.Delay( d ).ConfigureAwait(false);
                               midi.Send ( MidiMessage.StartNote   ( funda + 10 , dina , canal ).RawData); await Task.Delay( d ).ConfigureAwait(false);

                               midi.Send ( MidiMessage.StopNote    ( funda +  0 , dina , canal ).RawData);
                               midi.Send ( MidiMessage.StopNote    ( funda +  4 , dina , canal ).RawData);
                               midi.Send ( MidiMessage.StopNote    ( funda +  7 , dina , canal ).RawData);
                               midi.Send ( MidiMessage.StopNote    ( funda + 10 , dina , canal ).RawData);
         } 
         public static string     Tocar_OndaQuadr   ( int dura = 1 , int f1 = 440               ) 
         {
                                 TimeSpan d = new TimeSpan(0, 0, 0, dura, 0);
                                 var onda = new SignalGenerator(44100, 2)
                                 {
                                         Gain      = 0.2 ,
                                         Frequency = f1  ,
                                         Type      = SignalGeneratorType.Square      }.Take(d);
                                 using (var w = new WaveOutEvent())
                                 {
                                            w.Init ( onda );
                                            w.Play (      );
                                            while ( w.PlaybackState == PlaybackState.Playing ) { Thread.Sleep ( dura * 1000); }
                                 }
                                 return "ok";
         }
         public static string     Tocar_Glissando   ( int dura = 1 , int f1 = 440, int f2 = 880 ) 
         {
                                 TimeSpan d = new TimeSpan ( 0 , 0 , 0 , dura , 0);
                                 var onda   = new SignalGenerator ( 44100 , 2 )
                                 {
                                        Gain            = 0.2 ,
                                        Frequency       = f1  ,
                                        FrequencyEnd    = f2  ,
                                        Type            = SignalGeneratorType.Sweep,
                                        SweepLengthSecs = dura                        }.Take(d);
                                 using (var w = new WaveOutEvent())
                                 {
                                        w.Init( onda );
                                        w.Play(      );
                                        while ( w.PlaybackState == PlaybackState.Playing )   { Thread.Sleep ( dura * 1000); }
                                 }
                                 return "ok";
         }
		 public static void       Obj_Esfera        ( UIApplication app , XYZ p                 ) 
		 {
                                  try
                                  {
                                       Document   doc  = app.ActiveUIDocument.Document;
				                       UIDocument Uid  = app.ActiveUIDocument;
                           
				                       XYZ        p1   = p + new XYZ( 0 ,  3 , 0 );
				                       XYZ        p2   = p + new XYZ( 0 , -3 , 0 );
				                       XYZ        p3   = p + new XYZ( 3 ,  0 , 0 );

				                       List<Curve> perfil = new List<Curve>();
				                       perfil.Add ( Line.CreateBound(p1, p2));
				                       perfil.Add ( Arc.Create( p2 , p1 , p3 ));

				                       ElementId    mater = ElementId.InvalidElementId;
                                       CurveLoop    curva = CurveLoop.Create(perfil);
                                       CurveLoop[]  loopc = new CurveLoop[] { curva };
                                       SolidOptions optio = new SolidOptions ( mater , ElementId.InvalidElementId );
                                       Frame        forma = new Frame        ( p , XYZ.BasisX , -XYZ.BasisZ , XYZ.BasisY );
                                       Solid        esfer = GeometryCreationUtilities.CreateRevolvedGeometry( forma , loopc , 0 , Math.PI * 2, optio );

                                       using (Transaction t = new Transaction( doc , "Cria direct shape" ))
                                       {
                                                t.Start();
                                                  DirectShape ds   = DirectShape.CreateElement(doc, new ElementId(BuiltInCategory.OST_GenericModel));
					                              ds.ApplicationId = "Musica";
                                                  ds.SetShape ( new GeometryObject[] { esfer } );
                                                t.Commit();
					                            Uid.RefreshActiveView();
				                       }
			                      }
                                  catch (Exception error) { TaskDialog.Show( "Resultado" , "A Esfera falhou " + error.ToString()); }
                                  finally { }
         }
	}
}
