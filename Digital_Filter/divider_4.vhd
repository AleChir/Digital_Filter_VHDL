library ieee;
use ieee.std_logic_1164.all;

entity divider_4 is
    port(   data_in:    in std_logic_vector(7 downto 0);
            data_out:   out std_logic_vector( 10 downto 0));
end divider_4;

architecture behavior of divider_4 is
begin
    data_out(5 downto 0)<= data_in(7 downto 2);
    data_out(10 downto 6)<=(others=>data_in(7));
end behavior;