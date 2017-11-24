library ieee;
use ieee.std_logic_1164.all;

entity divider_2 is
    port(   data_in:    in std_logic_vector(7 downto 0);
            data_out:   out std_logic_vector( 10 downto 0));
end divider_2;

architecture behavior of divider_2 is
begin
    data_out(6 downto 0)<= data_in(7 downto 1);
    data_out(10 downto 7)<=(others=>data_in(7));
end behavior;