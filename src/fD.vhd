-------------------------------------------------------------------------------
--
-- Title       : fD
-- Design      : pipelined
-- Author      : Ziting Liu
-- Company     : StonyBrook
--
-------------------------------------------------------------------------------
--
-- File        : C:\Users\liuzi\Desktop\2020f\345\project\pipelined\src\fD.vhd
-- Generated   : Thu Nov 26 18:04:45 2020
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {fD} architecture {behavioral}}

library IEEE;
use IEEE.std_logic_1164.all;

entity fD is
	 port(
		 mux1 : out STD_LOGIC;
		 mux2 : out STD_LOGIC;
		 mux3 : out STD_LOGIC; 
		 mux4: out std_logic;
		 rd_prev: in std_logic_vector(4 downto 0);
		 rd : in STD_LOGIC_VECTOR(4 downto 0);
		 rs1 : in STD_LOGIC_VECTOR(4 downto 0);
		 rs2 : in STD_LOGIC_VECTOR(4 downto 0);
		 rs3 : in STD_LOGIC_VECTOR(4 downto 0);
		 data_in: in std_logic_vector(127 downto 0);
		 data_out: out std_logic_vector(127 downto 0)
	     );
end fD;

--}} End of automatically maintained section

architecture behavioral of fD is
begin
	forward:process
	begin
		wait for 10ns;
		if rs1=rd then
			mux1<='1';
		else
			mux1<='0';
		end if;
	
		if rs2=rd then
			mux2<='1';
		else
			mux2<='0';
		end if;
	
		if rs3=rd then
			mux3<='1';
		else
			mux3<='0';
		end if;
		
		if rd_prev=rd then
			mux4<='1';
		else
			mux4<='0';
			
		end if;
		
	
		data_out<=data_in;
	end process;
end behavioral;
