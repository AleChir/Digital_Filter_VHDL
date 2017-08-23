library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity filter is
  port( data_ext: in std_logic_vector( 7 downto 0);
        clock, start, rst: in std_logic;
        done: out std_logic);
end filter;

architecture behavior of filter is
  component datapath
    port( x:                        in std_logic_vector(7 downto 0);
          y:                        out std_logic_vector(7 downto 0);
          clock:                    in std_logic;
          rst_shift, enable_shift:  in std_logic;
          rst_sum, enable_sum:      in std_logic;
          rst_count, enable_count:  in std_logic;
          count_out:                out std_logic_vector(9 downto 0);
          module, cntrl:            in std_logic;
          mux1_sel:                 in std_logic_vector(2 downto 0);
          terminal_count:           out std_logic );
  end component;

  component control_unit
    port (  module:                     out std_logic;
            cntrl:                      out std_logic;
            enable_sum:                 out std_logic;
            enable_shift:               out std_logic;
            clock:                      in std_logic;
            rst_shift:                  out std_logic;
            cs_a,cs_b,wr_rd_a,wr_rd_b:  out std_logic;
            finished:                   out std_logic;
            rst_count:                  out std_logic;
            up_count:                   out std_logic;
            start:                      in std_logic;
            rst_sum:                    out std_logic;
            mux1_sel:                   out std_logic_vector(2 downto 0);
            reset:                      in std_logic;
            exceed:                     in std_logic  );
  end component;

  component ram_1024X8
    port( data_in:  in std_logic_vector(7 downto 0);
          address:  in integer range 1023 downto 0;
          cs:       in std_logic;
          clk:      in std_logic;
          wr_rd_n:  in std_logic;
          data_out: out std_logic_vector (7 downto 0));
  end component;



  signal mem_a_out, mem_b_in: std_logic_vector (7 downto 0);
  signal mem_b_out: std_logic_vector( 7 downto 0);
  signal rst_shift, enable_shift: std_logic;
  signal rst_sum, enable_sum: std_logic;
  signal rst_count, enable_count: std_logic;
  signal count_out: std_logic_vector(9 downto 0);
  signal module, cntrl: std_logic;
  signal mux1_sel: std_logic_vector(2 downto 0);
  signal cs_a,cs_b,wr_rd_a,wr_rd_b: std_logic;
  signal exceed:std_logic;
  signal add: integer:=0;

  begin

    dp: datapath port map(mem_a_out, mem_b_in, clock, rst_shift, enable_shift,
                          rst_sum, enable_sum, rst_count, enable_count, count_out,
                          module, cntrl, mux1_sel, exceed);

    cu: control_unit port map(module,cntrl,enable_sum, enable_shift, clock, rst_shift,
                              cs_a, cs_b, wr_rd_a, wr_rd_b, done,
                              rst_count,enable_count,
                              start, rst_sum, mux1_sel, rst, exceed);

    add<= to_integer(unsigned(count_out));
    ram_a: ram_1024x8 port map(data_ext,add, cs_a, clock, wr_rd_a, mem_a_out);
    ram_b: ram_1024x8 port map(mem_b_in,add, cs_b, clock, wr_rd_b, mem_b_out);

end architecture;
