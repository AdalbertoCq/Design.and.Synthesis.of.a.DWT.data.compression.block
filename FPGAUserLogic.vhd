------------------------------------------------------------------------------
-- user_logic.vhd - entity/architecture pair
------------------------------------------------------------------------------
--
-- ***************************************************************************
-- ** Copyright (c) 1995-2012 Xilinx, Inc.  All rights reserved.            **
-- **                                                                       **
-- ** Xilinx, Inc.                                                          **
-- ** XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"         **
-- ** AS A COURTESY TO YOU, SOLELY FOR USE IN DEVELOPING PROGRAMS AND       **
-- ** SOLUTIONS FOR XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE,        **
-- ** OR INFORMATION AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,        **
-- ** APPLICATION OR STANDARD, XILINX IS MAKING NO REPRESENTATION           **
-- ** THAT THIS IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,     **
-- ** AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE      **
-- ** FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY              **
-- ** WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE               **
-- ** IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR        **
-- ** REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF       **
-- ** INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS       **
-- ** FOR A PARTICULAR PURPOSE.                                             **
-- **                                                                       **
-- ***************************************************************************
--
------------------------------------------------------------------------------
-- Filename:          user_logic.vhd
-- Version:           1.00.a
-- Description:       User logic.
-- Date:              Wed Jul 24 13:05:47 2013 (by Create and Import Peripheral Wizard)
-- VHDL Standard:     VHDL'93
------------------------------------------------------------------------------
-- Naming Conventions:
--   active low signals:                    "*_n"
--   clock signals:                         "clk", "clk_div#", "clk_#x"
--   reset signals:                         "rst", "rst_n"
--   generics:                              "C_*"
--   user defined types:                    "*_TYPE"
--   state machine next state:              "*_ns"
--   state machine current state:           "*_cs"
--   combinatorial signals:                 "*_com"
--   pipelined or register delay signals:   "*_d#"
--   counter signals:                       "*cnt*"
--   clock enable signals:                  "*_ce"
--   internal version of output port:       "*_i"
--   device pins:                           "*_pin"
--   ports:                                 "- Names begin with Uppercase"
--   processes:                             "*_PROCESS"
--   component instantiations:              "<ENTITY_>I_<#|FUNC>"
------------------------------------------------------------------------------

-- DO NOT EDIT BELOW THIS LINE --------------------


library proc_common_v3_00_a;
use proc_common_v3_00_a.proc_common_pkg.all;

library ieee;

library work;
library ieee_proposed;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee_proposed.float_pkg.all;

use ieee_proposed.fixed_float_types.all;

use work.all;

-- DO NOT EDIT ABOVE THIS LINE --------------------

--USER libraries added here

------------------------------------------------------------------------------
-- Entity section
------------------------------------------------------------------------------
-- Definition of Generics:
--   C_SLV_AWIDTH                 -- Slave interface address bus width
--   C_SLV_DWIDTH                 -- Slave interface data bus width
--   C_NUM_MEM                    -- Number of memory spaces
--
-- Definition of Ports:
--   Bus2IP_Clk                   -- Bus to IP clock
--   Bus2IP_Resetn                -- Bus to IP reset
--   Bus2IP_Addr                  -- Bus to IP address bus
--   Bus2IP_CS                    -- Bus to IP chip select for user logic memory selection
--   Bus2IP_RNW                   -- Bus to IP read/not write
--   Bus2IP_Data                  -- Bus to IP data bus
--   Bus2IP_BE                    -- Bus to IP byte enables
--   Bus2IP_RdCE                  -- Bus to IP read chip enable
--   Bus2IP_WrCE                  -- Bus to IP write chip enable
--   Bus2IP_Burst                 -- Bus to IP burst-mode qualifier
--   Bus2IP_BurstLength           -- Bus to IP burst length
--   Bus2IP_RdReq                 -- Bus to IP read request
--   Bus2IP_WrReq                 -- Bus to IP write request
--   IP2Bus_AddrAck               -- IP to Bus address acknowledgement
--   IP2Bus_Data                  -- IP to Bus data bus
--   IP2Bus_RdAck                 -- IP to Bus read transfer acknowledgement
--   IP2Bus_WrAck                 -- IP to Bus write transfer acknowledgement
--   IP2Bus_Error                 -- IP to Bus error response
--   Type_of_xfer                 -- Transfer Type
------------------------------------------------------------------------------

entity user_logic is
  generic
  (
    -- ADD USER GENERICS BELOW THIS LINE ---------------
    --USER generics added here
    -- ADD USER GENERICS ABOVE THIS LINE ---------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol parameters, do not add to or delete
    C_SLV_AWIDTH                   : integer              := 32;
    C_SLV_DWIDTH                   : integer              := 32;
    C_NUM_MEM                      : integer              := 3
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );
  port
  (
    -- ADD USER PORTS BELOW THIS LINE ------------------
    --USER ports added here
    -- ADD USER PORTS ABOVE THIS LINE ------------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol ports, do not add to or delete
    Bus2IP_Clk                     : in  std_logic;
    Bus2IP_Resetn                  : in  std_logic;
    Bus2IP_Addr                    : in  std_logic_vector(C_SLV_AWIDTH-1 downto 0);
    Bus2IP_CS                      : in  std_logic_vector(C_NUM_MEM-1 downto 0);
    Bus2IP_RNW                     : in  std_logic;
    Bus2IP_Data                    : in  std_logic_vector(C_SLV_DWIDTH-1 downto 0);
    Bus2IP_BE                      : in  std_logic_vector(C_SLV_DWIDTH/8-1 downto 0);
    Bus2IP_RdCE                    : in  std_logic_vector(C_NUM_MEM-1 downto 0);
    Bus2IP_WrCE                    : in  std_logic_vector(C_NUM_MEM-1 downto 0);
    Bus2IP_Burst                   : in  std_logic;
    Bus2IP_BurstLength             : in  std_logic_vector(7 downto 0);
    Bus2IP_RdReq                   : in  std_logic;
    Bus2IP_WrReq                   : in  std_logic;
    IP2Bus_AddrAck                 : out std_logic;
    IP2Bus_Data                    : out std_logic_vector(C_SLV_DWIDTH-1 downto 0);
    IP2Bus_RdAck                   : out std_logic;
    IP2Bus_WrAck                   : out std_logic;
    IP2Bus_Error                   : out std_logic;
    Type_of_xfer                   : out std_logic
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );

  attribute MAX_FANOUT : string;
  attribute SIGIS : string;

  attribute SIGIS of Bus2IP_Clk    : signal is "CLK";
  attribute SIGIS of Bus2IP_Resetn : signal is "RST";

end entity user_logic;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture IMP of user_logic is

  --USER signal declarations added here, as needed for user logic

  ------------------------------------------
  -- Signals for user logic memory space example
  ------------------------------------------
  type RAM is array (0 to 2047) of std_logic_vector (31 downto 0); 
  --type DO_TYPE is array (0 to C_NUM_MEM-1) of std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal mem_data_out           : std_logic_vector (31 downto 0);
  signal mem_address            : std_logic_vector(7 downto 0);
  signal mem_select             : std_logic_vector(0 to 2);
  signal mem_read_enable        : std_logic;
  signal mem_ip2bus_data        : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal mem_read_ack_dly1      : std_logic;
  signal mem_read_ack_dly2      : std_logic;
  signal mem_read_ack           : std_logic;
  signal mem_write_ack          : std_logic;
  signal status_reg				: std_logic_vector(31 downto 0);
  signal ram_input_mem          : RAM;
  signal ram_output_mem         : RAM;
  signal access_input_element   : integer;
  signal access_output_element  : integer;
  signal writeMemout            : std_logic;
  signal Routaddres_out1        : std_logic_vector(31 downto 0);
  signal Routaddres_out2        : std_logic_vector(31 downto 0);
  signal Routdata_in1           : float (8 downto -23); 
  signal Routdata_in2           : float (8 downto -23); 
  signal Rinaddres_out          : std_logic_vector(31 downto 0);
  signal Rindata_out            : float (8 downto -23); 
  signal RinCRead               : std_logic;
  signal enF					: std_logic;
  signal encomp					: std_logic;
  signal nxtelementH,nxtelementL: std_logic;
  signal regcontrol				: std_logic;
  signal startmem  				: std_logic;
  signal datacontrol			: std_logic_vector(31 downto 0);
  signal access_input_data      : std_logic_vector(31 downto 0);
  signal access_output_data     : std_logic_vector(31 downto 0);

  ---components declaration

		component DWTL port(
					clk		  : in  std_logic;
					enF		  : in  std_logic;
					encomp	  : in  std_logic;
					data      : in  float (8 downto -23);
					output    : out float (8 downto -23);
					nxtelement: out std_logic
							);
		end component;

		component DWTH port(
					clk		  : in  std_logic;
					enF		  : in  std_logic;
					encomp	  : in  std_logic;
					data      : in  float (8 downto -23);
					output    : out float (8 downto -23);
					nxtelement: out std_logic
							);
		end component;

		component FSM port(
					clk                : in     std_logic;
					enF	               : out    std_logic;
					encomp	           : out    std_logic;
					nxtelement         : in     std_logic;
					startmem           : in     std_logic;   --it works as a reset.
					addressMinputout   : inout  std_logic_vector(31 downto 0);
					addressMoutputoutH : inout  std_logic_vector(31 downto 0);
					addressMoutputoutL : inout  std_logic_vector(31 downto 0);
					writeMemout		   : out    std_logic;
					readMemin		   : out    std_logic;
					datacontrol		   : out    std_logic_vector(31 downto 0);
					regcontrol		   : out    std_logic
							); 
		end component;
  
begin

  --USER logic implementation added here

	DWTHigh : DWTH PORT MAP(
						clk => Bus2IP_Clk ,
						enF => enF,
						encomp => encomp,
						data => Rindata_out,
						output => Routdata_in1,
						nxtelement => nxtelementH
						 );

	DWTLow  : DWTL PORT MAP(
						clk         => Bus2IP_Clk,
						enF         => enF,
						encomp      => encomp,
						data        => Rindata_out,
						output      => Routdata_in2,
						nxtelement  => nxtelementL
						 );

	FSMfinal  : FSM PORT MAP (
						clk         => Bus2IP_Clk,
						enF         => enF,
						encomp      => encomp,
						nxtelement  => nxtelementH,
						startmem    => startmem,
						addressMinputout   => Rinaddres_out,
						addressMoutputoutH => Routaddres_out1,
						addressMoutputoutL => Routaddres_out2,
						writeMemout        => writeMemout,
						readMemin		   => RinCread,
						datacontrol        => datacontrol,
						regcontrol         => regcontrol
							 );					
  ------------------------------------------
  -- Example code to access user logic memory region
  -- 
  -- Note:
  -- The example code presented here is to show you one way of using
  -- the user logic memory space features. The Bus2IP_Addr, Bus2IP_CS,
  -- and Bus2IP_RNW IPIC signals are dedicated to these user logic
  -- memory spaces. Each user logic memory space has its own address
  -- range and is allocated one bit on the Bus2IP_CS signal to indicated
  -- selection of that memory space. Typically these user logic memory
  -- spaces are used to implement memory controller type cores, but it
  -- can also be used in cores that need to access additional address space
  -- (non C_BASEADDR based), s.t. bridges. This code snippet infers
  -- 3 256x32-bit (byte accessible) single-port Block RAM by XST.
  ------------------------------------------
  mem_select      <= Bus2IP_CS;
  mem_read_enable <= ( Bus2IP_RdCE(0) or Bus2IP_RdCE(2) );
  mem_read_ack    <= mem_read_ack_dly1 and (not mem_read_ack_dly2);
  mem_write_ack   <= ( Bus2IP_WrCE(0) or Bus2IP_WrCE(1) );

  -- this process generates the read acknowledge 1 clock after read enable
  -- is presented to the BRAM block. The BRAM block has a 1 clock delay
  -- from read enable to data out.
  
  BRAM_RD_ACK_PROC : process( Bus2IP_Clk ) is
  begin

    if ( Bus2IP_Clk'event and Bus2IP_Clk = '1' ) then
      if ( Bus2IP_Resetn = '0' ) then
        mem_read_ack_dly1 <= '0';
        mem_read_ack_dly2 <= '0';
      else
        mem_read_ack_dly1 <= mem_read_enable;
        mem_read_ack_dly2 <= mem_read_ack_dly1;
      end if;
    end if;

  end process BRAM_RD_ACK_PROC;
  -- REGISTER
  
  REG : process(Bus2IP_Clk)
  begin
    if(Bus2IP_Clk'event and Bus2IP_Clk = '1') then
      if Bus2IP_Resetn = '0' then
        status_reg <= (others => '0');
      else
        if Bus2IP_WrCE(0) = '1' then
		    if Bus2IP_Data(0) = '1' then
				startmem <='1';
			 end if;
          status_reg <= Bus2IP_Data;
        end if;
		  if regcontrol ='1' then 
			 status_reg <= datacontrol;
		  end if;
      end if;
    end if;
  end process;
  
  -- Input Block
  
  RAM_IN : process(Bus2IP_Clk)
  begin
    if(Bus2IP_Clk'event and Bus2IP_Clk = '1') then
      if Bus2IP_WrCE(1) = '1' then
        ram_input_mem(CONV_INTEGER(Bus2IP_Addr(12 downto 2))) <= Bus2IP_Data;
      end if;
      if RinCRead = '1' then
         Rindata_out <= to_float(ram_input_mem(CONV_INTEGER(Rinaddres_out)));
      end if;
	end if;
  end process;
    
  -- Output Block
  
  RAM_OUT : process(Bus2IP_Clk)
  begin
    if(Bus2IP_Clk'event and Bus2IP_Clk = '1') then
      if writeMemout = '1' then
        ram_output_mem(CONV_INTEGER(Routaddres_out1)) <= to_slv(Routdata_in1);
		  ram_output_mem(CONV_INTEGER(Routaddres_out2)) <= to_slv(Routdata_in2);
      end if;
    end if;
  end process;
  
  MEM_RD_BLOC2_PROC : process(Bus2IP_Clk) is
  begin
    if(Bus2IP_Clk'event and Bus2IP_Clk = '1') then
      mem_data_out <=ram_output_mem(CONV_INTEGER(Bus2IP_Addr(12 downto 2)));
    end if;
  end process MEM_RD_BLOC2_PROC;
  
  -- Bus 2 IP Mux
  
  MEM_IP2BUS_DATA_PROC : process( mem_data_out, mem_select ) is
  begin
    case mem_select is
      when "001" =>  mem_ip2bus_data <= status_reg;
      when "100" =>  mem_ip2bus_data <= mem_data_out;
      when others => mem_ip2bus_data <= (others => '0');
    end case;
  end process MEM_IP2BUS_DATA_PROC;
end IMP;
