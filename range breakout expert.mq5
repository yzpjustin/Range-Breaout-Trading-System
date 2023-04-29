//+------------------------------------------------------------------+
//|                                        range breakout expert.mq5 |
//|                                                     yin zhanpeng |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "yin zhanpeng"
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <Trade/Trade.mqh>
CTrade trade;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

   input int Bars_range = 3;  // Number of Candles in the range
   input double lot_size = 0.01;  // Lot size
   input static int magic_num = 1002;  //Magic Number
   double breakout_high;
   double breakout_low;
   
   double break_high_high;
   double break_mid_high;
   double break_low_high;
   
   double break_high_low;
   double break_mid_low;
   double break_low_low;

int OnInit()
  {
//---
   trade.SetExpertMagicNumber(magic_num);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
// create 1 for all high n low range 
// find out what is a good number of ranges max, guessing about 5 ish would be good idk

   double high_3 = iHigh(_Symbol,PERIOD_CURRENT,Bars_range + 3);
   double low_3 = iLow(_Symbol,PERIOD_CURRENT,Bars_range + 3);
  
   double high_2 = iHigh(_Symbol,PERIOD_CURRENT,Bars_range + 2);
   double low_2 = iLow(_Symbol,PERIOD_CURRENT,Bars_range + 2);

   double high_1 = iHigh(_Symbol,PERIOD_CURRENT,Bars_range + 1);
   double low_1 = iLow(_Symbol,PERIOD_CURRENT,Bars_range + 1);
   
   int range_high_index = iHighest(_Symbol,PERIOD_CURRENT,MODE_HIGH,Bars_range,1);
   int range_low_index = iLowest(_Symbol,PERIOD_CURRENT,MODE_LOW,Bars_range,1);
   
   double range_high = iHigh(_Symbol,PERIOD_CURRENT,range_high_index);
   double range_low = iLow(_Symbol,PERIOD_CURRENT,range_low_index);

   
   // high high
   
   if(high_1 >= high_2 && high_1 >= high_3){
      break_high_high = high_1;
      }
   if(high_2 >= high_1 && high_2 >= high_3){
      break_high_high = high_2;
      }
   if(high_3 >= high_1 && high_3 >= high_2){
      break_high_high = high_3;
      }
      
   // low high
   
   if(high_1 <= high_2 && high_1 <= high_3){
      break_low_high = high_1;
      }
   if(high_2 <= high_1 && high_2 <= high_3){
      break_low_high = high_2;
      }
   if(high_3 <= high_1 && high_3 <= high_2){
      break_low_high = high_3;
      }
      
   // mid  high
   
   if(high_1 != break_high_high && high_1 != break_low_high){
      break_mid_high = high_1;
      }
   if(high_2 != break_high_high && high_2 != break_low_high){
      break_mid_high = high_2;
      }
   if(high_3 != break_high_high && high_3 != break_low_high){
      break_mid_high = high_3;
      }
      
   // findig high mid low for the lows    
   
   // high low
   
   if(low_1 >= low_2 && low_1 >= low_3){
      break_high_low = low_1;
      }
   if(low_2 >= low_1 && low_2 >= low_3){
      break_high_low = low_2;
      }
   if(low_3 >= low_1 && low_3 >= low_2){
      break_high_low = low_3;
      }
      
   // low low
   
   if(low_1 <= low_2 && low_1 <= low_3){
      break_low_low = low_1;
      }
   if(low_2 <= low_1 && low_2 <= low_3){
      break_low_low = low_2;
      }
   if(low_3 <= low_1 && low_3 <= low_2){
      break_low_low = low_3;
      }
      
   // mid low
   
   if(low_1 != break_low_low && low_1 != break_high_low){
      break_mid_low = low_1;
      }
   if(low_2 != break_low_low && low_2 != break_high_low){
      break_mid_low = low_2;
      }
   if(low_3 != break_low_low && low_3 != break_high_low){
      break_mid_low = low_3;
      }   
   
   // finding the next closest value for breakout 
   // highs 
   if(range_high < break_high_high && range_low > break_low_low ){
      
      if(range_high < break_high_high){
         breakout_high = break_high_high;
         }
      if(range_high < break_mid_high){
         breakout_high = break_mid_high;
         }
      if(range_high < break_low_high){
         breakout_high = break_low_high;
         }
         
      // lows 
      
      if(range_low > break_low_low){
         breakout_low = break_low_low;
         }
      if(range_low > break_mid_low){
         breakout_low = break_mid_low;
         }
      if(range_low > break_high_low){
         breakout_low = break_high_low;
         }
      }   
   // trading logic
   // when range is detected
   if(range_high < breakout_high && range_low > breakout_low && OrdersTotal() == 0 && OrdersTotal() != 2){
      ObjectCreate(0,"high",OBJ_HLINE,0,0,breakout_high);
      ObjectCreate(0,"low",OBJ_HLINE,0,0,breakout_low);
      
      double value = breakout_high - breakout_low; // calulate the distance between the two breakout 
     
      double buy_sl = breakout_high - value;
      double buy_tp = breakout_high + value;
      NormalizeDouble(buy_sl,_Digits);
      NormalizeDouble(buy_tp,_Digits);
      
      double sell_sl = breakout_low + value;
      double sell_tp = breakout_low - value;
      NormalizeDouble(sell_sl,_Digits);
      NormalizeDouble(sell_tp,_Digits);
      
      
      trade.BuyStop(lot_size,breakout_high,_Symbol,buy_sl,buy_tp);
      trade.SellStop(lot_size,breakout_low,_Symbol,sell_sl,sell_tp); 
      
      }
   Comment(
      "\n high",breakout_high,
      "\n low",breakout_low,
      "\n high high",break_high_high,
      "\n high mid",break_mid_high,
      "\n high low",break_low_high,
      "\n low high",break_high_low,
      "\n low mid",break_mid_low,
      "\n low low",break_low_low,
      "\n range high",range_high,
      "\n range low",range_low
      
      );   
   
  }
//+------------------------------------------------------------------+
