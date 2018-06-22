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

entity mii_1chksum is
	generic (
		n : natural);
	port (
		mii_txc  : in  std_logic;
		mii_rena : in  std_logic := '1';
		mii_rxdv : in  std_logic;
		mii_rxd  : in  std_logic_vector;
		mii_txdv : out  std_logic;
		mii_txd  : out std_logic_vector);
end;

architecture beh of mii_1chksum is
	signal cksm : std_logic_vector(n-1 downto 0);
	signal slr  : std_logic_vector(0 to n/mii_txd'length-1);
	signal ci   : std_logic;
	signal op1  : std_logic_vector(mii_txd'range);
	signal op2  : std_logic_vector(mii_txd'range);
	signal sum  : std_logic_vector(mii_txd'range);
	signal co   : std_logic;
begin

	op1 <= cksm(mii_rxd'reverse_range);
	op2 <= reverse(mii_rxd) when mii_rxdv='1' else (others => '0');

	adder_p: process(op1, op2, ci)
		variable arg1 : unsigned(0 to mii_txd'length+1);
		variable arg2 : unsigned(0 to mii_txd'length+1);
		variable val  : unsigned(0 to mii_txd'length+1);
	begin
		arg1 := "0" & unsigned(op1) & ci;
		arg2 := "0" & unsigned(op2) & "1";
		val  := arg1 + arg2;
		sum  <= std_logic_vector(val(1 to mii_txd'length));
		co   <= val(val'left);
	end process;

	process (mii_txc)
		variable aux1 : unsigned(cksm'range);
		variable aux2 : unsigned(slr'range);
	begin
		if rising_edge(mii_txc) then
			aux1 := unsigned(cksm);
			aux2 := unsigned(slr);
			if mii_rena='1' then
				aux1(mii_rxd'reverse_range) := unsigned(sum);
				aux1 := aux1 rol mii_txd'length;
				aux2 := aux2 sll 1;
				ci   <= co;
				if mii_rxdv='1' then
					aux2(aux2'right) := '1';
				elsif aux2(0)='0' then
					ci   <= '0';
					aux1 := (others => '0');
				end if;
			end if;
			cksm <= std_logic_vector(aux1);
			slr  <= std_logic_vector(aux2);
		end if;
	end process;

	mii_txdv <= slr(0) and not mii_rxdv;
	mii_txd  <= cksm(mii_txd'reverse_range);
end;
