--                                                                            --
-- Author(s):                                                                 --
--   Miguel Angel Sagreras                                                    --
--                                                                            --
-- Copyright (C) 2010-2013                                                    --
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

entity s3starter is
	port (
		s3s_anodes     : out std_ulogic_vector(3 downto 0) := (3 downto 0 => '1');
		s3s_segment_a  : out std_ulogic := '1';
		s3s_segment_b  : out std_ulogic := '1';
		s3s_segment_c  : out std_ulogic := '1';
		s3s_segment_d  : out std_ulogic := '1';
		s3s_segment_e  : out std_ulogic := '1';
		s3s_segment_f  : out std_ulogic := '1';
		s3s_segment_g  : out std_ulogic := '1';
		s3s_segment_dp : out std_ulogic := '1';

		switches : in  std_ulogic_vector(7 downto 0) := (7 downto 0 => '1');
		buttons  : in  std_ulogic_vector(3 downto 0) := (3 downto 0 => '1');
		leds     : out std_ulogic_vector(7 downto 0) := (7 downto 0 => '1');

		xtal  : in  std_logic := '1';

		rs232_rxd : in std_logic := '1';
		rs232_txd : out std_logic := '1');

	attribute loc : string;
	attribute iostandard : string;
	
	-------------------------------------------
	-- Xilinx/Digilent SPARTAN-3 Starter Kit --
	-------------------------------------------

	attribute loc of xtal : signal is "T9";
--	attribute iostandard of xtal  : signal is "LVTTL";

	attribute loc of leds : signal is "P11 P12 N12 P13 N14 L12 P14 K12";
--	attribute iostandard of leds : signal is "LVTTL";

	attribute loc of buttons : signal is "L14 L13 M14 M13";
	attribute loc of switches : signal is "K13 K14 J13 J14 H13 H14 G12 F12";

	attribute loc of s3s_anodes     : signal is "E13 F14 G14 D14";
	attribute loc of s3s_segment_a  : signal is "E14";
	attribute loc of s3s_segment_b  : signal is "G13";
	attribute loc of s3s_segment_c  : signal is "N15";
	attribute loc of s3s_segment_d  : signal is "P15";
	attribute loc of s3s_segment_e  : signal is "R16";
	attribute loc of s3s_segment_f  : signal is "F13";
	attribute loc of s3s_segment_g  : signal is "N16";
	attribute loc of s3s_segment_dp : signal is "P16";

--	attribute iostandard of s3s_anodes     : signal is "LVTTL";
--	attribute iostandard of s3s_segment_a  : signal is "LVTTL";
--	attribute iostandard of s3s_segment_b  : signal is "LVTTL";
--	attribute iostandard of s3s_segment_c  : signal is "LVTTL";
--	attribute iostandard of s3s_segment_d  : signal is "LVTTL";
--	attribute iostandard of s3s_segment_e  : signal is "LVTTL";
--	attribute iostandard of s3s_segment_f  : signal is "LVTTL";
--	attribute iostandard of s3s_segment_g  : signal is "LVTTL";
--	attribute iostandard of s3s_segment_dp : signal is "LVTTL";

	attribute loc of rs232_rxd : signal is "T13";
	attribute loc of rs232_txd : signal is "R13";
--	attribute iostandard of rs232_rxd : signal is "LVTTL";
--	attribute iostandard of rs232_txd : signal is "LVTTL";
end;