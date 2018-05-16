// ==============================================================
//
// The counter is designed by a series mode. / asynchronous mode. 即异步进位
// use "=" to give value to hour_counter_high and so on. 异步操作/阻塞赋值方式
//
// 3 key: key_reset/系统复位, key_start_pause/暂停计时, key_display_stop/暂停显示
//
// ==============================================================
module stopwatch_01(clk, key_reset, key_start_pause, key_display_stop, 
		hex0, hex1, hex2, hex3, hex4, hex5, led0, led1, led2, led3);
		//key_reset复位,key_start_pause开始暂停计时,key_display_stop开始暂停显示

	input clk, key_reset, key_start_pause, key_display_stop;
	output[6:0] hex0, hex1, hex2, hex3, hex4, hex5;
	output led0, led1, led2, led3;
	reg led0, led1, led2, led3;
	reg display_work;//显示刷新,即显示寄存器的值实时更新为计数寄存器的值
	reg counter_work;//计数工作状态,由按键key_start_pause控制
	parameter DELAY_TIME = 10000000;//定义一个常量参数.10000000->200ms

	reg[3:0] minute_display_high;
	reg[3:0] minute_display_low;
	reg[3:0] second_display_high;
	reg[3:0] second_display_low;
	reg[3:0] msecond_display_high;
	reg[3:0] msecond_display_low;//定义6个计时数据(变量)寄存器
	reg[3:0] minute_counter_high;
	reg[3:0] minute_counter_low;
	reg[3:0] second_counter_high;
	reg[3:0] second_counter_low;
	reg[3:0] msecond_counter_high;
	reg[3:0] msecond_counter_low;//定义6个显示数据(变量)寄存器

	reg[31:0] counter_50M;//计时用计数器,每个50MHz的clock为20ns.
	//若选择板上的50MHz时钟，需要500000次20ns后,才是10ms.
	reg reset_1_time;//消抖动用状态寄存器--for reset KEY_display_stop
	reg[31:0] counter_reset;//按键状态时间计数器
	//**start_1_time为1计时0不计时**
	reg start_1_time;//消抖动用状态寄存器--for counter/pause KEY
	reg start_2_time;
	reg start_3_time;
	reg[31:0] counter_start;//按键状态时间计数器
	//**display_1_time为1不实时显示0实时显示**
	reg display_1_time;//消抖动用状态寄存器--for Key_display_refresh/pause
	reg display_2_time;
	reg display_3_time;
	reg[31:0] counter_display;//按键状态时间计数器

	reg start;//工作状态寄存器
	reg display;//工作状态寄存器

	//sevenseg模块为4位的BCD码至7段LED的译码器,下面实例化6个LED数码管的各自译码器.
	//**有些设备连接时hex3,hex2和hex1,hex0需要换位**
	sevenseg LED8_minute_display_high(minute_display_high, hex5);
	sevenseg LED8_minute_display_low(minute_display_low, hex4);
	sevenseg LED8_second_display_high(second_display_high, hex3);
	sevenseg LED8_second_display_low(second_display_low, hex2);
	sevenseg LED8_msecond_display_high(msecond_display_high, hex1);
	sevenseg LED8_msecond_display_low(msecond_display_low, hex0);

	always@(posedge clk)
	begin
		if (key_start_pause == 0 && start_1_time == 1 && start_2_time == 1 && start_3_time == 1)//如果计时按钮被按下,且之前不是按下的
			counter_work = 1 - counter_work;//反转是否计时状态
		if (key_display_stop == 0 && display_1_time == 1 && display_2_time == 1 && display_3_time == 1)//如果显示按钮被按下,且之前不是按下的
			display_work = 1 - display_work;//反转是否显示状态
			
		if (key_reset == 1'b0)//如果复位被按下
		begin
			msecond_counter_low = 0;
			msecond_counter_high  = 0;
			second_counter_low = 0;
			second_counter_high = 0;
			minute_counter_low = 0;
			minute_counter_high = 0;
			msecond_display_low = msecond_counter_low;
			msecond_display_high = msecond_counter_high;
			second_display_low = second_counter_low;
			second_display_high = second_counter_high;
			minute_display_low = minute_counter_low;
			minute_display_high = minute_counter_high;
			//**下面这部分是根据自己的想法加的:复位后默认"不计时"且"显示计时"**
			counter_work = 0;
			display_work = 0;
		end
		
		//**记录这一次的button状态以供下次使用**
		start_3_time = start_2_time;
		display_3_time = display_2_time;
		start_2_time = start_1_time;
		display_2_time = display_1_time;
		start_1_time = key_start_pause;
		display_1_time = key_display_stop;
			
		counter_50M = counter_50M + 1;
		if (counter_50M == 500000)//如果已经经过了500000个时钟周期
		begin
			counter_50M = 0;//重新计算时钟周期
			
			//**如果处于计时开始状态,则计时器内部更新**
			if (counter_work == 1)
			begin
				msecond_counter_low =  msecond_counter_low + 1;
				if (msecond_counter_low == 4'b1010)//满10进1
				begin
					msecond_counter_low = 0;
					msecond_counter_high = msecond_counter_high + 1;
					if (msecond_counter_high == 4'b1010)//满10进1
					begin
						msecond_counter_high = 0;
						second_counter_low = second_counter_low + 1;
						if (second_counter_low == 4'b1010)//满10进1
						begin
							second_counter_low = 0;
							second_counter_high = second_counter_high + 1;
							if (second_counter_high == 4'b0110)//满6进1
							begin
								second_counter_high = 0;
								minute_counter_low = minute_counter_low + 1;
								if (minute_counter_low == 4'b1010)//满10进1
								begin
									minute_counter_low = 0;
									minute_counter_high = minute_counter_high + 1;
									if (minute_counter_high == 4'b0110)//满6进1(没有hour位因此清零)
										minute_counter_high = 0;
								end
							end
						end
					end
				end
			end
			//**如果处于显示更新状态,则显示更新为内部数值**
			if (display_work == 0)
			begin
				msecond_display_low = msecond_counter_low;
				msecond_display_high = msecond_counter_high;
				second_display_low = second_counter_low;
				second_display_high = second_counter_high;
				minute_display_low = minute_counter_low;
				minute_display_high = minute_counter_high;
			end
		end
		

		
	end
endmodule


//4bit的BCD码至7段LED数码管译码器模块
module sevenseg(data, ledsegments);
	input[3:0] data;
	output ledsegments;
	reg[6:0] ledsegments;
	always@(*)
		case(data)
			//gfe_dcba	//7段LED数码管的位段编号
			//654_3210	//DE2板上的信号位编号
			0:ledsegments = 7'b100_0000;//DE2C板上的数码管为共阳极接法.
			1:ledsegments = 7'b111_1001;
			2:ledsegments = 7'b010_0100;
			3:ledsegments = 7'b011_0000;
			4:ledsegments = 7'b001_1001;
			5:ledsegments = 7'b001_0010;
			6:ledsegments = 7'b000_0010;
			7:ledsegments = 7'b111_1000;
			8:ledsegments = 7'b000_0000;
			9:ledsegments = 7'b001_0000;
			default:ledsegments = 7'b111_1111;//其他值时全灭
		endcase
endmodule
