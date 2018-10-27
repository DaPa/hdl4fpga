library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library hdl4fpga;
use hdl4fpga.std.all;

entity scopeio_palette is
	generic (
		traces_fg   : in  std_logic_vector;
		trigger_fg  : in  std_logic_vector;
		grid_fg     : in  std_logic_vector;
		grid_bg     : in  std_logic_vector;
		hz_fg       : in  std_logic_vector;
		hz_bg       : in  std_logic_vector;
		vt_fg       : in  std_logic_vector;
		vt_bg       : in  std_logic_vector;
		text_bg    : in  std_logic_vector;
		sgmnt_bg    : in  std_logic_vector;
		bk_gd       : in  std_logic_vector);
	port (
		wr_clk      : in  std_logic;
		wr_dv       : in  std_logic;
		wr_palette  : in  std_logic_vector;
		wr_color    : in  std_logic_vector;
		
		video_clk   : in  std_logic;
		trigger_chanid : in std_logic_vector;
		trigger_dot : in  std_logic;
		grid_dot    : in  std_logic;
		grid_bgon   : in  std_logic;
		hz_dot      : in  std_logic;
		hz_bgon     : in  std_logic;
		vt_dot      : in  std_logic;
		vt_bgon     : in  std_logic;
		text_bgon   : in  std_logic;
		sgmnt_bgon  : in  std_logic;
		traces_dots : in  std_logic_vector;
		video_color : out std_logic_vector);
end;

architecture beh of scopeio_palette is

	function id_codes (
		constant n : natural)
		return std_logic_vector is
		constant size   : natural := unsigned_num_bits(n-1);
		variable retval : unsigned(0 to n*size-1);
	begin
		for i in 0 to n-1 loop
			retval(0 to size-1) := to_unsigned(i, size);
			retval := retval rol size;
		end loop;
		return std_logic_vector(retval);
	end;

	constant paletteid_size : natural := unsigned_num_bits(traces_dots'length + 9 - 1); 
	constant palette_ids    : std_logic_vector := std_logic_vector(unsigned(id_codes(traces_dots'length + 9)) ror paletteid_size*traces_dots'length); 

	signal trace_on   : std_logic;
	signal trigger_on : std_logic;
	signal fgbg_on    : std_logic := '1';
	signal trace_id   : std_logic_vector(0 to paletteid_size-1);
	signal trigger_id : std_logic_vector(trace_id'range);
	signal fgbg_id    : std_logic_vector(trace_id'range);

	signal rd_addr    : std_logic_vector(wr_palette'range);
	signal rd_data    : std_logic_vector(wr_color'range);

begin
	mem_e : entity hdl4fpga.dpram
	generic map (
		bitrom => grid_fg & grid_bg & hz_fg & hz_bg & vt_fg & vt_bg & text_bg & sgmnt_bg & bk_gd & traces_fg)
	port map (
		wr_clk  => wr_clk,
		wr_ena  => wr_dv,
		wr_addr => wr_palette,
		wr_data => wr_color,

		rd_addr => rd_addr,
		rd_data => rd_data);

	traceid_p : process (video_clk)
	begin
		if rising_edge(video_clk) then
			trace_id <= primux(palette_ids(0 to paletteid_size*traces_dots'length-1), traces_dots);
			trace_on <= setif(traces_dots/=(traces_dots'range => '0'));
		end if;
	end process;

	triggerio_p : process (video_clk)
	begin
		if rising_edge(video_clk) then
			trigger_id <= word2byte(palette_ids(0 to paletteid_size*traces_dots'length-1), trigger_chanid, paletteid_size);
			trigger_on <= trigger_dot;
		end if;
	end process;

	fgbg_p : process (video_clk)
		variable aux : std_logic_vector(palette_ids'range);
	begin
		if rising_edge(video_clk) then
			aux     := std_logic_vector(unsigned(palette_ids) rol paletteid_size*traces_dots'length);
			fgbg_id <= primux(aux(0 to 9*paletteid_size-1), grid_dot & grid_bgon & hz_dot & hz_bgon & vt_dot & vt_bgon & text_bgon & sgmnt_bgon & '1');
		end if;
	end process;

	process (video_clk)
	begin
		if rising_edge(video_clk) then
			rd_addr     <= primux(trace_id & trigger_id & fgbg_id, trace_on & trigger_on & fgbg_on);
			video_color <= rd_data;
		end if;
	end process;
--
--	process (video_clk)
--	begin
--		if rising_edge(video_clk) then
--			rd_addr     <= priencoder(traces_dots & trigger_dot & grid_dot & grid_bgon & hz_dot & hz_bgon & vt_dot & vt_bgon & '1');
--			video_color <= rd_data;
--		end if;
--	end process;

end;
