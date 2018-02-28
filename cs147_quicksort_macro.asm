# Macro: get
# Usage: get($arr, $index, $reg)
.macro get($arr, $index, $reg)
sll		$t0, $index, 2		# relative index
add		$t0, $arr, $t0		# address
lw		$reg, ($t0)
.end_macro

# Macro: set
# Usage: set($arr, $index, $val)
.macro set($arr, $index, $val)
sll		$t1, $index, 2
add		$t1, $arr, $t1
sw		$val, ($t1)
.end_macro

# Macro: swap
# Usage: swap($arr, $from, $to)
.macro swap($arr, $from, $to)
get($arr, $from, $t2)
get($arr, $to, $t3)
set($arr, $from, $t3)
set($arr, $to, $t2)
.end_macro

# Macro : exit
# Usage: exit
.macro exit
li 		$v0, 10 
syscall
.end_macro
