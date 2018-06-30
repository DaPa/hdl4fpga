library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library hdl4fpga;
use hdl4fpga.std.all;

entity scopeio_tracer is
	generic (
		inputs  : natural);
	port (
		clk     : in  std_logic;
		ena     : in  std_logic;
		samples : in  std_logic_vector;
		y       : in  std_logic_vector;
		pixels  : out std_logic_vector);
end;

architecture def of scopeio_tracer is
	constant bias : natural := 2**(y'length-1);

	signal dot : std_logic_vector(0 to pixels'length/size-1);

begin
	trace_g : for i in 0 to inputs-1 generate
		signal sample : std_logic_vector(0 to samples'length/inputs-1);
		signal row1   : unsigned(sample'range);
	begin
		sample <= word2byte(smp, i, smp'length/inputs);
		row1   <= resize(unsigned(y),sample'length) + bias;
		draw_vline_e : entity hdl4fpga.draw_vline
		generic map (
			n => sample'length)
		port map (
			video_clk  => clk,
			video_ena  => ena,
			video_row1 => std_logic_vector(row1),
			video_row2 => sample(i),
			video_dot  => dot(i));
	end generate;

	process(dot)
		variable aux : unsigned(0 to pixels'length-1) := (others => '0');
	begin
		aux := unsigned(pixels);
		for i in 0 to inputs-1 loop
			aux(0) := ena;
			aux(1) := dot(i);
			aux := aux rol (pixels'length/inputs);
		end loop;
		pixels <= std_logic_vector(aux);
	end process;
end;
