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

entity dpram is
	generic (
		synchronous_rdaddr : boolean := false;
		synchronous_rddata : boolean := false;
		bitrom : std_logic_vector := (1 to 0 => '-'));
	port (
		rd_clk  : in  std_logic := '-';
		rd_addr : in  std_logic_vector;
		rd_data : out std_logic_vector;

		wr_clk  : in std_logic;
		wr_ena  : in std_logic := '1';
		wr_addr : in std_logic_vector;
		wr_data : in std_logic_vector);
end;

architecture def of dpram is
	subtype word is std_logic_vector(0 to wr_data'length-1);
	type word_vector is array (natural range <>) of word;

	function init_ram (
		constant bitrom : std_logic_vector;
		constant size   : natural)
		return   word_vector is
		alias bitrom0   : std_logic_vector(0 to bitrom'length-1) is bitrom;
		variable aux    : std_logic_vector(0 to size*word'length-1);
		variable retval : word_vector(0 to size-1);
	begin
		if bitrom'length > 0 then  -- "if" WORKAROUND suggested by emard @ github.com
			if aux'length >= bitrom'length then
				aux(0 to bitrom'length-1) := bitrom0;
			else
				aux := bitrom0(0 to aux'length-1);
			end if;

			for i in retval'range loop
				retval(i) := aux(i*retval(0)'length to (i+1)*retval(0)'length-1);
			end loop;
		end if;
		return retval;
	end;

	signal async_rdaddr : std_logic_vector(rd_addr'range);
	signal async_rddata : std_logic_vector(rd_data'range);
	signal ram : word_vector(0 to 2**wr_addr'length-1) := init_ram(bitrom, 2**wr_addr'length);

begin

	assert wr_addr'length=rd_addr'length
	report "Difference address size"
	severity failure;


	assert wr_data'length=rd_data'length
	report "Difference data size"
	severity failure;

	sync_rdaddr_g : if synchronous_rdaddr generate
		sync_p : process (rd_clk)
		begin
			if rising_edge(rd_clk) then
				async_rdaddr <= rd_addr;
			end if;
		end process;
	end generate;

	async_rdaddr_g : if not synchronous_rdaddr generate
		async_rdaddr <= rd_addr;
	end generate;

	process (async_rdaddr, ram)
		variable addr : std_logic_vector(0 to async_rdaddr'length-1);
	begin
		addr := async_rdaddr;
		async_rddata <= ram(to_integer(unsigned(async_rdaddr)));
	end process;
		
	rddata_p : process (async_rddata, rd_clk)
	begin
		if synchronous_rddata then
			if rising_edge(rd_clk) then
				rd_data <= async_rddata;
			end if;
		else
			rd_data <= async_rddata;
		end if;
	end process;

	wrdata_p : process (wr_clk)
	begin
		if rising_edge(wr_clk) then
			if wr_ena='1' then
				ram(to_integer(unsigned(wr_addr))) <= wr_data;
			end if;
		end if;
	end process;
end;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library hdl4fpga;
use hdl4fpga.std.all;

entity dpram1 is
	generic (
		synchronous_rdaddr : boolean := false;
		synchronous_rddata : boolean := false;
		bitrom : std_logic_vector := (1 to 0 => '-'));
	port (
		rd_clk  : in  std_logic := '-';
		rd_addr : in  std_logic_vector;
		rd_data : out std_logic_vector;

		wr_clk  : in std_logic;
		wr_ena  : in std_logic := '1';
		wr_addr : in std_logic_vector;
		wr_data : in std_logic_vector);
end;

architecture def of dpram1 is
	subtype word is std_logic_vector(0 to hdl4fpga.std.max(wr_data'length,rd_data'length)-1);
	type word_vector is array (natural range <>) of word;

	subtype byte is std_logic_vector(0 to hdl4fpga.std.min(wr_data'length,rd_data'length)-1);
	type byte_vector is array (natural range <>) of byte;

	function to_bytevector(
		constant data : std_logic_vector)
		return byte_vector is
		variable aux    : std_logic_vector(0 to ((data'length+byte'length-1)/byte'length)*byte'length-1);
		variable retval : byte_vector(0 to (data'length+byte'length-1)/byte'length-1);
	begin

		aux(0 to data'length-1) := data;
		for i in 0 to data'length/byte'length-1 loop
			retval(i) := aux(i*byte'length to (i+1)*byte'length-1);
		end loop;
		return retval;

	end;

	function to_stdlogicvector(
		constant data : byte_vector)
		return std_logic_vector is
		constant aux    : byte_vector(0 to data'length-1) := data;
		variable retval : std_logic_vector(0 to byte'length*data'length-1);
	begin

		for i in 0 to data'length/byte'length-1 loop
			retval(i*byte'length to (i+1)*byte'length-1) := aux(i);
		end loop;
		return retval;

	end;

	constant addr_size : natural := hdl4fpga.std.max(addra'length,addrb'length);

	shared variable ram : word_vector(0 to 2**addr_size-1);

begin

	process (wr_clk)
		variable addr : std_logic_vector(0 to addr_size);
		variable data : unsigned(0 to wr_data'length-1);
	begin
		if rising_edge(clka) then
			data := unsigned(wr_data);
			for i in 0 to wr_data'length/byte'length-1 loop 
				if wr_ena='1' then
					ram(to_integer(unsigned(wr_addr)))(*) := std_logic_vector(data(byte'range));
				end if;
				data := data rol byte'length;
			end if;
		end if;
	end process;

	process (rd_clk)
		variable addr : std_logic_vector(0 to addr_size);
		variable data : unsigned(0 to rd_data'length-1);
	begin
		if rising_edge(clkb) then
			addr := (others => '0');
			addr(0 to rd_addr'length) := rd_addr;
			for i in 0 to rd_data'length/byte'length-1 loop 
				if rd_data'length=word'length the
				else
					data(byte'range) <= ram(to_integer(unsigned(addr)));
				end if;
				data := data rol byte'length;
			end if;
			rd_data <= std_logic_vector(data);
		end if;
	end process;
end;
