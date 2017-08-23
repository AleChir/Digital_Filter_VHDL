library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clk_gen is
end clk_gen;

architecture behavior of clk_gen is
  component filter
    port( data_ext:           in std_logic_vector( 7 downto 0);
          clock, start, rst:  in std_logic;
          done:               out std_logic);
  end component;

  signal data_ext: std_logic_vector( 7 downto 0);
  signal int_data: integer:=0;
  signal clk, start, rst: std_logic;
  signal done: std_logic;
  signal resettato: integer:=0;

  begin
    clock_process : process
    begin
      clk<= '0'; wait for 100 ns; clk <= '1'; wait for 100 ns;
      int_data<=int_data+1;
      data_ext<=std_logic_vector(to_unsigned(int_data,8));

      if(resettato=2) then
        start<='0';
      end if;

      if(resettato=1) then
        rst <= '1';
        resettato<=2;
      end if;

      if(resettato=0) then
        rst <= '0';
        start<='1';
        resettato<=1;
      end if;
    end process;

    stimulate: filter port map(data_ext, clk, start, rst, done);

end behavior;
