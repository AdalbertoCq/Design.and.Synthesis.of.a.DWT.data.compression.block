library ieee;
library ieee_proposed;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee_proposed.float_pkg.all;

use ieee_proposed.fixed_float_types.all;

entity Compress is 
	port(
	   clk        : in   std_logic;
	   encomp	  : in   std_logic;
	   data       : in   float (8 downto -23);
	   output     : out  float (8 downto -23);
	   nxtelement : out  std_logic
	);
end entity Compress;    

architecture behavior of Compress is 
	signal num           : integer :=0;
	begin 
		CompressSelection : process(clk) is 
		begin
			if (rising_edge(clk)) then
				if (encomp = '1') then
					num <= num  + 1;
					if (num = 19) then 
						nxtelement <= '1';
					end if;
					if (((num)>= 20) and (num<=2066)) then 
							if (((num) mod 2) = 0) then 
								output <= data;
							end if;
					end if;
						else output <="00000000000000000000000000000000";
						end if;
			end if;
end process;		
end architecture;

