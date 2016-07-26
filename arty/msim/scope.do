onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/rst
add wave -noupdate /testbench/arty_e/ddrphy_e/ddrbaphy_i/sys_mrst
add wave -noupdate /testbench/arty_e/scope_e/ddr_e/xdr_pgm_e/xdr_pgm_cal
add wave -noupdate /testbench/arty_e/scope_e/dataio_rst
add wave -noupdate /testbench/arty_e/scope_e/miirx_b/pktrx_rdy
add wave -noupdate -radix hexadecimal /testbench/arty_e/scope_e/miirx_b/cntr
add wave -noupdate /testbench/mii_txen
add wave -noupdate /testbench/arty_e/eth_tx_clk
add wave -noupdate /testbench/arty_e/eth_tx_en
add wave -noupdate -radix hexadecimal /testbench/arty_e/eth_txd
add wave -noupdate /testbench/arty_e/eth_rx_dv
add wave -noupdate -radix hexadecimal /testbench/arty_e/eth_rxd
add wave -noupdate /testbench/arty_e/scope_e/ddr2mii_req
add wave -noupdate /testbench/arty_e/scope_e/ddr2mii_rdy
add wave -noupdate /testbench/arty_e/scope_e/miitx_req
add wave -noupdate /testbench/arty_e/scope_e/miitx_rdy
add wave -noupdate /testbench/arty_e/scope_e/miidma_req
add wave -noupdate /testbench/arty_e/scope_e/miidma_rdy
add wave -noupdate /testbench/arty_e/scope_e/miidma_txen
add wave -noupdate -radix hexadecimal /testbench/arty_e/scope_e/miidma_txd
add wave -noupdate /testbench/arty_e/gclk100
add wave -noupdate /testbench/ddr_clk_p
add wave -noupdate /testbench/cke
add wave -noupdate /testbench/rst_n
add wave -noupdate /testbench/cs_n
add wave -noupdate /testbench/ras_n
add wave -noupdate /testbench/cas_n
add wave -noupdate /testbench/we_n
add wave -noupdate /testbench/arty_e/scope_e/ddr_e/xdr_pgm_e/line__230/t
add wave -noupdate /testbench/arty_e/scope_e/ddr_e/xdr_pgm_e/line__230/t(0)
add wave -noupdate /testbench/arty_e/scope_e/ddr_e/xdr_pgm_e/xdr_pgm_cmd
add wave -noupdate /testbench/arty_e/scope_e/ddr_e/xdr_pgm_e/xdr_pgm_start
add wave -noupdate /testbench/arty_e/scope_e/ddr_e/xdr_pgm_e/xdr_pgm_rdy
add wave -noupdate /testbench/arty_e/scope_e/ddr_e/xdr_pgm_e/xdr_pgm_req
add wave -noupdate /testbench/arty_e/scope_e/ddr_e/xdr_pgm_e/cal
add wave -noupdate -divider {New Divider}
add wave -noupdate /testbench/odt
add wave -noupdate -radix hexadecimal -childformat {{/testbench/ba(2) -radix hexadecimal} {/testbench/ba(1) -radix hexadecimal} {/testbench/ba(0) -radix hexadecimal}} -subitemconfig {/testbench/ba(2) {-height 16 -radix hexadecimal} /testbench/ba(1) {-height 16 -radix hexadecimal} /testbench/ba(0) {-height 16 -radix hexadecimal}} /testbench/ba
add wave -noupdate -radix hexadecimal /testbench/addr
add wave -noupdate -expand /testbench/dqs_p
add wave -noupdate -radix hexadecimal -childformat {{/testbench/dq(15) -radix hexadecimal} {/testbench/dq(14) -radix hexadecimal} {/testbench/dq(13) -radix hexadecimal} {/testbench/dq(12) -radix hexadecimal} {/testbench/dq(11) -radix hexadecimal} {/testbench/dq(10) -radix hexadecimal} {/testbench/dq(9) -radix hexadecimal} {/testbench/dq(8) -radix hexadecimal} {/testbench/dq(7) -radix hexadecimal} {/testbench/dq(6) -radix hexadecimal} {/testbench/dq(5) -radix hexadecimal} {/testbench/dq(4) -radix hexadecimal} {/testbench/dq(3) -radix hexadecimal} {/testbench/dq(2) -radix hexadecimal} {/testbench/dq(1) -radix hexadecimal} {/testbench/dq(0) -radix hexadecimal}} -subitemconfig {/testbench/dq(15) {-height 16 -radix hexadecimal} /testbench/dq(14) {-height 16 -radix hexadecimal} /testbench/dq(13) {-height 16 -radix hexadecimal} /testbench/dq(12) {-height 16 -radix hexadecimal} /testbench/dq(11) {-height 16 -radix hexadecimal} /testbench/dq(10) {-height 16 -radix hexadecimal} /testbench/dq(9) {-height 16 -radix hexadecimal} /testbench/dq(8) {-height 16 -radix hexadecimal} /testbench/dq(7) {-height 16 -radix hexadecimal} /testbench/dq(6) {-height 16 -radix hexadecimal} /testbench/dq(5) {-height 16 -radix hexadecimal} /testbench/dq(4) {-height 16 -radix hexadecimal} /testbench/dq(3) {-height 16 -radix hexadecimal} /testbench/dq(2) {-height 16 -radix hexadecimal} /testbench/dq(1) {-height 16 -radix hexadecimal} /testbench/dq(0) {-height 16 -radix hexadecimal}} /testbench/dq
add wave -noupdate /testbench/dqs_p(1)
add wave -noupdate /testbench/arty_e/ddrphy_e/byte_g(0)/ddrdqphy_i/adjdqs_req
add wave -noupdate /testbench/arty_e/ddrphy_e/byte_g(0)/ddrdqphy_i/adjdqs_rdy
add wave -noupdate /testbench/arty_e/ddrphy_e/byte_g(0)/ddrdqphy_i/adjdqi_req
add wave -noupdate /testbench/arty_e/ddrphy_e/byte_g(0)/ddrdqphy_i/adjdqi_rdy
add wave -noupdate /testbench/arty_e/ddrphy_e/byte_g(0)/ddrdqphy_i/adjsto_req
add wave -noupdate /testbench/arty_e/ddrphy_e/byte_g(0)/ddrdqphy_i/adjsto_rdy
add wave -noupdate /testbench/arty_e/ddrphy_e/byte_g(1)/ddrdqphy_i/iddr_g(6)/imdr_i/clk(0)
add wave -noupdate /testbench/arty_e/ddrphy_e/byte_g(1)/ddrdqphy_i/iddr_g(6)/imdr_i/clk(2)
add wave -noupdate /testbench/arty_e/ddrphy_e/byte_g(1)/ddrdqphy_i/iddr_g(6)/imdr_i/q
add wave -noupdate -divider {New Divider}
add wave -noupdate /testbench/arty_e/ddrphy_e/byte_g(1)/ddrdqphy_i/iddr_g(6)/imdr_i/clk(4)
add wave -noupdate -color {Orange Red} /testbench/arty_e/ddrphy_e/byte_g(1)/ddrdqphy_i/iddr_g(6)/imdr_i/d(0)
add wave -noupdate /testbench/arty_e/ddrphy_e/sys_clk90div
add wave -noupdate /testbench/arty_e/ddrphy_e/sys_clk90
add wave -noupdate /testbench/arty_e/ddrphy_e/byte_g(1)/ddrdqphy_i/dqsi
add wave -noupdate -divider {New Divider}
add wave -noupdate /testbench/arty_e/ddrphy_e/sys_sto(0)
add wave -noupdate -radix hexadecimal -childformat {{/testbench/arty_e/ddrphy_e/sys_dqo(63) -radix hexadecimal} {/testbench/arty_e/ddrphy_e/sys_dqo(62) -radix hexadecimal} {/testbench/arty_e/ddrphy_e/sys_dqo(61) -radix hexadecimal} {/testbench/arty_e/ddrphy_e/sys_dqo(60) -radix hexadecimal} {/testbench/arty_e/ddrphy_e/sys_dqo(59) -radix hexadecimal} {/testbench/arty_e/ddrphy_e/sys_dqo(58) -radix hexadecimal} {/testbench/arty_e/ddrphy_e/sys_dqo(57) -radix hexadecimal} {/testbench/arty_e/ddrphy_e/sys_dqo(56) -radix hexadecimal} {/testbench/arty_e/ddrphy_e/sys_dqo(55) -radix hexadecimal} {/testbench/arty_e/ddrphy_e/sys_dqo(54) -radix hexadecimal} {/testbench/arty_e/ddrphy_e/sys_dqo(53) -radix hexadecimal} {/testbench/arty_e/ddrphy_e/sys_dqo(52) -radix hexadecimal} {/testbench/arty_e/ddrphy_e/sys_dqo(51) -radix hexadecimal} {/testbench/arty_e/ddrphy_e/sys_dqo(50) -radix hexadecimal} {/testbench/arty_e/ddrphy_e/sys_dqo(49) -radix hexadecimal} {/testbench/arty_e/ddrphy_e/sys_dqo(48) -radix hexadecimal} {/testbench/arty_e/ddrphy_e/sys_dqo(47) -radix hexadecimal} {/testbench/arty_e/ddrphy_e/sys_dqo(46) -radix hexadecimal} {/testbench/arty_e/ddrphy_e/sys_dqo(45) -radix hexadecimal} {/testbench/arty_e/ddrphy_e/sys_dqo(44) -radix hexadecimal} {/testbench/arty_e/ddrphy_e/sys_dqo(43) -radix hexadecimal} {/testbench/arty_e/ddrphy_e/sys_dqo(42) -radix hexadecimal} {/testbench/arty_e/ddrphy_e/sys_dqo(41) -radix hexadecimal} {/testbench/arty_e/ddrphy_e/sys_dqo(40) -radix hexadecimal} {/testbench/arty_e/ddrphy_e/sys_dqo(39) -radix hexadecimal} {/testbench/arty_e/ddrphy_e/sys_dqo(38) -radix hexadecimal} {/testbench/arty_e/ddrphy_e/sys_dqo(37) -radix hexadecimal} {/testbench/arty_e/ddrphy_e/sys_dqo(36) -radix hexadecimal} {/testbench/arty_e/ddrphy_e/sys_dqo(35) -radix hexadecimal} {/testbench/arty_e/ddrphy_e/sys_dqo(34) -radix hexadecimal} {/testbench/arty_e/ddrphy_e/sys_dqo(33) -radix hexadecimal} {/testbench/arty_e/ddrphy_e/sys_dqo(32) -radix hexadecimal} {/testbench/arty_e/ddrphy_e/sys_dqo(31) -radix hexadecimal} {/testbench/arty_e/ddrphy_e/sys_dqo(30) -radix hexadecimal} {/testbench/arty_e/ddrphy_e/sys_dqo(29) -radix hexadecimal} {/testbench/arty_e/ddrphy_e/sys_dqo(28) -radix hexadecimal} {/testbench/arty_e/ddrphy_e/sys_dqo(27) -radix hexadecimal} {/testbench/arty_e/ddrphy_e/sys_dqo(26) -radix hexadecimal} {/testbench/arty_e/ddrphy_e/sys_dqo(25) -radix hexadecimal} {/testbench/arty_e/ddrphy_e/sys_dqo(24) -radix hexadecimal} {/testbench/arty_e/ddrphy_e/sys_dqo(23) -radix hexadecimal} {/testbench/arty_e/ddrphy_e/sys_dqo(22) -radix hexadecimal} {/testbench/arty_e/ddrphy_e/sys_dqo(21) -radix hexadecimal} {/testbench/arty_e/ddrphy_e/sys_dqo(20) -radix hexadecimal} {/testbench/arty_e/ddrphy_e/sys_dqo(19) -radix hexadecimal} {/testbench/arty_e/ddrphy_e/sys_dqo(18) -radix hexadecimal} {/testbench/arty_e/ddrphy_e/sys_dqo(17) -radix hexadecimal} {/testbench/arty_e/ddrphy_e/sys_dqo(16) -radix hexadecimal} {/testbench/arty_e/ddrphy_e/sys_dqo(15) -radix hexadecimal} {/testbench/arty_e/ddrphy_e/sys_dqo(14) -radix hexadecimal} {/testbench/arty_e/ddrphy_e/sys_dqo(13) -radix hexadecimal} {/testbench/arty_e/ddrphy_e/sys_dqo(12) -radix hexadecimal} {/testbench/arty_e/ddrphy_e/sys_dqo(11) -radix hexadecimal} {/testbench/arty_e/ddrphy_e/sys_dqo(10) -radix hexadecimal} {/testbench/arty_e/ddrphy_e/sys_dqo(9) -radix hexadecimal} {/testbench/arty_e/ddrphy_e/sys_dqo(8) -radix hexadecimal} {/testbench/arty_e/ddrphy_e/sys_dqo(7) -radix hexadecimal} {/testbench/arty_e/ddrphy_e/sys_dqo(6) -radix hexadecimal} {/testbench/arty_e/ddrphy_e/sys_dqo(5) -radix hexadecimal} {/testbench/arty_e/ddrphy_e/sys_dqo(4) -radix hexadecimal} {/testbench/arty_e/ddrphy_e/sys_dqo(3) -radix hexadecimal} {/testbench/arty_e/ddrphy_e/sys_dqo(2) -radix hexadecimal} {/testbench/arty_e/ddrphy_e/sys_dqo(1) -radix hexadecimal} {/testbench/arty_e/ddrphy_e/sys_dqo(0) -radix hexadecimal}} -subitemconfig {/testbench/arty_e/ddrphy_e/sys_dqo(63) {-height 15 -radix hexadecimal} /testbench/arty_e/ddrphy_e/sys_dqo(62) {-height 15 -radix hexadecimal} /testbench/arty_e/ddrphy_e/sys_dqo(61) {-height 15 -radix hexadecimal} /testbench/arty_e/ddrphy_e/sys_dqo(60) {-height 15 -radix hexadecimal} /testbench/arty_e/ddrphy_e/sys_dqo(59) {-height 15 -radix hexadecimal} /testbench/arty_e/ddrphy_e/sys_dqo(58) {-height 15 -radix hexadecimal} /testbench/arty_e/ddrphy_e/sys_dqo(57) {-height 15 -radix hexadecimal} /testbench/arty_e/ddrphy_e/sys_dqo(56) {-height 15 -radix hexadecimal} /testbench/arty_e/ddrphy_e/sys_dqo(55) {-height 15 -radix hexadecimal} /testbench/arty_e/ddrphy_e/sys_dqo(54) {-height 15 -radix hexadecimal} /testbench/arty_e/ddrphy_e/sys_dqo(53) {-height 15 -radix hexadecimal} /testbench/arty_e/ddrphy_e/sys_dqo(52) {-height 15 -radix hexadecimal} /testbench/arty_e/ddrphy_e/sys_dqo(51) {-height 15 -radix hexadecimal} /testbench/arty_e/ddrphy_e/sys_dqo(50) {-height 15 -radix hexadecimal} /testbench/arty_e/ddrphy_e/sys_dqo(49) {-height 15 -radix hexadecimal} /testbench/arty_e/ddrphy_e/sys_dqo(48) {-height 15 -radix hexadecimal} /testbench/arty_e/ddrphy_e/sys_dqo(47) {-height 15 -radix hexadecimal} /testbench/arty_e/ddrphy_e/sys_dqo(46) {-height 15 -radix hexadecimal} /testbench/arty_e/ddrphy_e/sys_dqo(45) {-height 15 -radix hexadecimal} /testbench/arty_e/ddrphy_e/sys_dqo(44) {-height 15 -radix hexadecimal} /testbench/arty_e/ddrphy_e/sys_dqo(43) {-height 15 -radix hexadecimal} /testbench/arty_e/ddrphy_e/sys_dqo(42) {-height 15 -radix hexadecimal} /testbench/arty_e/ddrphy_e/sys_dqo(41) {-height 15 -radix hexadecimal} /testbench/arty_e/ddrphy_e/sys_dqo(40) {-height 15 -radix hexadecimal} /testbench/arty_e/ddrphy_e/sys_dqo(39) {-height 15 -radix hexadecimal} /testbench/arty_e/ddrphy_e/sys_dqo(38) {-height 15 -radix hexadecimal} /testbench/arty_e/ddrphy_e/sys_dqo(37) {-height 15 -radix hexadecimal} /testbench/arty_e/ddrphy_e/sys_dqo(36) {-height 15 -radix hexadecimal} /testbench/arty_e/ddrphy_e/sys_dqo(35) {-height 15 -radix hexadecimal} /testbench/arty_e/ddrphy_e/sys_dqo(34) {-height 15 -radix hexadecimal} /testbench/arty_e/ddrphy_e/sys_dqo(33) {-height 15 -radix hexadecimal} /testbench/arty_e/ddrphy_e/sys_dqo(32) {-height 15 -radix hexadecimal} /testbench/arty_e/ddrphy_e/sys_dqo(31) {-height 15 -radix hexadecimal} /testbench/arty_e/ddrphy_e/sys_dqo(30) {-height 15 -radix hexadecimal} /testbench/arty_e/ddrphy_e/sys_dqo(29) {-height 15 -radix hexadecimal} /testbench/arty_e/ddrphy_e/sys_dqo(28) {-height 15 -radix hexadecimal} /testbench/arty_e/ddrphy_e/sys_dqo(27) {-height 15 -radix hexadecimal} /testbench/arty_e/ddrphy_e/sys_dqo(26) {-height 15 -radix hexadecimal} /testbench/arty_e/ddrphy_e/sys_dqo(25) {-height 15 -radix hexadecimal} /testbench/arty_e/ddrphy_e/sys_dqo(24) {-height 15 -radix hexadecimal} /testbench/arty_e/ddrphy_e/sys_dqo(23) {-height 15 -radix hexadecimal} /testbench/arty_e/ddrphy_e/sys_dqo(22) {-height 15 -radix hexadecimal} /testbench/arty_e/ddrphy_e/sys_dqo(21) {-height 15 -radix hexadecimal} /testbench/arty_e/ddrphy_e/sys_dqo(20) {-height 15 -radix hexadecimal} /testbench/arty_e/ddrphy_e/sys_dqo(19) {-height 15 -radix hexadecimal} /testbench/arty_e/ddrphy_e/sys_dqo(18) {-height 15 -radix hexadecimal} /testbench/arty_e/ddrphy_e/sys_dqo(17) {-height 15 -radix hexadecimal} /testbench/arty_e/ddrphy_e/sys_dqo(16) {-height 15 -radix hexadecimal} /testbench/arty_e/ddrphy_e/sys_dqo(15) {-height 15 -radix hexadecimal} /testbench/arty_e/ddrphy_e/sys_dqo(14) {-height 15 -radix hexadecimal} /testbench/arty_e/ddrphy_e/sys_dqo(13) {-height 15 -radix hexadecimal} /testbench/arty_e/ddrphy_e/sys_dqo(12) {-height 15 -radix hexadecimal} /testbench/arty_e/ddrphy_e/sys_dqo(11) {-height 15 -radix hexadecimal} /testbench/arty_e/ddrphy_e/sys_dqo(10) {-height 15 -radix hexadecimal} /testbench/arty_e/ddrphy_e/sys_dqo(9) {-height 15 -radix hexadecimal} /testbench/arty_e/ddrphy_e/sys_dqo(8) {-height 15 -radix hexadecimal} /testbench/arty_e/ddrphy_e/sys_dqo(7) {-height 15 -radix hexadecimal} /testbench/arty_e/ddrphy_e/sys_dqo(6) {-height 15 -radix hexadecimal} /testbench/arty_e/ddrphy_e/sys_dqo(5) {-height 15 -radix hexadecimal} /testbench/arty_e/ddrphy_e/sys_dqo(4) {-height 15 -radix hexadecimal} /testbench/arty_e/ddrphy_e/sys_dqo(3) {-height 15 -radix hexadecimal} /testbench/arty_e/ddrphy_e/sys_dqo(2) {-height 15 -radix hexadecimal} /testbench/arty_e/ddrphy_e/sys_dqo(1) {-height 15 -radix hexadecimal} /testbench/arty_e/ddrphy_e/sys_dqo(0) {-height 15 -radix hexadecimal}} /testbench/arty_e/ddrphy_e/sys_dqo
add wave -noupdate -radix hexadecimal /testbench/arty_e/ddrphy_e/byte_g(1)/ddrdqphy_i/sys_dqo
add wave -noupdate -radix hexadecimal -childformat {{/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(63) -radix hexadecimal} {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(62) -radix hexadecimal} {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(61) -radix hexadecimal} {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(60) -radix hexadecimal} {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(59) -radix hexadecimal} {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(58) -radix hexadecimal} {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(57) -radix hexadecimal} {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(56) -radix hexadecimal} {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(55) -radix hexadecimal} {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(54) -radix hexadecimal} {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(53) -radix hexadecimal} {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(52) -radix hexadecimal} {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(51) -radix hexadecimal} {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(50) -radix hexadecimal} {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(49) -radix hexadecimal} {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(48) -radix hexadecimal} {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(47) -radix hexadecimal} {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(46) -radix hexadecimal} {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(45) -radix hexadecimal} {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(44) -radix hexadecimal} {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(43) -radix hexadecimal} {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(42) -radix hexadecimal} {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(41) -radix hexadecimal} {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(40) -radix hexadecimal} {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(39) -radix hexadecimal} {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(38) -radix hexadecimal} {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(37) -radix hexadecimal} {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(36) -radix hexadecimal} {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(35) -radix hexadecimal} {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(34) -radix hexadecimal} {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(33) -radix hexadecimal} {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(32) -radix hexadecimal} {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(31) -radix hexadecimal} {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(30) -radix hexadecimal} {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(29) -radix hexadecimal} {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(28) -radix hexadecimal} {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(27) -radix hexadecimal} {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(26) -radix hexadecimal} {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(25) -radix hexadecimal} {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(24) -radix hexadecimal} {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(23) -radix hexadecimal} {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(22) -radix hexadecimal} {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(21) -radix hexadecimal} {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(20) -radix hexadecimal} {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(19) -radix hexadecimal} {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(18) -radix hexadecimal} {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(17) -radix hexadecimal} {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(16) -radix hexadecimal} {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(15) -radix hexadecimal} {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(14) -radix hexadecimal} {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(13) -radix hexadecimal} {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(12) -radix hexadecimal} {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(11) -radix hexadecimal} {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(10) -radix hexadecimal} {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(9) -radix hexadecimal} {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(8) -radix hexadecimal} {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(7) -radix hexadecimal} {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(6) -radix hexadecimal} {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(5) -radix hexadecimal} {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(4) -radix hexadecimal} {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(3) -radix hexadecimal} {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(2) -radix hexadecimal} {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(1) -radix hexadecimal} {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(0) -radix hexadecimal}} -subitemconfig {/testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(63) {-height 15 -radix hexadecimal} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(62) {-height 15 -radix hexadecimal} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(61) {-height 15 -radix hexadecimal} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(60) {-height 15 -radix hexadecimal} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(59) {-height 15 -radix hexadecimal} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(58) {-height 15 -radix hexadecimal} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(57) {-height 15 -radix hexadecimal} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(56) {-height 15 -radix hexadecimal} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(55) {-height 15 -radix hexadecimal} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(54) {-height 15 -radix hexadecimal} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(53) {-height 15 -radix hexadecimal} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(52) {-height 15 -radix hexadecimal} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(51) {-height 15 -radix hexadecimal} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(50) {-height 15 -radix hexadecimal} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(49) {-height 15 -radix hexadecimal} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(48) {-height 15 -radix hexadecimal} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(47) {-height 15 -radix hexadecimal} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(46) {-height 15 -radix hexadecimal} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(45) {-height 15 -radix hexadecimal} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(44) {-height 15 -radix hexadecimal} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(43) {-height 15 -radix hexadecimal} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(42) {-height 15 -radix hexadecimal} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(41) {-height 15 -radix hexadecimal} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(40) {-height 15 -radix hexadecimal} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(39) {-height 15 -radix hexadecimal} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(38) {-height 15 -radix hexadecimal} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(37) {-height 15 -radix hexadecimal} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(36) {-height 15 -radix hexadecimal} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(35) {-height 15 -radix hexadecimal} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(34) {-height 15 -radix hexadecimal} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(33) {-height 15 -radix hexadecimal} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(32) {-height 15 -radix hexadecimal} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(31) {-height 15 -radix hexadecimal} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(30) {-height 15 -radix hexadecimal} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(29) {-height 15 -radix hexadecimal} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(28) {-height 15 -radix hexadecimal} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(27) {-height 15 -radix hexadecimal} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(26) {-height 15 -radix hexadecimal} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(25) {-height 15 -radix hexadecimal} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(24) {-height 15 -radix hexadecimal} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(23) {-height 15 -radix hexadecimal} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(22) {-height 15 -radix hexadecimal} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(21) {-height 15 -radix hexadecimal} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(20) {-height 15 -radix hexadecimal} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(19) {-height 15 -radix hexadecimal} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(18) {-height 15 -radix hexadecimal} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(17) {-height 15 -radix hexadecimal} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(16) {-height 15 -radix hexadecimal} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(15) {-height 15 -radix hexadecimal} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(14) {-height 15 -radix hexadecimal} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(13) {-height 15 -radix hexadecimal} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(12) {-height 15 -radix hexadecimal} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(11) {-height 15 -radix hexadecimal} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(10) {-height 15 -radix hexadecimal} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(9) {-height 15 -radix hexadecimal} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(8) {-height 15 -radix hexadecimal} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(7) {-height 15 -radix hexadecimal} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(6) {-height 15 -radix hexadecimal} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(5) {-height 15 -radix hexadecimal} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(4) {-height 15 -radix hexadecimal} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(3) {-height 15 -radix hexadecimal} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(2) {-height 15 -radix hexadecimal} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(1) {-height 15 -radix hexadecimal} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi(0) {-height 15 -radix hexadecimal}} /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqi
add wave -noupdate /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_dqsi
add wave -noupdate /testbench/arty_e/ddrphy_e/byte_g(0)/ddrdqphy_i/dqso_b/sto
add wave -noupdate /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_win_dqs(7)
add wave -noupdate /testbench/arty_e/scope_e/ddr_e/rdfifo_i/xdr_win_dq(7)
add wave -noupdate /testbench/arty_e/scope_e/ddr_e/xdr_init_e/xdr_init_ras
add wave -noupdate /testbench/arty_e/scope_e/ddr_e/xdr_init_e/xdr_init_cas
add wave -noupdate /testbench/arty_e/scope_e/ddr_e/xdr_init_e/xdr_init_we
add wave -noupdate /testbench/arty_e/scope_e/ddr_e/xdr_init_e/xdr_init_clk
add wave -noupdate /testbench/arty_e/scope_e/ddr_e/xdr_init_e/xdr_init_pc
add wave -noupdate /testbench/arty_e/scope_e/ddr_e/xdr_init_e/xdr_init_req
add wave -noupdate /testbench/arty_e/scope_e/ddr_e/xdr_init_e/xdr_init_rdy
add wave -noupdate -divider {New Divider}
add wave -noupdate -radix hexadecimal /testbench/arty_e/ddrphy_e/byte_g(0)/ddrdqphy_i/smp
add wave -noupdate -radix hexadecimal /testbench/arty_e/ddrphy_e/byte_g(0)/ddrdqphy_i/dqso_b/adjsto_e/ddr_smp
add wave -noupdate /testbench/arty_e/ddrphy_e/byte_g(0)/ddrdqphy_i/dqso_b/adjsto_e/sel
add wave -noupdate -radix hexadecimal /testbench/arty_e/scope_e/dataio_e/ddrs_bnka
add wave -noupdate -radix hexadecimal /testbench/arty_e/scope_e/dataio_e/ddrs_rowa
add wave -noupdate -radix hexadecimal /testbench/arty_e/scope_e/dataio_e/ddrs_cola
add wave -noupdate /testbench/arty_e/ddrphy_e/byte_g(0)/ddrdqphy_i/dqso_b/adjsto_e/st
add wave -noupdate /testbench/arty_e/ddrphy_e/sys_iodclk
add wave -noupdate -divider {New Divider}
add wave -noupdate -radix hexadecimal /testbench/arty_e/ddrphy_e/byte_g(0)/ddrdqphy_i/dqso_b/dqsidelay_i/CNTVALUEOUT
add wave -noupdate /testbench/arty_e/ddrphy_e/byte_g(0)/ddrdqphy_i/smp(0)
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {19195000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 275
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits us
update
WaveRestoreZoom {19109335 ps} {19286523 ps}
