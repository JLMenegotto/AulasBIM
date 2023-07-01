using System;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

using NAudio.Midi;
using NAudio.Wave;
using NAudio.Wave.SampleProviders;

namespace Musica_2020
{
    public class Musica_2020
    {
        public static void Msj(string m)
        {
                                       System.Windows.Forms.MessageBox.Show(m);
        }
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
		public static MidiOut    MIDI_MIDI         ( int n = 0                ) 
		{
			                     return new MidiOut ( n );
		}
		public static MidiOut    MIDI_Ativar       ( int n = 0                ) 
		{
				                 return new MidiOut( n ); 
		} // 2 Teclado Casa - 1 Poli - 0 Windows
		public static MidiOut    MIDI_Reativar     ( MidiOut midi , int n = 0 ) 
		{
								 MIDI_Desativar ( midi );
				                 return new MidiOut( n ); //recarrego
		} // 2 Teclado Casa - 1 Poli - 0 Windows
		public static string     MIDI_Desativar    ( MidiOut midi             ) 
		{
		                	    if ( midi != null )
		   	                    {
				                    midi.Close();
				                    midi.Dispose();
			                    }
                                return "MIDI desativado";
		}
        public static async void MIDI_Testar       ( int n = 0                ) 
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
        public static async void Tocar_NAudio ( int    n = 0, int funda = 60, int dura = 1, int dina = 127 , int canal = 1, int instru = 1, int inv = 1, int[] Escala = null)
        {
                                 MIDI_Desativar ( new MidiOut( n ));
                                 MidiOut midi =   new MidiOut( n );

								 midi.Volume  = 65535;
                                 await Tocar_Escala ( midi , funda , dura , dina , canal, instru, inv, Escala );

			                     MIDI_Desativar(midi);
        }
        public static async Task Tocar_Escala ( MidiOut midi, int funda = 60, int dura = 1, int dina = 127 , int canal = 1, int instru = 1, int inv = 1, int[] Escala = null)
		{
                                 TimeSpan d = new TimeSpan(0, 0, 0, 0, dura);
                                 midi.Send ( MidiMessage.ChangePatch ( instru , canal ).RawData );
                                 foreach (int i in inv > 0 ? Escala : Escala.Reverse())
                                 {
                                          await Tocar_Acorde(midi, funda + i, dura, dina, canal, instru); await Task.Delay(d).ConfigureAwait(false);
                                 }
        }
        public static int        Tocar_1Nota  ( MidiOut midi, int funda = 60, int dura = 1, int dina = 127 , int canal = 1, int instru = 1 )
        {
			                     MidiMessage Instru  = MidiMessage.ChangePatch( instru , canal        );
		                       	 MidiMessage Notaon  = MidiMessage.StartNote  ( funda  , dina , canal );
			                     MidiMessage Notaof  = MidiMessage.StopNote   ( funda  ,    0 , canal );

                                 midi.Send ( Instru.RawData );
								 midi.Send ( Notaon.RawData );
                                 Thread.Sleep( dura);
                                 midi.Send ( Notaof.RawData );
  	                             return Notaon.RawData;
        }
        public static async Task Tocar_Nota   ( MidiOut midi, int funda = 60, int dura = 1, int dina = 127 , int canal = 1, int instru = 1 )
        {
                                 TimeSpan  d = new TimeSpan(0, 0, 0, 0, dura);
                                 int Instru  = MidiMessage.ChangePatch(instru, canal).RawData;
		                      	 int Notaon  = MidiMessage.StartNote(funda , dina , canal).RawData;
			                     int Notaof  = MidiMessage.StopNote (funda , dina , canal).RawData;
                                 midi.Send(Instru);
                                 midi.Send(Notaon); await Task.Delay( d ).ConfigureAwait(false);
                                 midi.Send(Notaof);
        }
        public static async Task Tocar_Acorde ( MidiOut midi, int funda = 60, int dura = 1, int dina = 127 , int canal = 1, int instru = 1 )
        {
                               TimeSpan d = new TimeSpan(0, 0, 0, 0, dura);
                               midi.Send ( MidiMessage.ChangePatch (instru, canal).RawData);
		                       midi.Send ( MidiMessage.StartNote ( funda +  0 , dina , canal ).RawData);
                               midi.Send ( MidiMessage.StartNote ( funda +  4 , dina , canal ).RawData);
                               midi.Send ( MidiMessage.StartNote ( funda +  7 , dina , canal ).RawData);
                               midi.Send ( MidiMessage.StartNote ( funda + 11 , dina , canal ).RawData); await Task.Delay(d).ConfigureAwait(false);
                               midi.Send ( MidiMessage.StopNote  ( funda +  0 , dina , canal ).RawData);
                               midi.Send ( MidiMessage.StopNote  ( funda +  4 , dina , canal ).RawData);
                               midi.Send ( MidiMessage.StopNote  ( funda +  7 , dina , canal ).RawData);
                               midi.Send ( MidiMessage.StopNote  ( funda + 11 , dina , canal ).RawData);
        }
        public static async Task Tocar_Arpejo ( MidiOut midi, int funda = 60, int dura = 1, int dina = 127 , int canal = 1, int instru = 1 )
        {
                               TimeSpan d = new TimeSpan(0, 0, 0, 0, dura / 50);
                               midi.Send(MidiMessage.ChangePatch ( instru , canal).RawData);
                               midi.Send(MidiMessage.StartNote   ( funda +  0 ,  dina , canal ).RawData); await Task.Delay(d).ConfigureAwait(false);
                               midi.Send(MidiMessage.StartNote   ( funda +  4 ,  dina , canal ).RawData); await Task.Delay(d).ConfigureAwait(false);
                               midi.Send(MidiMessage.StartNote   ( funda +  7 ,  dina , canal ).RawData); await Task.Delay(d).ConfigureAwait(false);
                               midi.Send(MidiMessage.StartNote   ( funda + 11 ,  dina , canal ).RawData); await Task.Delay(d).ConfigureAwait(false);
                               midi.Send(MidiMessage.StopNote    ( funda +  0 ,  dina , canal ).RawData);
                               midi.Send(MidiMessage.StopNote    ( funda +  4 ,  dina , canal ).RawData);
                               midi.Send(MidiMessage.StopNote    ( funda +  7 ,  dina , canal ).RawData);
                               midi.Send(MidiMessage.StopNote    ( funda + 11 ,  dina , canal ).RawData);
        }

        public static string     Tocar_OndaQuadr (int dura = 1 , int f1 = 440               ) 
        {
                      TimeSpan d = new TimeSpan(0, 0, 0, dura, 0);
                      var onda = new SignalGenerator(44100, 2)
                      {
                          Gain      = 0.2,
                          Frequency = f1,
                          Type      = SignalGeneratorType.Square
                      }.Take(d);

                      using (var w = new WaveOutEvent())
                      {
                             w.Init(onda);
                             w.Play();
                             while (w.PlaybackState == PlaybackState.Playing)
                             {
                                   Thread.Sleep( dura * 1000);
                             }
                      }
	                  return "ok";
		}
        public static string     Tocar_Glissando (int dura = 1 , int f1 = 440, int f2 = 880 ) 
        {
                      TimeSpan d = new TimeSpan ( 0 , 0 , 0 , dura , 0);
                      var onda   = new SignalGenerator ( 44100 , 2 )
                      {
                          Gain            = 0.2,
                          Frequency       = f1,
                          FrequencyEnd    = f2,
                          Type            = SignalGeneratorType.Sweep,
                          SweepLengthSecs = dura
                      }.Take(d);
                      using (var w = new WaveOutEvent())
                      {
                           w.Init( onda );
                           w.Play(      );
                           while (w.PlaybackState == PlaybackState.Playing)
                           {
                                  Thread.Sleep( dura * 1000 );
                           }
                      }
                      return "ok";
        }
    }
}
