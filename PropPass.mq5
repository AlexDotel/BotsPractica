
#include  <SnippetsDotel.mqh>
#include <Trade/Trade.mqh>

input group "Indicadores"
int input emaPeriod = 50;
int input rsiPeriod = 10;

input group "RSI Levels"
short input LowLVL = 30;
short input UpLVL = 70;

input group "Riesgo"
double input vol = 0.1;
int input slPoints = 150;
int input tpPoints = 100;

int emah;
int rsih;

double ema [];
double rsi [];
MqlRates velas [];

CTrade trade;


int OnInit(void){
   emah = iMA(_Symbol, PERIOD_CURRENT, emaPeriod, 0, MODE_EMA, PRICE_CLOSE);
   rsih = iRSI(_Symbol, PERIOD_CURRENT, rsiPeriod, PRICE_CLOSE);
   
   if(emah == INVALID_HANDLE || rsih == INVALID_HANDLE){
      Print("ERROR al cargar los indicadores: ", GetLastError());
      return INIT_FAILED;
   }
   
   ArraySetAsSeries(ema, true);
   ArraySetAsSeries(rsi, true);
   ArraySetAsSeries(velas, true);
   
   Print("Indicadores cargados correctamente.");
   return(INIT_SUCCEEDED);
}
  
void OnDeinit(const int reason){
   if (emah != INVALID_HANDLE) IndicatorRelease(emah);
   if (rsih != INVALID_HANDLE) IndicatorRelease(rsih);

}


void OnTick(void){

   CopyBuffer(emah, 0, 0, 3, ema);
   CopyBuffer(rsih, 0, 0, 3, rsi);
   CopyRates(_Symbol, PERIOD_CURRENT, 0, 3, velas);

   if(FlatMarket()){
      if(TendenciaAlcita() && SobreventaRSI()){
         double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);  
         
      }
         
      
     }
   
   
}

bool TendenciaAlcita(){
   double precioActual = velas[1].close;
   double emaActual = ema[1];
   
   return precioActual > emaActual;
}

bool TendenciaBajista(){
   double precioActual = velas[1].close;
   double emaActual = ema[1];
   
   return precioActual < emaActual;
}

bool SobreventaRSI(){
   double rsiActual = rsi[1];
   double rsiPrevio = rsi[2];

   return rsiActual > LowLVL && rsiPrevio < LowLVL;
}

bool SobrecompraRSI(){
   double rsiActual = rsi[1];
   double rsiPrevio = rsi[2];

   return rsiActual < UpLVL && rsiPrevio > UpLVL;
}

void Compra(double _volume, double _ask, double _slPoints, double _tpPoints){
   double _slPrice = _ask - _slPoints * _Point;
   double _tpPrice = _ask + _tpPoints * _Point;
   if(!trade.Buy(_volume, _Symbol, _ask, _slPrice, _tpPrice, "Compra Realizada")){
      Print("No se ha podido realizar la compra: ", GetLastError());
   }
}

void Venta(double _volume, double _bid, double _slPoints, double _tpPoints){
   double _slPrice = _bid + _slPoints * _Point;
   double _tpPrice = _bid - _tpPoints * _Point;
   if(!trade.Sell(_volume, _Symbol, _bid, _slPrice, _tpPrice, "Compra Realizada")){
      Print("No se ha podido realizar la venta: ", GetLastError());
   }
}







