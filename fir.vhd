library ieee;
library ieee_proposed;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee_proposed.float_pkg.all;

use ieee_proposed.fixed_float_types.all;


entity FIR is 
	port(

		clk		: in  std_logic;

		enF		: in  std_logic;
		data     : in  float (8 downto -23);
		output   : out float (8 downto -23)
		);
end entity FIR;


architecture behavior of FIR is 
	
	subtype float32 is float (8 downto -23);
	type float_array is array(0 to 19) of float32;
	signal tap: float_array := ("00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000");	

	begin 
		process(clk) is 
		  variable coef0,coef1,coef2,coef3,coef4,coef5,coef6,coef7,coef8,coef9,coef10,coef11,coef12,coef13,
					  coef14,coef15,coef16,coef17,coef18,coef19 : float32;
			begin
				if (rising_edge(clk)) then
					if (enF = '1') then
						coef0 := to_float  (-0.0267 , coef0);
						coef1 := to_float  ( 0.1882 , coef1);
						coef2 := to_float  (-0.5272 , coef2);
						coef3 := to_float  ( 0.6885 , coef3);
						coef4 := to_float  (-0.2812 , coef4);
						coef5 := to_float  (-0.2498 , coef5);
						coef6 := to_float  ( 0.1959 , coef6);
						coef7 := to_float  ( 0.1274 , coef7);
						coef8 := to_float  (-0.0931 , coef8);
						coef9 := to_float  (-0.0714 , coef9);
						coef10 := to_float ( 0.0295 , coef10);
						coef11 := to_float ( 0.0332 , coef11);
						coef12 := to_float (-0.0036 , coef12);
						coef13 := to_float (-0.0107 , coef13);
						coef14 := to_float (-0.0014 , coef14);
						coef15 := to_float ( 0.0020 , coef15);
						coef16 := to_float ( 0.0007 , coef16);
						coef17 := to_float (-0.0001 , coef17);
						coef18 := to_float (-0.0001 , coef18);
						coef19 := to_float ( 0.0000 , coef19);			
						for i in 19 downto 1 loop
							tap(i) <= tap(i-1);
						end loop;
						tap(0) <= data;
						output <= tap(0)*(coef0)+tap(1)*(coef1)+tap(2)*(coef2)+tap(3)*(coef3)+tap(4)*(coef4)+tap(5)*(coef5)+tap(6)*(coef6)+tap(7)*(coef7)+tap(8)*(coef8)+tap(9)*(coef9)+tap(10)*(coef10)+tap(11)*(coef11)+tap(12)*(coef12)+tap(13)*(coef13)+tap(14)*(coef14)+tap(15)*(coef15)+tap(16)*(coef16)+tap(17)*(coef17)+tap(18)*(coef18)+tap(19)*(coef19);
							
						else output <= "00000000000000000000000000000000";

						end if;
					end if;			
		end process;		
end architecture;
