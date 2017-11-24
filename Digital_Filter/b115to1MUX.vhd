library ieee;
use ieee.std_logic_1164.all;
entity b115to1MUX is
    port(   in0,in1,in2,in3,in4:    in std_logic_vector(10 downto 0);
            m:                      out std_logic_vector(10 downto 0);
            sel:                    in std_logic_vector(2 downto 0));
end b115to1MUX;

architecture behavior of b115to1MUX is
begin
    process(sel, in0, in1, in2, in3, in4)
    begin
        case sel is
            when "000" => m<=in0;
            when "001" => m<=in1;
            when "010" => m<=in2;
            when "011" => m<=in3;
            when "100" => m<=in4;
            when others => m<= (others=> 'Z');
        end case;
    end process;
end behavior; 