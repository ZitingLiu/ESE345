-------------------------------------------------------------------------------
--
-- Title       : executeAlu
-- Design      : pipelined
-- Author      : Ziting Liu
-- Company     : StonyBrook
--
-------------------------------------------------------------------------------
--
-- File        : C:\Users\liuzi\Desktop\2020f\345\project\pipelined\src\executeAlu.vhd
-- Generated   : Sun Nov 22 14:14:55 2020
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
--{entity {executeAlu} architecture {behavioral}}

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
use IEEE.math_real.all;
entity executeAlu is
	port(		 
		 clock: in STD_LOGIC;	
		 mux1 : in STD_LOGIC;
		 mux2 : in STD_LOGIC;
		 mux3 : in STD_LOGIC; 
		 mux4: in Std_logic;
		 
		 RdWrite : out STD_LOGIC;  
		 
		 forward : in std_logic_vector(127 downto 0);
		 constIn : in std_logic_vector(4 downto 0);
		 data_in_1 : in STD_LOGIC_VECTOR(127 downto 0);
		 data_in_2 : in STD_LOGIC_VECTOR(127 downto 0);
		 data_in_3 : in STD_LOGIC_VECTOR(127 downto 0);
		 rd : in STD_LOGIC_VECTOR(127 downto 0);
		 RdAddr : in STD_LOGIC_VECTOR(4 downto 0);
		 op_code_in : in STD_LOGIC_VECTOR(4 downto 0);
		 imm : in std_logic_vector(15 downto 0);  
		 index : in std_logic_vector(2 downto 0);
		 
		 
		 data_out : out STD_LOGIC_VECTOR(127 downto 0);
		 wrAddr : out STD_LOGIC_VECTOR(4 downto 0)	
		 
	     );
end executeAlu;

--}} End of automatically maintained section

architecture behavioral of executeAlu is

--signal up:signed(63 downto 0):=to_signed(9223372036854775807,64);


constant up16: integer:= 65535;
constant down16: integer:= -65536;
constant up32 : integer := 2147483647; 
constant down32 : integer :=  -2147483648; 
--constant up64 : integer := 2147483647;
--constant down64 : integer := -2147483648;

signal up64:signed(63 downto 0); 
signal down64:signed(63 downto 0);

begin
	
	alu:process(clock)
	variable ind:integer:=0;
	variable temp16_1:integer:=0;
	variable temp16_2:integer:=0;
	variable temp16_3:integer:=0;
	variable temp32_1:integer:=0;
	variable temp32_2:integer:=0;
	variable temp32_3:integer:=0;
	variable temp64: integer:=0;
	variable count: integer:=0;
	variable op_code: integer:=0;
	variable keeper:std_logic;
	variable rot:std_logic_vector(31 downto 0);
	variable rs1: std_logic_vector(127 downto 0);
	variable rs2: std_logic_vector(127 downto 0);
	variable rs3: std_logic_vector(127 downto 0);
	variable loadImmTemp: std_logic_vector(127 downto 0);
	variable temp:signed(63 downto 0);
	begin 
		up64<="0111111111111111111111111111111111111111111111111111111111111111";
		down64<="1000000000000000000000000000000000000000000000000000000000000000";
		op_code:=TO_INTEGER(unsigned(op_code_in));
		if rising_edge(clock) then		 --------------------------------------------------------------
			
			if mux1='1' then           --hazard protection for rs_1
				  rs1:=forward;
			else
				  rs1:=data_in_1;
			end if;
			
			if mux2='1' then			--hazard protection for rs_2
				  rs2:=forward;
			else
				  rs2:=data_in_2;
			end if;
			
			if mux3='1' then			--hazard protection for rs_3
				   rs3:=forward;
			else
				   rs3:=data_in_3;
			end if;
			
			if mux4='1' then			--hazard protection for rs_3
				   loadImmTemp:=forward;
			else
				   loadImmTemp:= rd;
			end if;
			ind:= TO_INTEGER(unSIGNED(index));
			--end mux statement------------------------------------------------------------------
			
			if op_code=1 then	 --load imm
				
				loadImmTemp(ind*16+15 downto ind*16):=imm;
				data_out<=loadImmTemp;
			elsif op_code=2 then	--Signed Integer Multiply-Add Low with Saturation 
				temp32_1:=TO_INTEGER(signed(rs1(31 downto 0)))+TO_INTEGER(signed(rs2(15 downto 0)))*TO_INTEGER(signed(rs3(15 downto 0)));
				if temp32_1>up32 then
					data_out(31 downto 0)<=	std_logic_vector(to_signed(up32,32));
				elsif temp32_1< down32 then 
					  data_out(31 downto 0)<=std_logic_vector(to_signed(down32,32));
				else
					  data_out(31 downto 0)<=std_logic_vector(to_signed(temp32_1,32));
				end if;
				temp32_1:=TO_INTEGER(signed(rs1(63 downto 32)))+TO_INTEGER(signed(rs2(47 downto 32)))*TO_INTEGER(signed(rs3(47 downto 32)));
				if temp32_1>up32 then
					data_out(63 downto 32)<=	std_logic_vector(to_signed(up32,32));
				elsif temp32_1< down32 then 
					  data_out(63 downto 32)<=std_logic_vector(to_signed(down32,32));
				else
					  data_out(63 downto 32)<=std_logic_vector(to_signed(temp32_1,32));
				end if;
				temp32_1:=TO_INTEGER(signed(rs1(95 downto 64)))+TO_INTEGER(signed(rs2(79 downto 64)))*TO_INTEGER(signed(rs3(79 downto 64)));
				if temp32_1>up32 then
					data_out(95 downto 64)<=	std_logic_vector(to_signed(up32,32));
				elsif temp32_1< down32 then 
					  data_out(95 downto 64)<=std_logic_vector(to_signed(down32,32));
				else
					  data_out(95 downto 64)<=std_logic_vector(to_signed(temp32_1,32));
				end if;
				temp32_1:=TO_INTEGER(signed(rs1(127 downto 96)))+TO_INTEGER(signed(rs2(111 downto 96)))*TO_INTEGER(signed(rs3(111 downto 96)));
				if temp32_1>up32 then
					data_out(127 downto 96)<=	std_logic_vector(to_signed(up32,32));
				elsif temp32_1< down32 then 
					  data_out(127 downto 96)<=std_logic_vector(to_signed(down32,32));
				else
					  data_out(127 downto 96)<=std_logic_vector(to_signed(temp32_1,32));
				end if;
			elsif op_code=3 then	 --Signed Integer Multiply-Add High with Saturation
				temp32_1:=TO_INTEGER(signed(rs1(31 downto 0)))+TO_INTEGER(signed(rs2(31 downto 16)))*TO_INTEGER(signed(rs3(31 downto 16)));
				if temp32_1>up32 then
					data_out(31 downto 0)<=	std_logic_vector(to_signed(up32,32));
				elsif temp32_1< down32 then 
					  data_out(31 downto 0)<=std_logic_vector(to_signed(down32,32));
				else
					  data_out(31 downto 0)<=std_logic_vector(to_signed(temp32_1,32));
				end if;
				temp32_1:=TO_INTEGER(signed(rs1(63 downto 32)))+TO_INTEGER(signed(rs2(63 downto 48)))*TO_INTEGER(signed(rs3(63 downto 48)));
				if temp32_1>up32 then
					data_out(63 downto 32)<=	std_logic_vector(to_signed(up32,32));
				elsif temp32_1< down32 then 
					  data_out(63 downto 32)<=std_logic_vector(to_signed(down32,32));
				else
					  data_out(63 downto 32)<=std_logic_vector(to_signed(temp32_1,32));
				end if;
				temp32_1:=TO_INTEGER(signed(rs1(95 downto 64)))+TO_INTEGER(signed(rs2(95 downto 80)))*TO_INTEGER(signed(rs3(95 downto 80)));
				if temp32_1>up32 then
					data_out(95 downto 64)<=	std_logic_vector(to_signed(up32,32));
				elsif temp32_1< down32 then 
					  data_out(95 downto 64)<=std_logic_vector(to_signed(down32,32));
				else
					  data_out(95 downto 64)<=std_logic_vector(to_signed(temp32_1,32));
				end if;
				temp32_1:=TO_INTEGER(signed(rs1(127 downto 96)))+TO_INTEGER(signed(rs2(127 downto 112)))*TO_INTEGER(signed(rs3(127 downto 112)));
				if temp32_1>up32 then
					data_out(127 downto 96)<=	std_logic_vector(to_signed(up32,32));
				elsif temp32_1< down32 then 
					  data_out(127 downto 96)<=std_logic_vector(to_signed(down32,32));
				else
					  data_out(127 downto 96)<=std_logic_vector(to_signed(temp32_1,32));
				end if;
			elsif op_code=4 then	 --Signed Integer Multiply-Subtract Low with Saturation
				temp32_1:=TO_INTEGER(signed(rs1(31 downto 0)))-TO_INTEGER(signed(rs2(15 downto 0)))*TO_INTEGER(signed(rs3(15 downto 0)));
				if temp32_1>up32 then
					data_out(31 downto 0)<=	std_logic_vector(to_signed(up32,32));
				elsif temp32_1< down32 then 
					  data_out(31 downto 0)<=std_logic_vector(to_signed(down32,32));
				else
					  data_out(31 downto 0)<=std_logic_vector(to_signed(temp32_1,32));
				end if;
				temp32_1:=TO_INTEGER(signed(rs1(63 downto 32)))-TO_INTEGER(signed(rs2(47 downto 32)))*TO_INTEGER(signed(rs3(47 downto 32)));
				if temp32_1>up32 then
					data_out(63 downto 32)<=	std_logic_vector(to_signed(up32,32));
				elsif temp32_1< down32 then 
					  data_out(63 downto 32)<=std_logic_vector(to_signed(down32,32));
				else
					  data_out(63 downto 32)<=std_logic_vector(to_signed(temp32_1,32));
				end if;
				temp32_1:=TO_INTEGER(signed(rs1(95 downto 64)))-TO_INTEGER(signed(rs2(79 downto 64)))*TO_INTEGER(signed(rs3(79 downto 64)));
				if temp32_1>up32 then
					data_out(95 downto 64)<=	std_logic_vector(to_signed(up32,32));
				elsif temp32_1< down32 then 
					  data_out(95 downto 64)<=std_logic_vector(to_signed(down32,32));
				else
					  data_out(95 downto 64)<=std_logic_vector(to_signed(temp32_1,32));
				end if;
				temp32_1:=TO_INTEGER(signed(rs1(127 downto 96)))-TO_INTEGER(signed(rs2(111 downto 96)))*TO_INTEGER(signed(rs3(111 downto 96)));
				if temp32_1>up32 then
					data_out(127 downto 96)<=	std_logic_vector(to_signed(up32,32));
				elsif temp32_1< down32 then 
					  data_out(127 downto 96)<=std_logic_vector(to_signed(down32,32));
				else
					  data_out(127 downto 96)<=std_logic_vector(to_signed(temp32_1,32));
				end if;
			elsif op_code=5 then	  --Signed Integer Multiply-Subtract High with Saturation
				temp32_1:=TO_INTEGER(signed(rs1(31 downto 0)))-TO_INTEGER(signed(rs2(31 downto 16)))*TO_INTEGER(signed(rs3(31 downto 16)));
				if temp32_1>up32 then
					data_out(31 downto 0)<=	std_logic_vector(to_signed(up32,32));
				elsif temp32_1< down32 then 
					  data_out(31 downto 0)<=std_logic_vector(to_signed(down32,32));
				else
					  data_out(31 downto 0)<=std_logic_vector(to_signed(temp32_1,32));
				end if;
				temp32_1:=TO_INTEGER(signed(rs1(63 downto 32)))-TO_INTEGER(signed(rs2(63 downto 48)))*TO_INTEGER(signed(rs3(63 downto 48)));
				if temp32_1>up32 then
					data_out(63 downto 32)<=	std_logic_vector(to_signed(up32,32));
				elsif temp32_1< down32 then 
					  data_out(63 downto 32)<=std_logic_vector(to_signed(down32,32));
				else
					  data_out(63 downto 32)<=std_logic_vector(to_signed(temp32_1,32));
				end if;
				temp32_1:=TO_INTEGER(signed(rs1(95 downto 64)))-TO_INTEGER(signed(rs2(95 downto 80)))*TO_INTEGER(signed(rs3(95 downto 80)));
				if temp32_1>up32 then
					data_out(95 downto 64)<=	std_logic_vector(to_signed(up32,32));
				elsif temp32_1< down32 then 
					  data_out(95 downto 64)<=std_logic_vector(to_signed(down32,32));
				else
					  data_out(95 downto 64)<=std_logic_vector(to_signed(temp32_1,32));
				end if;
				temp32_1:=TO_INTEGER(signed(rs1(127 downto 96)))-TO_INTEGER(signed(rs2(127 downto 112)))*TO_INTEGER(signed(rs3(127 downto 112)));
				if temp32_1>up32 then
					data_out(127 downto 96)<=	std_logic_vector(to_signed(up32,32));
				elsif temp32_1< down32 then 
					  data_out(127 downto 96)<=std_logic_vector(to_signed(down32,32));
				else
					  data_out(127 downto 96)<=std_logic_vector(to_signed(temp32_1,32));
				end if;
			elsif op_code=6 then	   --Signed Long Integer Multiply-Add Low with Saturation
				temp:=signed(rs1(63 downto 0))+signed(rs2(31 downto 0))*signed(rs3(31 downto 0));
				if temp>up64 then
					data_out(63 downto 0)<=	std_logic_vector(up64);
				elsif temp< down64 then 
					  data_out(63 downto 0)<=std_logic_vector(down64);
				else
					  data_out(63 downto 0)<=std_logic_vector(temp);
				end if;	
				temp:=signed(rs1(127 downto 64))+signed(rs2(95 downto 64))*signed(rs3(95 downto 64));
				if temp>up64 then
					data_out(127 downto 64)<=std_logic_vector(up64);
				elsif temp< down64 then 
					  data_out(127 downto 64)<=std_logic_vector(down64);
				else
					  data_out(127 downto 64)<=std_logic_vector(temp);
				end if;
			elsif op_code=7 then	  --Signed Long Integer Multiply-Add High with Saturation
				temp:=signed(rs1(63 downto 0))+signed(rs2(63 downto 32))*signed(rs3(63 downto 32));
				if temp>up64 then
					data_out(63 downto 0)<=	std_logic_vector(up64);
				elsif temp< down64 then 
					  data_out(63 downto 0)<=std_logic_vector(down64);
				else
					  data_out(63 downto 0)<=std_logic_vector(temp);
				end if;	
				temp:=signed(rs1(127 downto 64))+signed(rs2(127 downto 96))*signed(rs3(127 downto 96));
				if temp>up64 then
					data_out(127 downto 64)<=std_logic_vector(up64);
				elsif temp< down64 then 
					  data_out(127 downto 64)<=std_logic_vector(down64);
				else
					  data_out(127 downto 64)<=std_logic_vector(temp);
				end if;
			elsif op_code=8 then	  --Signed Long Integer Multiply-Subtract Low with Saturation
				temp:=signed(rs1(63 downto 0))-signed(rs2(31 downto 0))*signed(rs3(31 downto 0));
				if temp>up64 then
					data_out(63 downto 0)<=	std_logic_vector(up64);
				elsif temp< down64 then 
					  data_out(63 downto 0)<=std_logic_vector(down64);
				else
					  data_out(63 downto 0)<=std_logic_vector(temp);
				end if;	
				temp:=signed(rs1(127 downto 64))-signed(rs2(95 downto 64))*signed(rs3(95 downto 64));
				if temp>up64 then
					data_out(127 downto 64)<=std_logic_vector(up64);
				elsif temp< down64 then 
					  data_out(127 downto 64)<=std_logic_vector(down64);
				else
					  data_out(127 downto 64)<=std_logic_vector(temp);
				end if;
			elsif op_code=9 then	   --Signed Long Integer Multiply-Subtract High with Saturation
				temp:=signed(rs1(63 downto 0))-signed(rs2(63 downto 32))*signed(rs3(63 downto 32));
				if temp>up64 then
					data_out(63 downto 0)<=	std_logic_vector(up64);
				elsif temp< down64 then 
					  data_out(63 downto 0)<=std_logic_vector(down64);
				else
					  data_out(63 downto 0)<=std_logic_vector(temp);
				end if;	
				temp:=signed(rs1(127 downto 64))-signed(rs2(127 downto 96))*signed(rs3(127 downto 96));
				if temp>up64 then
					data_out(127 downto 64)<=std_logic_vector(up64);
				elsif temp< down64 then 
					  data_out(127 downto 64)<=std_logic_vector(down64);
				else
					  data_out(127 downto 64)<=std_logic_vector(temp);
				end if;
				
			elsif op_code=0 then	--nop
				--nothing to do
			elsif op_code=10 then	 --add word unsigned
				data_out(31 downto 0)<=std_logic_vector(to_unsigned(TO_INTEGER(unsigned(rs2(31 downto 0)))+TO_INTEGER(unsigned(rs1(31 downto 0))),32));
				data_out(63 downto 32)<=std_logic_vector(to_unsigned(TO_INTEGER(unsigned(rs2(63 downto 32)))+TO_INTEGER(unsigned(rs1(63 downto 32))),32));
				data_out(95 downto 64)<=std_logic_vector(to_unsigned(TO_INTEGER(unsigned(rs2(95 downto 64)))+TO_INTEGER(unsigned(rs1(95 downto 64))),32));
				data_out(127 downto 96)<=std_logic_vector(to_unsigned(TO_INTEGER(unsigned(rs2(127 downto 96)))+TO_INTEGER(unsigned(rs1(127 downto 96))),32));
			elsif op_code=11 then --absolute difference of bytes
				temp16_1:= abs(TO_INTEGER(signed(rs1(15 downto 0)))-TO_INTEGER(signed(rs2(15 downto 0))));
				data_out(15 downto 0)<=	std_logic_vector(to_signed(temp16_1,16));
				temp16_1:= abs(TO_INTEGER(signed(rs1(31 downto 16)))-TO_INTEGER(signed(rs2(31 downto 16))));
				data_out(31 downto 16)<=	std_logic_vector(to_signed(temp16_1,16));
				temp16_1:= abs(TO_INTEGER(signed(rs1(47 downto 32)))-TO_INTEGER(signed(rs2(47 downto 32))));
				data_out(47 downto 32)<=	std_logic_vector(to_signed(temp16_1,16));
				temp16_1:= abs(TO_INTEGER(signed(rs1(63 downto 48)))-TO_INTEGER(signed(rs2(63 downto 48))));
				data_out(63 downto 48)<=	std_logic_vector(to_signed(temp16_1,16));
				temp16_1:= abs(TO_INTEGER(signed(rs1(79 downto 64)))-TO_INTEGER(signed(rs2(79 downto 64))));
				data_out(79 downto 64)<=	std_logic_vector(to_signed(temp16_1,16));
				temp16_1:= abs(TO_INTEGER(signed(rs1(95 downto 80)))-TO_INTEGER(signed(rs2(95 downto 80))));
				data_out(95 downto 80)<=	std_logic_vector(to_signed(temp16_1,16));
				temp16_1:= abs(TO_INTEGER(signed(rs1(111 downto 96)))-TO_INTEGER(signed(rs2(111 downto 96))));
				data_out(111 downto 96)<=	std_logic_vector(to_signed(temp16_1,16));
				temp16_1:= abs(TO_INTEGER(signed(rs1(127 downto 112)))-TO_INTEGER(signed(rs2(127 downto 112))));
				data_out(127 downto 112)<=	std_logic_vector(to_signed(temp16_1,16));
			elsif op_code=12 then	 --add halfword unsigned
				temp16_1:= TO_INTEGER(unsigned(rs1(15 downto 0)))+TO_INTEGER(unsigned(rs2(15 downto 0)));
				data_out(15 downto 0)<=	std_logic_vector(to_unsigned(temp16_1,16));
				temp16_1:= TO_INTEGER(unsigned(rs1(31 downto 16)))+TO_INTEGER(unsigned(rs2(31 downto 16)));
				data_out(31 downto 16)<=std_logic_vector(to_unsigned(temp16_1,16));
				temp16_1:= TO_INTEGER(unsigned(rs1(47 downto 32)))+TO_INTEGER(unsigned(rs2(47 downto 32)));
				data_out(47 downto 32)<=std_logic_vector(to_unsigned(temp16_1,16));
				temp16_1:= TO_INTEGER(unsigned(rs1(63 downto 48)))+TO_INTEGER(unsigned(rs2(63 downto 48)));
				data_out(63 downto 48)<=std_logic_vector(to_unsigned(temp16_1,16));
				temp16_1:= TO_INTEGER(unsigned(rs1(79 downto 64)))+TO_INTEGER(unsigned(rs2(79 downto 64)));
				data_out(79 downto 64)<=std_logic_vector(to_unsigned(temp16_1,16));
				temp16_1:= TO_INTEGER(unsigned(rs1(95 downto 80)))+TO_INTEGER(unsigned(rs2(95 downto 80)));
				data_out(95 downto 80)<=std_logic_vector(to_unsigned(temp16_1,16));
				temp16_1:= TO_INTEGER(unsigned(rs1(111 downto 96)))+TO_INTEGER(unsigned(rs2(111 downto 96)));
				data_out(111 downto 96)<=std_logic_vector(to_unsigned(temp16_1,16));
				temp16_1:= TO_INTEGER(unsigned(rs1(127 downto 112)))+TO_INTEGER(unsigned(rs2(127 downto 112)));
				data_out(127 downto 112)<=std_logic_vector(to_unsigned(temp16_1,16));
			elsif op_code=13 then	 --add halfword saturated 
				temp16_1:= TO_INTEGER(signed(rs1(15 downto 0)))+TO_INTEGER(signed(rs2(15 downto 0))); 
				if temp16_1>up16 then 
					data_out(15 downto 0)<=std_logic_vector(to_signed(up16,16));
				elsif temp16_1<down16 then 
					data_out(15 downto 0)<=std_logic_vector(to_signed(down16,16));
				else
					data_out(15 downto 0)<=	std_logic_vector(to_signed(temp16_1,16));	
				end if;
				temp16_1:= TO_INTEGER(signed(rs1(31 downto 16)))+TO_INTEGER(signed(rs2(31 downto 16)));
				data_out(31 downto 16)<=std_logic_vector(to_unsigned(temp16_1,16));if temp16_1>up16 then 
					data_out(31 downto 16)<=std_logic_vector(to_signed(up16,16));
				elsif temp16_1<down16 then 
					data_out(31 downto 16)<=std_logic_vector(to_signed(down16,16));
				else
					data_out(31 downto 16)<=	std_logic_vector(to_signed(temp16_1,16));	
				end if;
				temp16_1:= TO_INTEGER(signed(rs1(47 downto 32)))+TO_INTEGER(signed(rs2(47 downto 32)));
				if temp16_1>up16 then 
					data_out(47 downto 32)<=std_logic_vector(to_signed(up16,16));
				elsif temp16_1<down16 then 
					data_out(47 downto 32)<=std_logic_vector(to_signed(down16,16));
				else
					data_out(47 downto 32)<=	std_logic_vector(to_signed(temp16_1,16));	
				end if;
				temp16_1:= TO_INTEGER(signed(rs1(63 downto 48)))+TO_INTEGER(signed(rs2(63 downto 48)));
				if temp16_1>up16 then 
					data_out(63 downto 48)<=std_logic_vector(to_signed(up16,16));
				elsif temp16_1<down16 then 
					data_out(63 downto 48)<=std_logic_vector(to_signed(down16,16));
				else
					data_out(63 downto 48)<=std_logic_vector(to_signed(temp16_1,16));	
				end if;
				temp16_1:= TO_INTEGER(signed(rs1(79 downto 64)))+TO_INTEGER(signed(rs2(79 downto 64)));
				if temp16_1>up16 then 
					data_out(79 downto 64)<=std_logic_vector(to_signed(up16,16));
				elsif temp16_1<down16 then 
					data_out(79 downto 64)<=std_logic_vector(to_signed(down16,16));
				else
					data_out(79 downto 64)<=	std_logic_vector(to_signed(temp16_1,16));	
				end if;
				temp16_1:= TO_INTEGER(signed(rs1(95 downto 80)))+TO_INTEGER(signed(rs2(95 downto 80)));
				if temp16_1>up16 then 
					data_out(95 downto 80)<=std_logic_vector(to_signed(up16,16));
				elsif temp16_1<down16 then 
					data_out(95 downto 80)<=std_logic_vector(to_signed(down16,16));
				else
					data_out(95 downto 80)<=	std_logic_vector(to_signed(temp16_1,16));	
				end if;
				temp16_1:= TO_INTEGER(signed(rs1(111 downto 96)))+TO_INTEGER(signed(rs2(111 downto 96)));
				if temp16_1>up16 then 
					data_out(111 downto 96)<=std_logic_vector(to_signed(up16,16));
				elsif temp16_1<down16 then 
					data_out(111 downto 96)<=std_logic_vector(to_signed(down16,16));
				else
					data_out(111 downto 96)<=	std_logic_vector(to_signed(temp16_1,16));	
				end if;
				temp16_1:= TO_INTEGER(signed(rs1(127 downto 112)))+TO_INTEGER(signed(rs2(127 downto 112)));
				if temp16_1>up16 then 
					data_out(127 downto 112)<=std_logic_vector(to_signed(up16,16));
				elsif temp16_1<down16 then 
					data_out(127 downto 112)<=std_logic_vector(to_signed(down16,16));
				else					  
					data_out(127 downto 112)<=	std_logic_vector(to_signed(temp16_1,16));	
				end if;
			elsif op_code=14 then	-- bitwise logical and 
				data_out<=rs1 and rs2;
			elsif op_code=15 then -- broadcast word
				data_out(31 downto 0)<=rs1(31 downto 0);
				data_out(63 downto 32)<=rs1(31 downto 0);
				data_out(95 downto 64)<=rs1(31 downto 0);
				data_out(127 downto 96)<=rs1(31 downto 0);
			elsif op_code=16 then	--max signed word
				temp32_1:= TO_INTEGER(signed(rs1(31 downto 0)));
				temp32_2:= TO_INTEGER(signed(rs2(31 downto 0)));
				if temp32_1>temp32_2 then
					data_out(31 downto 0)<=rs1(31 downto 0);
				else
					data_out(31 downto 0)<=rs2(31 downto 0);
				end if;	 
				temp32_1:= TO_INTEGER(signed(rs1(63 downto 32)));
				temp32_2:= TO_INTEGER(signed(rs2(63 downto 32)));
				if temp32_1>temp32_2 then
					data_out(63 downto 32)<=rs1(63 downto 32);
				else
					data_out(63 downto 32)<=rs2(63 downto 32);
				end if;
				temp32_1:= TO_INTEGER(signed(rs1(95 downto 64)));
				temp32_2:= TO_INTEGER(signed(rs2(95 downto 64)));
				if temp32_1>temp32_2 then
					data_out(95 downto 64)<=rs1(95 downto 64);
				else
					data_out(95 downto 64)<=rs2(95 downto 64);
				end if;
				temp32_1:= TO_INTEGER(signed(rs1(127 downto 96)));
				temp32_2:= TO_INTEGER(signed(rs2(127 downto 96)));
				if temp32_1>temp32_2 then
					data_out(127 downto 96)<=rs1(127 downto 96);
				else
					data_out(127 downto 96)<=rs2(127 downto 96);
				end if;
				
			elsif op_code=17 then	--min signed word
				 temp32_1:= TO_INTEGER(signed(rs1(31 downto 0)));
				temp32_2:= TO_INTEGER(signed(rs2(31 downto 0)));
				if temp32_1<temp32_2 then
					data_out(31 downto 0)<=rs1(31 downto 0);
				else
					data_out(31 downto 0)<=rs2(31 downto 0);
				end if;	 
				temp32_1:= TO_INTEGER(signed(rs1(63 downto 32)));
				temp32_2:= TO_INTEGER(signed(rs2(63 downto 32)));
				if temp32_1<temp32_2 then
					data_out(63 downto 32)<=rs1(63 downto 32);
				else
					data_out(63 downto 32)<=rs2(63 downto 32);
				end if;
				temp32_1:= TO_INTEGER(signed(rs1(95 downto 64)));
				temp32_2:= TO_INTEGER(signed(rs2(95 downto 64)));
				if temp32_1<temp32_2 then
					data_out(95 downto 64)<=rs1(95 downto 64);
				else
					data_out(95 downto 64)<=rs2(95 downto 64);
				end if;
				temp32_1:= TO_INTEGER(signed(rs1(127 downto 96)));
				temp32_2:= TO_INTEGER(signed(rs2(127 downto 96)));
				if temp32_1<temp32_2 then
					data_out(127 downto 96)<=rs1(127 downto 96);
				else
					data_out(127 downto 96)<=rs2(127 downto 96);
				end if;
			elsif op_code=18 then --multiply low unsigned
				temp32_1:=TO_INTEGER(unsigned(rs1(15 downto 0)))*TO_INTEGER(unsigned(rs2(15 downto 0)));
				data_out(31 downto 0)<=std_logic_vector(to_unsigned(temp32_1,32));
				temp32_1:=TO_INTEGER(unsigned(rs1(47 downto 32)))*TO_INTEGER(unsigned(rs2(47 downto 32)));
				data_out(63 downto 32)<=std_logic_vector(to_unsigned(temp32_1,32));
				temp32_1:=TO_INTEGER(unsigned(rs1(79 downto 64)))*TO_INTEGER(unsigned(rs2(79 downto 64)));
				data_out(95 downto 64)<=std_logic_vector(to_unsigned(temp32_1,32));
				temp32_1:=TO_INTEGER(unsigned(rs1(111 downto 96)))*TO_INTEGER(unsigned(rs2(111 downto 96)));
				data_out(127 downto 96)<=std_logic_vector(to_unsigned(temp32_1,32));
				
			elsif op_code=19 then --multiply low by constant unsigned
				temp32_1:=TO_INTEGER(unsigned(rs1(15 downto 0)))*TO_INTEGER(unsigned(constIn));
				data_out(31 downto 0)<=std_logic_vector(to_unsigned(temp32_1,32));
				temp32_1:=TO_INTEGER(unsigned(rs1(47 downto 32)))*TO_INTEGER(unsigned(constIn));
				data_out(63 downto 32)<=std_logic_vector(to_unsigned(temp32_1,32));
				temp32_1:=TO_INTEGER(unsigned(rs1(79 downto 64)))*TO_INTEGER(unsigned(constIn));
				data_out(95 downto 64)<=std_logic_vector(to_unsigned(temp32_1,32));
				temp32_1:=TO_INTEGER(unsigned(rs1(111 downto 96)))*TO_INTEGER(unsigned(constIn));
				data_out(127 downto 96)<=std_logic_vector(to_unsigned(temp32_1,32));
			elsif op_code=20 then	--bitwise logical or
				data_out<=rs1 or rs2;
			elsif op_code=21 then	--count ones in words 
				count:=0;
				for i in 0 to 31 loop
					if rs1(i)='1' then
						count:=count+1;
					end if;
				end loop;
				data_out(31 downto 0)<=std_logic_vector(to_unsigned(count,32));
				count:=0; 
				
				for i in 32 to 63 loop
					if rs1(i)='1' then
						count:=count+1;
					end if;
				end loop;
				data_out(63 downto 32)<=std_logic_vector(to_unsigned(count,32));
				count:=0;
				
				for i in 64 to 95 loop
					if rs1(i)='1' then
						count:=count+1;
					end if;
				end loop;
				data_out(95 downto 64)<=std_logic_vector(to_unsigned(count,32));
				count:=0;
				
				for i in 96 to 127 loop
					if rs1(i)='1' then
						count:=count+1;
					end if;
				end loop;
				data_out(127 downto 96)<=std_logic_vector(to_unsigned(count,32));
				count:=0;
			elsif op_code=22 then	 --rotate bits in word
				temp16_1:=TO_INTEGER(unsigned(rs2(4 downto 0)));
				rot:=rs1(31 downto 0);
				for i in 1 to temp16_1 loop
					keeper:=rot(0);
					rot(30 downto 0):=rot(31 downto 1);
					rot(31):=keeper;
				end loop;	 
				data_out(31 downto 0)<= rot;
				
				temp16_1:=TO_INTEGER(unsigned(rs2(36 downto 32)));
				rot:=rs1(63 downto 32);
				for i in 1 to temp16_1 loop
					keeper:=rot(0);
					rot(30 downto 0):=rot(31 downto 1);
					rot(31):=keeper;
				end loop;	 
				data_out(63 downto 32)<= rot;
				
				temp16_1:=TO_INTEGER(unsigned(rs2(68 downto 64)));
				rot:=rs1(95 downto 64);
				for i in 1 to temp16_1 loop
					keeper:=rot(0);
					rot(30 downto 0):=rot(31 downto 1);
					rot(31):=keeper;
				end loop;	 
				data_out(95 downto 64)<= rot;
				
				temp16_1:=TO_INTEGER(unsigned(rs2(100 downto 96)));
				rot:=rs1(127 downto 96);
				for i in 1 to temp16_1 loop
					keeper:=rot(0);
					rot(30 downto 0):=rot(31 downto 1);
					rot(31):=keeper;
				end loop;	 
				data_out(127 downto 96)<= rot;
				
			elsif op_code=23 then	 --subtract from halfword saturated
				temp16_1:= TO_INTEGER(signed(rs2(15 downto 0)))-TO_INTEGER(signed(rs1(15 downto 0))); 
				if temp16_1>up16 then 
					data_out(15 downto 0)<=std_logic_vector(to_signed(up16,16));
				elsif temp16_1<down16 then 
					data_out(15 downto 0)<=std_logic_vector(to_signed(down16,16));
				else
					data_out(15 downto 0)<=	std_logic_vector(to_signed(temp16_1,16));	
				end if;
				temp16_1:= TO_INTEGER(signed(rs2(31 downto 16)))-TO_INTEGER(signed(rs1(31 downto 16)));
				data_out(31 downto 16)<=std_logic_vector(to_unsigned(temp16_1,16));if temp16_1>up16 then 
					data_out(31 downto 16)<=std_logic_vector(to_signed(up16,16));
				elsif temp16_1<down16 then 
					data_out(31 downto 16)<=std_logic_vector(to_signed(down16,16));
				else
					data_out(31 downto 16)<=std_logic_vector(to_signed(temp16_1,16));	
				end if;
				temp16_1:= TO_INTEGER(signed(rs2(47 downto 32)))-TO_INTEGER(signed(rs1(47 downto 32)));
				if temp16_1>up16 then 
					data_out(47 downto 32)<=std_logic_vector(to_signed(up16,16));
				elsif temp16_1<down16 then 
					data_out(47 downto 32)<=std_logic_vector(to_signed(down16,16));
				else
					data_out(47 downto 32)<=std_logic_vector(to_signed(temp16_1,16));	
				end if;
				temp16_1:= TO_INTEGER(signed(rs2(63 downto 48)))-TO_INTEGER(signed(rs1(63 downto 48)));
				if temp16_1>up16 then 
					data_out(63 downto 48)<=std_logic_vector(to_signed(up16,16));
				elsif temp16_1<down16 then 
					data_out(63 downto 48)<=std_logic_vector(to_signed(down16,16));
				else
					data_out(63 downto 48)<=std_logic_vector(to_unsigned(temp16_1,16));	
				end if;
				temp16_1:= TO_INTEGER(signed(rs2(79 downto 64)))-TO_INTEGER(signed(rs1(79 downto 64)));
				if temp16_1>up16 then 
					data_out(79 downto 64)<=std_logic_vector(to_signed(up16,16));
				elsif temp16_1<down16 then 
					data_out(79 downto 64)<=std_logic_vector(to_signed(down16,16));
				else
					data_out(79 downto 64)<=std_logic_vector(to_signed(temp16_1,16));	
				end if;
				temp16_1:= TO_INTEGER(signed(rs2(95 downto 80)))-TO_INTEGER(signed(rs1(95 downto 80)));
				if temp16_1>up16 then 
					data_out(95 downto 80)<=std_logic_vector(to_signed(up16,16));
				elsif temp16_1<down16 then 
					data_out(95 downto 80)<=std_logic_vector(to_signed(down16,16));
				else
					data_out(95 downto 80)<=std_logic_vector(to_signed(temp16_1,16));	
				end if;
				temp16_1:= TO_INTEGER(signed(rs2(111 downto 96)))-TO_INTEGER(signed(rs1(111 downto 96)));
				if temp16_1>up16 then 
					data_out(111 downto 96)<=std_logic_vector(to_signed(up16,16));
				elsif temp16_1<down16 then 
					data_out(111 downto 96)<=std_logic_vector(to_signed(down16,16));
				else
					data_out(111 downto 96)<=std_logic_vector(to_signed(temp16_1,16));	
				end if;
				temp16_1:= TO_INTEGER(signed(rs2(127 downto 112)))-TO_INTEGER(signed(rs1(127 downto 112)));
				if temp16_1>up16 then 
					data_out(127 downto 112)<=std_logic_vector(to_signed(up16,16));
				elsif temp16_1<down16 then 
					data_out(127 downto 112)<=std_logic_vector(to_signed(down16,16));
				else					  
					data_out(127 downto 112)<=std_logic_vector(to_signed(temp16_1,16));	
				end if;
			elsif op_code=24 then	   --subtract from word unsigned
				data_out(31 downto 0)<=std_logic_vector(to_signed(TO_INTEGER(unsigned(rs2(31 downto 0)))-TO_INTEGER(unsigned(rs1(31 downto 0))),32));
				
				data_out(63 downto 32)<=std_logic_vector(to_signed(TO_INTEGER(unsigned(rs2(63 downto 32)))-TO_INTEGER(unsigned(rs1(63 downto 32))),32));
				
				data_out(95 downto 64)<=std_logic_vector(to_signed(TO_INTEGER(unsigned(rs2(95 downto 64)))-TO_INTEGER(unsigned(rs1(95 downto 64))),32));
				
				data_out(127 downto 96)<=std_logic_vector(to_signed(TO_INTEGER(unsigned(rs2(127 downto 96)))-TO_INTEGER(unsigned(rs1(127 downto 96))),32));
			else
				
			end if;
			--data_out<=x"ffffffffffffffffffffffffffffffff";
			wrAddr<=RdAddr;	
			Rdwrite<='1';
		end if;						-----------------------------------------------------
		
	end process;

end behavioral;
