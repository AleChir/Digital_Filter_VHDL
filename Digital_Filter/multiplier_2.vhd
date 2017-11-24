library ieee;
use ieee.std_logic_1164.all;

entity multiplier_2 is
    port(   data_in:    in std_logic_vector (7 downto 0);
            data_out:   out std_logic_vector (10 downto 0));
end multiplier_2;

architecture Behaviour of multiplier_2 is
begin
    data_out(0) <= '0';
    data_out(8 downto 1) <= data_in(7 downto 0);
    data_out(9) <= data_in(7);
    data_out(10) <= data_in(7);
end Behaviour;