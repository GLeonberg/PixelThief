library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is port (
    clk : in std_logic;
    vga_hs, vga_vs : out std_logic;
    vga_r, vga_b : out std_logic_vector(4 downto 0);
    vga_g : out std_logic_vector(5 downto 0)
);
end top;

architecture Behavioral of top is

    -- sprite rom
    component sprites
    PORT (
            a : IN STD_LOGIC_VECTOR(13 DOWNTO 0);
            spo : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
    END component;
    
    -- vga signal generator
    component vga_ctrl
    port (  
            clk, en: in std_logic;
            h, v: out std_logic_vector (9 downto 0);
            hs, vs, vid: out std_logic
    );
    end component;

    -- display generator
    component screen 
    port (
        vga_clk, en, vid : in std_logic;
        vga_h, vga_v : in std_logic_vector(9 downto 0);
        pixel : in std_logic_vector(7 downto 0);
        addr : out std_logic_vector(13 downto 0);
        vga_r, vga_b : out std_logic_vector(4 downto 0);
        vga_g : out std_logic_vector(5 downto 0)
    );
    end component;
    
    -- enable generator for 25 MHz effective clock
    component clk25
    Port (
        clk : in std_logic;
        en : out std_logic
    );
    end component;
    
    signal en : std_logic := '0';
    signal vid : std_logic;
    signal h, v : std_logic_vector (9 downto 0);
    signal pixel : std_logic_vector(7 downto 0);
    signal addr : std_logic_vector(13 downto 0);
    
begin

    -- display generator
    disp: screen port map(
        vga_clk => clk, 
        en => en,
        vid => vid, 
        vga_h => h, 
        vga_v => v, 
        pixel => pixel, 
        addr => addr, 
        vga_r => vga_r,
        vga_g => vga_g, 
        vga_b => vga_b
    );
    
    -- vga signal generator
     vga: vga_ctrl port map(  
     clk => clk,
     en => en,
     h => h, 
     v => v,
     hs => vga_hs, 
     vs => vga_vs, 
     vid => vid
    );
    
    -- sprite rom
    rom: sprites port map(
        a => addr,
        spo => pixel
    );
    
    -- enable generator for 25 MHz effective clock
     div: clk25 port map(
            clk => clk,
            en => en
    );

end Behavioral;
