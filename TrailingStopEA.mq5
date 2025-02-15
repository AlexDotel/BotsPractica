#include <Trade/Trade.mqh>
CTrade trade;

input group "PARAMETROS"
input double lotaje              = 2;     //LOTAJE
input int profitTriggerDollars   = 50;    //GANANCIA (DOLLARS)
input int slOffsetPoints         = 150;    //SL OFSETT (POINTS)

void OnTick(void){

   //Obtener el ask
   double ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);
   
   //Verificar las pocisiones abiertas
   if(PositionsTotal() < 1)
   
   trade.Buy(lotaje, _Symbol, ask, ask - 200 * _Point, ask + 200 * _Point);
   
   CheckTrailingStop(20, 150);
   
}
  
void CheckTrailingStop (double _profitTriggerDollars, double _slOffetPoints){

   //Extraemos el bid.
   double bidForCloseBuy = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);
   
   //Colocamos el SL deseado
   double sl = NormalizeDouble(bidForCloseBuy - (_slOffetPoints * _Point), _Digits);
   
   //Verificamos la posiciones abiertas
   Print("Posiciones Abiertas: ", PositionsTotal());
   
   //Recorremos todas las posiciones abiertas del simbolo actual
   for(int i = PositionsTotal() -1 ; i >= 0 ; i--){
      Print("Posicion Index: ", i);
      
      //Extraemos el simbolo de la posicion.
      string symbol = PositionGetSymbol(i);
      
      if(_Symbol == symbol){
         
         //Extramos el numero de ticket
         ulong positionTicket = PositionGetInteger(POSITION_TICKET);
         
         //Obtenemos el SL ACTUAL de la posicion
         double currentSL = PositionGetDouble(POSITION_SL);
         //Obtenemos el PROFIT ACTUAL de la posicion en RECORRIDO.
         double currentProfit = NormalizeDouble(PositionGetDouble(POSITION_PROFIT), _Digits);
            
         ////Verificamos que el profit es mayor al Profit Trigger
         //if(currentProfit >= _profitTriggerDollars){
         
         //Verificamos que el SL en este caso esta por debajo del trigger...
         if(currentSL < sl){
         
            //Modificamos la posicion actualizando el SL 10 puntos
            trade.PositionModify(positionTicket, sl, 0);
         
         }
               
      } //Symbol Loop
      
   } //Trailing Function


}  