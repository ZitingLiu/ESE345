-------------------------------------------------------------------------------
--
-- Title       : exe_tb
-- Design      : pipelined
-- Author      : Ziting Liu
-- Company     : StonyBrook
--
-------------------------------------------------------------------------------
--
-- File        : C:\Users\liuzi\Desktop\2020f\345\project\pipelined\src\exe_tb.vhd
-- Generated   : Mon Nov 23 14:09:52 2020
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
--{entity {exe_tb} architecture {tb}}
library IEEE;
use IEEE.std_logic_1164.all;  
library work;	
use work.all;
use ieee.numeric_std.all;


entity exe_tb is
end exe_tb;

--}} End of automatically maintained section

architecture tb of exe_tb is  
signal clock:std_logic;
signal mux1:std_logic;
signal mux2:std_logic;
signal mux3:std_logic;
signal RdWrite:std_logic;
signal forward:std_logic_vector(127 downto 0);
signal rs1:std_logic_vector(127 downto 0);
signal rs2:std_logic_vector(127 downto 0);
signal rs3:std_logic_vector(127 downto 0);
signal rd:std_logic_vector(127 downto 0);
signal RdAddr:std_logic_vector(4 downto 0);
signal Rs2Addr:std_logic_vector(4 downto 0);
signal op_code:std_logic_vector(4 downto 0);
signal imm:std_logic_vector(15 downto 0);
signal index:std_logic_vector(2 downto 0);
signal data_out:std_logic_vector(127 downto 0);
signal wrAddr:std_logic_vector(4 downto 0);
constant period_1:time:=20ns;
constant period_2:time:=40ns;
begin
	UUT: entity executeAlu port map(
		clock=>clock,
		mux1=>mux1,
		mux2=>mux2,
		mux3=>mux3,
		RdWrite=>RdWrite,
		forward=>forward,
		data_in_1=>rs1,
		data_in_2=>rs2,
		data_in_3=>rs3,
		rd=>rd,
		RdAddr=>RdAddr,
		op_code_in=>op_code,
		imm=>imm,
		index=>index,
		data_out=>data_out,
		wrAddr=>wrAddr,
		constIn=>Rs2Addr
		); 
		
		mux1<='0';
		mux2<='0';
		mux3<='0';
		RdWrite<='1';
		rs1<=x"00000000000000000000000000000009";
		rs2<=x"00000000000000000000000000000005";
		rs3<=x"00000000000000000000000000000004";
		rd<=x"00000000000000000000000000000000";
		forward<=x"00000000000000000000000000000000"; 
		imm<=x"8888";
		index<="000";
		Rs2Addr<="00011";
		clk:process
		begin
			clock<='0';	   
			for i in 0 to 100 loop
				wait for period_1;
				clock<=not clock;
				
			end loop;
		end process;
		
		op:process
		variable code:integer:=1;
		begin
			op_code<=std_logic_vector(to_unsigned(code,5));
			for i in 0 to 25 loop
				wait for period_2; 
				code:=code+1;
				op_code<=std_logic_vector(to_unsigned(code,5));
				
			end loop;
		end process;

end tb;
