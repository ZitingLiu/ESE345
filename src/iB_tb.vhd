-------------------------------------------------------------------------------
--
-- Title       : iB_tb
-- Design      : pipelined
-- Author      : Ziting Liu
-- Company     : StonyBrook
--
-------------------------------------------------------------------------------
--
-- File        : C:\Users\liuzi\Desktop\2020f\345\project\pipelined\src\iB_tb.vhd
-- Generated   : Sat Nov 21 18:26:48 2020
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--

library IEEE;
use IEEE.std_logic_1164.all;  
library work;	
use work.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity iB_tb is
end iB_tb;

--}} End of automatically maintained section

architecture tb of iB_tb is	  
signal clk: std_logic;
signal write_en: std_logic;
signal index : std_logic_vector(6 downto 0);
signal inst: std_logic_vector(24 downto 0);	
signal inst_out:std_logic_vector(24 downto 0); 
signal RdWrite:std_logic;
signal data_1:std_logic_vector(127 downto 0);
signal data_2:std_logic_vector(127 downto 0);
signal data_3:std_logic_vector(127 downto 0); 
signal RdData:std_logic_vector(127 downto 0);
signal Rd_Addr:std_logic_vector(4 downto 0);
signal opCode:std_logic_vector(4 downto 0);
signal Imm:std_logic_vector(15 downto 0);
signal load_index:std_logic_vector(2 downto 0);
signal data_out:std_logic_vector(127 downto 0);
signal wrAddr:std_logic_vector(4 downto 0);
signal Data1_Addr:std_logic_vector(4 downto 0);	 
signal Data2_Addr:std_logic_vector(4 downto 0);
signal Data3_Addr:std_logic_vector(4 downto 0);
signal m1:std_logic;
signal m2:std_logic;
signal m3:std_logic; 
signal m4:std_logic;
signal Fwd_data:std_logic_vector(127 downto 0);


constant period_1:time:=200ns;	 
constant period_2:time:=40ns;
constant period_3:time:=20ns;
begin
	I_F: entity instBuffer 
		port map(
		clk=>clk,
		write=>write_en,
		index=>index,
		inst_in=>inst,
		inst=>inst_out
		);	   
		
	I_D: entity instDecode
		port map(
			clk=>clk,
			regToWrite=>RdWrite,
			instruction=>Inst_out,
			regRead1_data=>Data_1,
			regRead2_data=>Data_2,
			regRead3_data=>Data_3,
			rd_data=>RdData,
			regRead1_addr=>Data1_Addr, 
			regRead2_addr=>Data2_Addr,
			regRead3_addr=>Data3_Addr,
			regWrite_data=>data_out,
			regWrite_addr=>wrAddr,
			regWrite_addr_out=>Rd_Addr,
			opcode=>opcode,
			loadImm=>Imm,
			loadIndex=>load_index
		);
	
	
	EXE: entity executeAlu
		port map(
			clock=>clk,
			mux1=>m1,
			mux2=>m2,
			mux3=>m3,
			RdWrite=>RdWrite,
			forward=>Fwd_data,
			constIn=>Data2_Addr,
			data_in_1=>Data_1,
			data_in_2=>Data_2,
			data_in_3=>Data_3,
			rd=>RdData,
			RdAddr=>Rd_Addr,
			op_code_in=>opcode,
			imm=>Imm,
			index=>load_index,
			data_out=>data_out,
			wrAddr=>wrAddr,
		   	mux4=>m4
		);
		
	FORWARD: entity fD
		port map(
			mux1=>m1,
			mux2=>m2,
			mux3=>m3,
			mux4=>m4,
			data_out=>Fwd_data,
			rd=>wrAddr,
			rs1=>Data1_Addr,
			rs2=>Data2_Addr,
			rs3=>Data3_Addr,
			data_in=>data_out,
			rd_prev=>Rd_Addr
		);
		
	
		
		
		
	------------------------------------------------------------------------------------------------------
	clock:process
	begin
		clk<='0';
		for i in 0 to 1000 loop
			wait for period_3;
			clk<= not clk; 
		end loop;
	end process;
	
	
	update: process
	variable row : line;	
	file read_file: text;
	variable insttemp:std_logic_vector(24 downto 0):="0000000000000000000000000";
	variable indcounter:integer:=0;	
	
	begin 
		write_en<='1';
		file_open(read_file, "binary.bin", read_mode);
		while not endfile(read_file) loop 
			readline( read_file, row);
			read(row,insttemp);
			inst<=insttemp;
			index<=std_logic_vector(to_unsigned(indcounter,7));
			indcounter:=indcounter+1;
			wait for period_2;
		end loop; 
		write_en<='0';
		wait for 100sec;
	end process;
	
	writeFile: process
	variable my_line: line;
	file result: text;
	begin 
		file_open(result, "result.txt", write_mode);
		for i in 0 to 1000 loop
			wait for period_2;	 
			write(my_line, string'("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"));
			writeline(result,my_line);
			write(my_line, string'("instruction: "));
			write(my_line, Inst_out);
			writeline(result,my_line);
			write(my_line, string'("Data 1 address: "));
			write(my_line, Data1_Addr);
			writeline(result,my_line); 
			write(my_line, string'("Data 2 address: "));
			write(my_line, Data2_Addr);
			writeline(result,my_line);
			write(my_line, string'("Data 3 address: "));
			write(my_line, Data3_Addr);
			writeline(result,my_line);
			write(my_line, string'("Data 1 value: "));
			write(my_line, data_1);
			writeline(result,my_line);
			write(my_line, string'("Data 2 value: "));
			write(my_line, data_2);
			writeline(result,my_line);
			write(my_line, string'("Data 3 value: "));
			write(my_line, data_3);
			writeline(result,my_line);
			write(my_line, string'("opcode is : "));
			write(my_line, opcode);
			writeline(result,my_line);
			write(my_line, string'("Reult from alu: "));
			write(my_line, data_out);
			writeline(result,my_line);
			write(my_line, string'("Imm value: "));
			write(my_line, Imm);
			writeline(result,my_line);
			write(my_line, string'("Mux for rs1 status: "));
			write(my_line, m1);
			writeline(result,my_line);
			write(my_line, string'("Mux for rs2 status: "));
			write(my_line, m2);
			writeline(result,my_line);
			write(my_line, string'("Mux for rs3 status: "));
			write(my_line, m3);
			writeline(result,my_line);
			write(my_line, string'("Mux for rs4 status: "));
			write(my_line, m4);
			writeline(result,my_line);
		end loop;
		
		
	
	end process;
	
end tb;
