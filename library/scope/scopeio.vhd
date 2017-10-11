use std.textio.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

use ieee.std_logic_textio.all;

library hdl4fpga;
use hdl4fpga.std.all;
use hdl4fpga.cgafont.all;

entity scopeio is
	generic (
		inputs      : natural := 1;
		input_unit  : real    := 1.0;
		layout_id   : natural := 0;

		trigger_scales : std_logic_vector;
		time_scales    : std_logic_vector;

		channels_fg : std_logic_vector;
		channels_bg : std_logic_vector;
		hzaxis_fg   : std_logic_vector;
		hzaxis_bg   : std_logic_vector;
		grid_fg     : std_logic_vector := "100";
		grid_bg     : std_logic_vector := "000";

		hz_scales   : scale_vector;
		vt_scales   : scale_vector);
	port (
		mii_rxc     : in  std_logic := '-';
		mii_rxdv    : in  std_logic := '0';
		mii_rxd     : in  std_logic_vector;
		tdiv        : out std_logic_vector(4-1 downto 0);
		cmd_sel     : in  std_logic_vector(0 to 2-1) := "--";
		cmd_inc     : in  std_logic := '-';
		cmd_rdy     : in  std_logic := '0';
		data        : in  std_logic_vector(32-1 downto 0) := (others => '1');
		input_clk   : in  std_logic;
		input_ena   : in  std_logic := '1';
		input_data  : in  std_logic_vector;
		video_clk   : in  std_logic;
		video_rgb   : out std_logic_vector;
		video_hsync : out std_logic;
		video_vsync : out std_logic;
		video_blank : out std_logic;
		video_sync  : out std_logic);
end;

architecture beh of scopeio is

	subtype input_sel is (unsigned_num_bits(inputs-1)-1 downto 0);

	type layout is record 
		mode        : natural;
		scr_width   : natural;
		num_of_seg  : natural;
		chan_x      : natural;
		chan_y      : natural;
		chan_width  : natural;
		chan_height : natural;
	end record;

	type layout_vector is array (natural range <>) of layout;
	constant ly_dptr : layout_vector(0 to 1) := (
--		0 => (mode, scr_width | num_of_seg | chan_x | chan_y | chan_width | chan_height
		0 => (   7,      1920,           4,     320,     270,       50*32,          256),
		1 => (   1,       800,           2,     320,     300,       15*32,          256));

	function to_naturalvector (
		constant arg : layout)
		return natural_vector is
		variable rval : natural_vector(0 to 4*arg.num_of_seg-1);
	begin
		for i in 0 to arg.num_of_seg-1 loop
			rval(i*4+0) := 0;
			rval(i*4+1) := i*arg.chan_y;
			rval(i*4+2) := arg.scr_width;
			rval(i*4+3) := arg.chan_y-1;
		end loop;
		return rval;
	end;

	signal hdr_data     : std_logic_vector(288-1 downto 0);
	signal pld_data     : std_logic_vector(3*8-1 downto 0);
	signal pll_data     : std_logic_vector(0 to hdr_data'length+pld_data'length-1);
	signal ser_data     : std_logic_vector(32-1 downto 0);

	constant cga_zoom  : natural := 0;
	signal cga_we      : std_logic;
	signal scope_cmd   : std_logic_vector(8-1 downto 0);
	signal scope_data  : std_logic_vector(8-1 downto 0);
	signal scope_chan  : std_logic_vector(8-1 downto 0);
	signal char_dot    : std_logic;

	signal video_hs    : std_logic;
	signal video_vs    : std_logic;
	signal video_frm   : std_logic;
	signal video_hon   : std_logic;
	signal video_nhl   : std_logic;
	signal video_vld   : std_logic;
	signal video_vcntr : std_logic_vector(11-1 downto 0);
	signal video_hcntr : std_logic_vector(11-1 downto 0);

	signal video_bg   : std_logic_vector(0 to 5+inputs-1);
	signal video_fg   : std_logic_vector(0 to 6+inputs-1);
	signal plot_fg    : std_logic_vector(0 to inputs-1);

	signal video_io    : std_logic_vector(0 to 3-1);
	signal abscisa     : std_logic_vector(0 to unsigned_num_bits(ly_dptr(layout_id).chan_width-1)-1);
	
	signal win_don     : std_logic_vector(0 to 18-1);
	signal win_frm     : std_logic_vector(0 to 18-1);
	signal pll_rdy     : std_logic;

	signal input_addr  : std_logic_vector(0 to unsigned_num_bits(ly_dptr(layout_id).num_of_seg*ly_dptr(layout_id).chan_width-1));
	signal input_we    : std_logic;


	signal scale_y     : std_logic_vector(4-1 downto 0);
	signal scale_x     : std_logic_vector(4-1 downto 0);
	signal amp         : std_logic_vector(4*inputs-1 downto 0);

	subtype vmword  is signed(unsigned_num_bits(ly_dptr(layout_id).chan_y)-1 downto 0);
	type    vmword_vector  is array (natural range <>) of vmword;

	signal  vm_inputs   : vmword_vector(inputs-1 downto 0);
	signal  vm_addr     : std_logic_vector(1 to input_addr'right);
	signal  trigger_lvl : vmword;
	signal  trigger     : vmword;
	signal  trigger_chn : std_logic_vector(8-1 downto 0);
	signal  trigger_edg : std_logic;
	signal  full_addr   : std_logic_vector(vm_addr'range);
	signal  vm_data     : std_logic_vector(vmword'length*inputs-1 downto 0);
	signal  offset      : vmword_vector(inputs-1 downto 0) := (others => (others => '0'));
	signal  scale_offset: vmword;
	signal  ordinates   : std_logic_vector(vm_data'range);
	signal  tdiv_sel    : std_logic_vector(4-1 downto 0);
	signal  text_data   : std_logic_vector(8-1 downto 0);
	signal  text_addr   : std_logic_vector(10-1 downto 0);

	subtype mword  is signed(0 to 18-1);
	subtype mdword is signed(0 to 2*mword'length-1);
	type  mword_vector  is array (natural range <>) of mword;
	type  mdword_vector is array (natural range <>) of mdword;
	function scales_init (
		constant size : natural)
		return mword_vector is
		variable j : natural;
		variable k : natural;
		variable n : integer;
		variable rval : mword_vector(0 to size-1);
	begin
		for i in 1 to size loop 
			j := i;
			n := (j - (j mod 3)) / 3;
			case j mod 3 is
			when 0 =>           -- 1.0
				rval(i-1) := to_signed(integer(trunc(-(input_unit*2.0**(rval(0)'length)) / (5.0**(n+0)*2.0**(n+0)))), rval(0)'length);
			when 1 =>           -- 2.0
				rval(i-1) := to_signed(integer(trunc(-(input_unit*2.0**(rval(0)'length)) / (5.0**(n+0)*2.0**(n+1)))), rval(0)'length);
			when 2 =>           -- 5.0
				rval(i-1) := to_signed(integer(trunc(-(input_unit*2.0**(rval(0)'length)) / (5.0**(n+1)*2.0**(n+0)))), rval(0)'length);
			when others =>
			end case;
		end loop;
		return rval;
	end;

	constant scales    : mword_vector(0 to 16-1)  := scales_init(16);

	signal pixel       : std_logic_vector(video_rgb'range);
	signal channel_sel : input_sel;
	signal trigger_sel : input_sel;
begin

	miirx_e : entity hdl4fpga.scopeio_miirx
	port map (
		mii_rxc  => mii_rxc,
		mii_rxdv => mii_rxdv,
		mii_rxd  => mii_rxd,
		pll_data => pll_data,
		pll_rdy  => pll_rdy,
		ser_data => ser_data);

	process (ser_data)
		variable data : unsigned(pll_data'range);
	begin
		data     := unsigned(pll_data);
		data     := data sll hdr_data'length;
		pld_data <= reverse(std_logic_vector(data(pld_data'reverse_range)));
	end process;

	process (pld_data)
		variable data : unsigned(pld_data'range);
	begin
		data        := unsigned(pld_data);
		scope_cmd   <= std_logic_vector(data(scope_cmd'range));
		data        := data srl scope_cmd'length;
		scope_data  <= std_logic_vector(data(scope_data'range));
		data        := data srl scope_data'length;
		scope_chan  <= std_logic_vector(data(scope_chan'range));
	end process;

	process (mii_rxc)
		variable cmd_edge : std_logic;
	begin
		if rising_edge(mii_rxc) then
			trigger <= -(
				trigger_lvl +
				offset(to_integer(unsigned(trigger_chn(0 downto 0)))) -
				vmword'(b"0_1000_0000"));
			if pll_rdy='1' then
				case scope_cmd(3 downto 0) is
				when "0000" =>
					for i in 0 to inputs-1 loop
						if i=to_integer(unsigned(scope_chan(0 downto 0))) then
							amp((i+1)*4-1 downto 4*i) <= scope_data(3 downto 0);
							scale_y   <= scope_data(3 downto 0);
							channel_sel(0) <= setif(i=1);
						end if;
					end loop;
				when "0001" =>
					offset(to_integer(unsigned(scope_chan(0 downto 0)))) <= resize(signed(scope_data), vmword'length);
					scale_offset <= resize(signed(scope_data), vmword'length);
				when "0010" =>
					trigger_lvl  <= resize(signed(scope_data), vmword'length);
					trigger_chn  <= scope_chan and x"7f";
					trigger_edg  <= scope_chan(scope_chan'left);
					trigger_sel(0) <= scope_chan(0);
				when "0011" =>
					tdiv_sel  <= scope_data(3 downto 0);
					scale_x   <= scope_data(3 downto 0);
				when others =>
				end case;
			end if;
			cmd_edge := cmd_rdy;
		end if;
	end process;
	tdiv <= tdiv_sel;

	video_e : entity hdl4fpga.video_vga
	generic map (
		mode => ly_dptr(layout_id).mode,
		n    => 11)
	port map (
		clk   => video_clk,
		hsync => video_hs,
		vsync => video_vs,
		hcntr => video_hcntr,
		vcntr => video_vcntr,
		don   => video_hon,
		frm   => video_frm,
		nhl   => video_nhl);

	video_vld <= video_hon and video_frm;

	vgaio_e : entity hdl4fpga.align
	generic map (
		n => video_io'length,
		i => (video_io'range => '-'),
		d => (video_io'range => 14))
	port map (
		clk   => video_clk,
		di(0) => video_hs,
		di(1) => video_vs,
		di(2) => video_vld,
		do    => video_io);

	win_mngr_e : entity hdl4fpga.win_mngr
	generic map (
		tab => to_naturalvector(ly_dptr(layout_id)))
	port map (
		video_clk  => video_clk,
		video_x    => video_hcntr,
		video_y    => video_vcntr,
		video_don  => video_hon,
		video_frm  => video_frm,
		win_don    => win_don,
		win_frm    => win_frm);

	process (input_clk)
		subtype tdiv_word is signed(0 to 16);
		type tdiv_vector is array (natural range <> ) of tdiv_word;

		variable tdiv_scales : tdiv_vector(0 to 16-1);
		variable scaler : tdiv_word := (others => '1');
		variable i : natural;
	begin
		for j in tdiv_scales'range loop
			tdiv_scales(0) := to_signed(-1, tdiv_scales(0)'length);
			if j > 0 then
				i := j -1;
				case i mod 3 is
				when 0 =>           -- 1.0
					tdiv_scales(j) := to_signed(5**(i/3+0)*2**(i/3+0)-2, tdiv_scales(0)'length);
				when 1 =>           -- 2.0
					tdiv_scales(j) := to_signed(5**(i/3+0)*2**(i/3+1)-2, tdiv_scales(0)'length);
				when 2 =>           -- 5.0
					tdiv_scales(j) := to_signed(5**(i/3+1)*2**(i/3+0)-2, tdiv_scales(0)'length);
				when others =>
				end case;
			end if;
		end loop;

		if rising_edge(input_clk) then
			input_we <= scaler(0) and input_ena;
			if input_ena='1' then
				if scaler(0)='1' then
					scaler := tdiv_scales(to_integer(unsigned(tdiv_sel)));
				else
					scaler := scaler - 1;
				end if;
			end if;
		end if;
	end process;

	process (input_clk)

		variable input_aux : unsigned(input_data'length-1 downto 0);
		variable amp_aux   : unsigned(amp'range);
		variable chan_aux  : vmword_vector(vm_inputs'range) := (others => (others => '-'));
		subtype sample_word  is std_logic_vector(input_data'length/inputs-1 downto 0);
		type sample_vector is array (natural range <>) of sample_word;
		variable samples : sample_vector(0 to inputs-1);
		variable m : mdword_vector(0 to inputs-1);
		variable a : mword_vector(0 to inputs-1);
		variable scale : mword_vector(0 to inputs-1);
	begin
		if rising_edge(input_clk) then
			amp_aux := unsigned(amp);
			for i in 0 to inputs-1 loop
				vm_inputs(i) <= resize(m(i)(0 to a(0)'length-1),vmword'length);
				m(i)         := a(i)*scale(i);
				scale(i)     := scales(to_integer(amp_aux(4-1 downto 0)));
				a(i)         := resize(signed(not input_aux((i+1)*sample_word'length-1 downto i*sample_word'length)), mword'length);
--				a(i)         := resize(signed(samples(i)), mword'length);
--				samples(i)   := not std_logic_vector(input_aux(sample_word'length-1 downto 0));
--				input_aux    := input_aux ror (sample_word'length/inputs);
				amp_aux      := amp_aux   ror (amp'length/inputs);
			end loop;
			input_aux := unsigned(input_data);
		end if;
	end process;

	trigger_b  : block
		signal input_level : vmword;
		signal trigger_ena : std_logic;
	begin
		process (input_clk)
			variable input_aux  : vmword;
			variable input_ge   : std_logic;
			variable input_trgr : std_logic;
		begin
			if rising_edge(input_clk) then
				if trigger_ena='1' then
					if input_addr(0)='1' then
						if video_frm='0' then
							trigger_ena <= '0';
						end if;
					end if;
					input_trgr := '0';
				elsif input_trgr='0' then
					if input_ge='0' then
						input_trgr := '1';
					end if;
				elsif input_ge='1' then
					trigger_ena <= '1';
				end if;
				if input_we='1' then
					input_ge := trigger_edg xnor setif(input_aux >= trigger_lvl);
				end if;
				input_aux := vm_inputs((to_integer(unsigned(trigger_chn(0 downto 0)))));
			end if;
		end process;

		process (input_clk)
		begin
			if rising_edge(input_clk) then
				if trigger_ena='0' then
					input_addr <= (others => '0');
				elsif input_addr(0)='0' then
					if input_we='1' then
						input_addr <= std_logic_vector(unsigned(input_addr) + 1);
					end if;
				end if;
			end if;
		end process;

	end block;

	videomem_b : block
		signal wr_addr : std_logic_vector(vm_addr'range);
		signal wr_data : std_logic_vector(vm_data'range);
		signal rd_addr : std_logic_vector(vm_addr'range);
		signal rd_data : std_logic_vector(vm_data'range);
	begin

		process (vm_inputs)
			variable aux  : signed(vm_data'length-1 downto 0);
		begin
			aux := (others => '-');
			for i in 0 to inputs-1 loop
				aux := aux sll vmword'length;
				aux(vmword'range) := vm_inputs(i)+offset(i);
			end loop;
			vm_data <= std_logic_vector(aux);
		end process;


		wr_data <= vm_data;
		wr_addr <= input_addr(vm_addr'range);

--		data_e : entity hdl4fpga.align
--		generic map (
--			n => wr_data'length,
--			d => (wr_data'range => 18))
--		port map (
--			clk => input_clk,
--			di  => vm_data,
--			do  => wr_data);
--
--		addr_e : entity hdl4fpga.align
--		generic map (
--			n => wr_addr'length,
--			d => (wr_addr'range => 1))
--		port map (
--			clk => input_clk,
--			di  => input_addr(vm_addr'range),
--			do  => wr_addr);

		process (video_clk)
			variable d : std_logic_vector(rd_data'range);
		begin
			if rising_edge(video_clk) then
				rd_addr   <= full_addr;
				ordinates <= d;
				d         := rd_data;
			end if;
		end process;

		dpram_e : entity hdl4fpga.dpram
		port map (
			wr_clk  => input_clk,
			wr_addr => wr_addr,
			wr_data => wr_data,
			rd_addr => rd_addr,
			rd_data => rd_data);
	end block;

	process (video_clk)
		variable base : unsigned(vm_addr'range);
	begin
		if rising_edge(video_clk) then
			base := (others => '-');
			for i in 0 to 4-1 loop
				if win_don(i)='1' then
					base := to_unsigned(i*ly_dptr(layout_id).chan_width, base'length);
				end if;
			end loop;
			full_addr <= std_logic_vector(resize(unsigned(abscisa),full_addr'length) + base);
		end if;
	end process;

	meter_b : block

		function bcd2ascii (
			constant arg : std_logic_vector)
			return std_logic_vector is
			variable aux : unsigned(0 to arg'length-1);
			variable val : unsigned(8*arg'length/4-1 downto 0);
		begin
			val := (others => '-');
			aux := unsigned(arg);
			for i in 0 to aux'length/4-1 loop
				val := val sll 8;
				if to_integer(unsigned(aux(0 to 4-1))) < 10 then
					val(8-1 downto 0) := unsigned'("0011") & unsigned(aux(0 to 4-1));
				elsif to_integer(unsigned(aux(0 to 4-1))) < 15 then
					val(8-1 downto 0) := unsigned'("0010") & unsigned(aux(0 to 4-1));
				else
					val(8-1 downto 0) := x"20";
				end if;
				aux := aux sll 4;
			end loop;
			return std_logic_vector(val);
		end;

		signal meassure : std_logic_vector(0 to 6*4-1) := (others => '1');
		signal display : std_logic_vector(0 to 6*4-1) := (others => '1');

		signal scale   : std_logic_vector(4-1 downto 0);
		signal value   : std_logic_vector(inputs*9-1 downto 0);
		signal unit    : std_logic_vector(0 to 4*8-1);
	begin

		process (mii_rxc)
			constant rtxt_size : natural := unsigned_num_bits(2+inputs-1);
		begin
			if rising_edge(mii_rxc) then
				name <= word2byte(fill(
					names,
					2**rtxt_size*scale'length, value => '1'),
					text_addr(rtxt_size+5-1 downto 5));
				scale <= word2byte(fill(
					word2byte(time_scales,    scale_x)     &
					word2byte(trigger_scales, trigger_sel) &
					amp,
					2**rtxt_size*scale'length, value => '1'),
					text_addr(rtxt_size+5-1 downto 5));

				value <= word2byte(fill(
					word2byte(time_value,    scale_x);
					word2byte(trigger_value, trigger_sel) &
					offset,
					2**rtxt_size*scale'length, value => '1'),
					text_addr(rtxt_size+5-1 downto 5));

				unit <= word2byte(
					word2byte(time_scales,    scale_x)     &
					word2byte(trigger_scales, trigger_sel) &
					unit,
					2**rtxt_size*scale'length, value => '1'),
					text_addr(rtxt_size+5-1 downto 5));
			end if;
		end process;

		display_e : entity hdl4fpga.meter_display
		generic map (
			frac => 6,
			int  => 2,
			dec  => 2)
		port map (
			value => value(9-1 downto 0),
			scale => scale,
			fmtds => meassure);	

		process (mii_rxc)
			variable addr : unsigned(text_addr'range) := (others => '0');
			variable aux  : unsigned(0 to data'length-1);
		begin
			if rising_edge(mii_rxc) then
				text_addr <= std_logic_vector(addr);
				text_data <= word2byte(fill(
					to_ascii(name) & bcd2ascii(display) & to_ascii(unit))
					not std_logic_vector(addr(5-1 downto 0)));
				addr := addr + 1;
				aux  := unsigned(data);
			end if;

		end process;

	end block;

	scopeio_channel_e : entity hdl4fpga.scopeio_channel
	generic map (
		inputs      => inputs,
		num_of_seg  => ly_dptr(layout_id).num_of_seg,
		chan_x      => ly_dptr(layout_id).chan_x,
		chan_width  => ly_dptr(layout_id).chan_width,
		chan_height => ly_dptr(layout_id).chan_height,
		scr_width   => ly_dptr(layout_id).scr_width,
		height      => ly_dptr(layout_id).chan_y,
		hz_scales   => hz_scales,
		vt_scales   => vt_scales)
	port map (
		video_clk  => video_clk,
		video_nhl  => video_nhl,
		ordinates  => ordinates,
		text_clk   => mii_rxc,
		text_addr  => text_addr,
		text_data  => text_data,
		offset     => std_logic_vector(scale_offset),
		trigger    => std_logic_vector(trigger),
		abscisa    => abscisa,
		scale_x    => scale_x,
		scale_y    => scale_y,
		win_frm    => win_frm,
		win_on     => win_don,
		plot_fg    => plot_fg,
		video_bg   => video_bg,
		video_fg   => video_fg);

	process(video_clk)
		variable pcolor_sel   : input_sel;
		variable vcolorfg_sel : std_logic_vector(0 to unsigned_num_bits(video_fg'length-1)-1);
		variable vcolorbg_sel : std_logic_vector(0 to unsigned_num_bits(video_bg'length-1)-1);

		variable plot_on    : std_logic;
		variable video_fgon : std_logic;
		variable video_bgon : std_logic;

		variable vtaxis_fg  : std_logic_vector(3-1 downto 0);
		variable vtaxis_bg  : std_logic_vector(3-1 downto 0);
		variable trigger_fg : std_logic_vector(3-1 downto 0);
		variable trigger_bg : std_logic_vector(3-1 downto 0);

	begin
		if rising_edge(video_clk) then
			vtaxis_fg  := word2byte(fill(channels_fg, 2**channel_sel'length*vtaxis_fg'length),  not channel_sel);
			trigger_fg := word2byte(fill(channels_fg, 2**trigger_sel'length*trigger_fg'length), not trigger_sel);
			trigger_bg := word2byte(fill(channels_bg, 2**trigger_sel'length*trigger_bg'length), not trigger_sel);

			if plot_on='1' then
				pixel <= word2byte(fill(channels_fg, 2**pcolor_sel'length*pixel'length), not pcolor_sel);
			elsif video_fgon='1' then
				pixel <= word2byte(fill(trigger_fg  & hzaxis_fg & vtaxis_fg  & grid_fg & hzaxis_fg & trigger_fg & vtaxis_fg, 2**vcolorfg_sel'length*pixel'length), not vcolorfg_sel);
			elsif video_bgon='1' then                                                                                                                       
				pixel <= word2byte(fill(channels_bg & hzaxis_bg & trigger_bg & grid_bg & hzaxis_bg & vtaxis_bg, 2**vcolorbg_sel'length*pixel'length), not vcolorbg_sel);
			else
				pixel <= (others => '0');
			end if;

			vcolorfg_sel := encoder(video_fg);
			vcolorbg_sel := encoder(video_bg);
			pcolor_sel   := encoder(plot_fg);
			plot_on      := setif(plot_fg  /= (plot_fg'range => '0'));
			video_fgon   := setif(video_fg /= (video_fg'range => '0'));
			video_bgon   := setif(video_bg /= (video_bg'range => '0'));
		end if;
	end process;

	video_rgb   <= (video_rgb'range => video_io(2)) and pixel;
	video_blank <= video_io(2);
	video_hsync <= video_io(0);
	video_vsync <= video_io(1);
	video_sync  <= not video_io(1) and not video_io(0);

end;
