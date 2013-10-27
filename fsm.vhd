library ieee; 
library ieee_proposed;
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

entity FSM is
		port(
			  clk                : in     std_logic;
			  enF	             : out    std_logic;
			  encomp	         : out    std_logic;
			  nxtelement         : in     std_logic;
			  startmem           : in     std_logic;   --it works as a reset.
			  addressMinputout   : inout  std_logic_vector(31 downto 0);
			  addressMoutputoutH : inout  std_logic_vector(31 downto 0);
			  addressMoutputoutL : inout  std_logic_vector(31 downto 0);
			  writeMemout		 : out    std_logic;
			  readMemin			 : out    std_logic;
			  datacontrol		 : out    std_logic_vector(31 downto 0);
			  regcontrol		 : out    std_logic
			  ); 
end FSM;

architecture Behavioral of FSM is
	type state_type is (s1, s2, s3, s3a, s4, s4a, s5, s5a, s6);
	SIGNAL state : state_type;
	begin
	process (state)
		variable auxin, auxoutH, auxoutL      : std_logic_vector(31 downto 0) := (others => '0');
		variable auxwriteMemout, auxreadMemin : std_logic;
		
		begin 
			case state is
			 when s1  => readMemin <= '1';
						enF       <= '0';
						encomp    <= '0';
						addressMinputout <= "00000000000000000000000000000000"; 
						addressMoutputoutH  <= "00000000000000000000000000000000";
						addressMoutputoutL  <= "00000000000000000000010000001001";
						writeMemout         <= '0';  
						auxin               := "00000000000000000000000000000000";  
						auxoutH             := "00000000000000000000000000000000";
						auxoutL             := "00000000000000000000010000001001";
						datacontrol			<= "00000000000000000000000000000000";
						regcontrol		    <= '0';
										
			when s2  => enF <= '1';
						auxin := auxin + "00000000000000000000000000000001";
						addressMinputout   <= auxin;
			when s3  => encomp <= '1';
						auxin := auxin + "00000000000000000000000000000001";
						addressMinputout   <= auxin;
						
			when s3a => auxin := auxin + "00000000000000000000000000000001";
						addressMinputout   <= auxin;
			when s4  => auxin := auxin + "00000000000000000000000000000001";
						addressMinputout   <= auxin;
						 writeMemout        <= '1';
						auxoutH            := auxoutH + "00000000000000000000000000000001";
						addressMoutputoutH <= auxoutH;
						auxoutL            := auxoutL + "00000000000000000000000000000001";
						addressMoutputoutL <= auxoutL;
			when s4a => auxin := auxin + "00000000000000000000000000000001";
						addressMinputout   <= auxin;
						writeMemout        <= '0';
			when s5 =>  auxreadMemin       := '0'; 
						readMemin          <= auxreadMemin;
						auxoutH            := auxoutH + "00000000000000000000000000000001";
						addressMoutputoutH <= auxoutH;
						auxoutL            := auxoutL + "00000000000000000000000000000001";
						addressMoutputoutL <= auxoutL;
			when s5a => addressMoutputoutH <= auxoutH;
						addressMoutputoutL <= auxoutL;
						writeMemout        <= '0'; 	
			when s6  => writeMemout 	   <= '0'; 
						encomp 			   <= '0'; 
						enF 		   	   <= '0'; 
						datacontrol		   <= "00000000000000000000000000001111";
						regcontrol		   <= '1';
			end case;		
		end process;
	process (clk, nxtelement, startmem)
		Begin
		if( startmem='1') then 
 			state <= s1;
		end if;
			if (rising_edge(clk)) then
				
				case state is 					
				when s1 => state <= s2;
				when s2 => state <= s3; 
				when s3 => if (nxtelement = '1') then state <= s4;
						else state <= s3a;
					       end if;
				when s3a=> if (nxtelement = '1') then state <= s4;
						   else state <= s3;
							end if; 
				when s4 => if (CONV_INTEGER(addressMinputout)  >= 2047) then 
							state <= s5;
						  else state <= s4a; 
						  end if;
				when s4a=> if (CONV_INTEGER(addressMinputout)  >= 2047) then 
							state <= s5;
						  else state <= s4;
						   end if; 
				when s5 => if (CONV_INTEGER(addressMoutputoutH) >= 1032) then 
							state <= s6; 								    
						   else state <= s5a;
						   end if;
				when s5a=> if (CONV_INTEGER(addressMoutputoutH) >= 1032) then 
							state <= s6; 								    
						   else state <= s5;
				  		   end if;
				when s6 => state <= s1;	
			end case;
				
			end if;
	
	end process;
	
end Behavioral;
