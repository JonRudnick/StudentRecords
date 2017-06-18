
	.data

MENU0:	.asciiz "\n0. Quit\n"
MENU1:	.asciiz "1. Display all ID and SSN pairs\n"
MENU2:	.asciiz "2. Enter a new student's ID and SSN\n"
MENU3:	.asciiz "3. Find SSN based on ID\n"
MENU4:	.asciiz "4. Find ID based on SSN\n"
MENU5:	.asciiz "5. Move current student to start of list\n"
MENU6:	.asciiz "6. Move current student to start of list\n"
PROMPT3:.asciiz "Please enter the following to find the record. "
CHOOSE:	.asciiz "Enter your menu choice (0-6): "
SSNGET: .asciiz "Enter SSN: "
IDGET:	.asciiz "Enter ID: "
FOUNDSSN:	.asciiz "Record Found. Student's SSN: "
FOUNDID:	.asciiz "Record Found. Student's ID: "
NOTFOUND:	.asciiz "Record Not Found. Going back to main menu..."
COMMA:	.asciiz ", " 
P1:	.asciiz	"("
P2:	.asciiz ")\n" 
REPLY:	.asciiz	"The number is " 
ERROR:	.asciiz "ERROR - bad selection!\n"
ERROR1:	.asciiz "ERROR - No data in Arrays\n"
CARRET: .asciiz "\n" 

SSN:	.word	0, 0, 0, 0, 0, 0, 0, 0, 0, 0 # an array containing one ten zeros
ID:	.word	0, 0, 0, 0, 0, 0, 0, 0, 0, 0

	.text

# First some code for testing purposes 

	addi	$s0, $zero, 0		#s0 is pointer to position of non-zero data in array
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
	beq	$s0, $zero, error1
	addi	$sp, $sp, -8
	sw	$ra, ($sp)
	sw	$s0, 4($sp)
	addi	$t0, $zero, 0
loop1:
	addi	$s0, $s0, -4
	la	$a0, P1
	jal	dispStr
	lw	$a0, ID($t0)
	jal	dispNum
	la	$a0, COMMA
	jal	dispStr
	lw	$a0, SSN($t0)
	jal	dispNum
	la	$a0, P2
	jal	dispStr
	addi	$t0, $t0, 4
	bne	$s0, $zero, loop1
	lw	$s0, 4($sp)
	lw	$ra, ($sp)
	addi	$sp, $sp, 8
	jr	$ra

option2:
	addi	$sp, $sp, -4
	sw	$ra, ($sp)
	la	$a0, IDGET
	jal	dispStr
	jal	getNum
	sw	$v0, ID($s0)
	la	$a0, SSNGET
	jal	dispStr
	jal	getNum
	sw	$v0, SSN($s0)
	addi	$s0, $s0, 4
	lw	$ra, ($sp)	# pop return address 
	addi	$sp, $sp, 4
	jr	$ra

option3:
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
	addi	$sp, $sp, -8
	sw	$ra, ($sp)
	sw	$t1, 4($sp)
	addi	$t4, $t1, -4
	addi	$t5, $t1, 0
loop5:	lw	$s4, ID($t4)
	lw	$s5, ID($t5)
	sw	$s4, ID($t5)
	sw	$s5, ID($t4)
	addi	$t4, $t4, -4
	addi	$t5, $t5, -4		
	bne	$t5, $zero, loop5
	addi	$t4, $t1, -4
	addi	$t5, $t1, 0
loop5a:	lw	$s4, SSN($t4)
	lw	$s5, SSN($t5)
	sw	$s4, SSN($t5)
	sw	$s5, SSN($t4)
	addi	$t4, $t4, -4
	addi	$t5, $t5, -4		
	bne	$t5, $zero, loop5a
	lw	$t1, 4($sp)
	lw	$ra, ($sp)
	jr	$ra
	
option6:
	addi	$sp, $sp, -8
	sw	$ra, ($sp)
	sw	$t1, 4($sp)
	addi	$t4, $t1, 0
	addi	$t5, $t1, 4
loop6:	lw	$s4, ID($t4)
	lw	$s5, ID($t5)
	sw	$s4, ID($t5)
	sw	$s5, ID($t4)
	addi	$t4, $t4, 4
	addi	$t5, $t5, 4		
	bne	$t5, $s0, loop6
	addi	$t4, $t1, 0
	addi	$t5, $t1, 4
loop6a:	lw	$s4, SSN($t4)
	lw	$s5, SSN($t5)
	sw	$s4, SSN($t5)
	sw	$s5, SSN($t4)
	addi	$t4, $t4, 4
	addi	$t5, $t5, 4		
	bne	$t5, $zero, loop6a
	lw	$t1, 4($sp)
	lw	$ra, ($sp)
	jr	$ra
										
findRecord:
# $t1 is used to compare
	addi	$sp, $sp, -8
	sw	$ra, ($sp)
	sw	$s0, 4($sp)
	addi	$t0, $zero, 0
loopR:	addi	$s0, $s0, -4
	blt	$s0, $zero, noRecord
	lw	$t1, ID($t0)
	beq	$v0, $t1, foundRecordID
	lw	$t1, SSN($t0)
	beq	$v0, $t1, foundRecordSSN			
	addi	$t0, $t0, 4
	j	loopR
						
foundRecordID:
	la	$a0, FOUNDSSN
	jal	dispStr
	lw	$a0, SSN($t0)
	jal	dispNum
	lw	$s0, 4($sp)
	lw	$ra, ($sp)	# pop return address 
	addi	$sp, $sp, 8
	jr	$ra

foundRecordSSN:
	la	$a0, FOUNDID
	jal	dispStr
	lw	$a0, ID($t0)
	jal	dispNum
	lw	$s0, 4($sp)
	lw	$ra, ($sp)	# pop return address 
	addi	$sp, $sp, 8
	jr	$ra
		
noRecord:	
	la	$a0, NOTFOUND
	jal	dispStr
	lw	$s0, 4($sp)
	lw	$ra, ($sp)	# pop return address 
	addi	$sp, $sp, 8
	jr	$ra

error1:
	la 	$a0, ERROR1
	jal	dispStr
	j	main				
						
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
