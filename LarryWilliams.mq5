#include <SnippetsDotel.mqh>;

input group "Paramtros Indicadores."
input int emaPeriod = 50;
input int rsiPeriod = 4;

input group "Parametros Horario (GMT)"
input int HoraInicio = 9;
input int HoraFinal = 16;
input int MinutoInicio = 30;
input int MinutoFinal = 0;

int ema_h;
int rsi_h;

double ema [];
double rsi [];

MqlRates velas[];

int OnInit(void){

   ema_h = iMA(_Symbol,PERIOD_CURRENT, emaPeriod, 0, MODE_EMA, PRICE_CLOSE);
   rsi_h = iRSI(_Symbol, PERIOD_CURRENT, rsiPeriod, PRICE_CLOSE);   
   
   if(ema_h == INVALID_HANDLE || rsi_h == INVALID_HANDLE){
   Print("No se han cargado los indicadores: ", GetLastError());
   return INIT_FAILED;
   }
   
   ArraySetAsSeries(velas, true);
   ArraySetAsSeries(ema, true);
   ArraySetAsSeries(rsi, true);
   
   return(INIT_SUCCEEDED);
}
  
void OnDeinit(const int reason){
   if (ema_h != INVALID_HANDLE) IndicatorRelease(ema_h);
   if (rsi_h != INVALID_HANDLE) IndicatorRelease(rsi_h);

}

void OnTick(void){

   //Si esta fuera del horario que se cierre.
   if (!EnHorario(HoraInicio, HoraFinal, MinutoInicio, MinutoFinal)) return;
   
   //Rellenamos los arrays
   CopyBuffer(ema_h, 0, 1, 3, ema);
   CopyBuffer(rsi_h, 0, 1, 3, rsi);
   CopyRates(_symbol, PERIOD_CURRENT, 1, 1, velas);
   
   
  }

