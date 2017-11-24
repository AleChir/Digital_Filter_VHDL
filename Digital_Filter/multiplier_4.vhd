library ieee;
use ieee.std_logic_1164.all;

entity multiplier_4 is
    port (  data_in:    in std_logic_vector(7 downto 0);
            data_out:   out std_logic_vector(10 downto 0));
end multiplier_4;

architecture Behaviour of multiplier_4 is
begin
    data_out(0) <= '0';
    data_out(1) <= '0';
    data_out(9 downto 2) <= data_in(7 downto 0);
    data_out(10) <= data_in(7);
end Behaviour;