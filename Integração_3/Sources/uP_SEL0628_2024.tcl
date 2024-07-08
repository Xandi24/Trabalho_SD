
set pasta C:/Users/VITOR/Desktop/Eng_Comp/3_semestre/Sistemas_Digitais/Trabalho/Exs7/Entrega
set encoding Binary
set resource_sharing TRUE
set report_delay_detail short
set exclude_gates {}
load_library scl05u

set_working_dir $pasta
read -technology "scl05u" -dont_elaborate { ./mux21.v }
read -technology "scl05u" -dont_elaborate { ./mux41.v }
read -technology "scl05u" -dont_elaborate { ./decode24.v }
read -technology "scl05u" -dont_elaborate { ./adder.v }
read -technology "scl05u" -dont_elaborate { ./register.v }
read -technology "scl05u" -dont_elaborate { ./regbank.v }
read -technology "scl05u" -dont_elaborate { ./ALU.v }
read -technology "scl05u" -dont_elaborate { ./counter.v }
read -technology "scl05u" -dont_elaborate { ./fsm.v }
read -technology "scl05u" -dont_elaborate { ./uP_SEL0628_2024.v }


set x 8
#for {set x 2} {$x<=128} {set x [expr {$x * 2}]} {

elaborate uP_SEL0628_2024 -parameters Size=$x

optimize .work.uP_SEL0628_2024.INTERFACE -target scl05u -macro -area -effort quick -hierarchy auto 
optimize_timing .work.uP_SEL0628_2024.INTERFACE 

report_area area_$x.txt -cell_usage -all_leafs 
report_delay  delay_$x.txt -num_paths 1 -critical_paths -clock_frequency
auto_write -format Verilog -downto PRIMITIVES uP_SEL0628_2024_$x.v
#}
