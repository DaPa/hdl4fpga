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

architecture miitx_dhcp of arty is
	signal sys_clk        : std_logic;
	signal mii_req        : std_logic;
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

	eth_rx_clk_ibufg : ibufg
	port map (
		I => eth_rx_clk,
		O => eth_rxclk_bufg);

	video_dcm_e : entity hdl4fpga.dfs
	generic map (
		dcm_per => 10.0,
		dfs_div => 2,
		dfs_mul => 3)
	port map (
		dcm_rst => '0',
		dcm_clk => sys_clk,
		dfs_clk => video_clk,
		dcm_lck => open);

	mii_debug_e : entity hdl4fpga.mii_debug
	port map (
		mii_req   => mii_req,
		mii_rxc   => eth_rxclk_bufg,
		mii_rxd   => eth_rxd,
		mii_rxdv  => eth_rx_dv,
		mii_txc   => eth_txclk_bufg,
		mii_txd   => eth_txd,
		mii_txdv  => eth_tx_en,

		video_clk => video_clk,
		video_dot => video_dot,
		video_hs  => video_hs,
		video_vs  => video_vs);
		
	process (btn(0), eth_txclk_bufg)
	begin
		if btn(0)='1' then
			mii_req <= '0';
		elsif rising_edge(eth_txclk_bufg) then
			mii_req <= '1';
		end if;
	end process;

	eth_rstn <= '1';
	eth_mdc  <= '0';
	eth_mdio <= '0';
end;
