library ieee;
use ieee.std_logic_1164.all;

entity datapath is
  port( x:                        in std_logic_vector(7 downto 0);
        y:                        out std_logic_vector(7 downto 0);
        clock:                    in std_logic;
        rst_shift, enable_shift:  in std_logic;
        rst_sum, enable_sum:      in std_logic;
        rst_count, enable_count:  in std_logic;
        count_out:                buffer std_logic_vector(9 downto 0);
        module, cntrl:            in std_logic;
        mux1_sel:                 in std_logic_vector(2 downto 0);
        terminal_count:           out std_logic );
end datapath;

architecture behavior of datapath is
  component b82to1MUX
    port( in0,in1:  in std_logic_vector(7 downto 0);
          m:        out std_logic_vector(7 downto 0);
          sel:      in std_logic);
  end component;

  component count_n
    generic(  N: integer:=16);
    port( clk, clear, enable: IN std_logic;
          q:                  OUT std_logic_vector(N-1 downto 0));
  end component;

  component b115to1MUX
    port( in0,in1,in2,in3,in4: in std_logic_vector(10 downto 0);
          m:                   out std_logic_vector(10 downto 0);
          sel:                 in std_logic_vector(2 downto 0));
  end component;

  component mux_2to1_11bit
    port( data0:    in std_logic_vector (10 downto 0);
          data1:    in std_logic_vector (10 downto 0);
          sel:      in std_logic;
          data_out: out std_logic_vector(10 downto 0) );
    end component;

  component divider_2
    port( data_in:  in std_logic_vector(7 downto 0);
          data_out: out std_logic_vector( 10 downto 0)  );
  end component;

  component divider_4
    port( data_in:  in std_logic_vector(7 downto 0);
          data_out: out std_logic_vector( 10 downto 0));
  end component;

  component multiplier_2
    port( data_in:  in std_logic_vector (7 downto 0);
          data_out: out std_logic_vector (10 downto 0));
  end component;

  component multiplier_4
    port( data_in:  in std_logic_vector(7 downto 0);
          data_out: out std_logic_vector(10 downto 0));
  end component;

  component ram_1024X8
    port( data_in:  in std_logic_vector(7 downto 0);
          address:  in integer range 1023 downto 0;
          cs:       in std_logic;
          clk:      in std_logic;
          rd_wr_n:  in std_logic;
          data_out: out std_logic_vector (7 downto 0));
  end component;

  component regn_std_logic
    generic( N: integer:=8);
    port( R:                      in std_logic_vector(N-1 downto 0);
          Clock, Resetn, enable : in std_logic;
          Q:                      out std_logic_vector(N-1 downto 0));
  end component;

  component fulladder_generic is
      GENERIC ( N: integer:=8);
    port( a, b:   IN std_logic_vector (N-1 downto 0);
          ci:     IN std_logic;
          co:     OUT std_logic;
          s:      OUT std_logic_vector (N-1 downto 0);
          overf:  out std_logic );
  end component;

  signal q_shift0, q_shift1, q_shift2, q_shift3: std_logic_vector(7 downto 0);

  signal in_mux0, in_mux1, in_mux2, in_mux3, in_mux4: std_logic_vector(10 downto 0);

  signal out_mux1, out_mux1n: std_logic_vector(10 downto 0);

  signal mux2_sel, mux3_sel: std_logic;

  signal out_mux2, out_mux3: std_logic_vector(10 downto 0);

  signal out_sum: std_logic_vector(10 downto 0);

  signal saturation: std_logic;

  signal co, ovf: std_logic;


  begin

    count: count_n generic map(10) port map(clock,rst_count, enable_count, count_out);
    terminal_count<=count_out(9) and count_out(8) and count_out(7) and
    count_out(6) and count_out(5) and count_out(4) and count_out(3) and
    count_out(2) and count_out(1) and count_out(0);

    shift_0: regn_std_logic generic map(8) port map(x, clock, rst_shift, enable_shift, q_shift0);
    shift_1: regn_std_logic generic map(8) port map(q_shift0,clock, rst_shift,  enable_shift, q_shift1);
    shift_2: regn_std_logic generic map(8) port map(q_shift1,clock, rst_shift, enable_shift, q_shift2);
    shift_3: regn_std_logic generic map(8) port map(q_shift2,clock, rst_shift, enable_shift, q_shift3);
    div_2: divider_2 port map(q_shift0, in_mux0);
    mult_2: multiplier_2 port map(q_shift1, in_mux1);
    mult_4: multiplier_4 port map(q_shift2, in_mux2);
    div_4: divider_4 port map(q_shift3, in_mux3);
    mux_1: b115to1MUX port map(in_mux0, in_mux1, in_mux2, in_mux3, in_mux4, out_mux1, mux1_sel);

    out_mux1n(0)<= not out_mux1(0);
    out_mux1n(1)<= not out_mux1(1);
    out_mux1n(2)<= not out_mux1(2);
    out_mux1n(3)<= not out_mux1(3);
    out_mux1n(4)<= not out_mux1(4);
    out_mux1n(5)<= not out_mux1(5);
    out_mux1n(6)<= not out_mux1(6);
    out_mux1n(7)<= not out_mux1(7);
    out_mux1n(8)<= not out_mux1(8);
    out_mux1n(9)<= not out_mux1(9);
    out_mux1n(10)<=not out_mux1(10);

    mux_2: mux_2to1_11bit port map(out_mux1, out_mux1n, mux2_sel,out_mux2);
    sum: fulladder_generic generic map(11) port map(out_mux3, out_mux2, mux2_sel, co, out_sum, ovf);
    reg_sum: regn_std_logic generic map(11) port map(out_sum, clock, rst_sum, enable_sum, in_mux4);
    mux_3: mux_2to1_11bit port map(in_mux4, "00000000000", mux3_sel, out_mux3);

    mux3_sel<= module;
    mux2_sel<= cntrl xor (module and in_mux4(10));
    saturation<=in_mux4(7) or in_mux4(8) or in_mux4(9);

    mux_4: b82to1MUX port map(in_mux4(7 downto 0), "01111111", y, saturation);

end behavior;
