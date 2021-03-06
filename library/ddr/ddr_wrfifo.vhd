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

entity ddr_wrfifo is
	generic (
		DATA_PHASES : natural;
		DATA_GEAR   : natural;
		WORD_SIZE   : natural;
		BYTE_SIZE   : natural);
	port (
		fifo_bypass : in std_logic;

		ctlr_clk : in  std_logic;
		ctlr_req : in  std_logic;
		ctlr_ena : in  std_logic;
		ctlr_dmi : in  std_logic_vector(DATA_GEAR*WORD_SIZE/BYTE_SIZE-1 downto 0);
		ctlr_dqi : in  std_logic_vector(DATA_GEAR*WORD_SIZE-1 downto 0);

		ddr_clks : in  std_logic_vector(0 to DATA_PHASES*WORD_SIZE/BYTE_SIZE-1);
		ddr_enas : in  std_logic_vector(0 to DATA_PHASES*WORD_SIZE/BYTE_SIZE-1);
		ddr_dmo  : out std_logic_vector(DATA_GEAR*WORD_SIZE/BYTE_SIZE-1 downto 0);
		ddr_dqo  : out std_logic_vector(DATA_GEAR*WORD_SIZE-1 downto 0));

end;

library hdl4fpga;
use hdl4fpga.std.all;

use std.textio.all;

architecture struct of ddr_wrfifo is

	subtype byte is std_logic_vector(BYTE_SIZE downto 0);
	type byte_vector is array (natural range <>) of byte;

	impure function merge (
		constant arg1 : std_logic_vector;
		constant arg2 : std_logic_vector)
		return std_logic_vector is
		variable dat1 : unsigned(ddr_dqo'length-1 downto 0);
		variable dat2 : unsigned(ddr_dmo'length-1 downto 0);
		variable val  : unsigned(0 to arg1'length+arg2'length-1);
	begin
		dat1 := unsigned(arg1);
		dat2 := unsigned(arg2);
		for i in dat2'range loop
			val  := val  srl byte'length;
			val(0 to BYTE_SIZE) := dat2(0) & dat1(BYTE_SIZE-1 downto 0);
			dat1 := dat1 srl BYTE_SIZE;
			dat2 := dat2 srl 1;
		end loop;
		return std_logic_vector(val);
	end;

	impure function extract_dm (
		constant arg : std_logic_vector)
		return std_logic_vector is
		variable dat : unsigned(arg'length-1 downto 0);
		variable val : unsigned(0 to ddr_dmo'length-1);
	begin
		dat := unsigned(arg);
		for i in val'range loop
			val := val srl 1;
			val(0) := dat(BYTE_SIZE);
			dat := dat srl byte'length;
		end loop;
		return std_logic_vector(val);
	end;

	impure function extract_dq (
		constant arg : std_logic_vector)
		return std_logic_vector is
		variable dat : unsigned(arg'length-1 downto 0);
		variable val : unsigned(0 to ddr_dqo'length-1);
	begin
		dat := unsigned(arg);
		for i in ddr_dmo'range loop
			val := val srl BYTE_SIZE;
			val(0 to BYTE_SIZE-1) := dat(BYTE_SIZE-1 downto 0);
			dat := dat srl byte'length;
		end loop;
		return std_logic_vector(val);
	end;

	function to_bytevector (
		arg : std_logic_vector)
		return byte_vector is
		variable dat : unsigned(arg'length-1 downto 0);
		variable val  : byte_vector(arg'length/byte'length-1 downto 0);
	begin	
		dat := unsigned(arg);
		for i in val'reverse_range loop
			val(i) := std_logic_vector(dat(byte'range));
			dat := dat srl byte'length;
		end loop;
		return val;
	end;

	function to_stdlogicvector (
		arg : byte_vector)
		return std_logic_vector is
		variable dat : byte_vector(arg'length-1 downto 0);
		variable val : unsigned(arg'length*byte'length-1 downto 0);
	begin
		dat := arg;
		for i in dat'range loop
			val := val sll byte'length;
			val(byte'range) := unsigned(dat(i));
		end loop;
		return std_logic_vector(val);
	end;

	subtype word is std_logic_vector(byte'length*DATA_GEAR-1 downto 0);
	type word_vector is array (natural range <>) of word;

	subtype shuffleword is byte_vector(DATA_GEAR-1 downto 0);

	impure function unshuffle (
		arg : word_vector)
		return byte_vector is
		variable aux : byte_vector(word'length/byte'length-1 downto 0);
		variable val : byte_vector(ddr_dmo'range);
	begin
		for i in arg'range loop
			aux := to_bytevector(arg(i));
			for j in aux'range loop
				val(j*(WORD_SIZE/BYTE_SIZE)+i) := aux(j);
			end loop;
		end loop;
		return val;
	end;

	signal di : byte_vector(ctlr_dmi'range);
	signal do : byte_vector(ddr_dmo'range);
	signal dqo : word_vector((WORD_SIZE/BYTE_SIZE)-1 downto 0);
	signal fifo_di : word_vector((WORD_SIZE/BYTE_SIZE)-1 downto 0);

begin

	di <= to_bytevector(merge(ctlr_dqi, ctlr_dmi));
	ddr_fifo_g : for i in 0 to WORD_SIZE/BYTE_SIZE-1 generate
		signal ser_clk : std_logic_vector(ddr_clks'range);
		signal ser_ena : std_logic_vector(ddr_enas'range);

		signal dqi : shuffleword;

		function shuffle (
			arg1 : byte_vector;
			arg2 : natural)
			return shuffleword is
			variable val : shuffleword;
			variable aux : byte_vector(arg1'length-1 downto 0);
		begin
			aux := arg1;
			for i in val'range loop
				val(i) := aux((WORD_SIZE/BYTE_SIZE)*i+arg2);
			end loop;
			return val;
		end;

	begin
		dqi <= shuffle(di, i);
		ser_clk <= std_logic_vector(unsigned(ddr_clks) sll (i*DATA_PHASES));
		ser_ena <= std_logic_vector(unsigned(ddr_enas) sll (i*DATA_PHASES));

		fifo_di(i) <= to_stdlogicvector(dqi);
		outbyte_i : entity hdl4fpga.iofifo
		generic map (
			pll2ser => true,
			DATA_PHASES => DATA_PHASES,
			WORD_SIZE => word'length,
			BYTE_SIZE => byte'length)
		port map (
			pll_clk => ctlr_clk,
			pll_req => ctlr_req,
			pll_ena => ctlr_ena,
			ser_clk => ser_clk(0 to DATA_PHASES-1),
			ser_ena => ser_ena(0 to DATA_PHASES-1),
			di  => fifo_di(i),
			do  => dqo(i));

	end generate;

	do <= unshuffle(dqo) when fifo_bypass='0' else unshuffle(fifo_di);
	ddr_dqo <= extract_dq(to_stdlogicvector(do));
	ddr_dmo <= extract_dm(to_stdlogicvector(do));
end;
