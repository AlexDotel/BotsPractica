   #include <MisSnippetsMQL5/SnippetsDotel.mqh>;
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
   input int slPoints = 500; //StopLoss en Puntos
   input int tpPoints = 500; //TakeProfit en Puntos
   input double riskPercent = 1; //Porcentaje a Arriesgar
   
   input group "Direccion"
   bool input longSide  = true; //Habilitar Compras
   bool input shortSide = true; //Habilitar Ventas
   
   
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
      
      //Calculamos el lotaje automaticamente
      double lotaje = CalculateLotSize(riskPercent, slPoints);
   
      //Si esta fuera del horario que se cierre.
      if (!EnHorario(HoraInicio, HoraFinal, MinutoInicio, MinutoFinal)) return;
      
      //Rellenamos los arrays
      CopyBuffer(ema_h, 0, 1, 3, ema);
      CopyBuffer(rsi_h, 0, 1, 3, rsi);
      CopyRates(_Symbol, PERIOD_CURRENT, 1, 3, velas);
      
      //Verificamos que no hay ordenes.
      if(FlatMarket()){
      
         //Condicion de Compra.
         if(precioAlcista(velas, ema) && rsiCompra(rsi, LwLevel) && longSide){
            double ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);
            Print("Compramos");
            AbrirCompra(lotaje, ask, slPoints, tpPoints);
         }
         
         //Condicion de Venta.
         if(precioBajista(velas, ema) && rsiVenta(rsi, UpLevel) && shortSide){
            double bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);
            Print("Vendemos");
            AbrirVenta(lotaje, bid, slPoints, tpPoints);
         }
      }
      
     }
   
   // === === === === === === === === === === MIS FUNCIONES === === === === === === === === === === === === //