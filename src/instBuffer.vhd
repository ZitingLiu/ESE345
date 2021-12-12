-------------------------------------------------------------------------------
--
-- Title       : instBuffer
-- Design      : pipelined
-- Author      : Ziting Liu
-- Company     : StonyBrook
--
-------------------------------------------------------------------------------
--
-- File        : C:\Users\liuzi\Desktop\2020f\345\project\pipelined\src\instBuffer.vhd
-- Generated   : Thu Nov 19 15:15:59 2020
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
entity instBuffer is
	 port(
	 clk : in STD_LOGIC; 
	 write : in STD_logic;
	 index : in STD_LOGIC_VECTOR(6 downto 0);
	 inst_in : in STD_LOGIC_VECTOR(24 downto 0);
	 inst : out STD_LOGIC_VECTOR(24 downto 0)
	 );
end instBuffer;

--}} End of automatically maintained section

architecture behavioral of instBuffer is  
type instructions is array (63 downto 0) of std_logic_vector(24 downto 0);
 

begin
	
   update:process(clk, write)
   variable ind:integer:=1;
   variable pc:integer:=0;
   variable myIns : instructions;
   begin
	   if rising_edge(clk) then	
		   ind := TO_INTEGER(SIGNED(index));
		   if(write='1') then
			   myIns(ind):=inst_in;
		   else
			   inst<=myIns(pc);
			   pc:=pc+1;
		   end if;
		   
	   
	   
	   
	   end if; 	  
	   
	end process;

	 

end behavioral;
