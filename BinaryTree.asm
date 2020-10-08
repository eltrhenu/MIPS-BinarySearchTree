.data
# -9999 marks end of the list
firstlist: .word 8, 3, 6, 10, 13, 7, 4, 5, -9999

# other examples for testing your code
secondlist: .word 8, 3, 6, 6, 10, 13, 7, 4, 5, -9999
thirdlist: .word 8, 3, 6, -9999, 10, 13, 7, 4, 5, -9999
fourthlist: .word 8, 3, -3, 6, -10, 13, -7, 4, 5, -9999

# assertEquals data
failf: .asciiz " failed\n"
passf: .asciiz " passed\n"
asertNumber: .word 0

.text
main:
    la $t0, firstlist 
#-----root creation----    
    lw $a0,0($t0)
    li $a1,0
    li $a2,0
    li $a3,0
    jal node_creation
#----------------------
    move $s0,$v0
    move $a1,$s0
    la $a0,firstlist
    # create root node here and load its address to $a1 and $s0
    jal build
#1
    lw $t0, 4($s0) # real address of the left child of the root
    lw $a0, 0($t0) # real value of the left child of the root
    li $a1, 3 # expected value of the left child of the root
    # if left child != 3 then print failed 
    jal assertEquals
#2
    li $a0, 11
    move $a1, $s0
    jal insert
    li $a0, 11
    lw $a1, 0($v0)#a1 is 11 however its print failed i canr understand why when i looked the assert equals

    # if returned address's value != 11 print failed 
    jal assertEquals
#3
    move $a0, $s0
    li $a1, 11
    jal find
    # if returned address's value != 11 print failed 
    lw $a0, 0($v1)
    jal assertEquals
#4
    move $a0, $s0
    li $a1, 44
    jal find
    # if returned value of $v0 != 0 print failed
    move $a0, $v0
    li $a1, 0
    jal assertEquals

    # this test only works with the first 3 lists. 
    # if 4th list is used change the value of $a1 to -10 from 3 before calling last assertEquals
    move $a0, $s0
    li $a1, 0
    jal findMinMax
    # if returned address's value != returned value fail
    lw $a0,0($v1)
    move $a1, $v0
    jal assertEquals
    # if returned address's value != expected value of min node
    lw $a0,0($v1)
    li $a1, 3
   jal assertEquals

    move $a0, $s0
    li $a1, 1
    # if returned address's value != returned value fail
    jal findMinMax
    lw $a0,0($v1)
    move $a1, $v0
    jal assertEquals
    # if returned address's value != expected value of max node
    lw $a0,0($v1)
    li $a1, 13
    jal assertEquals

    #move $a0, $s0
    #jal print

    li $v0, 10
    syscall

assertEquals:
    move $t2, $a0
    # increment count of total assertions.
    la $t0, asertNumber
    lw $t1, 0($t0)
    addi $t1, $t1, 1
    sw $t1, 0($t0) 
    add $a0, $t1, $zero
    li $v0, 1
    syscall

    # print passed or failed.
    beq $t2, $a1, passed
    la $a0, failf
    li $v0, 4
    syscall
    j $ra
passed:
    la $a0, passf
    li $v0, 4
    syscall
    j $ra
node_creation:
	addi $sp,$sp,-24
	sw $ra,20($sp)
	sw $s0,16($sp)
	sw $s1,12($sp)
	sw $s2,8($sp)
	sw $s3,4($sp)
	sw $s4,0($sp)
	move $s0, $a0 #node value
	move $s1, $a1 # node left = 0
	move $s2, $a2 #node right = 0
	move $s3, $a3 #node parent = 0
	li $a0, 16 # it needs 16 bytes for a new node. 
        li $v0, 9 # sbrk is syscall 9. 
 	syscall
	move $s4,$v0
	#put all node description
	sw $s0,0($s4)
	sw $s1,4($s4)
	sw $s2,8($s4)
	sw $s3,12($s4)
	move $v0, $s4 # put return value input into v0. 
 	# release the stack frame: 
	lw $s4,0($sp)
 	lw $s3, 4($sp)  
 	lw $s2, 8($sp)  
 	lw $s1, 12($sp) 
 	lw $s0, 16($sp)  
 	lw $ra, 20($sp)  
	
 	addi $sp, $sp, 24 # restore the Stack Poinputer. 
 	jr $ra # return. 
build:
	addi $sp,$sp,-8
	sw $ra,4($sp)
	sw $s0,0($sp)
	move $s0,$a1#root
	move $t1,$a0#list contains all values that needed to insert tree
	addi $t1,$t1,4#we create root with its first value
forin_array:
	
	lw $a0,0($t1)#take value from array
	li $t6,-9999
	beq $a0,$t6,exit_array#check if it is last member
	move $a1,$s0
	jal insert
	addi $t1,$t1,4
	j forin_array#do this until reach the last member
exit_array:
	 
 	lw $s0,0($sp)  
 	lw $ra, 4($sp)  
	
 	addu $sp, $sp, 8
	jr $ra		
insert:
	addi $sp,$sp,-20
	sw $ra,16($sp)
	sw $s0,12($sp)
	sw $s1,8($sp)
	sw $s2,4($sp)
	sw $s3,0($sp)
	move $s0,$a0#value
	move $s1,$a1#root
	#create node for new value
	#left, parent and right will be 0,	
	move $a0,$s0
	li $a1,0
	li $a2,0
	li $a3,0
	jal node_creation
	move $s2,$v0#store new node addess
		

loop:
	lw $s4,0($s1)
	#check if current node value is less or more than new node value
	blt $s0,$s4,left
	b right
left:
	#if left is empty insert_left or assign current node to this node
	lw $s5,4($s1)
	
	beq $s5,$zero,insert_left
	move $s1,$s5
	b loop
right:
	#if right is empty insert_right or assign current node to this right node
	lw $s5,8($s1)
	
	beq $s5,$zero,insert_right
	move $s1,$s5
	b loop
insert_left:
	sw $s2,4($s1)
	sw $s1,12($s2)
	b exit_loop
insert_right:
	sw $s2,8($s1)
	sw $s1,12($s2)
	
	b exit_loop
exit_loop:
	move $v0, $s2
	lw $s3, 0($sp)  
 	lw $s2, 4($sp)  
 	lw $s1, 8($sp) 
 	lw $s0, 12($sp)  
 	lw $ra, 16($sp)

	addu $sp, $sp, 20
	
	jr $ra
find:
	
	addi $sp,$sp,-20
	sw $ra,16($sp)
	sw $s0,12($sp)
	sw $s1,8($sp)
	sw $s2,4($sp)
	sw $s3,0($sp)
	move $s0,$a0#root
	move $s1,$a1#value
loop_find:

	lw $t0,0($s0)
	beq $t0,$s1,root
	blt $s1,$t0,child_left
	b child_right
root: 
	li $v0,0
	move $v1,$s0
	b return


child_left:
	lw $s2,4($s0)
	beq $s2,$zero,exit_tree
	lw $t1,0($s2)
	beq $s1,$t1,hallelujah
	move $s0,$s2
	b loop_find



child_right:
	lw $s2,8($s0)
	beq $s2,$zero,exit_tree
	lw $t1,0($s2)
	beq $s1,$t1,hallelujah
	move $s0,$s2
	b loop_find


hallelujah:
	li $v0,0
	move $v1,$s2
	b return

exit_tree:

	li $v0,0
	b return

return:
	lw $s3, 0($sp)  
 	lw $s2, 4($sp)  
 	lw $s1, 8($sp) 
 	lw $s0, 12($sp)  
 	lw $ra, 16($sp)

	addu $sp, $sp, 20
	jr $ra
findMinMax:
	addi $sp,$sp,-12
	
	sw $ra,8($sp)
	sw $s0,4($sp)
	sw $s1,0($sp)
	move $s0,$a0#root
	move $s1,$a1#value
	move $t5,$s0
	lw $t4,0($s0)
	beq $s1,$zero,min
	bne $s1,$zero,max
min: 	
	lw $t1,4($t5)
	beq $t1,$zero,eureka 
	move $t5,$t1
	b min
max: 
	lw $t1,8($t5)
	beq $t1,$zero,eureka
	move $t5,$t1
	b max
eureka:
	lw $v0,0($t5)
	move $v1,$t5
	sw $s1,0($sp)
	
	sw $s0,4($sp)
	sw $ra,8($sp)
	addi $sp,$sp,12
	jr $ra
	
	

    
