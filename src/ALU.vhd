----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/18/2025 02:50:18 PM
-- Design Name: 
-- Module Name: ALU - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
    Port ( i_A : in STD_LOGIC_VECTOR (7 downto 0);
           i_B : in STD_LOGIC_VECTOR (7 downto 0);
           i_op : in STD_LOGIC_VECTOR (2 downto 0);
           o_result : out STD_LOGIC_VECTOR (7 downto 0);
           o_flags : out STD_LOGIC_VECTOR (3 downto 0));
end ALU;

architecture Behavioral of ALU is
    component ripple_adder is 
        port (
            A : in STD_LOGIC_VECTOR(3 downto 0); 
            B : in STD_LOGIC_VECTOR(3 downto 0);
            Cin : in STD_LOGIC; 
            S : out STD_LOGIC_VECTOR(3 downto 0);
            Cout : out STD_LOGIC 
        ); 
        end component ripple_adder; 
            
    signal w_sum : STD_LOGIC_VECTOR(7 downto 0); 
    signal w_lower_carry : STD_LOGIC; 
    signal w_upper_carry : STD_LOGIC; 
    signal resultOUT : STD_LOGIC_VECTOR(7 downto 0); 
    signal w_B_ALU : STD_LOGIC_VECTOR(7 downto 0); 
    
begin 
    w_B_ALU <= i_B when (i_OP(0) = '0') else
                   not i_B; 

Ripple_Lower : ripple_adder --Lower Bits 
    port map(
        A => i_A(3 downto 0), 
        B => w_B_ALU(3 downto 0), 
        Cin => i_OP(0), 
        S => w_sum(3 downto 0), 
        Cout => w_lower_carry
    ); 
    
Ripple_Upper : ripple_adder --Upper Bits 
    port map(
        A => i_A(7 downto 4), 
        B => w_B_ALU(7 downto 4), 
        Cin => w_lower_carry, 
        S => w_sum(7 downto 4), 
        Cout => w_upper_carry
    );     

    --MUX
    resultOUT <= w_sum when i_OP = "000" else
                 w_sum when i_OP = "001" else
                 i_A and i_B when i_OP = "010" else
                 i_A or i_B when i_OP = "011" else
                 w_sum; 
                 
    o_result <= resultOUT; 
    
    --overflow flags 
    o_flags(0) <= not (i_OP(0) xor i_A(7) xor i_B(7)) and (i_A(7) xor w_sum(7)) and (not i_OP(1)); 
    
    --Carry
    o_flags(1) <= w_upper_carry and (not i_OP(1)); 
    
    --Negative
    o_flags(3) <= resultOUT(7); 
    
    --Zero
    o_flags(2) <= '1' when (resultOUT = x"00") else
                  '0'; 


end Behavioral;
