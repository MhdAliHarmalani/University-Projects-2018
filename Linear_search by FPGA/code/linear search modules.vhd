----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:14:00 12/15/2018 
-- Design Name: 
-- Module Name:    Linear_Search_Module - Behavioral 
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
use IEEE.STD_LOGIC_unsigned.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Linear_Search_Module is
    Port ( targetM : in  STD_LOGIC_VECTOR (3 downto 0);
           clk : in  STD_LOGIC;
           addressOfTargetM : out  STD_LOGIC_VECTOR (3 downto 0);
           LedOfExistenceM : out  STD_LOGIC);
end Linear_Search_Module;

architecture Behavioral of Linear_Search_Module is
component Algorithm is
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
end component Algorithm;

component ram_memory is
    Port ( data : inout  STD_LOGIC_VECTOR (3 downto 0);
           address : in  STD_LOGIC_VECTOR ( 3 downto 0);
           wr_ena : in  STD_LOGIC;
			  read_ena : in std_logic;
           clk : in  STD_LOGIC;
           reset : in  STD_LOGIC);
end component ram_memory;

signal sData : STD_LOGIC_VECTOR (3 downto 0);
signal sAddressOfSearching : STD_LOGIC_VECTOR (3 downto 0);
signal sMEM_read : STD_LOGIC ;
signal sMEM_wr : STD_LOGIC ;
signal sMEM_reset : STD_LOGIC ;

begin
Ram : ram_memory port map(sData,sAddressOfSearching,sMEM_wr,sMEM_read,clk,sMEM_reset);
Algorithm_component : Algorithm port map(targetM,addressOfTargetM,LedOfExistenceM,sData,sAddressOfSearching,sMEM_read,sMEM_wr,sMEM_reset,clk);

end Behavioral;

