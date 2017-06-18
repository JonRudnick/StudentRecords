
	.data

MENU0:		.asciiz "\n0. Quit\n"
MENU1:		.asciiz "1. Display all ID and SSN pairs\n"
MENU2:		.asciiz "2. Enter a new student's ID and SSN\n"
MENU3:		.asciiz "3. Find SSN based on ID\n"
MENU4:		.asciiz "4. Find ID based on SSN\n"
MENU5:		.asciiz "5. Move current student to the start of the list\n"
MENU6:		.asciiz "6. Move current student to the end of the list\n"
PROMPT3:	.asciiz "Please enter the following to find the record. "
CHOOSE:		.asciiz "Enter your menu choice (0-6): "
SSNGET: 	.asciiz "Enter SSN: "
IDGET:		.asciiz "Enter ID: "
FOUNDSSN:	.asciiz "Record Found. Student's SSN: "
FOUNDID:	.asciiz "Record Found. Student's ID: "
NOTFOUND:	.asciiz "Record Not Found. Going back to main menu..."
COMMA:		.asciiz ", " 
P1:		.asciiz	"("
P2:		.asciiz ")\n" 
REPLY:		.asciiz	"The number is " 
ERROR:		.asciiz "ERROR - bad selection!\n"
ERROR1:		.asciiz "ERROR - No data in Arrays\n"
NOSELECT:	.asciiz	"ERROR - Student's Record not Selected\n"
ERRDUP:		.asciiz "ERROR - Duplicate Detected! Going back to main menu...\n"
CARRET: 	.asciiz "\n" 

SSN:		.word	0, 0, 0, 0, 0, 0, 0, 0, 0, 0 # an array containing one ten zeros
ID:		.word	0, 0, 0, 0, 0, 0, 0, 0, 0, 0

	.text

#s0 is points to position after last data entry. So, if data is at index 8, s0 = 12
#t0 is a check if user goes to option 5/6 when user skips option 3/4
	addi	$s0, $zero, 0		
	addi	$t0, $zero, -1		 
main:	jal	displayMenu
	jal	getChoice
	bne	$v0, $zero, skip1
	jal	quit
skip1:	addi	$v0, $v0, -1
	bne	$v0, $zero, skip2
	jal	option1
	j	main
skip2:	addi	$v0, $v0, -1
	bne	$v0, $zero, skip3
	jal	option2
	j	main
skip3:	addi	$v0, $v0, -1
	bne	$v0, $zero, skip4
	jal	option3
	j	main
skip4:	addi	$v0, $v0, -1
	bne	$v0, $zero, skip5
	jal	option4
	j	main	
skip5:	addi	$v0, $v0, -1
	bne	$v0, $zero, skip6
	jal	option5
	j	main
skip6:	addi	$v0, $v0, -1
	bne	$v0, $zero, skip7
	jal	option6
	j	main
skip7:	la	$a0, ERROR
	jal	dispStr
	j	main

displayMenu: 
# Display the menu (obviously!)
	addi	$sp, $sp, -4
	sw	$ra, ($sp)	# push return address 
	la	$a0, MENU0
	jal	dispStr
	la	$a0, MENU1
	jal	dispStr
	la	$a0, MENU2
	jal	dispStr
	la	$a0, MENU3
	jal	dispStr
	la	$a0, MENU4
	jal	dispStr
	la	$a0, MENU5
	jal	dispStr
	la	$a0, MENU6
	jal	dispStr
	lw	$ra, ($sp)	# pop return address 
	addi	$sp, $sp, 4
	jr	$ra 
	
getChoice: 
# Prompt user for a choice and get that choice from user 
# return: 
#   $v0 = user's choice 
	addi	$sp, $sp, -4
	sw	$ra, ($sp)	# push return address 
	la	$a0, CHOOSE
	jal	dispStr
	jal	getNum
	lw	$ra, ($sp)	# pop return address 
	addi	$sp, $sp, 4
	jr	$ra

option1:
# Displays the ID & SSN array
# t4 is used as increasing index; s0 = number of data in arrays
# first line checks if data has been input for ID/SSN array
	beq	$s0, $zero, error1
	addi	$sp, $sp, -8
	sw	$ra, ($sp)
	sw	$s0, 4($sp)
	addi	$t4, $zero, 0
loop1:
	addi	$s0, $s0, -4
	la	$a0, P1
	jal	dispStr
	lw	$a0, ID($t4)
	jal	dispNum
	la	$a0, COMMA
	jal	dispStr
	lw	$a0, SSN($t4)
	jal	dispNum
	la	$a0, P2
	jal	dispStr
	addi	$t4, $t4, 4
	bne	$s0, $zero, loop1
	lw	$s0, 4($sp)
	lw	$ra, ($sp)
	addi	$sp, $sp, 8
	jr	$ra
	
option2:
# Ask and store user input into ID/SSN array
# Checks if there is duplicate data
# s4 is temporary register to hold ID data while SSN data is checked for duplication
	addi	$sp, $sp, -4
	sw	$ra, ($sp)
	la	$a0, IDGET
	jal	dispStr
	jal	getNum
	jal	checkDuplicate
	beq	$t4, 0, quit2
	addi	$t4, $zero, 2
	addi	$s4, $v0, 0
	la	$a0, SSNGET
	jal	dispStr
	jal	getNum
	jal	checkDuplicate
	beq	$t4, 0, quit2
	addi	$t4, $zero, 2
	sw	$s4, ID($s0)
	sw	$v0, SSN($s0)
	addi	$s0, $s0, 4
quit2:	lw	$ra, ($sp)	# pop return address 
	addi	$sp, $sp, 4
	jr	$ra

option3:
# Asks for ID to find student's SSN
# Uses findRecord to find ID
	beq	$s0, $zero, error1
	addi	$sp, $sp, -4
	sw	$ra, ($sp)
	la	$a0, PROMPT3
	jal	dispStr
	la	$a0, IDGET
	jal	dispStr
	jal	getNum
	jal	findRecord
	lw	$ra, ($sp)	# pop return address 
	addi	$sp, $sp, 4
	jr	$ra

option4:
	beq	$s0, $zero, error1
	addi	$sp, $sp, -4
	sw	$ra, ($sp)
	la	$a0, PROMPT3
	jal	dispStr
	la	$a0, SSNGET
	jal	dispStr
	jal	getNum
	jal	findRecord
	lw	$ra, ($sp)	# pop return address 
	addi	$sp, $sp, 4
	jr	$ra

option5:
	beq	$t0, -1, errnoselect
	addi	$sp, $sp, -8
	sw	$ra, ($sp)
	sw	$t0, 4($sp)
	addi	$t4, $t0, -4
	addi	$t5, $t0, 0
loop5:	lw	$s4, ID($t4)
	lw	$s5, ID($t5)
	sw	$s4, ID($t5)
	sw	$s5, ID($t4)
	addi	$t4, $t4, -4
	addi	$t5, $t5, -4		
	bne	$t5, $zero, loop5
	addi	$t4, $t0, -4
	addi	$t5, $t0, 0
loop5a:	lw	$s4, SSN($t4)
	lw	$s5, SSN($t5)
	sw	$s4, SSN($t5)
	sw	$s5, SSN($t4)
	addi	$t4, $t4, -4
	addi	$t5, $t5, -4		
	bne	$t5, $zero, loop5a
	lw	$t0, 4($sp)
	lw	$ra, ($sp)
	addi	$sp, $sp, 8
	jr	$ra
	
option6:
	beq	$t0, -1, errnoselect
	addi	$sp, $sp, -8
	sw	$ra, ($sp)
	sw	$t0, 4($sp)
	addi	$t4, $t0, 0
	addi	$t5, $t0, 4
loop6:	lw	$s4, ID($t4)
	lw	$s5, ID($t5)
	sw	$s4, ID($t5)
	sw	$s5, ID($t4)
	addi	$t4, $t4, 4
	addi	$t5, $t5, 4		
	bne	$t5, $s0, loop6
	addi	$t4, $t0, 0
	addi	$t5, $t0, 4
loop6a:	lw	$s4, SSN($t4)
	lw	$s5, SSN($t5)
	sw	$s4, SSN($t5)
	sw	$s5, SSN($t4)
	addi	$t4, $t4, 4
	addi	$t5, $t5, 4		
	bne	$t5, $s0, loop6a
	lw	$t0, 4($sp)
	lw	$ra, ($sp)
	addi	$sp, $sp, 8
	jr	$ra

error1:
#Displays error message when there's no ID/SSN yet
	la 	$a0, ERROR1
	jal	dispStr
	lw	$s0, 4($sp)
	lw	$ra, ($sp)
	addi	$sp, $sp, 8
	jr	$ra
	
errnoselect:
# Displays error message when user hasn't selected a student
	addi	$sp, $sp, -4
	sw	$ra, ($sp)
	la	$a0, NOSELECT
	jal	dispStr
	lw	$ra, ($sp)
	addi	$sp, $sp, 4
	jr	$ra

checkDuplicate:
# Checks if user inputs same ID/SSN
# t4 is used to indicate if duplicate is deteced
		addi	$t4, $zero, 0
		addi	$sp, $sp, -4
		sw	$ra, ($sp)
		addi	$t4, $zero, -1
		jal	findRecord
		bne	$t4, $zero, quitCheck
		la	$a0, ERRDUP
		jal	dispStr
quitCheck:
		lw	$ra, ($sp)
		addi	$sp, $sp, 4
		jr	$ra

# start of Record Procedure																																					
findRecord:
# Detects if ID/SSN is in the arrays, Compare v0 with t1 to see if they match or not
# $t1 is used to compare ID/SSN; $t0 is used as index to the record you want to find; t4 is checkDuplicate indicator;
	addi	$sp, $sp, -8
	sw	$ra, ($sp)
	sw	$s0, 4($sp)
	addi	$t0, $zero, 0
loopR:	addi	$s0, $s0, -4
	blt	$s0, $zero, noRecord
	lw	$t1, ID($t0)
	beq	$v0, $t1, foundRecordID
skipID:	lw	$t1, SSN($t0)
	beq	$v0, $t1, foundRecordSSN			
	addi	$t0, $t0, 4
	j	loopR
						
foundRecordID:
# first line is for duplication check
# Displays record found message
	beq	$t4, -1, foundDupli
	la	$a0, FOUNDSSN
	jal	dispStr
	lw	$a0, SSN($t0)
	jal	dispNum
	j	exitRecord

foundRecordSSN:
# first line is for duplication check
# Displays record found message
	beq	$t4, -1, foundDupli
	la	$a0, FOUNDID
	jal	dispStr
	lw	$a0, ID($t0)
	jal	dispNum
	j	exitRecord
		
noRecord:
# first line is for duplication check
# Displays record not found message
	beq	$t4, -1, exitRecord	
	la	$a0, NOTFOUND
	jal	dispStr
	j	exitRecord

foundDupli:
# adds 1 to t4 so indicate there is duplication in record
	addi	$t4, $t4, 1
	j	exitRecord
	
exitRecord:
# exit from Record Procedure
	lw	$s0, 4($sp)
	lw	$ra, ($sp)	# pop return address 
	addi	$sp, $sp, 8
	jr	$ra
# end of Record Procredure
																				
# Display a string
# receive: 
#   $a0 = starting address of string 
# (leave registers unaffected) 
dispStr: 
	addi	$sp, $sp, -4
	sw	$v0, ($sp)
	addi	$v0, $zero, 4
	syscall
	lw	$v0, ($sp)
	addi	$sp, $sp, 4
	jr	$ra

# Display a number
# receive: 
#   $a0 = number to display
# (leave registers unaffected) 
dispNum: 
	addi	$sp, $sp, -4
	sw	$v0, ($sp)
	addi	$v0, $zero, 1
	syscall
	lw	$v0, ($sp)
	addi	$sp, $sp, 4
	jr	$ra

# Get a number from user
# return: 
#   $v0 = number from user  
# (leave other registers unaffected) 
getNum: 
	addi	$v0, $zero, 5
	syscall
	jr	$ra

# terminate program cleanly 
quit: 
	addi	$v0, $zero, 10
	syscall
