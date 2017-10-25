library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clk25 is
    Port (
        clk : in std_logic;
        en : out std_logic
    );
end clk25;

architecture Behavioral of clk25 is
    signal count : std_logic_vector(2 downto 0) := (others => '0');
begin

    process(clk) begin
        if rising_edge(clk) then
            if count = std_logic_vector(to_unsigned(4, 3)) then
                count <= (others => '0');
                en <= '1';
            else
                count <= std_logic_vector(unsigned(count) + 1);
                en <= '0';
            end if;
       end if;
   end process;

end Behavioral;
