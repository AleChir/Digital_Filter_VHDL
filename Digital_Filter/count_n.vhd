library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity count_n is
    generic(N:  integer:=16);
    port(   clk, clear, enable: IN std_logic;
            q:                  OUT std_logic_vector(N-1 downto 0));
end count_n;

architecture behavior of count_n is
    signal count: unsigned(N-1 downto 0):= (others => '0');
    
    attribute keep: boolean;
    attribute keep of count: signal is true;

begin
    process (clk)
    begin
        if (clk'event and clk= '1') then
            if (clear= '0') then
                count<=(others => '0');
            elsif (enable ='1') then
                count<=count + 1;
            end if;
        end if;
    end process;
    
    q<=std_logic_vector(count);

end behavior;