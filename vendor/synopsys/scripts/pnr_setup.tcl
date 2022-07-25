#source ./setup.tcl
set SCLIB $::env(SCLIB)
set SkyPlaceRoute "PlaceRoute/"

set WORK_DIR "/tmp/"
if { [info exists ::env(WORK_DIR) ] } {
    set WORK_DIR "PlaceRoute/"
}


# Customizable Parameters 
set VERILOG_NETLIST_FILES "${SkyPlaceRoute}/../sample_netlist/siso8.v"
set DESIGN_NAME           "siso8"

# Variable section
set SCLIB_DIMENSIONS [dict create  \
        sky130_fd_sc_hd {0.46 2.72} \
        sky130_fd_sc_hdll {0.46 2.72} \
        sky130_fd_sc_hs {0.48 3.33} \
        sky130_fd_sc_ls {0.48 3.33} \
        sky130_fd_sc_ms {0.48 3.33} \
]

set SC_HEIGHT           [lindex [dict get $SCLIB_DIMENSIONS [subst "${SCLIB}"]] 1];
set CPP                 [lindex [dict get $SCLIB_DIMENSIONS [subst "${SCLIB}"]] 0];

set POWER_PIN			"VDD" ; # Pin on standard celll
set GROUND_PIN			"VSS" ; # Pin on standard celll

set MIN_ROUTING_LAYER	"M2"   ; # Min routing layer
set MAX_ROUTING_LAYER	"M5"   ; # Max routing layer

# Common setup 
set LIBRARY_SUFFIX      "_block.dlib" ;
set DESIGN_LIBRARY      "${DESIGN_NAME}${LIBRARY_SUFFIX}" ;
set TECH_FILE           [list "${SkyPlaceRoute}/${SCLIB}/techfile/${SCLIB}_icc.tf"];
set REFERENCE_LIBRARY   [list "${SkyPlaceRoute}/${SCLIB}/ndm/${SCLIB}.ndm"];
set LINK_LIBRARY        [list "${SkyPlaceRoute}/${SCLIB}/db_nldm/${SCLIB}__tt_100C_1v80.db"];

set LAYERMAP_FILES      "${SkyPlaceRoute}/common/skywater130.mw2itf.map"
set TLUPlusFile         "${SkyPlaceRoute}/common/skywater130.nominal.tluplus"
# Setup 


# NOTE: The library will not appear on disk until you save
set cmd "create_lib ${WORK_DIR}/${DESIGN_LIBRARY} -tech ${TECH_FILE} -ref_libs ${REFERENCE_LIBRARY}"
puts "\[Info\] : Creating ICC2 library"
puts "\[Info\] : ${cmd}"
eval "$cmd"

read_parasitic_tech -name nominal \
    -layermap $LAYERMAP_FILES \
    -tlup $TLUPlusFile

# Read verilog netlist
read_verilog $VERILOG_NETLIST_FILES

# Set Corners, mode and scenarios


set_voltage -corner default 1.8 -object_list [get_supply_nets VDD]
set_voltage -corner default 0 -object_list [get_supply_nets VSS]
set_temperature -corner default 25

# nominal
set_parasitics_parameters -corners default \
        -library [get_attribute -name full_name -objects [current_lib]] \
        -early_spec nominal -early_temperature 25 \
        -late_spec nominal -late_temperature 25


create_clock -name CLK -period 100 [get_ports "clk"]

initialize_floorplan -side_length {20 20} 

create_placement -floorplan
place_pins -self

set_app_options -name place.coarse.continue_on_missing_scandef -value true
place_opt
route_opt

create_stdcell_filler -lib_cell "*fill*"
connect_pg_net

return