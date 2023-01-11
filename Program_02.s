###########################################################
#	Michael Strand
#	2/27/21
###########################################################
#		Program Description
#	This program will use a static array of integers and 
#	two dynamic arrays. One of the dynamic arrays will read 
#	input to fill the array. Then the two full arrays will be
#	added together index by index. both arrays will be printed
#	to the console. The third array will hold the sums of the 
#	first twi arrays and will be printed backwards before the 
#	program ends.
###########################################################
#		Register Usage
#	$t0
#	$t1
#	$t2
#	$t3
#	$t4
#	$t5
#	$t6
#	$t7 array_input address
#	$t8	array_sum address
#	$t9 array length
###########################################################
		.data
print_static_array:		.asciiz		"Static Array: "
prompt:					.asciiz		"\nPlease enter a non-negative integer: "
print_dynamic_array:	.asciiz		"\nDynamic Array: "
print_backwards_array:	.asciiz		"\nBackwards Array: "

array_static:	.word	9, 18, 3, 8, 11, 6, 14, 1, 10, 4, 14
array_input:	.word	0
array_sum:		.word	0
###########################################################
		.text
main:
	
	la $t7, array_input				#array_input variable
	la $t8, array_sum				#array_sum variable
	li $t9, 11						#array length

	print_array_static:
		li $v0, 4					#print string
		la $a0, print_static_array	#prints "Static Array: "
		syscall

		la $a0, array_static		#loading address of static array
		move $a1, $t9				#move 11 into $a1

		jal print_array				#jump to print_array

	allocate_array:
		li $t2, 4			#$t2=4
		li $v0, 9			#array allocation
		mul $a0, $t9, $t2	#get array length
		syscall				#$v0 = new array 

		sw $v0, 0 ($t7)		#$t7 = dynamic array address
		
	prompt_user:
		la $a0, array_input			#load address of dynamic Array
		move $a1, $t9				#$a1=11
		
		jal read_array				#jumo to read_array

	print_array_dynamic:
		li $v0, 4					#print string
		la $a0, print_dynamic_array	#prints "Dynamic Array: "
		syscall

		la $a0, array_input			#$a0=array_input address
		lw $a0, 0 ($a0)				#load dynamic array address
		move $a1, $t9				#$a1=11

		jal print_array				#jump to print_array

	add_arrays:
		la $a0, array_static		#$a0=static array address
		la $a1, array_input			#$a1=dynamic array address
		move $a2, $t9				#$a2=11

		jal sum_arrays				#jump to sum_arrays
		
	print_array_backwards:
		li $v0, 4					#print string
		la $a0, print_backwards_array	
		syscall

		la $a0, array_sum			#$a0 = array_sum address
		lw $a0, 0 ($a0)				#load dynamic array address
		move $a1, $t9				#$a1=11

		jal print_backwards			#jump to print_backwards

	li $v0, 10		#End Program
	syscall
###########################################################
###########################################################
#		read_array
# 
#	This subprogram will take in the address of array_input
#	and get user input to fill the array. It will then return 
#	the address of the filled dynamic array.
#
###########################################################
#		Arguments In and Out of subprogram
#
#	$a0 array_input address
#	$a1 array length
#	$a2
#	$a3
#	$v0
#	$v1
#	$sp
#	$sp+4
#	$sp+8
#	$sp+12
###########################################################
#		Register Usage
#	$t0 array_input address
#	$t1 array length
#	$t2 
#	$t3
#	$t4
#	$t5
#	$t6
#	$t7
#	$t8
#	$t9
###########################################################
		.data
invalid_input:		.asciiz		"\nInvalid input must be non-negative integer."

###########################################################
		.text
read_array:
	lw $t0, 0 ($a0)		#move ddress into $t0
	move $t1, $a1		#$t1=11

input_loop:
	blez $t1, read_end	#while $t1>0 read input

	li $v0, 4			#print string
	la $a0, prompt		#user prompt
	syscall

	li $v0, 5			#read user input
	syscall

	bltz $v0, invalid	#branch if input is less than zero

	sw $v0, 0 ($t0)		#store user input in array

	addi $t0, 4			#increment array index
	addi $t1, -1		#decrement counter

	b input_loop
	
invalid:
	li $v0, 4
	la $a0, invalid_input
	syscall
	
	b input_loop

read_end:
	jr $ra	#return to calling location
###########################################################
###########################################################
#		print_array
#
#	This subprogram will take in the addresses of array_static 
#	and array_input and print their contents
#
###########################################################
#		Arguments In and Out of subprogram
#
#	$a0 array base address
#	$a1 array length
#	$a2
#	$a3
#	$v0
#	$v1
#	$sp
#	$sp+4
#	$sp+8
#	$sp+12
###########################################################
#		Register Usage
#	$t0 array base address
#	$t1 array length
#	$t2
#	$t3
#	$t4
#	$t5
#	$t6
#	$t7
#	$t8
#	$t9
###########################################################
		.data
print_space:	.asciiz		" "
###########################################################
		.text
print_array:
	move $t0, $a0			#moving address to $t0
	move $t1, $a1			#moving array size to $t1

print_loop:
	blez $t1, print_end		#while counter is >0 loop

	li $v0, 1				#print int system call
	lw $a0, 0 ($t0)			#get whats in array index
	syscall

	li $v0, 4				#print string
	la $a0, print_space		#print space in-between numbers
	syscall

	addi $t0, 4				#move to next index
	addi $t1, -1			#decrement counter

	b print_loop			#branch back to start of loop

print_end:
	jr $ra	#return to calling location
###########################################################

###########################################################
#		sum_arrays
#
#	This subprogram will take in array_static, array_input, 
#	and array_sum and add array_static's indexes with 
#	array_input's indexes and store the results in array_sum
#
###########################################################
#		Arguments In and Out of subprogram
#
#	$a0 static array address
#	$a1	dynamic array address
#	$a2 array length
#	$a3
#	$v0
#	$v1
#	$sp
#	$sp+4
#	$sp+8
#	$sp+12
###########################################################
#		Register Usage
#	$t0 static array addresses
#	$t1 dynamic array address
#	$t2 array length
#	$t3 static array index value
#	$t4	array_input index value
#	$t5 sum of indexes
#	$t6
#	$t7
#	$t8 sum_array
#	$t9
###########################################################
		.data

###########################################################
		.text
sum_arrays:

	move $t0, $a0		#$t0=static array address
	lw $t1, 0 ($a1)		#$t1=dynamic array address
	move $t2, $a2		#$t2=11

allocate_sum_array:
	li $t3, 4			#$t3=4
	li $v0, 9			#begin allocate_array
	mul $a0, $t2, $t3	#get array length
	syscall

	sw $v0, 0 ($t8)		#$t8= dynamic address

	lw $t8, 0 ($t8)

add_indexes:
	blez $t2, sum_end		#while $t2>0 loop

	lw $t3, 0 ($t0)			#$t3=$t0 index value
	lw $t4, 0 ($t1)			#$t1=dynamic index value

	add $t5, $t3, $t4		#$t5= sum of indexes 

	sw $t5, 0($t8)			#save sum in array_sum
	
	addi $t0, 4				#incrementing array indexes
	addi $t1, 4
	addi $t8, 4

	addi $t2, -1			#decrementing counter

	b add_indexes

sum_end:
	la $v0, array_sum

	jr $ra	#return to calling location
###########################################################

###########################################################
#		print_backwards

###########################################################
#		Arguments In and Out of subprogram
#
#	$a0 Array sum 
#	$a1	array length
#	$a2
#	$a3
#	$v0
#	$v1
#	$sp
#	$sp+4
#	$sp+8
#	$sp+12
###########################################################
#		Register Usage
#	$t0	Array sum
#	$t1 array length
#	$t2 byte length of array
#	$t3
#	$t4
#	$t5
#	$t6
#	$t7
#	$t8
#	$t9
###########################################################
		.data
space:		.asciiz		" "
###########################################################
		.text
print_backwards:
	move $t0, $a0			#$t0 = array address
	move $t1, $a1			#$t1 = 11
	
	li $t2, 4				#$t2 = 4
	mul $t2, $t2, $t1		#$t2 = array byte length
	addi $t2, -4

	add $t0, $t0, $t2		#start at end of Array

backwards_loop:
	blez $t1, backwards_end	#while #t1>0 loop

	li $v0, 1				#print int
	lw $a0, 0 ($t0)
	syscall

	li $v0, 4				#print string
	la $a0, space
	syscall

	addi $t0, -4			#decrement array index
	addi $t1, -1			#decrement counter

	b backwards_loop
		
backwards_end:
	jr $ra	#return to calling location
###########################################################

