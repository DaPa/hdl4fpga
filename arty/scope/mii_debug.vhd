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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library hdl4fpga;
use hdl4fpga.std.all;
use hdl4fpga.cgafont.all;

library unisim;
use unisim.vcomponents.all;

architecture mii_debug of arty is
	signal sys_clk        : std_logic;
	signal mii_req        : std_logic;
	signal mii_rxd        : std_logic_vector
	signal eth_txclk_bufg : std_logic;
	signal eth_rxclk_bufg : std_logic;
	signal video_dot      : std_logic;
	signal video_vs       : std_logic;
	signal video_hs       : std_logic;
	signal video_clk      : std_logic;

begin

	clkin_ibufg : ibufg
	port map (
		I => gclk100,
		O => sys_clk);

	process (sys_clk)
		variable div : unsigned(0 to 1) := (others => '0');
	begin
		if rising_edge(sys_clk) then
			div := div + 1;
			eth_ref_clk <= div(0);
		end if;
	end process;

	eth_rx_clk_ibufg : ibufg
	port map (
		I => eth_rx_clk,
		O => eth_rxclk_bufg);

	eth_tx_clk_ibufg : ibufg
	port map (
		I => eth_tx_clk,
		O => eth_txclk_bufg);

	dcm_e : block
		signal video_clkfb : std_logic;
	begin
		video_dcm_i : mmcme2_base
		generic map (
			clkin1_period    => 10.0,
			clkfbout_mult_f  => 12.0,		-- 200 MHz
			clkout0_divide_f => 8.0,
			bandwidth        => "LOW")
		port map (
			pwrdwn   => '0',
			rst      => '0',
			clkin1   => sys_clk,
			clkfbin  => video_clkfb,
			clkfbout => video_clkfb,
			clkout0  => video_clk);
	end block;

	mii_debug_e : entity hdl4fpga.mii_debug
	port map (
		mii_req   => mii_req,
		mii_rxc   => eth_rxclk_bufg,
		mii_rxd   => mii_rxd, -- eth_rxd,
		mii_rxdv  => mii_rxdv, --eth_rx_dv,
		mii_txc   => eth_txclk_bufg,
		mii_txd   => eth_txd,
		mii_txdv  => eth_tx_en,

		video_clk => video_clk,
		video_dot => video_dot,
		video_hs  => video_hs,
		video_vs  => video_vs);
		
	process(eth_txclk_bufg)
	begin
		if rising_edge(eth_txclk_bufg) then
		end if;
	end process;

	process (btn(0), eth_txclk_bufg)
	begin
		if btn(0)='1' then
			mii_req <= '0';
			led(0)  <= '1';
		elsif rising_edge(eth_txclk_bufg) then
			led(0)  <= '0';
			mii_req <= '1';
		end if;
	end process;

	process (video_clk)
	begin
		if rising_edge(video_clk) then
			ja(1)  <= video_dot;
			ja(2)  <= video_dot;
			ja(3)  <= video_dot;
			ja(4)  <= video_hs;
			ja(10) <= video_vs;
		end if;
	end process;

	eth_rstn <= '1';
	eth_mdc  <= '0';
	eth_mdio <= '0';
end;
