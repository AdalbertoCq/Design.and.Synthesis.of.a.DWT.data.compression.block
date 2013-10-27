library ieee; library ieee_proposed;
 use ieee.std_logic_1164.all; 
use ieee.std_logic_arith.all;
 use ieee.std_logic_unsigned.all;
 use ieee_proposed.float_pkg.all;
use ieee_proposed.fixed_float_types.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DWTH is
	port(
		clk		  : in  std_logic;
		enF		  : in  std_logic;
		encomp	  : in  std_logic; 
		data       : in  float (8 downto -23);
 		output     : out float (8 downto -23);
		nxtelement : out std_logic
		);
end DWTH;

architecture Behavioral of DWTH is
		--signals:
		--components
		component FIR port(
					clk		: in  std_logic;
					enF		: in  std_logic; 
					data    : in  float (8 downto -23); 
					output  : out float (8 downto -23)
								);
		end component;
		component compress port(
					clk		   : in  std_logic;
					encomp     : in  std_logic; 
					data       : in  float (8 downto -23); 
					output     : out float (8 downto -23);
					nxtelement : out std_logic
								);
		end component;
		
		SIGNAL firoutput : float (8 downto -23);
		
begin		
		
		filterH : entity WORK.FIR(behavior)
						port map (clk,enF,data,firoutput);
						
		comp	  : entity WORK.compress(behavior) 
						port map(clk,encomp,firoutput,output,nxtelement);

end Behavioral;
