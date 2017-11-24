library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram_1024X8 is
    port(   data_in:    in std_logic_vector(7 downto 0);
            address:    in integer range 1023 downto 0;
            cs:         in std_logic;
            clk:        in std_logic;
            wr_rd_n:    in std_logic;
            data_out:   out std_logic_vector (7 downto 0));
end ram_1024X8;

architecture Behaviour of ram_1024X8 is
type ram is array(1023 downto 0) of std_logic_vector(7 downto 0);
begin
    process(clk)
        variable mem:ram;
    begin
        if(clk'event and clk='1') then
            data_out <= (others => 'Z');
            if (cs = '1') then
                if (wr_rd_n = '0') then
                    data_out <= mem(address);
                elsif (wr_rd_n = '1') then
                    mem(address) := data_in;
                end if;
            end if;
        end if;
    end process;
end Behaviour;