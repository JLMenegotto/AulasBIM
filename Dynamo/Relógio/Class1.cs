﻿//
// FUNÇÕES MUSICAIS PARA MIDI                                         
// AUTOR: PROF.JOSÉ LUIS MENEGOTTO - ESCOLA POLITÉCNICA DA UFRJ                                  
//                              

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

using DSG = Autodesk.DesignScript.Geometry;
using System.Security.AccessControl;

namespace Musica_2020
{
    public class Musica_2020
    {
        private static UIApplication _app;
        public static UIApplication   Rev { get { return _app; } set { _app = value; } }

        private static DirectShape   _esf;
        public static DirectShape     Esf { get { return _esf; } set { _esf = value; } }

         public static void   Msj ( string m )            
         {
            System.Windows.Forms.MessageBox.Show(m);
         }
         public static double Dec ( double a )            
         {
            return a / 0.3048;
         } // Converte de polegada a métrico um doble
         public static double D10 ( double a )            
         {
            return a / 3.048;
         } // Converte de polegada a métrico um doble e div 10
         public static double Pip ( double a )            
         {
            return a / 304.8;
         } // Converte de polegada tubos dados em milimetros 
         public static double Dme ( double a )            
         {
            return a * 0.3048;
         } // Convierte para métrico as Distancias 
         public static XYZ    Vun ( double a , double b ) 
         {
                       double ahor = a * ( Math.PI * 2 / 360 );
                       double aver = b * ( Math.PI * 2 / 360 );
                       double a1   = Math.Cos ( aver );
                       double b1   = Math.Cos ( ahor );
                       double c1   = Math.Sin ( ahor );
                       double d1   = Math.Sin ( aver );
                       return new XYZ ( a1 * b1 , a1 * c1 , d1 );
         } // Retorna vetor unitário

         public static string[]     MIDI_Dispositivos (              ) 
         {
            string[] midis = new string[MidiOut.NumberOfDevices];
            string msg = "";
            for (int devic = 0; devic < midis.Length; devic++)
            {
                midis[devic] = MidiOut.DeviceInfo(devic).ProductName;
                msg += MidiOut.DeviceInfo(devic).ProductName + "\n";
            }
            System.Windows.Forms.MessageBox.Show(msg, "Lista de MIDIS");
            return midis;
         }
         public static MidiOut      MIDI_MIDI         ( int n        ) 
         {
            return new MidiOut(n);
         }
         public static async void   MIDI_Testar       ( int n        ) 
         {
                try
                {
                     MidiOut midi = MIDI_Ativar(n);
                     midi.Volume = 65535;

                     int[] Croma = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 };
                     int[] Maior = { 0, 2, 4, 5, 7, 9, 11 };
                     int[] Menor = { 0, 2, 3, 5, 7, 8, 10 };
                     int[] Penta = { 0, 2, 5, 7, 9 };
                     int[] Doric = { 0, 2, 4, 6, 7, 9, 11 };
                     int[] TonsP = { 0, 2, 4, 6, 8, 10 };
                     int[] TonsI = { 1, 3, 5, 7, 9, 11 };

                     await Tocar_Escala ( midi , 60 , 500 , 1 , 1 , Maior);
                     MIDI_Desativar(midi);
                }
                catch   { }
                finally { }
         }
         public static MidiOut      MIDI_Ativar       ( int n        ) 
         {
            MidiOut midi = null;
            try
            {
                midi = new MidiOut(n);
            }
            catch { }
            finally { }
            return midi;

         } // 2 Teclado Casa - 1 Poli - 0 Windows
         public static string       MIDI_Desativar    ( MidiOut midi ) 
         {
                try
                {
                    if (midi != null)
                    {
                       midi.Close();
                       midi.Dispose();
                    }
                }
                catch { }
                finally { }
                return "MIDI desativado";
         }

         public static void         Tocar_Esfera      ( UIApplication app,  MidiOut midi , DirectShape esf, DSG.Point p, int f0 = 64,                                        int s1 =  0, int s2 = 0,                         int dur = 500 , int v1 = 1, int v2 = 1, int v3 = 1, int fdi = 20, double azi = 0, double alt = 0 ) 
         {
                                                        Tocar_Voz   ( app, midi, f0, s1, s2, dur, v1, v2, v3);
                                                        Esfera_Mover( app, p  , esf );
                                                        Vista_Girar ( app, azi, alt );
                                                        Vista_Focar ( app           );
         }
         public static void         Tocar_Voz         ( UIApplication app , MidiOut midi ,                               int f0 = 64,                                        int s1 =  0, int s2 = 0,                         int dur = 500 , int v1 = 1, int v2 = 1, int v3 = 1, int fdi = 20, double azi = 0, double alt = 0 ) 
         {
                                                        MidiMessage Instru1 = MidiMessage.ChangePatch ( v1 ,             1 );
                                                        MidiMessage Notaon1 = MidiMessage.StartNote   ( f0 + s1 , 120  , 1 );
                                                        MidiMessage Notaof1 = MidiMessage.StopNote    ( f0 + s1 ,   0  , 1 );  

                                                        midi.Send ( Instru1.RawData );
                                                        midi.Send ( Notaon1.RawData );
                                                         Thread.Sleep  ( dur ); 
                                                        midi.Send ( Notaof1.RawData );
		 }
         public static void         Tocar_Vozes       ( UIApplication app , MidiOut midi ,                               int f0 = 64,                                        int s1 =  0, int s2 = 0,                         int dur = 500 , int v1 = 1, int v2 = 1, int v3 = 1, int fdi = 20, double azi = 0, double alt = 0 , int gir = 0) 
         {                                         
                           				                MidiMessage In1     = MidiMessage.ChangePatch ( v1 , 1 );
                                                        MidiMessage In2     = MidiMessage.ChangePatch ( v2 , 2 );
                                                        MidiMessage In3     = MidiMessage.ChangePatch ( v3 , 3 );

                                                        midi.Send( In1.RawData );
		                                                midi.Send( In2.RawData );
		                                                midi.Send( In3.RawData );

                                                        MidiMessage Nota1on = MidiMessage.StartNote ( f0 + s1 , 120       , 1 );
                                                        MidiMessage Nota1of = MidiMessage.StopNote  ( f0 + s1 , 0         , 1 );
                                                        MidiMessage Nota2on = MidiMessage.StartNote ( f0 + s2 , 120 - fdi , 2 );
                                                        MidiMessage Nota2of = MidiMessage.StopNote  ( f0 + s2 , 0         , 2 );
                                                        MidiMessage Nota3on = MidiMessage.StartNote ( f0 - s2 , 120 - fdi , 3 );
                                                        MidiMessage Nota3of = MidiMessage.StopNote  ( f0 - s2 , 0         , 3 );

                                                        midi.Send ( Nota1on.RawData ); 
									                    midi.Send ( Nota2on.RawData );               
			                                            midi.Send ( Nota3on.RawData ); 
            
                                                         Thread.Sleep (dur); 

                                                         midi.Send ( Nota1of.RawData ); 
                                                         midi.Send ( Nota2of.RawData );
                                                         midi.Send ( Nota3of.RawData );

                                                         if (gir == 1) Vista_Girar(app, azi, alt);
         }
         public static void         Tocar_4Vozes      ( UIApplication app , MidiOut midi ,                               int f1 = 64, int f2 = 64, int f3 = 64, int f4 = 64, int s1 =  0, int s2 = 0, int s3 = 0, int s4 = 0, int dur = 500 , int v1 = 1, int v2 = 1, int v3 = 1, int v4 = 1, int fdi = 20, int fdu = 2, double azi = 0, double alt = 0 , int gir = 0) 
         { 
                                                        if (gir == 1)
                                                        {
			                                               UIView uiv = Vista_Ativa(app);
				                                       Vista_Girar ( app , uiv , azi , alt); 
                                                        }

                                                        int[] voz = new int[] { v1 , v2 , v3 , v4 };
                                                        int[] fun = new int[] { f1 , f2 , f3 , f4 };
                                                        int[] sal = new int[] { s1 , s2 , s3 , s4 };
                                                        //Seta Instrumentos --------------------------------------------------------------------------------------------------------------------
                                                        for (int v = 0; v < voz.Length;   v++) { midi.Send ( MidiMessage.ChangePatch ( voz[v] , v+1 ).RawData); }
                                                        //Vozes 1 e 2 --------------------------------------------------------------------------------------------------------------------------
                                                        for (int v = 0; v < sal.Length-2; v++) { midi.Send ( MidiMessage.StartNote   ( fun[v] + sal[v] , 120 - (fdi * v) , v+1).RawData); } Thread.Sleep ( dur    );
                                                        //Vozes 3 e 4 --------------------------------------------------------------------------------------------------------------------------
                                                        for (int v = 2; v < sal.Length-2; v++) { midi.Send ( MidiMessage.StartNote   ( fun[v] + sal[v] , 120 - (fdi * v) , v+1).RawData); } Thread.Sleep ( dur / fdu);
                                                        //Finaliza todos os toques -------------------------------------------------------------------------------------------------------------
                                                        for (int v = 0; v < sal.Length;   v++) { midi.Send ( MidiMessage.StopNote    ( fun[v] + sal[v] ,               0 , v+1).RawData); }

         }
         public static async Task   Tocar_Escala      (                     MidiOut midi ,                               int f0 = 64,                         int dur = 500 , int v1 = 1,                         int inv = 1, int[] Escala = null  ) 
         {
                                    TimeSpan d = new TimeSpan(0, 0, 0, 0, dur);
                                    midi.Send ( MidiMessage.ChangePatch ( v1 , 1 ).RawData );
                                    foreach (int i in inv > 0 ? Escala : Escala.Reverse())
                                    {
                                          await Tocar_Acorde( midi , f0 + i, dur , v1); 
                                          await Task.Delay(d).ConfigureAwait(false);
                                    }
         }
         public static async Task   Tocar_Acorde      (                     MidiOut midi , int f0 = 64, int dur = 500, int v1 = 1                                    ) 
         {
                                     midi.Send ( MidiMessage.ChangePatch ( v1 , 1 ).RawData);

                                     midi.Send ( MidiMessage.StartNote ( f0 +  0 , 120 , 1 ).RawData);
                                     midi.Send ( MidiMessage.StartNote ( f0 +  4 , 120 , 1 ).RawData);
                                     midi.Send ( MidiMessage.StartNote ( f0 +  7 , 120 , 1 ).RawData);
                                     midi.Send ( MidiMessage.StartNote ( f0 + 10 , 120 , 1 ).RawData);
 
			                         TimeSpan d = new TimeSpan(0, 0, 0, 0, dur);
                                     await Task.Delay ( d ).ConfigureAwait(false);
                                  
                                     midi.Send ( MidiMessage.StopNote  ( f0 +  0 , 120 , 1 ).RawData);
                                     midi.Send ( MidiMessage.StopNote  ( f0 +  4 , 120 , 1 ).RawData);
                                     midi.Send ( MidiMessage.StopNote  ( f0 +  7 , 120 , 1 ).RawData);
                                     midi.Send ( MidiMessage.StopNote  ( f0 + 10 , 120 , 1 ).RawData);
         }
         public static async Task   Tocar_Arpejo      (                     MidiOut midi , int f0 = 64, int dur = 500, int v1 = 1                                    ) 
         {
                                    TimeSpan d1 = new TimeSpan (0 , 0 , 0 , 0 , dur  );
                                    TimeSpan d2 = new TimeSpan (0 , 0 , 0 , 0 , dur/2);
			            TimeSpan d3 = new TimeSpan (0 , 0 , 0 , 0 , dur/3);
		                    TimeSpan d4 = new TimeSpan (0 , 0 , 0 , 0 , dur/4);

			              Midi.Send ( MidiMessage.ChangePatch ( v1 , 1 ).RawData);
 
                                    midi.Send ( MidiMessage.StartNote   ( f0 +  0 , 120 , 1 ).RawData); await Task.Delay( d1 ).ConfigureAwait(false);
                                    midi.Send ( MidiMessage.StartNote   ( f0 +  4 , 120 , 1 ).RawData); await Task.Delay( d2 ).ConfigureAwait(false);
                                    midi.Send ( MidiMessage.StartNote   ( f0 +  7 , 120 , 1 ).RawData); await Task.Delay( d3 ).ConfigureAwait(false);
                                    midi.Send ( MidiMessage.StartNote   ( f0 + 10 , 120 , 1 ).RawData); await Task.Delay( d4 ).ConfigureAwait(false);
            
                                    midi.Send ( MidiMessage.StopNote    ( f0 +  0 , 120 , 1 ).RawData);
                                    midi.Send ( MidiMessage.StopNote    ( f0 +  4 , 120 , 1 ).RawData);
                                    midi.Send ( MidiMessage.StopNote    ( f0 +  7 , 120 , 1 ).RawData);
                                    midi.Send ( MidiMessage.StopNote    ( f0 + 10 , 120 , 1 ).RawData);
         } 
         public static string       Tocar_Quadrada    ( int dur = 1 , int f0 = 440                        ) 
         {
                                    TimeSpan d = new TimeSpan(0, 0, 0, dur, 0);
                                    var onda = new SignalGenerator(44100, 2)
                                    {
                                         Gain      = 0.2 ,
                                         Frequency = f0  ,
                                         Type      = SignalGeneratorType.Square     
                                    }.Take ( d );

                                         using (var w = new WaveOutEvent())
                                         {
                                               w.Init ( onda );
                                               w.Play (      );
                                               while ( w.PlaybackState == PlaybackState.Playing )
                                               {
                                                       Thread.Sleep ( dur * 1000); 
                                               }
                                         }
                                   return "ok";
         }
         public static string       Tocar_Glissando   ( int dur = 1 , int f0 = 440 , int f1 = 880         ) 
         {
                                    TimeSpan d = new TimeSpan ( 0 , 0 , 0 , dur , 0);
                                    var onda   = new SignalGenerator ( 44100 , 2 )
                                    {
                                         Gain            = 0.2 ,
                                         Frequency       = f0  ,
                                         FrequencyEnd    = f1  ,
                                         Type            = SignalGeneratorType.Sweep,
                                         SweepLengthSecs = dur                        
                                    }.Take(d);
                                    using (var w = new WaveOutEvent())
                                    {
                                         w.Init( onda );
                                         w.Play(      );
                                         while ( w.PlaybackState == PlaybackState.Playing )   { Thread.Sleep ( dur * 1000); }
                                    }
                                    return "ok";
         }
         public static void         Esfera_Apagar     ( UIApplication app                                 ) 
         {
                                    Document    doc = app.ActiveUIDocument.Document;
				                    UIDocument  Uid = app.ActiveUIDocument;
                                    FilteredElementCollector col = new FilteredElementCollector(doc);
                                    ElementCategoryFilter    gen = new ElementCategoryFilter((BuiltInCategory)Enum.Parse(typeof(BuiltInCategory), "OST_GenericModel"));
                                    IList<Element>           ele = col.WherePasses(gen).WhereElementIsNotElementType().ToElements().ToList();
                                    using (Transaction t = new Transaction(doc, "Apaga Esferas"))
                                    {
                                           t.Start();
                                           foreach (Element e in ele)
                                           {
                                                    doc.Delete(e.Id);
                                           }
                                           t.Commit();
                                    }
                                    Uid.RefreshActiveView();
         }
		 public static DirectShape  Esfera_Criar      ( UIApplication app                                 ) 
		 {
                                    Document    doc  = app.ActiveUIDocument.Document;
				    UIDocument  Uid  = app.ActiveUIDocument;
                                    DirectShape ds   = null;
                                    XYZ         po   = new XYZ (Dec(0), Dec(0), Dec(0));
                                    try
                                    {
                                            XYZ         p1   = po + new XYZ(  0      , Dec( 0.25)  , 0 );
				            XYZ         p2   = po + new XYZ(  0      , Dec(-0.25)  , 0 );
				            XYZ         p3   = po + new XYZ(Dec(0.25),       0     , 0 );
                                            List<Curve> perfil = new List<Curve>();
				            perfil.Add ( Line.CreateBound(p1, p2));
				            perfil.Add ( Arc.Create( p2 , p1 , p3 ));

				            ElementId    mater = ElementId.InvalidElementId;
                                            CurveLoop    curva = CurveLoop.Create(perfil);
                                            CurveLoop[]  loopc = new CurveLoop[] { curva };
                                            SolidOptions optio = new SolidOptions ( mater , ElementId.InvalidElementId );
                                            Frame        forma = new Frame        ( po , XYZ.BasisX , -XYZ.BasisZ , XYZ.BasisY );
                                            Solid        esfer = GeometryCreationUtilities.CreateRevolvedGeometry( forma , loopc , 0 , Math.PI * 2, optio );
                                                           
                                            using (Transaction t = new Transaction( doc , "Cria direct shape" ))
                                            {
                                                  t.Start();
                                                     ds = DirectShape.CreateElement(doc, new ElementId(BuiltInCategory.OST_GenericModel));
					                ds.ApplicationId = "Musica";
                                                     ds.SetShape ( new GeometryObject[] { esfer } );
                                                  t.Commit();
		                           }
                                            
                                    }
                                    catch (Exception error) { TaskDialog.Show( "Resultado" , "A Esfera falhou " + error.ToString()); }
                                    finally { }
                                    Uid.RefreshActiveView();
                                 return ds;
         }
         public static DirectShape  Esfera_Criar      ( UIApplication app , DSG.Point p                   ) 
		 {
                                    Document    doc  = app.ActiveUIDocument.Document;
			            UIDocument  Uid  = app.ActiveUIDocument;
                                    DirectShape ds   = null;
                                    XYZ         po   = new XYZ (Dec(p.X) , Dec(p.Y) , Dec(p.Z) );
                                    try
                                    {
                                            XYZ         p1   = po + new XYZ(  0      , Dec( 0.25)  , 0 );
			                    XYZ         p2   = po + new XYZ(  0      , Dec(-0.25)  , 0 );
			                    XYZ         p3   = po + new XYZ(Dec(0.25),       0     , 0 );
                                            List<Curve> perfil = new List<Curve>();
				                                        perfil.Add ( Line.CreateBound(p1, p2));
				                                        perfil.Add ( Arc.Create( p2 , p1 , p3 ));

			                    ElementId    mater = ElementId.InvalidElementId;
                                            CurveLoop    curva = CurveLoop.Create(perfil);
                                            CurveLoop[]  loopc = new CurveLoop[] { curva };
                                            SolidOptions optio = new SolidOptions ( mater , ElementId.InvalidElementId );
                                            Frame        forma = new Frame        ( po , XYZ.BasisX , -XYZ.BasisZ , XYZ.BasisY );
                                            Solid        esfer = GeometryCreationUtilities.CreateRevolvedGeometry( forma , loopc , 0 , Math.PI * 2, optio );
                                                           
                                            using (Transaction t = new Transaction( doc , "Cria direct shape" ))
                                            {
                                                  t.Start();
                                                     ds = DirectShape.CreateElement(doc, new ElementId(BuiltInCategory.OST_GenericModel));
			                                ds.ApplicationId = "Musica";
                                                     ds.SetShape ( new GeometryObject[] { esfer } );
                                                  t.Commit();
				                            }
                                            
                                    }
                                    catch (Exception error) { TaskDialog.Show( "Resultado" , "A Esfera falhou " + error.ToString()); }
                                    finally { }
                                    Uid.RefreshActiveView();
                                 return ds;
         }
         public static void         Esfera_Mover      ( UIApplication app , DSG.Point p , DirectShape esf ) 
         {
                                    Document   doc = app.ActiveUIDocument.Document;
	                           UIDocument Uid = app.ActiveUIDocument;
                                    XYZ        vn  = new XYZ ( Dec( p.X ) , Dec( p.Y ), Dec ( p.Z ));
                                    try
                                    {
                                          using (Transaction t = new Transaction( doc , "Mover Esfera" ))
                                          {
                                               t.Start();
                                                  BoundingBoxXYZ bb = esf.get_BoundingBox( Uid.ActiveView );
                                                  XYZ            po = (bb.Max + bb.Min) * 0.5;
                                                  XYZ            vo = new XYZ ( po.X , po.Y ,  po.Z );

                                                  ElementTransformUtils.MoveElement (doc , esf.Id , (vn - vo));
                                               t.Commit();
                                          }
		                     }
                                     catch (Exception error) { TaskDialog.Show( "Resultado" , "Mover " + error.ToString()); }
                                     finally { }
                                     Uid.RefreshActiveView();
         }

		 public static int[]        Maior ( ) { return new int[] { 0, 2, 4, 5, 7, 9, 11 }; }
		 public static int[]        Menor ( ) { return new int[] { 0, 2, 3, 5, 7, 8, 10 }; }
		 public static int[]        Penta ( ) { return new int[] { 0, 2, 5, 7, 9 };        }
		 public static int[]        Dorio ( ) { return new int[] { 0, 2, 4, 6, 7, 9, 11 }; }
		 public static int[]        TonsP ( ) { return new int[] { 0, 2, 4, 6, 8, 10 };    }
		 public static int[]        TonsI ( ) { return new int[] { 1, 3, 5, 7, 9, 11 };    }

         public static void   Vista_Redraw ( UIApplication app                                     ) 
         {
                              app.ActiveUIDocument.RefreshActiveView();
         }
         public static UIView Vista_Ativa  ( UIApplication app                                     ) 
         {
                             UIView        uiv = null;
                             UIDocument    uid = app.ActiveUIDocument;
                             IList<UIView> Lvi = uid.GetOpenUIViews();
                             foreach (UIView v in Lvi)
                             {
                                 if (v.ViewId.Equals(uid.ActiveView.Id))
                                 {
                                     uiv = v;
                                     break;
                                 }
                             }
                             return uiv;
         }
         public static void   Vista_Focar  ( UIApplication app                                     ) 
         {
                              UIView vis = Vista_Ativa ( app );
                              if (vis != null)
                              {
                                  vis.ZoomToFit();
                                  app.ActiveUIDocument.RefreshActiveView();
                              }
         }
         public static void   Vista_Zoom   ( UIApplication app , double zof = 1.0                  ) 
         {
                             Document   doc = app.ActiveUIDocument.Document;
                             UIDocument Uid = app.ActiveUIDocument;
                             UIView     vis = Vista_Ativa (app);
                             if (vis != null)
                             {
                                 vis.Zoom( zof );
                                 app.ActiveUIDocument.RefreshActiveView();
                             }
                             
         }
         public static void   Vista_Girar  ( UIApplication app , double azi = 0.0 , double alt = 0 ) 
         {
                              Document   doc = app.ActiveUIDocument.Document;
                              View       vis = app.ActiveUIDocument.ActiveView;
                              UIView     uiv = Vista_Ativa(app);

		              if (vis is View3D)
                              {
                                   View3D      v   = vis as View3D;
			           Transaction t = new Transaction(doc, "Posiciona em 3D");
                                   using (t)
                                   {
                                          t.Start();
                                              XYZ o = XYZ.Zero;
                                              XYZ d = Vun( azi , alt + 90);
                                              XYZ s = Vun( azi , alt).Negate();
                                              ViewOrientation3D ptv = new ViewOrientation3D(o, d, s);
                                              v.SetOrientation(ptv);
                                              uiv.ZoomToFit();
			      	         t.Commit();
                                  }
                              }
			      app.ActiveUIDocument.RefreshActiveView();
        }
         public static void   Vista_Girar ( UIApplication app , UIView uiv , double azi = 0.0 , double alt = 0 ) 
         {
                              Document   doc = app.ActiveUIDocument.Document;
                              View       vis = app.ActiveUIDocument.ActiveView;
	                      if (vis is View3D)
                              {
                                   View3D      v   = vis as View3D;
                                   Transaction t = new Transaction(doc, "Posiciona em 3D");
                                   using (t)
                                   {
                                          t.Start();
                                              XYZ o = XYZ.Zero;
                                              XYZ d = Vun( azi , alt + 90);
                                              XYZ s = Vun( azi , alt).Negate();
                                              ViewOrientation3D ptv = new ViewOrientation3D(o, d, s);
                                              v.SetOrientation(ptv);
                                              uiv.ZoomToFit();
					  t.Commit();
				  }
                              }
			      app.ActiveUIDocument.RefreshActiveView();

		 }
    }
}
