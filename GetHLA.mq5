#include <MisSnippetsMQL5/SnippetsDotel.mqh>

input int HoraApertura     = 15;    //Hora de Apertura.
input int MinutosApertura  = 30;    //Minutos de Apertura.
input int Lookback         = 8;     //Horas atras a buscar el high.

void OnTick(){

   if(IsNewCandle()){
      
      datetime HoraActual = TimeCurrent();
      MqlDateTime tiempoActual;
      TimeToStruct(HoraActual, tiempoActual);
      
      if(tiempoActual.hour == HoraApertura && tiempoActual.min == MinutosApertura){
         Print("APERTURA!!! ===> ", HoraActual);
         
         //Logica para ejecutar a la hora de la apertura.
         //En este caso buscaremos el high y los de las X hora anteriores.
         
      }
      
   }
   
}


