LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY regn_std_logic IS
    GENERIC ( N : integer:=8);
    PORT (  R:                      IN std_logic_vector(N-1 DOWNTO 0);
            Clock, Resetn, enable : IN STD_LOGIC;
            Q:                      OUT std_logic_vector(N-1 DOWNTO 0));
END regn_std_logic;

Architecture Behavior OF regn_std_logic IS
BEGIN
    PROCESS (Clock, Resetn)
    BEGIN
        IF (Resetn = '0') THEN
            Q <= (OTHERS => '0');
        ELSIF (Clock'EVENT AND Clock = '1') THEN
            IF(enable='1') then
                Q <= R;
            end IF;
        END IF;
    END PROCESS;
END Behavior;