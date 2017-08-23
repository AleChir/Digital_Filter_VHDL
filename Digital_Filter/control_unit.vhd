library ieee;
use ieee.std_logic_1164.all;
entity control_unit is
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
end control_unit;

architecture Behaviour of control_unit is
  type states is (idle,write_a,reset_for_sums,read_a,sample_shift,op_0,op_1,op_2,op_3,op_4,sample_sum,write_b,done);
  signal present_state:states;

  begin
    process(clock,reset)
    begin
      if (reset='0') then
        present_state<=idle;
      elsif(clock'event and clock='1') then

        case present_state is

          when idle=>
            if (start='1') then
              present_state<=write_a;
            else
              present_state<=idle;
            end if;

          when write_a=>
            if(exceed='1') then
              present_state<=reset_for_sums;
            else
              present_state<=write_a;
            end if;

          when reset_for_sums=>
            present_state<=read_a;

          when read_a=>
            present_state <= sample_shift;

          when sample_shift =>
            present_state<=op_0;

          when op_0=>
            present_state <= op_1;

          when op_1 =>
            present_state <= op_2;

          when op_2 =>
            present_state <= op_3;

          when op_3 =>
            present_state <= op_4;

          when op_4 =>
            present_state <= sample_sum;

          when sample_sum =>
            present_state <= write_b;

          when write_b =>
            if(exceed = '0') then
              present_state <= read_a;
            else
              present_state <= done;
            end if;

          when done =>
            if (start = '1') then
              present_state <= done;
            else
              present_state <= idle;
            end if;

          when others =>
            present_state<=idle;

        end case;
      end if;
    end process;

    process (present_state)
    begin
      module <= '0';
      cntrl <= '0';
      enable_shift <= '0';
      cs_a <= '0';
      cs_b <= '0';
      wr_rd_a <= '0';
      wr_rd_b <= '0';
      finished <= '0';
      up_count <= '0';
      mux1_sel <= "000";
      rst_sum <= '1';
      rst_shift <= '1';
      rst_count <= '1';
      enable_sum <= '1';

      case present_state is
        when idle =>
          rst_count <= '0';

        when write_a =>
          cs_a <= '1';
          wr_rd_a <= '1';
          up_count <= '1';

        when reset_for_sums =>
          rst_shift <= '0';
          rst_count <= '0';

        when read_a =>
          cs_a <= '1';
          wr_rd_a <= '0';

        when sample_shift =>
          cs_a <= '1';
          wr_rd_a <= '0';
          enable_shift <= '1';
          rst_sum <= '0';

        when op_0 =>
          mux1_sel <= "000";
          cntrl <= '1';

        when op_1 =>
          mux1_sel <= "001";
          cntrl <= '1';

        when op_2 =>
          mux1_sel <= "010";

        when op_3 =>
          mux1_sel <= "011";

        when op_4 =>
          mux1_sel <= "100";
          module <= '1';

        when sample_sum =>
          enable_sum <= '0';

        when write_b =>
          cs_b <= '1';
          wr_rd_b <= '1';
          up_count <= '1';
          enable_sum <= '0';

        when done =>
          finished <= '1';

        when others =>

      end case;
    end process;
end Behaviour;
