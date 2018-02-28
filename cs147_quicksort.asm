.include "./cs147_quicksort_macro.asm"
 # Quicksort using MIPS on an static array
.data 
array: .word 58, 4, 20, 17, 11, 16, 11, 8, 5, 4, 3, 1
size: .word 11

.text
# $a0 = array
# $a1 = low pointer
# $a2 = high pointer
main:
la		$a0, array
move		$zero, $a1
lw		$a3, size
subi		$a2, $a3, 1
jal 		sort
exit

################### Sort procedure ###################
# $a0 = array
# $a1 = low pointer
# $a2 = high pointer
# $s0 = partition
# $s1 = partition - 1
# $s2 = partition + 1
sort:
# Store Frame
addi		$sp, $sp, -36
sw		$fp, 36($sp)
sw		$ra, 32($sp)
sw		$a0, 28($sp)
sw		$a1, 24($sp)
sw		$a2, 20($sp)
sw		$s0, 16($sp)
sw		$s1, 12($sp)
sw		$s2, 8($sp)
addi		$fp, $sp, 48

sort_body:
bge		$a1, $a2, sort_end		# if $a1(low) >= $a2(high)
jal		partition			# $v0 = partition
subi		$s1, $v0, 1			# $s1 = partition - 1
addi		$s2, $v0, 1			# $s2 = partition + 1
move		$a2, $t4			# temp = high
move		$s1, $a2			# high = $s1 = partition - 1
jal		sort				
move 		$t4, $a2			# $a2 = $t4 = high
move		$s2, $a1			# $a1 = $s2 = low = partition + 1
jal		sort

# Restore Frame
sort_end:
lw		$fp, 36($sp)
lw		$ra, 32($sp)
lw		$a0, 28($sp)
lw		$a1, 24($sp)
lw		$a2, 20($sp)
lw		$s0, 16($sp)
lw		$s1, 12($sp)
lw		$s2, 8($sp)
addi		$sp, $sp, 36
jr 		$ra

################### Partition procedure ###################
# $a0 = array
# $a1 = low pointer
# $a2 = high pointer
# $s3 = pivot value
# $s4 = i
# $s5 = j
# $s6 = array[j]
partition:
#Store frame
addi		$sp, $sp, -40
sw		$fp, 40($sp)
sw		$ra, 36($sp)
sw		$a0, 32($sp)
sw		$a1, 28($sp)
sw		$a2, 24($sp)
sw		$s3, 20($sp)
sw		$s4, 16($sp)
sw		$s5, 12($sp)
sw		$s6, 8($sp)
addi		$fp, $sp, 40

get($a0, $a2, $s3)					# $s3 = [$a2] = pivot value
subi		$s4, $a1, 1				# i = $s4 = $a1 - 1 = low - 1
move		$a1, $s5				# j = $s5 = $a1 = low

partition_for_loop:
bge		$s5, $s3, partition_return		# while ($s5 = j) < ($s3 = pivot)
get($a0, $s5, $s6)					# $s6 = array[j]
bgt		$s6, $s3, partition_for_loop_end	# if ($s6 = array[j]) <= ($s3 = pivot)
addi		$s4, $s4, 1
swap($a0, $s4, $s5)					#swap(array, i, j)

partition_for_loop_end:
addi		$s5, $s5, 1				# j++ // loop increment
j		partition_for_loop

partition_return:
addi		$s4, $s4, 1				# i++
swap($a0, $s4, $a2)
move		$s4, $v0				# $v0 = return = $s4 = i
partition_end:
#restore frame
lw		$fp, 40($sp)
lw		$ra, 36($sp)
lw		$a0, 32($sp)
lw		$a1, 28($sp)
lw		$a2, 24($sp)
lw		$s3, 20($sp)
lw		$s4, 16($sp)
lw		$s5, 12($sp)
lw		$s6, 8($sp)
addi		$sp, $sp, 40
jr		$ra
