--                                                                            --
-- Author(s):                                                                 --
--   Miguel Angel Sagreras                                                    --
--                                                                            --
-- Copyright (C) 2015                                                         --
--    Miguel Angel Sagreras                                                   --
--                                                                            --
-- This source file may be used and distributed without restriction provided  --
-- that this copyright statement is not removed from the file and that any    --
-- derivative work contains  the original copyright notice and the associated --
-- disclaimer.                                                                --
--                                                                            --
-- This source file is free software; you can redistribute it and/or modify   --
-- it under the terms of the GNU General Public License as published by the   --
-- Free Software Foundation, either version 3 of the License, or (at your     --
-- option) any later version.                                                 --
--                                                                            --
-- This source is distributed in the hope that it will be useful, but WITHOUT --
-- ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or      --
-- FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for   --
-- more details at http://www.gnu.org/licenses/.                              --
--                                                                            --

use std.textio.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;

library hdl4fpga;
use hdl4fpga.std.all;
use hdl4fpga.cgafonts.all;

entity mii_display is
	port (
		mii_rxc   : in  std_logic;
		mii_rxdv  : in  std_logic;
		mii_rxd   : in  std_logic_vector;

		video_clk : in  std_logic;
		video_dot : out std_logic;
		video_hs  : out std_logic;
		video_vs  : out std_logic);
	end;

architecture struct of mii_display is

	signal video_frm   : std_logic;
	signal video_hon   : std_logic;
	signal video_nhl   : std_logic;
	signal video_vld   : std_logic;
	signal video_vcntr : std_logic_vector(11-1 downto 0);
	signal video_hcntr : std_logic_vector(11-1 downto 0);

begin

	video_e : entity hdl4fpga.video_vga
	generic map (
		mode => 7,
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

	cgaadapter_b : block
		signal font_col  : std_logic_vector(3-1 downto 0);
		signal font_row  : std_logic_vector(4-1 downto 0);
		signal font_addr : std_logic_vector(8+4-1 downto 0);
		signal font_line : std_logic_vector(8-1 downto 0);

		signal cga_clk   : std_logic;
		signal cga_ena   : std_logic;
		signal cga_rdata : std_logic_vector(ascii'range);
		signal cga_wdata : std_logic_vector(ascii'length*2-1 downto 0);
		signal cga_addr  : std_logic_vector(13-1 downto 0) := (others => '0');

		signal video_on  : std_logic;
	begin
	
		cgabram_b : block
			signal video_addr : std_logic_vector(14-1 downto 0);
			signal rd_addr    : std_logic_vector(video_addr'range);
			signal rd_data    : std_logic_vector(cga_rdata'range);
			signal rxd8       : std_logic_vector(0 to 8-1);
			signal cga_eol    : std_logic;
		begin

			cga_clk <= mii_rxc;
			cga_eol <= mii_rxdv;
			process (cga_clk)
				variable edge : std_logic := '0';
			begin
				if rising_edge(cga_clk) then
					if cga_ena='1' then
						cga_addr <= std_logic_vector(unsigned(cga_addr) + 1);
					elsif cga_eol='0' and edge='1' then
						cga_addr <= std_logic_vector(unsigned(cga_addr) + 1);
					end if;
					edge := cga_eol;
				end if;
			end process;

			process (mii_rxc, mii_rxd, mii_rxdv)
				variable aux  : unsigned(0 to 8-mii_rxd'length-1);
				variable cntr : unsigned(0 to 8/mii_rxd'length-1);
			begin
				if mii_rxd'length < rxd8'length then
					if rising_edge(mii_rxc) then
						if mii_rxdv='0' then
							cntr := (0 => '1', others => '0');
							cntr := cntr rol 1;
						else
							cntr := cntr rol 1;
							aux  := aux  rol mii_rxd'length; 
							aux(mii_rxd'range) := unsigned(mii_rxd);
						end if;
						cga_ena <= cntr(0);
					end if;
					rxd8 <= std_logic_vector(aux) & mii_rxd;
				else
					rxd8    <= mii_rxd;
					cga_ena <= mii_rxdv;
				end if;
			end process;

			process (rxd8)
				constant tab  : ascii_vector(0 to 16-1) := to_ascii("0123456789ABCDEF");
				variable rxd  : unsigned(rxd8'range);
				variable data : unsigned(2*ascii'length-1 downto 0);
			begin
				rxd := unsigned(reverse(rxd8));
				for i in 0 to rxd'length/4-1 loop
					data := data ror ascii'length;
					data(ascii'range) := unsigned(tab(to_integer(rxd(0 to 4-1))));
					rxd  := rxd sll 4;
				end loop;
				cga_wdata <= std_logic_vector(data);
			end process;

			process (video_vcntr, video_hcntr)
				variable aux : unsigned(video_addr'range);
			begin
				aux := resize(unsigned(video_vcntr) srl 4, video_addr'length);
				aux := ((aux sll 4) - aux) sll 4;  -- * (1920/8)
				aux := aux + (unsigned(video_hcntr) srl 3);
				video_addr <= std_logic_vector(aux);
			end process;

			rdaddr_e : entity hdl4fpga.align
			generic map (
				n   => video_addr'length,
				d   => (video_addr'range => 1))
			port map (
				clk => video_clk,
				di  => video_addr,
				do  => rd_addr);

			cgaram_e : entity hdl4fpga.dpram
			port map (
				wr_clk  => cga_clk,
				wr_ena  => cga_ena,
				wr_addr => cga_addr,
				wr_data => cga_wdata,
				rd_addr => rd_addr,
				rd_data => rd_data);

			rddata_e : entity hdl4fpga.align
			generic map (
				n => cga_rdata'length,
				d => (cga_rdata'range => 1))
			port map (
				clk => video_clk,
				di  => rd_data,
				do  => cga_rdata);

		end block;

		vsync_e : entity hdl4fpga.align
		generic map (
			n   => font_row'length,
			d   => (font_row'range => 2))
		port map (
			clk => video_clk,
			di  => video_vcntr(4-1 downto 0),
			do  => font_row);

		hsync_e : entity hdl4fpga.align
		generic map (
			n   => font_col'length,
			d   => (font_col'range => 4))
		port map (
			clk => video_clk,
			di  => video_hcntr(font_col'range),
			do  => font_col);

		font_addr <= cga_rdata & font_row;

		cgarom_e : entity hdl4fpga.rom
		generic map (
			synchronous => 2,
			bitrom => psf1cp850x8x16)
		port map (
			clk  => video_clk,
			addr => font_addr,
			data => font_line);

		don_e : entity hdl4fpga.align
		generic map (
			n    => 1,
			d    => (1 to 1 => 4))
		port map (
			clk   => video_clk,
			di(0) => video_hon,
			do(0) => video_on);

		video_dot <= word2byte(font_line, font_col)(0) and video_on;

	end block;

end;
