#include <SnippetsDotel.mqh>;
#include <Trade/Trade.mqh>;

input group "Parametros Indicadores."
input int emaPeriod = 50; //Periodo EMA
input int rsiPeriod = 4; //Periodo RSI

input group "Niveles RSI"
input short UpLevel = 80; //Nivel superior RSI
input short LwLevel = 20; //Nivel inferior RSI

input group "Parametros Horario (GMT)"
input int HoraInicio = 9; //Hora Inicio
input int HoraFinal = 16; //Hora Final
input int MinutoInicio = 30;  //Minutos inicio.
input int MinutoFinal = 0;  //Minutos final.

input group "Manejo de Riesgo"
input int StopLossPoints = 500; //StopLoss en Puntos
input int TakeProfitPoints = 500; //TakeProfit en Puntos
input double PercentRisk = 1; 


CTrade trade;

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

   double _slPoints = StopLossPoints   * _Point;
   double _tpPoints = TakeProfitPoints * _Point;

   double miLotaje = CalculateLotSize(PercentRisk, _slPoints);

   //Si esta fuera del horario que se cierre.
   if (!EnHorario(HoraInicio, HoraFinal, MinutoInicio, MinutoFinal)) return;
   
   //Rellenamos los arrays
   CopyBuffer(ema_h, 0, 1, 3, ema);
   CopyBuffer(rsi_h, 0, 1, 3, rsi);
   CopyRates(_Symbol, PERIOD_CURRENT, 1, 3, velas);
   
   //double lotaje = calcular_riesgo(StopLossPoints, PercentRisk);
   
   
   if(FlatMarket()){
      if(precioBajista() && rsiCompra()){
         double ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);
         Print("Compramos");
         Compra(0.1, ask, StopLossPoints, TakeProfitPoints);
         
      }else if(precioAlcista() && rsiVenta()){
         double bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);
         Print("Vendemos");
         Venta(0.1, bid, StopLossPoints, TakeProfitPoints);
      }
   }
   
  }

// === === === === === === === === === === MIS FUNCIONES === === === === === === === === === === === === //

bool precioAlcista(){
   //Devuelve true si el precio esta encima de la ema 
   return velas[1].close > ema[1];
   //return iClose(_Symbol, PERIOD_CURRENT, 0) > ema[0]; //Otra forma de hacerlo.
}

bool precioBajista(){
   //Devuelve true si el precio esta encima de la ema 
   return velas[1].close < ema[1];
}

bool rsiCompra (){
   return rsi[2] < LwLevel && rsi[1] > LwLevel;
}

bool rsiVenta (){
   return rsi[2] > UpLevel && rsi[1] < UpLevel;
}

void Compra(double _volume, double _ask, double _slPoints, double _tpPoints){
   if(
      !trade.Buy(
         _volume,
         _Symbol,
         _ask,
         _slPoints == 0 ? 0 : _ask - _slPoints * _Point,
         _tpPoints == 0 ? 0 : _ask + _tpPoints * _Point
      )){
      Print("No se pudo abrir la compra: ", GetLastError());
    }
}

void Venta(double _volume, double _bid, double _slPoints, double _tpPoints){
   if(
      !trade.Sell(
         _volume,
         _Symbol,
         _bid,
         _slPoints == 0 ? 0 : _bid + _slPoints * _Point,
         _tpPoints == 0 ? 0 : _bid - _tpPoints * _Point
      )){
      Print("No se pudo abrir la venta: ", GetLastError());
    }

}