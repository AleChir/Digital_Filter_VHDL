library ieee;
use ieee.std_logic_1164.all;
entity b82to1MUX is
    port(   in0,in1:    in std_logic_vector(7 downto 0);
            m:          out std_logic_vector(7 downto 0);
            sel:        in std_logic);
end b82to1MUX;

architecture behavior of b82to1MUX is
begin

    process(sel, in0, in1)
    begin
        case sel is
            when '0' => m<=in0;
            when '1' => m<=in1;
            when others=> m<=(others=> 'Z');
        end case;
    end process;
end behavior; 