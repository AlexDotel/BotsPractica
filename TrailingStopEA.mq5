#include <Trade/Trade.mqh>


CTrade trade;

void OnTick(void){

   //Obtener el ask
   double ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);
   
   //Verificar las pocisiones abiertas
   if(PositionsTotal() > 2)
   
   trade.Buy(0.1, _Symbol, ask, ask-200 * _Point, ask+200 * _Point);
   
   CheckTrailingStop(ask);
   
}
  
void CheckTrailingStop (double ask){
   
   //Colocamos el SL deseado
   double sl = NormalizeDouble(ask - 150 * _Point, _Digits);
   
   //Recorremos todas las posiciones abiertas del simbolo actual
   for(int i= PositionsTotal() - 1; i > 0 ; i--){
   
      //Extraemos el simbolo de la posicion.
      string symbol = PositionGetSymbol(i);
      
      if(_Symbol == symbol){
         
         //Extramos el numero de ticket
         ulong positionTicket = PositionGetInteger(POSITION_TICKET);
         
         //Obtenemos el SL ACTUAL de la posicion
         double currentSL = PositionGetDouble(POSITION_SL);
         
         //Verificamos que el SL en este caso esta por debajo de 150 puntos...
         if(currentSL < sl){
         
            //Modificamos la posicion actualizando el SL 10 puntos
            trade.PositionModify(positionTicket, currentSL + 10 * _Point, 0);
         
         }
               
      } //Symbol Loop
      
   } //Trailing Function


}  