library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity screen is port (
    vga_clk, en, vid : in std_logic;
    vga_h, vga_v : in std_logic_vector(9 downto 0);
    pixel : in std_logic_vector(7 downto 0);
    addr : out std_logic_vector(13 downto 0);
    vga_r, vga_b : out std_logic_vector(4 downto 0);
    vga_g : out std_logic_vector(5 downto 0)
);
end screen;

architecture arch of screen is

    -- horizantal [290, 354)
    -- vertical [210, 274)
    -- displays 64x64 sprite at location (290, 210) almost center of screen
    
    signal currSprite : std_logic_vector(1 downto 0) := (others => '0');
    signal currAddr : std_logic_vector(11 downto 0) := (others => '0');
    signal finalAddr : std_logic_vector(13 downto 0) := (others => '0');
    signal spriteCounter : std_logic_vector(21 downto 0) := (others => '0');
    
begin

    -- Sprite counter at 10 fps
    process(vga_clk) begin
        if rising_edge(vga_clk) and en = '1' then
            if spriteCounter = std_logic_vector(to_unsigned(2500000, 22)) then
                spriteCounter <= (others => '0');
                currSprite <= std_logic_vector(unsigned(currSprite) + 1);
            else
                spriteCounter <= std_logic_vector(unsigned(spriteCounter) + 1);
            end if;
        end if;
    end process;
    
    -- process for counting current address
    process(vga_clk) begin
        if rising_edge(vga_clk) and en = '1' then
            if   (vga_h >= std_logic_vector(to_unsigned(290, 10))) and
                    (vga_h < std_logic_vector(to_unsigned(354, 10))) and
                    (vga_v >= std_logic_vector(to_unsigned(210, 10))) and
                    (vga_v < std_logic_vector(to_unsigned(274, 10))) then    
                currAddr <= std_logic_vector(unsigned(currAddr) + 1); 
            elsif vga_v = std_logic_vector(to_unsigned(274, 10)) then
                currAddr <= (others => '0');
            end if;
        end if;
    end process;
    
    -- process for generating total address output
    process(currAddr, spriteCounter) begin
        addr <= ("00" & currAddr);
          case (currSprite) is
              when "00" => addr <= ("00" & currAddr);
              when "01" => addr <= std_logic_vector(to_unsigned(4096, 14) + unsigned("00" & currAddr));
              when "10" => addr <= std_logic_vector(to_unsigned(8192, 14) + unsigned("00" & currAddr));
              when "11" => addr <= std_logic_vector(to_unsigned(12288, 14) + unsigned("00" & currAddr));
          end case;
    end process;
    
    -- process for generating rgb signals from pixel and vid signal
    process(pixel, vid) begin
        if vid = '0' then
            vga_r <= (others => '0');
            vga_g <= (others => '0');
            vga_b <= (others => '0');
        elsif   (vga_h >= std_logic_vector(to_unsigned(290, 10))) and
                (vga_h < std_logic_vector(to_unsigned(354, 10))) and
                (vga_v >= std_logic_vector(to_unsigned(210, 10))) and
                (vga_v < std_logic_vector(to_unsigned(274, 10))) then  
            vga_r <= pixel(7 downto 5) & "00";
            vga_g <= pixel(4 downto 2) & "000";
            vga_b <= pixel(1 downto 0) & "000";
        else
            vga_r <= (others => '0');
            vga_g <= (others => '0');
            vga_b <= (others => '0');
        end if;
    end process;
end arch;