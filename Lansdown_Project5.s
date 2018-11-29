.data

	.align 2
	records: .space 480 		#2 ints
	inputMessage: .asciiz "Enter in the name, age and ID for 10 students please: "
	name: .asciiz "Name: "
	age: .asciiz "Age: "
	idNumber: .asciiz "idNumber: "
	recordLine: .asciiz "Record "
	colon: .asciiz ": "


.text

#Main 
main:

	#Displays inputMessage
	li $v0, 4
	la $a0, inputMessage
	syscall

	li $v0, 4
	la $a0, newLine
	syscall


	addi $t0, $zero, 0

	#Call storeArray
	addiu $sp, $sp, -4
	sw $ra, 0($sp)
	jal storeArray
	lw $ra, 0($sp)
	addiu $sp, $sp, 4


	addi $t0, $zero, 0
	addi $t3, $zero, 1 #counter

	#Call printArr
	addiu $sp, $sp, -4
	sw $ra, 0($sp)
	jal printArr
	lw $ra, 0($sp)
	addiu $sp, $sp, 4
	


	#End of program
	li $v0, 10
	syscall



#STORE ARRAY - Subroutine
storeArray:

############Read Name string 40 bytes --- Needs to be done with loop to char array
		
	li $v0, 8
	syscall
	sw $v0, records($t0)
	addi $t0, $t0, 40


	






#######################################
	

	#Read Age int 4 bytes
	li $v0, 5
	syscall
	sw $v0, records($t0)
	addi $t0, $t0, 4


	#Read ID # int 4 bytes
	li $v0, 5
	syscall
	sw $v0, records($t0)
	addi $t0, $t0, 4

	blt $t0, 96, storeArray ###############change t0 480 for final
	addi $zero, $zero, 0

	jr $ra



printArr:

	li $v0, 4
	la $a0, recordLine
	syscall

	li $v0, 1
	move $a0, $t3   #test word
	syscall

	li $v0, 4
	la $a0, colon
	syscall


 ##########Print Name###################
	li $v0, 11
	lw $a0, records($t0)
	syscall
 	
 	#print space
	li $v0, 11
	la $a0, 32
	syscall

	addi $t0, $t0, 40










###########################################

	#Print age
	li $v0, 1
	lw $a0, records($t0)
	syscall

	addi $t0, $t0, 4

	li $v0, 11
	la $a0, 32  #print space char
	syscall


	#Print ID Number
	li $v0, 1
	lw $a0, records($t0)
	syscall

	addi $t0, $t0, 4

	#Print Newline
	li $v0, 11
	la $a0, 13
	syscall


	#Increment record counter
	addi $t3, $t3, 1


	blt $t0, 96, printArr     ###############change t0 480 for final
	jr $ra
	





