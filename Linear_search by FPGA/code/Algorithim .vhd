----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:23:31 11/26/2018 
-- Design Name: 
-- Module Name:    Algorithim - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Algorithm1 is
    Port ( target : in  STD_LOGIC_VECTOR (3 downto 0);
           addressOfTarget : out  STD_LOGIC_VECTOR (3 downto 0);
           ledOfexistence : out  STD_LOGIC;
           data : inout  STD_LOGIC_VECTOR (3 downto 0);
           addressOfSearching : out  STD_LOGIC_VECTOR (3 downto 0);
			  MEM_read : out  STD_LOGIC;
			  MEM_wr : out  STD_LOGIC;
			  MEM_reset : out  STD_LOGIC;
			  clk : in  STD_LOGIC
			  );
end Algorithm1;

architecture Behavioral of Algorithm is
signal address : STD_LOGIC_VECTOR (4 downto 0):= "10000";
signal sig_ledOfexistence : STD_LOGIC;


begin

	MEM_reset<='0';
	MEM_wr<='0';
	MEM_read<='1';
	
	process (clk)
begin

if(address = "10000")then --
	address <= "00000";
	sig_ledOfexistence<='0';
	ledOfexistence<=sig_ledOfexistence ; --before searching
	L1:for I in 0 to 15 loop
		addressOfSearching<=address(3 downto 0);
		L2:while (clk'event=false or clk='0') loop -- include { if (clk'event and clk ='1') }
		end loop L2;
		--wait for 0.1 ns
		if (data=target)then
			sig_ledOfexistence<='1';
			ledOfexistence<=sig_ledOfexistence ;
			
			addressOfTarget<=address(3 downto 0);
			exit L1;
		else	
		address<=address+1;
		end if;
	end loop L1;
	
	if (sig_ledOfexistence='0') then addressOfTarget<="ZZZZ"; end if;
	
	--address <= "10000";
	  address <= "10001";
end if;
	
end process;
	
	

end Behavioral;

