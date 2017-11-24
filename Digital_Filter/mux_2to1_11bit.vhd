library ieee;
use ieee.std_logic_1164.all;

entity mux_2to1_11bit is
    port (  data0:      in std_logic_vector (10 downto 0);
            data1:      in std_logic_vector (10 downto 0);
            sel:        in std_logic;
            data_out:   out std_logic_vector(10 downto 0));
end mux_2to1_11bit;

architecture Behaviour of mux_2to1_11bit is
begin
    process(data0,data1,sel)
    begin
        if(sel='0') then
            data_out <= data0;
        elsif(sel='1') then
            data_out <= data1;
        end if;
    end process;
end Behaviour;