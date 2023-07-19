transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlib lab62_soc
vmap lab62_soc lab62_soc
vlog -vlog01compat -work lab62_soc +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis {C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/lab62_soc.v}
vlog -vlog01compat -work lab62_soc +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules {C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules/altera_reset_controller.v}
vlog -vlog01compat -work lab62_soc +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules {C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules/altera_reset_synchronizer.v}
vlog -vlog01compat -work lab62_soc +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules {C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules/lab62_soc_mm_interconnect_0.v}
vlog -vlog01compat -work lab62_soc +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules {C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules/lab62_soc_mm_interconnect_0_avalon_st_adapter_005.v}
vlog -vlog01compat -work lab62_soc +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules {C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules/lab62_soc_mm_interconnect_0_avalon_st_adapter.v}
vlog -vlog01compat -work lab62_soc +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules {C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules/altera_avalon_sc_fifo.v}
vlog -vlog01compat -work lab62_soc +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules {C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules/lab62_soc_usb_rst.v}
vlog -vlog01compat -work lab62_soc +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules {C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules/lab62_soc_timer_0.v}
vlog -vlog01compat -work lab62_soc +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules {C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules/lab62_soc_sysid_qsys_0.v}
vlog -vlog01compat -work lab62_soc +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules {C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules/lab62_soc_spi_0.v}
vlog -vlog01compat -work lab62_soc +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules {C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules/lab62_soc_sdram_pll.v}
vlog -vlog01compat -work lab62_soc +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules {C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules/lab62_soc_sdram.v}
vlog -vlog01compat -work lab62_soc +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules {C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules/lab62_soc_onchip_memory2_0.v}
vlog -vlog01compat -work lab62_soc +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules {C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules/lab62_soc_nios2_gen2_0.v}
vlog -vlog01compat -work lab62_soc +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules {C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules/lab62_soc_nios2_gen2_0_cpu.v}
vlog -vlog01compat -work lab62_soc +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules {C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules/lab62_soc_nios2_gen2_0_cpu_debug_slave_sysclk.v}
vlog -vlog01compat -work lab62_soc +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules {C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules/lab62_soc_nios2_gen2_0_cpu_debug_slave_tck.v}
vlog -vlog01compat -work lab62_soc +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules {C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules/lab62_soc_nios2_gen2_0_cpu_debug_slave_wrapper.v}
vlog -vlog01compat -work lab62_soc +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules {C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules/lab62_soc_nios2_gen2_0_cpu_test_bench.v}
vlog -vlog01compat -work lab62_soc +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules {C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules/lab62_soc_leds_pio.v}
vlog -vlog01compat -work lab62_soc +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules {C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules/lab62_soc_key.v}
vlog -vlog01compat -work lab62_soc +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules {C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules/lab62_soc_jtag_uart_0.v}
vlog -vlog01compat -work lab62_soc +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules {C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules/lab62_soc_hex_digits_pio.v}
vlog -vlog01compat -work lab62_soc +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules {C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules/lab62_soc_button.v}
vlog -sv -work work +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2 {C:/Personal_Stuff/School/ECE385/fp_pt2/mario_fsm.sv}
vlog -sv -work work +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2/collision_map {C:/Personal_Stuff/School/ECE385/fp_pt2/collision_map/collision_map_rom.sv}
vlog -sv -work work +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2/goomba_right {C:/Personal_Stuff/School/ECE385/fp_pt2/goomba_right/goomba_right_rom.sv}
vlog -sv -work work +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2/goomba_right {C:/Personal_Stuff/School/ECE385/fp_pt2/goomba_right/goomba_right_palette.sv}
vlog -sv -work work +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2/small_mario {C:/Personal_Stuff/School/ECE385/fp_pt2/small_mario/small_mario_rom.sv}
vlog -sv -work work +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2/small_mario {C:/Personal_Stuff/School/ECE385/fp_pt2/small_mario/small_mario_palette.sv}
vlog -sv -work work +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2/background_small {C:/Personal_Stuff/School/ECE385/fp_pt2/background_small/background_small_rom.sv}
vlog -sv -work work +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2/background_small {C:/Personal_Stuff/School/ECE385/fp_pt2/background_small/background_small_palette.sv}
vlog -sv -work work +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2/background_small {C:/Personal_Stuff/School/ECE385/fp_pt2/background_small/background_small_example.sv}
vlog -sv -work work +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2 {C:/Personal_Stuff/School/ECE385/fp_pt2/VGA_controller.sv}
vlog -sv -work work +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2 {C:/Personal_Stuff/School/ECE385/fp_pt2/HexDriver.sv}
vlog -sv -work work +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2 {C:/Personal_Stuff/School/ECE385/fp_pt2/goomba.sv}
vlog -sv -work work +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2 {C:/Personal_Stuff/School/ECE385/fp_pt2/mario.sv}
vlog -sv -work lab62_soc +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules {C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules/lab62_soc_irq_mapper.sv}
vlog -sv -work lab62_soc +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules {C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules/lab62_soc_mm_interconnect_0_avalon_st_adapter_005_error_adapter_0.sv}
vlog -sv -work lab62_soc +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules {C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules/lab62_soc_mm_interconnect_0_avalon_st_adapter_error_adapter_0.sv}
vlog -vlog01compat -work lab62_soc +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules {C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules/altera_avalon_st_handshake_clock_crosser.v}
vlog -vlog01compat -work lab62_soc +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules {C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules/altera_avalon_st_clock_crosser.v}
vlog -vlog01compat -work lab62_soc +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules {C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules/altera_std_synchronizer_nocut.v}
vlog -sv -work lab62_soc +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules {C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules/altera_merlin_width_adapter.sv}
vlog -sv -work lab62_soc +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules {C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules/altera_merlin_burst_uncompressor.sv}
vlog -sv -work lab62_soc +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules {C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules/lab62_soc_mm_interconnect_0_rsp_mux_001.sv}
vlog -sv -work lab62_soc +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules {C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules/altera_merlin_arbitrator.sv}
vlog -sv -work lab62_soc +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules {C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules/lab62_soc_mm_interconnect_0_rsp_mux.sv}
vlog -sv -work lab62_soc +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules {C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules/lab62_soc_mm_interconnect_0_rsp_demux_009.sv}
vlog -sv -work lab62_soc +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules {C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules/lab62_soc_mm_interconnect_0_rsp_demux.sv}
vlog -sv -work lab62_soc +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules {C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules/lab62_soc_mm_interconnect_0_cmd_mux_009.sv}
vlog -sv -work lab62_soc +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules {C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules/lab62_soc_mm_interconnect_0_cmd_mux.sv}
vlog -sv -work lab62_soc +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules {C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules/lab62_soc_mm_interconnect_0_cmd_demux_001.sv}
vlog -sv -work lab62_soc +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules {C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules/lab62_soc_mm_interconnect_0_cmd_demux.sv}
vlog -sv -work lab62_soc +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules {C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules/altera_merlin_burst_adapter.sv}
vlog -sv -work lab62_soc +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules {C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules/altera_merlin_burst_adapter_uncmpr.sv}
vlog -sv -work lab62_soc +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules {C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules/lab62_soc_mm_interconnect_0_router_011.sv}
vlog -sv -work lab62_soc +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules {C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules/lab62_soc_mm_interconnect_0_router_007.sv}
vlog -sv -work lab62_soc +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules {C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules/lab62_soc_mm_interconnect_0_router_002.sv}
vlog -sv -work lab62_soc +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules {C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules/lab62_soc_mm_interconnect_0_router_001.sv}
vlog -sv -work lab62_soc +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules {C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules/lab62_soc_mm_interconnect_0_router.sv}
vlog -sv -work lab62_soc +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules {C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules/altera_merlin_slave_agent.sv}
vlog -sv -work lab62_soc +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules {C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules/altera_merlin_master_agent.sv}
vlog -sv -work lab62_soc +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules {C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules/altera_merlin_slave_translator.sv}
vlog -sv -work lab62_soc +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules {C:/Personal_Stuff/School/ECE385/fp_pt2/lab62_soc/synthesis/submodules/altera_merlin_master_translator.sv}
vlog -sv -work work +incdir+C:/Personal_Stuff/School/ECE385/fp_pt2 {C:/Personal_Stuff/School/ECE385/fp_pt2/lab62.sv}

