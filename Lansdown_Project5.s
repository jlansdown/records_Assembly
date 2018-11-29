.data

	.align 2
	records: .space 480 		#2 ints
	tempArr: .space 48
	inputMessage: .asciiz "Enter in the name, age and ID for 10 students please: "
	name: .asciiz "Name: "
	age: .asciiz "Age: "
	idNumber: .asciiz "idNumber: "
	recordLine: .asciiz "Record "
	colon: .asciiz ": "
	menu: .asciiz " \nMenu\n1) Swap two records.\n2) Exit\nPlease choose one of the above options: "
	prompt1: .asciiz "Which record do you select first? " 
	prompt2: .asciiz "Which record do you want to swap it with? "	


.text

#Main 
main:

	#Displays inputMessage
	li $v0, 4
	la $a0, inputMessage
	syscall

	#Newline
	li $v0, 11
	la $a0, 13
	syscall


	addi $t0, $zero, 0

	#Call storeArray
	addiu $sp, $sp, -4
	sw $ra, 0($sp)
	jal storeArray
	lw $ra, 0($sp)
	addiu $sp, $sp, 4

	#Initialize records array to 0
	addi $t0, $zero, 0

	#Conter for record number display
	addi $t3, $zero, 1 

	#Call printArr
	addiu $sp, $sp, -4
	sw $ra, 0($sp)
	jal printArr
	lw $ra, 0($sp)
	addiu $sp, $sp, 4

	displayMenu:
		
		li $v0, 4
 		la $a0, menu  #Print menu asciiz
 		syscall

		li $v0, 5
		syscall

		move $t0, $v0

		#Initialize values
		li $t1, 1
		li $t2, 2

		beq $t0, $t1, swap
		beq $t0, $t2, exit

		bne $t0, $zero, displayMenu


	exit:
	#End of program
	li $v0, 10
	syscall


#STORE ARRAY - Subroutine
storeArray:

############Read Name string 40 bytes --- Needs to be done with loop to char array
		
	li $v0, 8
	la $a0, tempArr
	li $a1, 40
	syscall

	li $a3, '\n'

	deleteNewLine:
		beqz $a1, exitNewLine
		subu $a1, $a1, 1
		lb $a2, tempArr($a1)
		bne $a2, $a3, deleteNewLine
		li $a3, 0
		sb $a3, tempArr($a1)
	exitNewLine:

		#initialize tempArr index to 0
		addi $t3, $zero, 0

		#Copy tempArr into records array
		readName:
			lb $t2, tempArr($t3)
			sb $t2, records($t0)
			addi $t3, $t3, 1
			addi $t0, $t0, 1
			beq $t2, $zero, exitReadName
			j readName		

		exitReadName:

	#Restores position of $t0 for records array
	subu $t0, $t0, $t3 

	#increment to next int
	addi $t0, $t0, 40		
	


#######################################
	

	#Read Age int 4 bytes
	li $v0, 5
	syscall
	sw $v0, records($t0)

	#increment to next int
	addi $t0, $t0, 4


	#Read ID # int 4 bytes
	li $v0, 5
	syscall
	sw $v0, records($t0)

	#increment to beginning of new struct
	addi $t0, $t0, 4

	blt $t0, 96, storeArray ###############change t0 480 for final

	jr $ra


#PRINT ARRAY - Subroutine
printArr:

	li $v0, 4
	la $a0, recordLine
	syscall

	li $v0, 1
	move $a0, $t3   #record count
	syscall

	li $v0, 4
	la $a0, colon
	syscall


 ##########Print Name###################
 	addi $t4, $zero, 0
	printName:
		
		li $v0, 11
		lb $a0, records($t0)
		beq $a0, $zero, exitPrintName
		syscall

		addi $t4, $t4, 1	#Counter for char array size to restore #t0 position
		addi $t0, $t0, 1
		j printName
 	

 	exitPrintName:

 	#Restores $t0 position for records
 	subu $t0, $t0, $t4

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

	#print space char
	li $v0, 11
	la $a0, 32  
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
	




swap:
	
	li $v0, 4
	la $a0, prompt1
	syscall

	#Store choice 1 in $t0
	li $v0, 5
	syscall
	move $t0, $v0

	li $v0, 4
	la $a0, prompt2
	syscall

	#Store choice 2 in $t1
	li $v0, 5
	syscall
	move $t1, $v0

	#New Line
	li $v0, 11
	la $a0, 13
	syscall

	addi $t0, $t0, -1
	addi $t1, $t1, -1

	li $t5,48
	mult $t0, $t5
	mflo $0

	mult $t1, $t5
	mflo $t1

	#SWAP HERE
	#$t0 first record $t1 second record
	addi $t2, $zero, 0


	#Store first into tempArr
	lb $t3, records($t0)
	sb $t3, tempArr($t2)

	#Store second into first
	lb $t3, records($t1)
	sb $t3, records($t0)

	#Store tempArr into Second
	lb $t3, tempArr($t2)
	sb $t3, records($t1)

	#first int
	addi $t0, $zero, 44
	addi $t1, $zero, 44
	addi $t2, $zero, 44

	lw $t3, records($t0)
	sw $t3, tempArr($t2)

	
	lw $t3, records($t1)
	sw $t3, records($t0)

	lw $t3, tempArr($t2)
	sw $t3, records($t1)






	#Initialize records array to 0
	addi $t0, $zero, 0

	#Conter for record number display
	addi $t3, $zero, 1 

	#Call printArr
	addiu $sp, $sp, -4
	sw $ra, 0($sp)
	jal printArr
	lw $ra, 0($sp)
	addiu $sp, $sp, 4
	
	j displayMenu

