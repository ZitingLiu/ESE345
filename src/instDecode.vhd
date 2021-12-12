-------------------------------------------------------------------------------
--
-- Title       : registerFile
-- Design      : registerFile
-- Author      : zechao.wei@stonybrook.edu
-- Company     : Stony Brook University
--
-------------------------------------------------------------------------------
--
-- File        : c:\My_Designs\ESE345Project\src\registerFile.vhd
-- Generated   : Sun Nov 22 12:21:44 2020
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
--{entity {registerFile} architecture {registerFile}}

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

entity instDecode is
	port(
	clk : in STD_LOGIC;
	regToWrite : in STD_LOGIC;
	instruction : in STD_LOGIC_VECTOR(24 downto 0);
	
	regRead1_data : out STD_LOGIC_VECTOR(127 downto 0);
	regRead2_data : out STD_LOGIC_VECTOR(127 downto 0);
	regRead3_data : out STD_LOGIC_VECTOR(127 downto 0);
	rd_data: out std_logic_vector(127 downto 0);
	regRead1_addr : out STD_LOGIC_VECTOR(4 downto 0);
	regRead2_addr : out STD_LOGIC_VECTOR(4 downto 0);
	regRead3_addr : out STD_LOGIC_VECTOR(4 downto 0);
	
	regWrite_data : in STD_LOGIC_VECTOR(127 downto 0);
	regWrite_addr : in STD_LOGIC_VECTOR(4 downto 0);
	regWrite_addr_out : out STD_LOGIC_VECTOR(4 downto 0);
	
	opcode : out STD_LOGIC_VECTOR(4 downto 0);
	loadImm : out STD_LOGIC_VECTOR(15 downto 0);
	loadIndex : out STD_LOGIC_VECTOR(2 downto 0)
	);
end instDecode;

--}} End of automatically maintained section

architecture behavioral of instDecode is
type regFile is array (31 downto 0) of STD_LOGIC_VECTOR(127 downto 0);
 

begin
	process(clk,regToWrite)
	variable myRegFile : regFile;
	begin
		if rising_edge(clk) then
			if regToWrite='1' then
				myRegFile(TO_INTEGER(UNSIGNED(regWrite_addr))) := regWrite_data;
			end if;
		case instruction(24) is
			when '0' =>
				regWrite_addr_out <= instruction(4 downto 0);
				loadImm <= instruction(20 downto 5);
				loadIndex <= instruction(23 downto 21);
				opcode <= "00001";
				rd_data<=myRegFile(TO_INTEGER(UNSIGNED(instruction(4 downto 0)))) ;
			when '1' =>	 
				case instruction(23) is
					when '0' =>
						regRead1_data <= myRegFile(TO_INTEGER(UNSIGNED(instruction(9 downto 5))));
						regRead2_data <= myRegFile(TO_INTEGER(UNSIGNED(instruction(14 downto 10))));
						regRead3_data <= myRegFile(TO_INTEGER(UNSIGNED(instruction(19 downto 15))));
						
						regWrite_addr_out <= instruction(4 downto 0);
						regRead1_addr <= instruction(9 downto 5);
						regRead2_addr <= instruction(14 downto 10);
						regRead3_addr <= instruction(19 downto 15);
					if instruction(22 downto 20) = "000" then opcode <= "00010"; end if;
					if instruction(22 downto 20) = "001" then opcode <= "00011"; end if;
					if instruction(22 downto 20) = "010" then opcode <= "00100"; end if;
					if instruction(22 downto 20) = "011" then opcode <= "00101"; end if;
					if instruction(22 downto 20) = "100" then opcode <= "00110"; end if;
					if instruction(22 downto 20) = "101" then opcode <= "00111"; end if;
					if instruction(22 downto 20) = "110" then opcode <= "01000"; end if;
					if instruction(22 downto 20) = "111" then opcode <= "01001"; end if;
					
					when '1' =>	
						regRead1_data <= myRegFile(TO_INTEGER(UNSIGNED(instruction(9 downto 5))));
						regRead2_data <= myRegFile(TO_INTEGER(UNSIGNED(instruction(14 downto 10))));
						
						regWrite_addr_out <= instruction(4 downto 0);
						regRead1_addr <= instruction(9 downto 5);
						regRead2_addr <= instruction(14 downto 10);
						
					if instruction(18 downto 15) = "0000" then opcode <= "00000"; end if;
					if instruction(18 downto 15) = "0001" then opcode <= "01010"; end if;
					if instruction(18 downto 15) = "0010" then opcode <= "01011"; end if;
					if instruction(18 downto 15) = "0011" then opcode <= "01100"; end if;
					if instruction(18 downto 15) = "0100" then opcode <= "01101"; end if;
					if instruction(18 downto 15) = "0101" then opcode <= "01110"; end if;
					if instruction(18 downto 15) = "0110" then opcode <= "01111"; end if;
					if instruction(18 downto 15) = "0111" then opcode <= "10000"; end if;
					if instruction(18 downto 15) = "1000" then opcode <= "10001"; end if;
					if instruction(18 downto 15) = "1001" then opcode <= "10010"; end if;
					if instruction(18 downto 15) = "1010" then opcode <= "10011"; end if;
					if instruction(18 downto 15) = "1011" then opcode <= "10100"; end if;
					if instruction(18 downto 15) = "1100" then opcode <= "10101"; end if;
					if instruction(18 downto 15) = "1101" then opcode <= "10110"; end if;
					if instruction(18 downto 15) = "1110" then opcode <= "10111"; end if;
					if instruction(18 downto 15) = "1111" then opcode <= "11000"; end if;
					
					when others =>
						opcode <= "00000";
				end case;
	
			when others =>
				opcode <= "00000";
		end case;
		
		end if;
	end process;
end behavioral;











