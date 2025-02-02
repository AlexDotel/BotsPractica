
   #include <Trade/Trade.mqh>;
   #include <MisSnippetsMQL5/SnippetsDotel.mqh>;

   input group "Estrategia"
   input string marketOpen =  "15:30";
   input ENUM_TIMEFRAMES period = PERIOD_M30;
   
   input group "Manejo de Riesgo"
   input int slPoints = 500; //StopLoss en Puntos
   input int tpPoints = 500; //TakeProfit en Puntos
   input double riskPercent = 1; //Porcentaje a Arriesgar
   input bool isFixedRisk = true; //Riesgo Fijo (En caso de False sera porcentual)
   input double fixedRisk = 1.0; //Lotaje fijo
   
   input group "Direccion"
   bool input longSide  = true; //Habilitar Compras
   bool input shortSide = true; //Habilitar Ventas
   bool input invertirEstrategia = false; //Invertir Estrategia
   
   void OnStart(void)
     {
      
     }