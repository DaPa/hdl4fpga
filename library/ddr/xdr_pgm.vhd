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

entity xdr_pgm is
	port (
		xdr_pgm_rst : in  std_logic := '0';
		xdr_pgm_clk : in  std_logic := '0';
		xdr_pgm_ref : in  std_logic := '0';
		xdr_pgm_rrdy : out  std_logic := '0';
		sys_pgm_ref : out std_logic := '0';
		xdr_pgm_start : in  std_logic := '1';
		xdr_pgm_rdy : out std_logic;
		xdr_pgm_req : in  std_logic := '1';
		xdr_pgm_rw  : in  std_logic := '1';
		xdr_pgm_cas : out std_logic := '0';
		xdr_pgm_cmd : out std_logic_vector(0 to 2));

end;

architecture registered of xdr_pgm is

	constant cacc : natural := 6;
	constant rrdy : natural := 5;
	constant ref  : natural := 4;
	constant rdy  : natural := 3;
	constant ras  : natural := 2;
	constant cas  : natural := 1;
	constant we   : natural := 0;

                        --> xdr_pgm_rdy <---------------------+
                        --> sys_pgm_ref <--------------------+|
                        --                                   ||
                        --                                   VV
	constant xdr_act  : std_logic_vector(6 downto 0)    := B"0000_011";
	constant xdr_actq : std_logic_vector(xdr_act'range) := B"0010_011";
	constant xdr_acty : std_logic_vector(xdr_act'range) := B"0100_011";
	constant xdr_rea  : std_logic_vector(xdr_act'range) := B"1000_101";
	constant xdr_reaq : std_logic_vector(xdr_act'range) := B"1010_101";
	constant xdr_wri  : std_logic_vector(xdr_act'range) := B"1000_100";
	constant xdr_wriq : std_logic_vector(xdr_act'range) := B"1010_100";
	constant xdr_pre  : std_logic_vector(xdr_act'range) := B"0000_010";
	constant xdr_preq : std_logic_vector(xdr_act'range) := B"0010_010";
	constant xdr_prey : std_logic_vector(xdr_act'range) := B"0100_010";
	constant xdr_aut  : std_logic_vector(xdr_act'range) := B"0000_001";
	constant xdr_autq : std_logic_vector(xdr_act'range) := B"0010_001";
	constant xdr_auty : std_logic_vector(xdr_act'range) := B"0111_001";
	constant xdr_nop  : std_logic_vector(xdr_act'range) := B"0001_111";
	constant xdr_nopy : std_logic_vector(xdr_act'range) := B"0101_111";
	constant xdr_dnt  : std_logic_vector(xdr_act'range) := (others => '-');

	constant ddrs_act : std_logic_vector(0 to 2) := "011";
	constant ddrs_rea : std_logic_vector(0 to 2) := "101";
	constant ddrs_wri : std_logic_vector(0 to 2) := "100";
	constant ddrs_pre : std_logic_vector(0 to 2) := "010";
	constant ddrs_aut : std_logic_vector(0 to 2) := "001";
	constant ddrs_dnt : std_logic_vector(0 to 2) := (others => '-');

	type trans_row is record
		state   : std_logic_vector(0 to 2);
		input   : std_logic_vector(0 to 2);
		state_n : std_logic_vector(0 to 2);
		cmd_n   : std_logic_vector(xdr_act'range);
	end record;

	type trans_tab is array (natural range <>) of trans_row;

	signal xdr_input  : std_logic_vector(0 to 2);

	signal xdr_pgm_pc : std_logic_vector(ddrs_act'range);

	signal pgm_cmd : std_logic_vector(xdr_pgm_cmd'range);
	signal pgm_rdy : std_logic;
	signal pgm_rrdy : std_logic;
	signal pgm_cas : std_logic;
	signal sys_ref : std_logic;

	constant ddrs_pact : std_logic_vector(0 to 2) := "110";
	constant ddrs_paut : std_logic_vector(0 to 2) := "111";
	constant ddrs_idl  : std_logic_vector(0 to 2) := "000";

-- pgm_ref   ------+
-- pgm_rw    -----+|
-- pgm_start ----+||
--               |||
--               vvv
--               000    001    010    011    100    101    110    111
--             +------+------+------+------+------+------+------+------+
--     act     | wri  | wriq | rea  | reaq | wri  | wriq | rea  | reaq |
--     pact    | wri  | wriq | rea  | reaq | wri  | wriq | rea  | reaq |
--     rea     | pre  | pre  | pre  | pre  | wri  | wri  | rea  | rea  |
--     wri     | pre  | pre  | pre  | pre  | wri  | wri  | rea  | rea  |
--     pre     | pre  | paut | pre  | paut | pact | paut | pact | paut |
--     idl     | pre  | paut | pre  | paut | pact | paut | pact | paut |
--     paut    | idl  | idl  | idl  | idl  | act  | act  | act  | act  |
--     aut     | idl  | idl  | idl  | idl  | act  | act  | act  | act  |
--             +------+------+------+------+------+------+------+------+

--                           --                 --
--                           -- OUTPUT COMMANDS --
--                           --                 --

--
--               000    001    010    011    100    101    110    111
--             +------+------+------+------+------+------+------+------+
--     act     | wri  | wriq | rea  | reaq | wri  | wriq | rea  | reaq |
--     pact    | nop  | autq | nop  | autq | act  | autq | act  | autq |
--     rea     | pre  | preq | pre  | preq | wri  | wriq | rea  | reaq |
--     wri     | pre  | preq | pre  | preq | wri  | wriq | rea  | reaq |
--     pre     | nop  | autq | nop  | autq | act  | autq | act  | autq |
--     idl     | nop  | autq | nop  | autq | act  | autq | act  | autq |
--     paut    | nopy | auty | nopy | auty | acty | auty | acty | auty |
--     aut     | nopy | auty | nopy | auty | acty | auty | acty | auty |
--             +------+------+------+------+------+------+------+------+

	constant pgm_tab : trans_tab(0 to 64-1) := (
		(ddrs_act, "000", ddrs_wri, xdr_wri),	---------
		(ddrs_act, "001", ddrs_wri, xdr_wriq),	-- ACT --
		(ddrs_act, "010", ddrs_rea, xdr_rea),	---------
		(ddrs_act, "011", ddrs_rea, xdr_reaq),
		(ddrs_act, "100", ddrs_wri, xdr_wri),
		(ddrs_act, "101", ddrs_wri, xdr_wriq),
		(ddrs_act, "110", ddrs_rea, xdr_rea),
		(ddrs_act, "111", ddrs_rea, xdr_reaq),
		
		(ddrs_pact, "000", ddrs_wri, xdr_wri),	---------
		(ddrs_pact, "001", ddrs_wri, xdr_wriq),	-- PACT --
		(ddrs_pact, "010", ddrs_rea, xdr_rea),	---------
		(ddrs_pact, "011", ddrs_rea, xdr_reaq),
		(ddrs_pact, "100", ddrs_wri, xdr_wri),
		(ddrs_pact, "101", ddrs_wri, xdr_wriq),
		(ddrs_pact, "110", ddrs_rea, xdr_rea),
		(ddrs_pact, "111", ddrs_rea, xdr_reaq),
		
		(ddrs_rea, "000", ddrs_pre, xdr_pre),	---------
		(ddrs_rea, "001", ddrs_pre, xdr_preq),	-- REA --
		(ddrs_rea, "010", ddrs_pre, xdr_pre),	---------
		(ddrs_rea, "011", ddrs_pre, xdr_preq),
		(ddrs_rea, "100", ddrs_wri, xdr_wri),
		(ddrs_rea, "101", ddrs_wri, xdr_wriq),
		(ddrs_rea, "110", ddrs_rea, xdr_rea),
		(ddrs_rea, "111", ddrs_rea, xdr_reaq),

		(ddrs_wri, "000", ddrs_pre, xdr_pre),	---------
		(ddrs_wri, "001", ddrs_pre, xdr_preq),	-- WRI --
		(ddrs_wri, "010", ddrs_pre, xdr_pre),	---------
		(ddrs_wri, "011", ddrs_pre, xdr_preq),
		(ddrs_wri, "100", ddrs_wri, xdr_wri),
		(ddrs_wri, "101", ddrs_wri, xdr_wriq),
		(ddrs_wri, "110", ddrs_rea, xdr_rea),
		(ddrs_wri, "111", ddrs_rea, xdr_reaq),

		(ddrs_pre, "000", ddrs_idl, xdr_nop),	---------
		(ddrs_pre, "001", ddrs_aut, xdr_autq),	-- PRE --
		(ddrs_pre, "010", ddrs_idl, xdr_nop),	---------
		(ddrs_pre, "011", ddrs_aut, xdr_autq),
		(ddrs_pre, "100", ddrs_act, xdr_act),
		(ddrs_pre, "101", ddrs_aut, xdr_autq),
		(ddrs_pre, "110", ddrs_act, xdr_act),
		(ddrs_pre, "111", ddrs_aut, xdr_autq),

		(ddrs_idl, "000", ddrs_idl,  xdr_nop),	---------
		(ddrs_idl, "001", ddrs_paut, xdr_autq),	-- IDL --
		(ddrs_idl, "010", ddrs_idl,  xdr_nop),	---------
		(ddrs_idl, "011", ddrs_paut, xdr_autq),
		(ddrs_idl, "100", ddrs_pact, xdr_act),
		(ddrs_idl, "101", ddrs_paut, xdr_autq),
		(ddrs_idl, "110", ddrs_pact, xdr_act),
		(ddrs_idl, "111", ddrs_paut, xdr_autq),

		(ddrs_paut, "000", ddrs_idl, xdr_nopy),	---------
		(ddrs_paut, "001", ddrs_idl, xdr_auty),	-- PAUT --
		(ddrs_paut, "010", ddrs_idl, xdr_nopy),	---------
		(ddrs_paut, "011", ddrs_idl, xdr_auty),
		(ddrs_paut, "100", ddrs_act, xdr_acty),
		(ddrs_paut, "101", ddrs_aut, xdr_auty),
		(ddrs_paut, "110", ddrs_act, xdr_acty),
		(ddrs_paut, "111", ddrs_aut, xdr_auty),

		(ddrs_aut, "000", ddrs_idl, xdr_nopy),	---------
		(ddrs_aut, "001", ddrs_idl, xdr_auty),	-- AUT --
		(ddrs_aut, "010", ddrs_idl, xdr_nopy),	---------
		(ddrs_aut, "011", ddrs_idl, xdr_auty),
		(ddrs_aut, "100", ddrs_act, xdr_acty),
		(ddrs_aut, "101", ddrs_aut, xdr_auty),
		(ddrs_aut, "110", ddrs_act, xdr_acty),
		(ddrs_aut, "111", ddrs_aut, xdr_auty)
	);
	signal ppp : std_logic;
	attribute fsm_encoding : string;
	attribute fsm_encoding of xdr_pgm_pc : signal is "compact";

begin

	xdr_input(2) <= xdr_pgm_ref;
	xdr_input(1) <= xdr_pgm_rw;
	xdr_input(0) <= xdr_pgm_start;

	process (xdr_pgm_clk)
		variable pc : std_logic_vector(xdr_pgm_pc'range);

		
	begin
		if rising_edge(xdr_pgm_clk) then
			if xdr_pgm_rst='0' then
				xdr_pgm_cmd  <= pgm_cmd;
				xdr_pgm_rdy  <= pgm_rdy;
				sys_pgm_ref  <= sys_ref;
				xdr_pgm_rrdy <= pgm_rrdy;
				if xdr_pgm_req='1' then
					xdr_pgm_pc <= pc; 
				end if;
				for i in pgm_tab'range loop
					if xdr_pgm_pc=pgm_tab(i).state then
						if xdr_input=pgm_tab(i).input then
							pc := pgm_tab(i).state_n; 
						end if;
					end if;
				end loop;
				ppp <= pgm_cas;
			else
				ppp <= '0';
				xdr_pgm_pc <= ddrs_pre; 
				pc := ddrs_pre;
				xdr_pgm_cmd <= "111";
				xdr_pgm_rdy <= '1';
				sys_pgm_ref <= '0';
				xdr_pgm_rrdy <= '0';
			end if;
		end if;
	end process;

	xdr_pgm_cas  <= ppp and xdr_pgm_req;
	process (xdr_input, xdr_pgm_pc)
	begin
		pgm_rdy <= '-'; 
		pgm_rrdy <= '-'; 
		sys_ref <= '-';
		pgm_cmd <= (others => '-');
		pgm_cas <= '-';
		for i in pgm_tab'range loop
			if xdr_pgm_pc=pgm_tab(i).state then
				if xdr_input=pgm_tab(i).input then
					pgm_cmd <= pgm_tab(i).cmd_n(ras downto we);
					pgm_rdy <= pgm_tab(i).cmd_n(rdy);
					sys_ref <= pgm_tab(i).cmd_n(ref);
					pgm_rrdy <= pgm_tab(i).cmd_n(rrdy);
					pgm_cas <= pgm_tab(i).cmd_n(cacc);
				end if;
			end if;
		end loop;
	end process;

end;

--architecture non_registered of xdr_pgm is
--
---- pgm_ref   ------+
---- pgm_rw    -----+|
---- pgm_start ----+||
----               |||
----               vvv
----               000   001   010   011   100   101   110   111
----             +-----+-----+-----+-----+-----+-----+-----+-----+
----     act     | wri | wri | rea | rea | wri | wri | rea | rea |
----     rea     | pre | pre | pre | pre | wri | wri | rea | rea |
----     wri     | pre | pre | pre | pre | wri | wri | rea | rea |
----     pre     | pre | aut | pre | aut | act | aut | act | aut |
----     aut     | pre | pre | pre | pre | act | act | act | act |
----             +-----+-----+-----+-----+-----+-----+-----+-----+
--
----                           --                 --
----                           -- OUTPUT COMMANDS --
----                           --                 --
--
----
----               000    001    010    011    100    101    110    111
----             +------+------+------+------+------+------+------+------+
----     act     | wri  | wriq | rea  | reaq | wri  | wriq | rea  | reaq |
----     rea     | pre  | preq | pre  | preq | wri  | wriq | rea  | reaq |
----     wri     | pre  | preq | pre  | preq | wri  | wriq | rea  | reaq |
----     pre     | nop  | autq | nop  | autq | act  | autq | act  | autq |
----     aut     | nopy | auty | nopy | auty | acty | auty | acty | auty |
----             +------+------+------+------+------+------+------+------+
--
--	constant pgm_tab : trans_tab := (
--		(ddrs_act, "000", ddrs_wri, xdr_wri),	---------
--		(ddrs_act, "001", ddrs_wri, xdr_wriq),	-- ACT --
--		(ddrs_act, "010", ddrs_rea, xdr_rea),	---------
--		(ddrs_act, "011", ddrs_rea, xdr_reaq),
--		(ddrs_act, "100", ddrs_wri, xdr_wri),
--		(ddrs_act, "101", ddrs_wri, xdr_wriq),
--		(ddrs_act, "110", ddrs_rea, xdr_rea),
--		(ddrs_act, "111", ddrs_rea, xdr_reaq),
--		
--		(ddrs_rea, "000", ddrs_pre, xdr_pre),	---------
--		(ddrs_rea, "001", ddrs_pre, xdr_preq),	-- REA --
--		(ddrs_rea, "010", ddrs_pre, xdr_pre),	---------
--		(ddrs_rea, "011", ddrs_pre, xdr_preq),
--		(ddrs_rea, "100", ddrs_wri, xdr_wri),
--		(ddrs_rea, "101", ddrs_wri, xdr_wriq),
--		(ddrs_rea, "110", ddrs_rea, xdr_rea),
--		(ddrs_rea, "111", ddrs_rea, xdr_reaq),
--
--		(ddrs_wri, "000", ddrs_pre, xdr_pre),	---------
--		(ddrs_wri, "001", ddrs_pre, xdr_preq),	-- WRI --
--		(ddrs_wri, "010", ddrs_pre, xdr_pre),	---------
--		(ddrs_wri, "011", ddrs_pre, xdr_preq),
--		(ddrs_wri, "100", ddrs_wri, xdr_wri),
--		(ddrs_wri, "101", ddrs_pre, xdr_wriq),
--		(ddrs_wri, "110", ddrs_rea, xdr_rea),
--		(ddrs_wri, "111", ddrs_rea, xdr_reaq),
--
--		(ddrs_pre, "000", ddrs_pre, xdr_nop),	---------
--		(ddrs_pre, "001", ddrs_aut, xdr_autq),	-- PRE --
--		(ddrs_pre, "010", ddrs_pre, xdr_nop),	---------
--		(ddrs_pre, "011", ddrs_aut, xdr_autq),
--		(ddrs_pre, "100", ddrs_act, xdr_act),
--		(ddrs_pre, "101", ddrs_aut, xdr_autq),
--		(ddrs_pre, "110", ddrs_act, xdr_act),
--		(ddrs_pre, "111", ddrs_aut, xdr_autq),
--
--		(ddrs_aut, "000", ddrs_pre, xdr_nopy),	---------
--		(ddrs_aut, "001", ddrs_aut, xdr_auty),	-- AUT --
--		(ddrs_aut, "010", ddrs_pre, xdr_nopy),	---------
--		(ddrs_aut, "011", ddrs_aut, xdr_auty),
--		(ddrs_aut, "100", ddrs_act, xdr_acty),
--		(ddrs_aut, "101", ddrs_aut, xdr_auty),
--		(ddrs_aut, "110", ddrs_act, xdr_acty),
--		(ddrs_aut, "111", ddrs_aut, xdr_auty));
--
--begin
--
--	xdr_input(2) <= xdr_pgm_ref;
--	xdr_input(1) <= xdr_pgm_rw;
--	xdr_input(0) <= xdr_pgm_start;
--
--	process (xdr_pgm_clk)
--	begin
--		if rising_edge(xdr_pgm_clk) then
--			if xdr_pgm_rst='0' then
--				if xdr_pgm_req='1' then
--					xdr_pgm_pc <= pc;
--				end if;
--			else
--				xdr_pgm_pc  <= ddrs_pre;
--			end if;
--		end if;
--	end process;
--
--	xdr_pgm_cas  <= pgm_cas and xdr_pgm_req;
--	xdr_pgm_cmd  <= pgm_cmd;
--	xdr_pgm_rdy  <= pgm_rdy;
--	sys_pgm_ref  <= sys_ref;
--	xdr_pgm_rrdy <= pgm_rrdy;
--
--	process (xdr_pgm_pc, xdr_input)
--	begin
--		pgm_rdy <= '-'; 
--		pgm_rrdy <= '-'; 
--		sys_ref <= '-';
--		pgm_cmd <= (others => '-');
--		pc  <= (others => '-');
--		pgm_cas <= '-';
--		loop_pgm : for i in pgm_tab'range loop
--			if xdr_pgm_pc=pgm_tab(i).state then
--				if xdr_input=pgm_tab(i).input then
--					pc <= pgm_tab(i).state_n; 
--					pgm_cmd <= pgm_tab(i).cmd_n(ras downto we);
--					pgm_rdy <= pgm_tab(i).cmd_n(rdy);
--					sys_ref <= pgm_tab(i).cmd_n(ref);
--					pgm_rrdy <= pgm_tab(i).cmd_n(rrdy);
--					pgm_cas <= pgm_tab(i).cmd_n(cacc);
--					exit loop_pgm;
--				end if;
--			end if;
--		end loop;
--	end process;
--
--end;
