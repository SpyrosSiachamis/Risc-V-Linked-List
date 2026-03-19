.data
	input: .asciz "Enter inputs for the list (>0, enter <=0 to end program): "
	int_input: .asciz "\nInput an int to print all list data greater than N(if 0, all are printed, <0 end program): "
	.align 2
	space: .asciz " "
	.align 2
.text
main:
	# setup dummy node
	jal ra, node_alloc
	add s0, zero, a0 # Store starting address of list (head)
	add s1, zero, a0 # Store address as end of list
	jal ra, dummy # Fill dummy node
	
	# Input first data
	addi a7, zero, 4
	la a0,input
	ecall
	jal ra, read_int
	add s2, a0, zero # save inputed data
	addi t0, zero, 1 # if (i<0+1) from assignment 5
	# Check if first input is greater or equal than zero  
	blt s2, t0, end_program #  if input < 1 (input<=0)
loop:
	jal ra, node_alloc # allocate new memory
	# link new node to list
	sw a0 ,4(s1) # store address of new node to nxt of tail
	add s1,zero, a0 # update tail
	jal ra, create_node
	
	# take new input
	jal ra, read_int
	add s2, a0, zero # save inputed data4
	add t0, zero,zero
	# Check if first input is greater or equal than zero  
	blt t0, s2, loop
	#if not greater, end building list
list_search:
	addi a7, zero, 4
	la a0, int_input
	ecall
	jal ra, read_int
	add a1, zero, a0 # store inputed threshold to a1
	addi t1, a1, 1
	slt t1, zero, t1 # if 0 <= threshold = true, continue
	beq t1, zero, end_program
	add a0, zero, s0 # store address of head to a0
	jal ra, search_list # start searchin for threshholds
	j list_search
end_program:
	addi a7, zero, 10 
    	ecall
node_alloc:
	addi a7,x0, 9 #Sbrk
	addi a0,x0, 8 # Allocate 8 bytes for node
	ecall
	jr ra, 0 #return
dummy:
	sw zero, 0(a0) # Store 0 data in node
	sw zero, 4(a0) # Set next pointer as null
	jr ra, 0 #return
create_node:
	sw s2, 0(a0) # data = s2
	sw zero, 4(a0) # ntxPtr = 0
	jr ra, 0
read_int:
	addi a7, zero, 5
	ecall
	jr ra, 0
print_node:
	lw t0, 0(a0) #extract data
	slt t1, a1, t0 #threshhold < data
	beq t1, zero, exit
    	add t2, a0, zero # t2=address of node
    	
	addi a7, zero, 1 
	add a0, t0, zero
	ecall #print data
	addi a7, zero,4 
	la a0, space
	ecall
	add a0, t2, zero # restore address of node
exit:
	jr ra
search_list:
	addi sp,sp, -12 # allocate 16 bytes to stack
	sw ra, 8(sp) # store old ra
	sw s0, 4(sp) # store head of list to return to main
	sw s1, 0(sp) # store inputted int for thresh to return to main
	
	add s0, a0, zero # store head in s0
	add s1, a1, zero # store thresh to s1
	lw s0, 4(s0)# t0 = s0->next, skip dummy node
loop2:
	beq s0, zero, exit2 #if node == null return
	add a0, s0, zero # put address of first node in arg0
	add a1, s1, zero # put theshold to arg1
    	jal ra, print_node # check if data > thresh or if thresh <0 and print if valid

	lw s0, 4(s0) # move to next node
	j loop2
exit2:
	#restore valeus of main
	lw ra, 8(sp)
	lw s0, 4(sp)
	lw s1, 0(sp)
	addi sp,sp,12
	jr ra # return main