#Altere a pasta abaixo para a pasta do seu projeto
set pasta C:/Users/VITOR/Desktop/Eng_Comp/3_semestre/Sistemas_Digitais/Trabalho/Exs4/Entrega
set encoding Binary
set resource_sharing TRUE
set report_delay_detail short
set report_area_format_style %6.2f
set exclude_gates {}
load_library scl05u

set_working_dir $pasta
read -technology "scl05u" -dont_elaborate { ./mux21.v }
read -technology "scl05u" -dont_elaborate { ./mux41.v }
read -technology "scl05u" -dont_elaborate { ./decode24.v }
read -technology "scl05u" -dont_elaborate { ./register.v }
read -technology "scl05u" -dont_elaborate { ./bregisters.v }

#set x 8
for {set x 2} {$x<=64} {set x [expr {$x * 2}]} {

elaborate bregisters -parameters Size=$x

optimize .work.bregisters.INTERFACE -target scl05u -macro -area -effort quick -hierarchy auto 
optimize_timing .work.bregisters.INTERFACE 

report_area area_$x.txt -cell_usage -all_leafs 
report_delay  delay_$x.txt -num_paths 1 -critical_paths -clock_frequency
auto_write -format Verilog -downto PRIMITIVES bregisters_$x.v
}