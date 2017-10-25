library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity screen_gen is
    Port ( 
        clk, clk_en : in std_logic;
        h_curr, v_curr : in std_logic_vector(9 downto 0);
        pixel : in std_logic_vector(7 downto 0);
        vid : in std_logic;
        addr : out std_logic_vector(19 downto 0);
        red_out, blue_out : out std_logic_vector(4 downto 0);
        green_out : out std_logic_vector(5 downto 0)
    );
end screen_gen;

architecture Behavioral of screen_gen is
    signal addr_sig : std_logic_vector(19 downto 0) := (others => '0');
begin

    process(clk, clk_en) begin
        if (rising_edge(clk) and clk_en = '1') then
            if (h_curr >= std_logic_vector(to_unsigned(0, 10)) 
                    and h_curr <= std_logic_vector(to_unsigned(639, 10))
                    and v_curr >= std_logic_vector(to_unsigned(0, 10))
                    and v_curr <= std_logic_vector(to_unsigned(479, 10))) then
                if (addr_sig = std_logic_vector(to_unsigned((640*480*2)-1, 20))) then
                    addr_sig <= (others => '0');
                else
                    addr_sig <= std_logic_vector(unsigned(addr_sig) + 1);
                end if;              
            end if;  
        end if;
    end process;
    
    addr <= addr_sig;
    
    process(vid) begin
        if (vid = '0') then
            red_out <= (others => '0');
            green_out <= (others => '0');
            blue_out <= (others => '0');
        else
            red_out <= pixel(7 downto 5) & "00";
            green_out <= pixel(4 downto 2) & "000";
            blue_out <= pixel(1 downto 0) & "000";
        end if;
    end process; 
    
end Behavioral;
