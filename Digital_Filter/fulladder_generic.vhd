library ieee;
use ieee.std_logic_1164.all;

entity fulladder_generic is
  generic (N: integer:=8);
  port( a, b:   in std_logic_vector (N-1 downto 0);
        ci:     in std_logic;
        co:     out std_logic;
        s:      out std_logic_vector (N-1 downto 0);
        overf:  out std_logic);
end fulladder_generic;

architecture behavior of fulladder_generic is

  component b1fulladder
    port( a, b, ci: IN std_logic;
          s,co:     OUT std_logic);
  end component;

  signal internalco: std_logic_vector(N downto 0);
  signal sum: std_logic_vector(N-1 downto 0);

  begin

    internalco(0)<= ci;
    G1: for i in 1 to N generate
      additions: b1fulladder port map (a(i-1), b(i-1), internalco(i-1), sum(i-1), internalco(i));
    end generate;

    co<=internalco(N);
    s<=sum;
    overf<=(a(N-1) and b(N-1) and (not sum(N-1))) or (not(a(N-1)) and not(b(N-1)) and
    sum(N-1));

end behavior;
