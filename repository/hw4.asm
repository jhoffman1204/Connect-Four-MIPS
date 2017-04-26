##############################################################
# Homework #4
# name: James Hoffman
# sbuid: 110229072
##############################################################

##############################################################
# DO NOT DECLARE A .DATA SECTION IN YOUR HW. IT IS NOT NEEDED
##############################################################

.text

##############################
# Part I FUNCTIONS
##############################

set_slot:
#  int set_slot(slot[][] board, int num_rows, int num_cols, int row, int col, char c, int turn_num)

	#li $t1, 0
	#li $t2, 0
	#li $t3, 0
	#li $t4, 0
	#li $t5, 0
	#li $t6, 0
	#li $t7, 0
	#li $t8, 0
	#li $t9, 0

	# t0 = board
	# t1 = num_rows
	# t2 = num_cols
	# t4 = row
	# t5 = column
	# t3 = character to be placed
	# t6 = turn number
	
	move $t0, $a0	# load the board into t0
	move $t1, $a1	# load the number of rows into t1
	move $t2, $a2	# lods the number of columns into t2
	move $t4, $a3	# load the row to be placed in t4
	
	lw $t5, 0($sp)	# loads the column
	lw $t3, 4($sp)	# lods the character into t5
	lw $t6, 8($sp)	# loads the turn into t6
	
	blt $t1, 0, set_slot_error
	blt $t2, 0, set_slot_error
	blt $t4, 0, set_slot_error
	bgt $t4, 255, set_slot_error
	blt $t5, 0, set_slot_error
	bgt $t5, 255, set_slot_error
	bgt $t6, 255, set_slot_error
	
	#addi $t0, $t0, -9
		
	# Formula to Calculate where to place the character
	# addr = base_addr + i * num_columns * elem_size_in_bytes + j * elem_size_in_bytes
	# addr = base_addr + elem_size_in_bytes * (i * num_columns + j)
	
	# where i is the row number and j is the column number
	# using t7 as an intermediate register for calculations 
	mul $t7, $t4, $t2 # i * num_columns	(in this case i is the row)
	add $t7, $t7, $t5 # i * num_columns + j (in this case j is the column)
	sll $t7, $t7, 1   # 2*(i * num_columns + j)  Mult by 2 b/c we have an array of half words
	add $t7, $t7, $t0 # base_addr + 2*(i * num_columns + j)
	#t7 is now the address of where we are saving to 
	sb $t3, 0($t7)
	addi $t7, $t7, 1
	addi $t6, $t6, 48
	sb $t6, 0($t7)
	
	# iterate the turn number by 1
	addi $t6, $t6, 1
		
	li $v0, 0
    j finish_set_slot
    set_slot_error:
	li $v0, -1
	j finish_set_slot
		
    finish_set_slot:
    
    jr $ra

get_slot:

	#li $t1, 0
	#li $t2, 0
	#li $t3, 0
	#li $t4, 0
	#li $t5, 0
	#li $t6, 0
	#li $t7, 0
	#li $t8, 0
	#li $t9, 0

	# (char piece, int turn) get_slot(slot[][] board, int num_rows, int num_cols, int row, int col)
	
	blt $t1, 0, get_slot_error
	blt $t2, 0, get_slot_error
	blt $t4, 0, get_slot_error
	bgt $t4, 255, get_slot_error
	blt $t5, 0, get_slot_error
	bgt $t5, 255, get_slot_error

    	move $t0, $a0	# load the board into t0
	move $t1, $a1	# load the number of rows into t1
	move $t2, $a2	# lods the number of columns into t2
	move $t4, $a3	# loads the row into t4
	lw $t5, 0($sp)	# lods the column into t5
	li $t7, 0
	
	#algorithm to retrieve the correct memory address
	mul $t7, $t4, $t2 # i * num_columns	(in this case i is the row)
	add $t7, $t7, $t5 # i * num_columns + j (in this case j is the column)
	sll $t7, $t7, 1   # 4*(i * num_columns + j)  Mult by 4 b/c we have an array of 4-byte words
	add $t7, $t7, $t0 # base_addr + 4*(i * num_columns + j), t7 now has the memory address that we need
	
	lb $t3 0($t7) # retrieving the ascii character
	addi $t7, $t7, 1
	lb $t4 0($t7) # retrieving the turn character

    
    move $v0, $t3
    move $v1, $t4
    ##########################################
    
    li $v0, 0
    j finish_get_slot
    get_slot_error:
        li $v0, -1
	j finish_get_slot
		
    finish_get_slot:
    
    jr $ra

clear_board:

	#li $t1, 0
	#li $t2, 0
	#li $t3, 0
	#li $t4, 0
	#li $t5, 0
	#li $t6, 0
	#li $t7, 0
	#li $t8, 0
	#li $t9, 0

    # int clear_board(slot[][] board, int num_rows, int num_cols)
	
    move $t0, $a0	# matrix being passed
    move $t1, $a1	# number of rows
    move $t2, $a2	# number of columns
    
    li $t9, 46 # the ascii character for "." is 46, not sure if this is the correct way to do this
    
    li $t3, 0  # i, row counter

    row_loop:
	li $t4, 0  # j, column counter
    col_loop:
   
	# addr = base_addr + i * num_columns * elem_size_in_bytes + j * elem_size_in_bytes
	# addr = base_addr + elem_size_in_bytes * (i * num_columns + j)

	mul $t5, $t3, $t2 # i * num_columns
	add $t5, $t5, $t4 # i * num_columns + j
	sll $t5, $t5, 2   # 4*(i * num_columns + j)  Mult by 4 b/c we have an array of 4-byte words
	add $t5, $t5, $t0 # base_addr + 4*(i * num_columns + j)
	sw $t9, 0($t5) # needs to store the ascii characer "."

	addi $t4, $t4, 1  # j++
	
	
	blt $t4, $t2, col_loop
	col_loop_done:

	addi $t3, $t3, 1  # i++
	blt $t3, $t1, row_loop

	row_loop_done:

    li $v0, 0		 # returns a 0 if this method was a success
    jr $ra


##############################
# Part II FUNCTIONS
##############################

load_board:
	
	# (int num_rows, int num_cols) load_board(slot[][] board, char[] filename)
	# need a buffer to store the space of the 
	
    move $t1, $a0	# a reference to the matrix board
    move $t2, $a1	# the address of the file
    
    addi $sp, $sp, -8
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    
    # from the MARS website
    li   $v0, 13       # system call for open file
    move   $a0, $t2      # output file name
    li   $a1, 0        # Open for writing (flags are 0: read, 1: write)
    li   $a2, 0        # mode is ignored
    syscall            # open a file (file descriptor returned in $v0)
    move $t6, $v0      # save the file descriptor
    
    # need to use the file descriptor to read
   
    
    ##############################################################
    #	Using the Stack to Store the buffer used for the file read
    ##############################################################
    
    addi $sp, $sp, -100	# want to allocate 100 bytes in the stack
    
    # now need to use syscall 14 ( read file ) to read the file from the descriptor
    	li $v0, 14
	move $a0, $t6    # a0 = file descriptor
	#move $a1, $t2    # a1 = adddress of input buffer	( t2 = address of the file)
	move $a1, $sp	 # using the buffer address as the address of the stack pointer
	li $a2, 100	 # a2 = maximum number of characters to read ( currently we are doing a 100 character max) 
	syscall
	

    move $t8, $a1
    
   ##########################################################
   # Determine the size of the board with first 4 digits
   ########################################################## 
   # t8 = address of the buffer of the word
   # sp = starting address of the word buffer
   # t1 = reference to the board
   # t6 = reference to the decriptor
   
   # load the amount of rows
   li $v0, 10
   lb $t2, 0($t8)	# load the first byte fit from the first line into t2
   addi $t2, $t2, -48	# convert to its integer form
   mul $t2, $t2, $v0	# multiply t2 by 10 
   addi $t8, $t8, 1	# go to the next address in t8
 
   lb $t3, 0($t8)	# oad the second byte form the first line into t3 
   addi $t3, $t3, -48	# convert to its integer form
   addi $t8, $t8, 1	# go to the next address in t8
   
   add $t4, $t2, $t3    # add the two together to get the total amount of rows and store in t4
   
   # load the amount of columns
   lb $t2, 0($t8)	# load the first byte fit from the first line into t2
   addi $t2, $t2, -48	# convert to its integer form
   mul $t2, $t2, $v0	# multiply t2 by 10 
   addi $t8, $t8, 1	# go to the next address in t8
 
   lb $t3, 0($t8)	# oad the second byte form the first line into t3 
   addi $t3, $t3, -48	# convert to its integer form
   addi $t8, $t8, 1	# go to the next address in t8
   
   add $t3, $t3, $t2    # add the two together to get the total amount of rows and store in t3
   
   # now t4 has the amount of rows and t3 has the amount of columns
   

   
    
    move $s0, $t4	# v0 is the number of rows
    move $s1, $t3	# v1 is the amount of columns
    
    # now the address of t8 should be the nextline character
    addi $t8, $t8, 1 # now the address should be on the first byte of the second line
    
   piece_loop: 
    
   ##########################################################
   # Determine the row and column for the piece
   ########################################################## 
    
    # 1) read first two bytes    --> row
    # 2) read second two bytes   --> column
    # 3) read next byte to determine if R or Y
    # 4) read next three bytes and determine which turn the piece belongs to.
    # available registeres: t2, t5, t7, t9
   li $t7, 10   
   lb $t2, 0($t8)	# load the first byte fit from the first line into t2
   beqz $t2, piecesLoaded
   addi $t2, $t2, -48	# convert to its integer form 
   mul $t2, $t2, $t7	# multiply t2 by 10
   addi $t8, $t8, 1	# go to the next address in t8
 
   lb $t5, 0($t8)	# oad the second byte form the first line into t3 
   addi $t5, $t5, -48	# convert to its integer form
   addi $t8, $t8, 1	# go to the next address in t8
   
   add $t5, $t2, $t5
    # t5 now has the row for the piece
    
    
    # now calculate the column
   lb $t2, 0($t8)	# load the first byte fit from the first line into t2
   addi $t2, $t2, -48	# convert to its integer form 
   mul $t2, $t2, $t7	# multiply t2 by 10
   addi $t8, $t8, 1	# go to the next address in t8
 
   lb $t7, 0($t8)	# oad the second byte form the first line into t3 
   addi $t7, $t7, -48	# convert to its integer form
   addi $t8, $t8, 1	# go to the next address in t8
   
   add $t6, $t2, $t7
    # t6 now has the column for the first piece
    
   
   ##########################################################
   # Determine the piece color
   ########################################################## 
    
   # now need to calculate whether the next byte is 'R' or 'Y'
   lb $t2, 0($t8)	# load the first byte fit from the first line into t2
   beq $t2, 82, redTile
   beq $t2, 89, yellowTile
     
     redTile:
     	li $t0, 82
     	j continue_load
     	
  
     	
     yellowTile:
     	li $t0, 89
     
     continue_load:
     
     addi $t8, $t8, 1	# go to the next address in t8, going to the first of the last 3 digits of t3
     
   ##########################################################
   # Determine the turn number
   ########################################################## 
     
     # now read the last three digits to determine the turn number
     # registers being used: t5 and t6 for row and column
   li $t7, 100
   lb $t2, 0($t8)	# load first turn digit
   addi $t2, $t2, -48	# convert to its integer form
   mul $t2, $t2, $t7	# multiply t2 by 10 
   addi $t8, $t8, 1	# go to the next address in t8
 
   li $t7, 10
   lb $t9, 0($t8)	# load second turn digit 
   addi $t9, $t9, -48	# convert to its integer form
   mul $t9, $t9, $t7	# multiply t2 by 10
   addi $t8, $t8, 1	# go to the next address in t8
   
   lb $t7, 0($t8)	# load third turn digit 
   addi $t7, $t7, -48	# convert to its integer form
   addi $t8, $t8, 1	# go to the next address in t8
   
   add $t9, $t9, $t2
   add $t7, $t7, $t9
   
     
   addi $t8, $t8, 1  
   
   #j skip
     # now t4 has the turn number, t5 has the row number and t6 has the column number
     	
   ##########################################################
   # use the information to load the piece into the board
   ########################################################## 	
     	
    # need to call the set_slot function
    
    
    # values to save to the stack ( because we still need them for this loaded board from the file ): the number of rows and columns of the board
    addi $sp, $sp, -4
    sw $t1, 0($sp)	 # store the matrix
    addi $sp, $sp, -4
    sw $t4, 0($sp)	 # store the rows
    addi $sp, $sp, -4      
    sw $t3, 0($sp)	 # store the columns
    addi $sp, $sp, -4      
    sw $t8, 0($sp)	# store whatever this reference is 
    addi $sp, $sp, -4      
    sw $ra, 0($sp)	 # store the return address    
    
    # need to load the function arguments, including the ones that have to be pushed onto the stack
    
    # int set_slot(slot[][] board, int num_rows, int num_cols, int row, int col, char c, int turn_num)
    # t4 has the turn number, t5 has the row number and t6 has the column number, t1 has the board
    
    move $a0, $t1	# matrix
    move $a1, $t4	# rows
    move $a2, $t3	# columns
    move $a3, $t5	# row
    
    addi $sp, $sp, -12
    sw, $t6, 0($sp)	 # column	 
    sw, $t0, 4($sp)	 # character     
    sw, $t7, 8($sp)	 # turn number
   
    jal set_slot
    
    # we are not returning these values because they are in the stack for the purpose of being input parameters
    
    addi $sp $sp, 12	# returning the value of the stack pointer from set_slot
    
    # return the values back to the stack
    
    lw, $ra, 0($sp)	 # load back the return address
    addi $sp, $sp, 4
    lw, $t8, 0($sp)	 # load back the columns 
    addi $sp, $sp, 4
    lw, $t3, 0($sp)	 # load back the columns 
    addi $sp, $sp, 4
    lw, $t4, 0($sp)	 # load back the rows
    addi $sp, $sp, 4      
    lw, $t1, 0($sp)	 # load back the current matrix
    addi $sp, $sp, 4 	 	
     	
     	
    #skip: 	
     	
   j piece_loop 	
     	
   piecesLoaded:  	
     	
    addi $sp, $sp, 100	# return values back to the stack
    ##########################################
    
    move $v0, $s0
    move $v1, $s1
    
    lw $s0, 0($sp)
    lw $s1, 4($sp)
    addi $sp, $sp, 8
    
    jr $ra

save_board:

    
    # int save_board(slot[][] board, int num_rows, int num_cols, char[] filename)
    # note that the ascii code now newline in ascii is 10
    
    move $t0, $a0 # reference to the board
    move $t1, $a1 # number of rows 
    move $t2, $a2 # number of columns
    move $t9, $a3 # reference to file passed
    
    addi $sp, $sp, -4
    sw $s0, 0($sp)
    addi $sp, $sp, -4
    sw $s1, 0($sp)
    
    # Open (for writing) a file that does not exist ( taken from mars website)
    li   $v0, 13       # system call for open file
    move   $a0, $t9     # output file reference
    li   $a1, 1        # Open for writing (flags are 0: read, 1: write)
    li   $a2, 0        # mode is ignored
    syscall            # open a file (file descriptor returned in $v0)
    move $s0, $v0      # save the file descriptor 
    
    # t0 = the reference to tha board
    # t1 =  the number of rows
    # t2 =  the number of columns
    # t3 =  the reference to the file passed
    # t4 =  the file decriptor
    # s1 =  the counter for how long to make the buffer space
    
    addi $sp, $sp, -200	# create space in the space to write the buffer to
    
    
    
    #########################################################
    # Need to first write the rows and columns into the file
    #########################################################

    # copy the address of the beginning of the stack into t5
    move $t5, $sp
    move $s1, $t5

    # write the row and column size into the file ( 2 bytes each )
    li $t6, 10
    div $t1, $t6
    mfhi $t6
    mflo $t7
    addi $t6, $t6, 48
    addi $t7, $t7, 48
    sb $t7, 0($t5)
    addi $t5, $t5, 1
    sb $t6, 0($t5)
    addi $t5, $t5, 1
    
    li $t6, 10
    div $t2, $t6
    mfhi $t6
    mflo $t7
    addi $t6, $t6, 48
    addi $t7, $t7, 48    
    sb $t7, 0($t5)
    addi $t5, $t5, 1
    sb $t6, 0($t5)
    addi $t5, $t5, 1
    
    # now write the nextLine character (10)
    li $t6, 10
    sb $t6, 0($t5)
    addi $t5, $t5, 1
    
    # now loop for storing the rest of the characters
    # need to iterate through the rows and columns to see if there are any pieces places
    # need to use the get_slot function
    # (char piece, int turn) get_slot(slot[][] board, int num_rows, int num_cols, int row, int col)
    # need to go through every slot of the board
    
    # t0 = the reference to the matrix
    # t1 =  the number of rows
    # t2 =  the number of columns
    # t3 =  the row counter
    # t4 =  the column counter
    # t5 =  the copied address of the stack ( which is currently the buffer to be written to)
    # need to have every row and column for the 4th and 5th parameter
    
    # move $t6, $t0 # save a reference to where the beginning of the matrix is

    li $t3, 0  # i, row counter
    
    #this iterates through the indexes of the matrix and adds by 4's 
    row_loop_save:
	li $t4, 0  # j, column counter
	col_loop_save:
	
		# values that are being saved on the stack
		addi $sp, $sp, -28
		sw $t0, 0($sp) # matrix
		sw $t1, 4($sp) # rows
		sw $t2, 8($sp) # columns  
		sw $t3, 12($sp) # row counter 
		sw $t4, 16($sp) # column counter
		sw $t5, 20($sp) # copied address of the stack
		sw $ra, 24($sp) # save the return address
		
		# load funuction arguments for get_slot
		# (char piece, int turn) get_slot(slot[][] board, int num_rows, int num_cols, int row, int col)
		move $a0, $t0
		move $a1, $t1
		move $a2, $t2
		move $a3, $t3
		addi $sp, $sp, -4
		sw $t4, 0($sp)
		
		jal get_slot
		
		move $t8, $v0 # return the character at the spot
		move $t9, $v1 # return the turn number
		addi $t9, $t9, -48
		
		
		# now need to take the piece and write it to the stack that takes up 8 bits, and then place a /n character
		
		addi $sp, $sp, 4

		# load back saved values from the stack
		lw $t0, 0($sp) # matrix
		lw $t1, 4($sp) # rows
		lw $t2, 8($sp) # columns  
		lw $t3, 12($sp) # row counter 
		lw $t4, 16($sp) # column counter
		lw $t5, 20($sp) # copied address of the stack
		lw $ra, 24($sp) # load back the word address
		addi $sp, $sp, 28
		
		beq $t8, 82, add_to_grid
		beq $t8, 89, add_to_grid
		j continue_save

		add_to_grid:
		# t3 = row
		# t4 = columns
		# t8 = the character
		# t9 = the turn number ( can be up to 3 bytes )
		
		# 1)  write the row (two bytes) then write the columns (2 bytes)
		# row
		li $t6, 10
    		div $t3, $t6 # divide t3 (row) by 10
    		mfhi $t6
   		mflo $t7
    		addi $t6, $t6, 48
    		addi $t7, $t7, 48
    		sb $t7, 0($t5)
    		addi $t5, $t5, 1
    		sb $t6, 0($t5)
    		addi $t5, $t5, 1
		# column 
		li $t6, 10
    		div $t4, $t6 # divide t4 (column) by 10
    		mfhi $t6
   		mflo $t7
    		addi $t6, $t6, 48
    		addi $t7, $t7, 48
    		sb $t7, 0($t5)
    		addi $t5, $t5, 1
    		sb $t6, 0($t5)
    		addi $t5, $t5, 1
		
		# 2)  write the piece
		sb $t8, 0($t5)
		addi $t5, $t5, 1
		
		# 2)  write the turn number (3 bytes)
		li $t6, 100
		div $t9, $t6 # divide t9 (turn number) by 100
    		mfhi $t7 # remainder 
   		mflo $t6 # quotient
   		addi $t6, $t6, 48
   		sb $t6, 0($t5) # store the result of dividing by 100 into t5
   		addi $t5, $t5, 1
   		li $t6, 10
		div $t7, $t6 # divide t7 (the remainder) by 10
		mfhi $t6 # remainder 
   		mflo $t7 # quotient
   		addi $t7, $t7, 48
   		sb $t7, 0($t5) # store the quotient of this
    		addi $t5, $t5, 1
    		addi $t6, $t6, 48
    		sb $t6, 0($t5) # store the remainder of this
    		addi $t5, $t5, 1
   		
		li $t6, 10
		sb $t6, 0($t5) # store a nextline character into the grid
		addi $t5, $t5, 1
		
		continue_save:


		addi $t4, $t4, 1  # j++
		blt $t4, $t2, col_loop_save
		
	col_loop_done_save:

	addi $t3, $t3, 1  # i++
	blt $t3, $t1, row_loop_save

    row_loop_done_save: 
    
    li $t0, 0
    sb $t0, 0($t5)
    # after stack is loaded with all the values, then the file is needed to be written to
    
    sub $t5, $t5, $s1
    
    # write to the file just opened
    li   $v0, 15       # system call for write to file
    move $a0, $s0      # file descriptor 
    move   $a1, $sp      # address of buffer from which to write
    move   $a2, $t5      # hardcoded buffer length
    syscall            # write to file
    
    addi $sp, $sp, 200
    

    lw $s1, 0($sp)
    addi $sp, $sp, 4            
    lw $s0, 0($sp)
    addi $sp, $sp, 4
    
    jr $ra

validate_board:
    
     move $t0, $a0 # reference to the board
     move $t1, $a1 # amount of rows
     move $t2, $a2 # amount of columns
    
    # keep the running total in $t3
    li $t3, 0
    
    
    
    # Bit 7: There are 2 or more pieces with the same turn number or the turn numbers do not start at 1.
     addi $sp, $sp, -20 # store values for this method
     sw $t0 0($sp)
     sw $t1 4($sp)
     sw $t2 8($sp)
     sw $t3 12($sp)
     sw $ra 16($sp)
     
     move $a0, $t0 # load function arguments
     move $a1, $t1
     move $a2, $t2
     
     jal validate_board_helper_7
     # v0 = if there was an error found
     
  
     
     lw $t0 0($sp)
     lw $t1 4($sp)
     lw $t2 8($sp)
     lw $t3 12($sp)
     lw $ra 16($sp)
     addi $sp, $sp, 20
     
    # add $t3, $v0 
    add $t3, $t3, $v0
    sll $t3, $t3, 1

    
    ############################
    # Bit 5 and 6 Method
    ############################
     # call the validate_board_helper_5_6 method
     addi $sp, $sp, -20 # store values for this method
     sw $t0 0($sp)
     sw $t1 4($sp)
     sw $t2 8($sp)
     sw $t3 12($sp)
     sw $ra 16($sp)
     
     move $a0, $t0 # load function arguments
     move $a1, $t1
     move $a2, $t2
     
     jal validate_board_helper_5_6
     # v0 = case 5
     # v1 = case 6
     
     lw $t0 0($sp)
     lw $t1 4($sp)
     lw $t2 8($sp)
     lw $t3 12($sp)
     lw $ra 16($sp)
     addi $sp, $sp, 20
     
    # Bit 6: A piece with a lower turn number resides above a piece with a higher turn number.
    # similar to bit 5, check the below node of each piece to see if it is either greater than the number or equal to 0
    add $t3, $t3, $v1
    sll $t3, $t3, 1
    # Bit 5: An empty slot exists below a piece.
    # check if a piece exists and the piece below is = 0
    add $t3, $t3, $v0
    sll $t3, $t3, 1
    
    # Bit 4: The red and yellow pieces DO NOT alternate turn numbers.
    # somehow sort pieces sequentially and then see if two are the same in a row
    
     # call the validate_board_helper_5_6 method
     addi $sp, $sp, -20 # store values for this method
     sw $t0 0($sp)
     sw $t1 4($sp)
     sw $t2 8($sp)
     sw $t3 12($sp)
     sw $ra 16($sp)
     
     move $a0, $t0 # load function arguments
     move $a1, $t1
     move $a2, $t2
     
     jal validate_board_helper_4
     
     lw $t0 0($sp)
     lw $t1 4($sp)
     lw $t2 8($sp)
     lw $t3 12($sp)
     lw $ra 16($sp)
     addi $sp, $sp, 20
      
     add $t3, $t3, $v0 
     sll $t3, $t3, 1
    
    # Bit 3: The absolute difference between the number of placed red pieces and yellow pieces is greater than 1.
    # call the helper method for finding case 3
    addi $sp, $sp, -20 # store values for this method
     sw $t0 0($sp)
     sw $t1 4($sp)
     sw $t2 8($sp)
     sw $t3 12($sp)
     sw $ra 16($sp)
     
     move $a0, $t0 # load function arguments
     move $a1, $t1
     move $a2, $t2
     
     jal validate_board_helper_3
     # v0 = case 5
     # v1 = case 6
     
     lw $t0 0($sp)
     lw $t1 4($sp)
     lw $t2 8($sp)
     lw $t3 12($sp)
     lw $ra 16($sp)
     addi $sp, $sp, 20    
                
    # add bit 3, whether it be 1 or 0  depending  
    add $t3, $t3, $v0
    sll $t3, $t3, 1
    
    # Bit 2: check if (columns * rows) > 255
    mul $t4, $t1, $t2
    ble $t4, 255, bit_two_0
    addi $t3, $t3, 1
    bit_two_0:
    sll $t3, $t3, 1
    
    # Bit 1: num_cols is less than 4.
    bgt $t2, 3 bit_one_0 # t1 are the # of row
    addi $t3, $t3, 1
    bit_one_0:
    sll $t3, $t3, 1
    
    # Bit 0: num_rows is less than 4.
    bgt $t1, 3 bit_zero_0 # t1 are the # of rows
    addi $t3, $t3, 1
    bit_zero_0:
    
    
    li $v0, 35
    move $a0, $t3
    syscall
    
    move $v0, $t3
    ##########################################
    jr $ra

validate_board_helper_4:
# need to be able to set bits to values based on whether they are certain errors
    
     move $t0, $a0 # reference to the board
     move $t1, $a1 # amount of rows
     move $t2, $a2 # amount of columns
     li $t3, 0  # i, row counter
     li $t7, 0 # red piece counter
     li $t8, 0 # yellow piece counter
     
     # v0 and v1 will return 0 if there is no error found
     li $v0, 0
     li $v1, 0
     

   row_loop_helper_4:
	li $t4, 0  # j, column counter
   col_loop_helper_4:

	# addr = base_addr + i * num_columns * elem_size_in_bytes + j * elem_size_in_bytes
	# addr = base_addr + elem_size_in_bytes * (i * num_columns + j)

	mul $t5, $t3, $t2 # i * num_columns
	add $t5, $t5, $t4 # i * num_columns + j
	sll $t5, $t5, 1   # 4*(i * num_columns + j)  Mult by 4 b/c we have an array of 4-byte words
	add $t5, $t5, $t0 # base_addr + 4*(i * num_columns + j)
	# t5 has the address of the current i j indexs 
	lb $t6, 0($t5) # has the character
	lb $t7, 1($t5) # loads the turn number for this piece
	addi $t5, $t5, 2
	
    ########################################
    # Call the helper method for this method
    ########################################
     # call the validate_board_helper_5_6 method
     addi $sp, $sp, -20 # store values for this method
     sw $t0 0($sp)
     sw $t1 4($sp)
     sw $t2 8($sp)
     sw $t3 12($sp)
     sw $ra 16($sp)
     
     move $a0, $t0 # load function arguments
     move $a1, $t1
     move $a2, $t2
     move $a3, $t7 # the turn number as an argument
     
     addi $sp, $sp, -4
     sw $t6,  0($sp)	# store the character
     
     jal validate_board_helper_4_helper
   
     addi $sp, $sp , 4
     
     lw $t0 0($sp)
     lw $t1 4($sp)
     lw $t2 8($sp)
     lw $t3 12($sp)
     lw $ra 16($sp)
     addi $sp, $sp, 20
	 
     move $t9, $v0
     beq $t9, 1 duplicate_found_4
     j iterate_helper_4
     duplicate_found_4:
     li $v0, 1
     j return_4
	
	iterate_helper_4:

	addi $t4, $t4, 1  # j++
	blt $t4, $t2, col_loop_helper_4
    col_loop_done_helper_4:

    addi $t3, $t3, 1  # i++
    blt $t3, $t1, row_loop_helper_4

    row_loop_done_helper_4:

	
	return_4:										
    ##########################################
    jr $ra
    
validate_board_helper_4_helper:

     move $t0, $a0 # reference to the board
     move $t1, $a1 # amount of rows
     move $t2, $a2 # amount of columns
     lw $t8, 0($sp) # the character 
     move $t9, $a3 # the turn number that is being compared
     
     li $t3, 0  # i, row counter
     
     # v0 and v1 will return 0 if there is no error found
     li $v0, 0
     li $v1, 0
     

   row_loop_helper_4_helper:
	li $t4, 0  # j, column counter
   col_loop_helper_4_helper:

	# addr = base_addr + i * num_columns * elem_size_in_bytes + j * elem_size_in_bytes
	# addr = base_addr + elem_size_in_bytes * (i * num_columns + j)

	mul $t5, $t3, $t2 # i * num_columns
	add $t5, $t5, $t4 # i * num_columns + j
	sll $t5, $t5, 1   # 4*(i * num_columns + j)  Mult by 4 b/c we have an array of 4-byte words
	add $t5, $t5, $t0 # base_addr + 4*(i * num_columns + j)
	# t5 has the address of the current i j indexs 
	lb $t6, 0($t5) # has the character
	lb $t7, 1($t5) # loads the turn number for this piece
	addi $t7, $t7, -1
	
	beq $t7, $t9, check_order # if t7 - 1 is the same as t9, then t7 is the next character 
	j iterate_helper_4_helper
	check_order:
	beq $t6, $t8, not_in_order
	j iterate_helper_4_helper
	
	not_in_order:
	li $v0, 1
	j return_4_helper
	
	
	iterate_helper_4_helper:

	addi $t4, $t4, 1  # j++
	blt $t4, $t2, col_loop_helper_4_helper
    col_loop_done_helper_4_helper:

    addi $t3, $t3, 1  # i++
    blt $t3, $t1, row_loop_helper_4_helper

    row_loop_done_helper_4_helper:

	
    return_4_helper:										
    ##########################################
    jr $ra                                  
    
validate_board_helper_7:
# need to be able to set bits to values based on whether they are certain errors
    
     move $t0, $a0 # reference to the board
     move $t1, $a1 # amount of rows
     move $t2, $a2 # amount of columns
     li $t3, 0  # i, row counter
     li $t7, 0 # red piece counter
     li $t8, 0 # yellow piece counter
     
     # v0 and v1 will return 0 if there is no error found
     li $v0, 0
     li $v1, 0
     

   row_loop_helper_7:
	li $t4, 0  # j, column counter
   col_loop_helper_7:

	# addr = base_addr + i * num_columns * elem_size_in_bytes + j * elem_size_in_bytes
	# addr = base_addr + elem_size_in_bytes * (i * num_columns + j)

	mul $t5, $t3, $t2 # i * num_columns
	add $t5, $t5, $t4 # i * num_columns + j
	sll $t5, $t5, 1   # 4*(i * num_columns + j)  Mult by 4 b/c we have an array of 4-byte words
	add $t5, $t5, $t0 # base_addr + 4*(i * num_columns + j)
	# t5 has the address of the current i j indexs 
	lb $t6, 0($t5) # has the character
	lb $t7, 1($t5) # loads the turn number for this piece
	
    ########################################
    # Call the helper method for this method
    ########################################
     # call the validate_board_helper_5_6 method
     addi $sp, $sp, -20 # store values for this method
     sw $t0 0($sp)
     sw $t1 4($sp)
     sw $t2 8($sp)
     sw $t3 12($sp)
     sw $ra 16($sp)
     
     move $a0, $t0 # load function arguments
     move $a1, $t1
     move $a2, $t2
     move $a3, $t7 # the character as an argument
     
     jal validate_board_helper_7_helper
   
     
     lw $t0 0($sp)
     lw $t1 4($sp)
     lw $t2 8($sp)
     lw $t3 12($sp)
     lw $ra 16($sp)
     addi $sp, $sp, 20
	 
     move $t9, $v0
     beq $t9, 1 duplicate_found
     j continue_7_checker
     duplicate_found:
     li $v0, 1
     j return_7
     
	continue_7_checker:
	
	
	iterate_helper_7:

	addi $t4, $t4, 1  # j++
	blt $t4, $t2, col_loop_helper_7
    col_loop_done_helper_7:

    addi $t3, $t3, 1  # i++
    blt $t3, $t1, row_loop_helper_7

    row_loop_done_helper_7:

	
	return_7:										
    ##########################################
    jr $ra            
    
validate_board_helper_7_helper:

     move $t0, $a0 # reference to the board
     move $t1, $a1 # amount of rows
     move $t2, $a2 # amount of columns
     move $t8, $a3 # the turn number that is being compared
     
     li $t3, 0  # i, row counter
     
     # v0 and v1 will return 0 if there is no error found
     li $v0, 0
     li $v1, 0
     

   row_loop_helper_7_helper:
	li $t4, 0  # j, column counter
   col_loop_helper_7_helper:

	# addr = base_addr + i * num_columns * elem_size_in_bytes + j * elem_size_in_bytes
	# addr = base_addr + elem_size_in_bytes * (i * num_columns + j)

	mul $t5, $t3, $t2 # i * num_columns
	add $t5, $t5, $t4 # i * num_columns + j
	sll $t5, $t5, 1   # 4*(i * num_columns + j)  Mult by 4 b/c we have an array of 4-byte words
	add $t5, $t5, $t0 # base_addr + 4*(i * num_columns + j)
	# t5 has the address of the current i j indexs 
	lb $t6, 0($t5) # has the character
	lb $t7, 1($t5) # loads the turn number for this piece
	
	beq $t8, $t7, duplicate
	j iterate_helper_7_helper
	
	duplicate:
	li $v0, 1
	j return_7_helper
	
	
	iterate_helper_7_helper:

	addi $t4, $t4, 1  # j++
	blt $t4, $t2, col_loop_helper_7_helper
    col_loop_done_helper_7_helper:

    addi $t3, $t3, 1  # i++
    blt $t3, $t1, row_loop_helper_7_helper

    row_loop_done_helper_7_helper:

	
    return_7_helper:										
    ##########################################
    jr $ra

validate_board_helper_5_6:

       # need to be able to set bits to values based on whether they are certain errors
    
     move $t0, $a0 # reference to the board
     move $t1, $a1 # amount of rows
     move $t2, $a2 # amount of columns
     li $t3, 0  # i, row counter
     li $t7, 0 # add one for every red, subtract one for every yellow, if the total by the end is greater than 1 or less than -1 then there is an error
     
     # v0 and v1 will return 0 if there is no error found
     li $v0, 0
     li $v1, 0
     

   row_loop_helper_5_6:
	li $t4, 0  # j, column counter
   col_loop_helper_5_6:

	# addr = base_addr + i * num_columns * elem_size_in_bytes + j * elem_size_in_bytes
	# addr = base_addr + elem_size_in_bytes * (i * num_columns + j)
	
	beq $t3, 0, iterate_helper

	mul $t5, $t3, $t2 # i * num_columns
	add $t5, $t5, $t4 # i * num_columns + j
	sll $t5, $t5, 1   # 4*(i * num_columns + j)  Mult by 4 b/c we have an array of 4-byte words
	add $t5, $t5, $t0 # base_addr + 4*(i * num_columns + j)
	# t5 has the address of the current i j indexs 
	lb $t6, 0($t5) # has the character
	addi $t5, $t5, 1
	lb $t7, 0($t5) # has the turn number
	addi $t5, $t5, -1
	beq $t6, 82, check_below
	beq $t6, 89, check_below
	j iterate_helper
	# check if the piece below this one is empty
	check_below:
	move $t8, $t2     # copy the amount of columns
	sll $t8, $t8, 1   # multiply the number of columns x 2
	sub $t5, $t5, $t8 # subtract the current address by (cols x 2)
	lb $t8, 0($t5)    # load the bit below into t8
	addi $t5, $t5, 1
	lb $t9, 0 ($t5) # t9 has the below character
	beq $t8, 0, below_error_zero
	j check_character
	below_error_zero:
	li $v0, 1 # sets the v0 bit to 1, indicating that bit 5 should be an error
	check_character:
	blt $t7, $t9, below_error_greater
	j iterate_helper
	below_error_greater:
	li $v1, 1 # sets the v0 bit to 1, indicating that bit 5 should be an error
	
	iterate_helper:

	addi $t4, $t4, 1  # j++
	blt $t4, $t2, col_loop_helper_5_6
    col_loop_done_helper_5_6:

    addi $t3, $t3, 1  # i++
    blt $t3, $t1, row_loop_helper_5_6

    row_loop_done_helper_5_6:
		
	move $t0, $v0
	move $t1, $v1
	
	li $v0, 1
	move $a0, $t0
	#syscall				

	li $v0, 1
	move $a0, $t1
	#syscall	
	
	move $v0, $t0
	move $v1, $t1										
    ##########################################
    jr $ra

validate_board_helper_3:

       # need to be able to set bits to values based on whether they are certain errors
    
     move $t0, $a0 # reference to the board
     move $t1, $a1 # amount of rows
     move $t2, $a2 # amount of columns
     li $t3, 0  # i, row counter
     li $t7, 0 # red piece counter
     li $t8, 0 # yellow piece counter
     
     # v0 and v1 will return 0 if there is no error found
     li $v0, 0
     li $v1, 0
     

   row_loop_helper_3:
	li $t4, 0  # j, column counter
   col_loop_helper_3:

	# addr = base_addr + i * num_columns * elem_size_in_bytes + j * elem_size_in_bytes
	# addr = base_addr + elem_size_in_bytes * (i * num_columns + j)

	mul $t5, $t3, $t2 # i * num_columns
	add $t5, $t5, $t4 # i * num_columns + j
	sll $t5, $t5, 1   # 4*(i * num_columns + j)  Mult by 4 b/c we have an array of 4-byte words
	add $t5, $t5, $t0 # base_addr + 4*(i * num_columns + j)
	# t5 has the address of the current i j indexs 
	lb $t6, 0($t5) # has the character
	addi $t5, $t5, 1
	
	beq $t6, 82, plus_one_red
	beq $t6, 89, plus_one_yellow
	j iterate_helper_3
	
	plus_one_red:
	addi $t7, $t7, 1
	j iterate_helper_3
	plus_one_yellow:
	addi $t8, $t8, 1
	j iterate_helper_3
	
	iterate_helper_3:

	addi $t4, $t4, 1  # j++
	blt $t4, $t2, col_loop_helper_3
    col_loop_done_helper_3:

    addi $t3, $t3, 1  # i++
    blt $t3, $t1, row_loop_helper_3

    row_loop_done_helper_3:
		
	move $t0, $v0
	move $t1, $v1
	
	li $v0, 1
	move $a0, $t7
	#syscall				

	li $v0, 1
	move $a0, $t8
	#syscall
	
	li $v0, 0
	sub $t8, $t8, $t7
	blt $t8, -1, error_3
	bgt $t8,  1, error_3
	j return_3
	error_3:
	li $v0, 1
	
	return_3:										
    ##########################################
    jr $ra


##############################
# Part III FUNCTIONS
##############################

display_board:

	# int display_board(slot[][] board, int num_rows, int num_cols)
	
	move $t0, $a0 # reference to the board
	move $t1, $a1 # the number of rows
	move $t2, $a2 # the number of columns
	
	#li $t7, 0		# get t0 to be the max value instead of the min value
	#mul $t7, $t1, $t2
	#sll $t7, $t7, 1
	#add $t0, $t7, $t0
	#addi $t0, $t0, -2
	
	 li $t7, 0
	  
	# need to iterate through the entire board

	move $t3, $t1  # i, row counter
	addi $t3, $t3, -1

	row_loop_display:
	li $t4, 0  # j, column counter
	col_loop_display:
	# Although this array traversal could be implemented by simply
	# adding 4 to a starting address (e.g., matrix's address), the
	# point here is to show the arithmetic of computing the address
	# of an element in a 2D array.
	
	# addr = base_addr + i * num_columns * elem_size_in_bytes + j * elem_size_in_bytes
	# addr = base_addr + elem_size_in_bytes * (i * num_columns + j)

	mul $t5, $t3, $t2 # i * num_columns
	add $t5, $t5, $t4 # i * num_columns + j
	sll $t5, $t5, 1   # 4*(i * num_columns + j)  Mult by 4 b/c we have an array of 4-byte words
	
	#sub $t5, $t0, $t7
	#addi $t7, $t7, 2
	
	add $t5, $t5, $t0 # base_addr + 4*(i * num_columns + j)
	
	
	#sw $t9, 0($t5) # t5 has the address of the current index
	# this is the location of the value which to print
	lb $t9, 0($t5)
	
	bge $t9, 1, letter_found_display # if the byte is not 0 then it does not have to be converted to a dot
	addi $t9, $t9, 46 # if the value here is a 0 then we need a "." and not a 0, so we add 46 and print the character version
	letter_found_display:
	li $v0, 11
	move $a0, $t9
	syscall

	addi $t4, $t4, 1  # j++
	blt $t4, $t2, col_loop_display
	col_loop_done_display:
	
	li $v0, 11 # onto next row so a line must be skipped
	li $a0, 10
	syscall

	addi $t3, $t3, -1  # i++
	bge $t3, 0, row_loop_display
	

	row_loop_done_display:
		
			
    
    
    li $v0, -200
    ##########################################
    jr $ra
    

drop_piece:
    
    # int drop_piece(slot[][] board, int num_rows, int num_cols, int col, char piece, int turn_num)

    
    move $t0, $a0 # the matrix board
    move $t1, $a1 # number of rows
    move $t2, $a2 # number of cols
    move $t3, $a3 # column to place piece
    
    lw $t4, 0($sp) # piece to place (should be R)
    lw $t5, 4($sp) # turn number (should be 7)
    li $t6 , 0 # j value for iterating through the different slots of the column speicified
    
    drop_piece_loop:
    beq $t6, $t1, set_the_slot
    
    addi $sp, $sp, -28 # need to save all thes avlues on the stack for when the get_slot method is called
    sw $t0, 0($sp)
    sw $t1, 4($sp)
    sw $t2, 8($sp)
    sw $t3, 12($sp)
    sw $t4, 16($sp)
    sw $t5, 20($sp)
    sw $t6, 24($sp)
    
    # call getSlot on lowest slot in the column specified 
    # (char piece, int turn) get_slot(slot[][] board, int num_rows, int num_cols, int row, int col)
    
    move $a0, $t0 # the matrix
    move $a1, $t1 # rows
    move $a2, $t2 # columns
    move $a3, $t6 # row starts off as 0
    
    addi $sp, $sp, -8
    sw $t3, 0($sp) # t3 should be the column value inputeted above
    sw $ra, 4($sp) # store the return address onto the stack
    
    jal get_slot
    
    lw $ra, 4($sp)
    
    addi $sp, $sp, 8 # return the value back to the stack
    move $t7, $v0 # retrieve the piece taken from the method
    
    # if the piece is taken is 0, the set the new piece at this slot value
    
    
    #li $v0, 1
    #move $a0, $t7
    #syscall
    
    lw $t0, 0($sp) # should be matrix address
    lw $t1, 4($sp) # should be rows
    lw $t2, 8($sp) # should be columns 
    lw $t3, 12($sp) # column to be placed
    lw $t4, 16($sp) # piece to place
    lw $t5, 20($sp) # turn number
    lw $t6, 24($sp)
    addi $sp, $sp, 28 # need to save all thes avlues on the stack for when the get_slot method is called
    
    beqz $t7, set_the_slot  
    
    addi $t6, $t6, 1
j drop_piece_loop
    
    set_the_slot:
    
    #  int set_slot(slot[][] board, int num_rows, int num_cols, int row, int col, char c, int turn_num)
    move $a0, $t0 # the matrix
    move $a1, $t1 # rows
    move $a2, $t2 # columns
    move $a3, $t6 # row starts off as 0
    
    addi $sp, $sp, -16
    sw $t3, 0($sp) # t3 should be the column value inputeted above
    sw $t4, 4($sp) # t3 should be the character value inputeted above
    sw $t5, 8($sp) # t3 should be the turn number value inputeted above
        
    sw $ra, 12($sp) # store the return address onto the stack
    
    jal set_slot
    
    lw $ra, 12($sp) # store the return address onto the stack
    
    addi $sp, $sp, 16
    
    
    
    jr $ra

undo_piece:
    
    
    # (char piece, int turn_num) undo_piece(slot[][] board, int num_rows, int num_cols)
  
    # 0. load the values   
    # 1. iterate through the board and find the largest turn number using the return address from get_slot method (save the char and turn # for each iterated turn)
    # 2. after is said and done, use the set_slot method to turn the slots into 0's
    
    # load values
    	move $t0, $a0 # the matrix board
        move $t1, $a1 # number of rows
        move $t2, $a2 # number of cols

        li $t5, 0 # stores the current maximum value
   	li $t6, 0 # stores the i value of the max
   	li $t9, 0 # stores the j value of the max
   	
   	li $t3, 0  # i, row counter
    row_loop_undo:
	li $t4, 0  # j, column counter
    col_loop_undo:
   
   	# need to save board, rows, cols, t3 and t4 onto the stack
   	addi $sp, $sp, -32
   	sw $t0, 0($sp) # store board
   	sw $t1, 4($sp) # store rows
   	sw $t2, 8($sp) # store cols
   	sw $t3, 12($sp) # store row counter
   	sw $t4, 16($sp) # store col counter
	sw $t5, 20($sp) # store max turn value 
	sw $t6, 24($sp) # store max row 
	sw $t9, 28($sp) # store max col    	
 
   	
   
	# this is where we need to call the get_slot for every value combination of i and  j
	# (char piece, int turn) get_slot(slot[][] board, int num_rows, int num_cols, int row, int col)
    
   	 move $a0, $t0 # the matrix
    	 move $a1, $t1 # rows
   	 move $a2, $t2 # columns
   	 move $a3, $t3 # row
   	 addi $sp, $sp, -8
   	 sw $t4, 0($sp) # column
    	 sw $ra, 4($sp) # the return address
   	 jal get_slot
   	 lw $ra, 4($sp)
   	 addi $sp, $sp, 8 # return the value back to the stack
   	 
   	 move $t7, $v0 # retrieve the piece taken from the method
   	 move $t8, $v1 # retrieve the turn from the piece placed
	
	# load back the values that were stores on the stack
   	lw $t0, 0($sp) # store board
   	lw $t1, 4($sp) # store rows
   	lw $t2, 8($sp) # store cols
   	lw $t3, 12($sp) # store row counter
   	lw $t4, 16($sp) # store col counter
   	lw $t5, 20($sp) # store max turn value 
	lw $t6, 24($sp) # store max row 
	lw $t9, 28($sp) # store max col   
   	addi $sp, $sp, 32
   	
   	# check if the turn (t8) is the new max
   	ble $t8, 0, skip_g
	addi $t8, $t8, -48
	
	bgt $t8, $t5, new_max_found
	j skip_g
	new_max_found:
	move $t5, $t8 # sets the new maximum value to t5
	move $t6, $t3 # store the max row to t6
	move $t9, $t4 # store the max col to t9
	
	skip_g:
	

	addi $t4, $t4, 1  # j++
	blt $t4, $t2, col_loop_undo
	col_loop_done_undo:

	addi $t3, $t3, 1  # i++
	blt $t3, $t1, row_loop_undo

	row_loop_done_undo:
	
	
	 # now i need to call the set_slot method with the coordinates specified
	 #  int set_slot(slot[][] board, int num_rows, int num_cols, int row, int col, char c, int turn_num)
    	 move $a0, $t0 # the matrix
    	 move $a1, $t1 # rows
   	 move $a2, $t2 # columns
   	 move $a3, $t6 # row 
    
   	 addi $sp, $sp, -16
   	 sw $t9, 0($sp) # t3 should be the column value inputeted above
   	 li $t4, 0
   	 sw $t4, 4($sp) # t3 should be the character value inputeted above
   	 li $t5, 0
   	 sw $t5, 8($sp) # t3 should be the turn number value inputeted above
        
   	 sw $ra, 12($sp) # store the return address onto the stack
    
   	 jal set_slot
    
   	 lw $ra, 12($sp) # store the return address onto the stack
    
   	 addi $sp, $sp, 16
    
    li $v0, -200
    li $v1, -200
    ##########################################
    jr $ra

check_winner:
    
    # char check_winner(slot[][] board, int num_rows, int num_cols)

    move $t0, $a0
    move $t1, $a1
    move $t2, $a2
    
    # need to check these values for every single value in the board
    
    # check characters to the left
    # check characters to the right
    # check characters to the bottom
    # check character to the left

    # call the get method on every single piece
    
    li $t3, 0  # i, row counter
    row_loop_check:
	li $t4, 0  # j, column counter
    col_loop_check:
   
      	########################################################
   	# check to see if the horizontal directions had a winner
   	########################################################
   
   	# need to save board, rows, cols, t3 and t4 onto the stack
   	addi $sp, $sp, -20
   	sw $t0, 0($sp) # store board
   	sw $t1, 4($sp) # store rows
   	sw $t2, 8($sp) # store cols
   	sw $t3, 12($sp) # store row counter
   	sw $t4, 16($sp) # store col counter    	
	# this is where we need to call the get_slot for every value combination of i and  j
	# (char piece, int turn) get_slot(slot[][] board, int num_rows, int num_cols, int row, int col)
   	 move $a0, $t0 # the matrix
    	 move $a1, $t1 # rows
   	 move $a2, $t2 # columns
   	 move $a3, $t3 # row
   	 addi $sp, $sp, -8
   	 sw $t4, 0($sp) # column
    	 sw $ra, 4($sp) # the return address
   	 jal check_horizontal_winner
   	 lw $t4, 0($sp) # column
   	 lw $ra, 4($sp)
   	 move $t7, $v0 # retrieve the piece taken from the method, do not need the turn number
   	 addi $sp, $sp, 8 # return the value back to the stack
	# load back the values that were stores on the stack
   	lw $t0, 0($sp) # store board
   	lw $t1, 4($sp) # store rows
   	lw $t2, 8($sp) # store cols
   	lw $t3, 12($sp) # sre row counter
   	lw $t4, 16($sp) # store col counter
   	addi $sp, $sp, 20
   	
   	####################################
   	# check to see if there was a winner
   	####################################
   	
   	 beq $t7, 1, return_winner
   	 
      	########################################################
   	# check to see if the vertical direction had a winner
   	########################################################   	 
   	 
   	 # need to save board, rows, cols, t3 and t4 onto the stack
   	addi $sp, $sp, -20
   	sw $t0, 0($sp) # store board
   	sw $t1, 4($sp) # store rows
   	sw $t2, 8($sp) # store cols
   	sw $t3, 12($sp) # store row counter
   	sw $t4, 16($sp) # store col counter    	
	# this is where we need to call the get_slot for every value combination of i and  j
	# (char piece, int turn) get_slot(slot[][] board, int num_rows, int num_cols, int row, int col)
   	 move $a0, $t0 # the matrix
    	 move $a1, $t1 # rows
   	 move $a2, $t2 # columns
   	 move $a3, $t3 # row
   	 addi $sp, $sp, -8
   	 sw $t4, 0($sp) # column
    	 sw $ra, 4($sp) # the return address
   	 jal check_vertical_winner
   	 lw $t4, 0($sp) # column
   	 lw $ra, 4($sp)
   	 move $t7, $v0 # retrieve the piece taken from the method, do not need the turn number
   	 addi $sp, $sp, 8 # return the value back to the stack
	# load back the values that were stores on the stack
   	lw $t0, 0($sp) # store board
   	lw $t1, 4($sp) # store rows
   	lw $t2, 8($sp) # store cols
   	lw $t3, 12($sp) # sre row counter
   	lw $t4, 16($sp) # store col counter
   	addi $sp, $sp, 20
   	 
   	####################################
   	# check to see if there was a winner
   	####################################
   	
   	 beq $t7, 1, return_winner

   	##########################################
   	# jumps to this code if a winner was found
   	##########################################
   	    	     	 
   	 j no_win
   	 return_winner:
   	 # this is the part where we call the get_slot method to find the character that there is four in a row of
   	
   	 move $a0, $t0 # the matrix
    	 move $a1, $t1 # rows
   	 move $a2, $t2 # columns
   	 move $a3, $t3 # row
   	 addi $sp, $sp, -8
   	 sw $t4, 0($sp) # column
    	 sw $ra, 4($sp) # the return address
   	 jal get_slot
   	 lw $t4, 0($sp) # column
   	 lw $ra, 4($sp)
   	 move $t7, $v0 # retrieve the piece taken from the method, do not need the turn number
   	 addi $sp, $sp, 8 # return the value back to the stack
   	 move $v0, $t7 # set the return value to the character found
         j done_check
   	 no_win:
   	 
   	 continue_check:

	addi $t4, $t4, 1  # j++
	blt $t4, $t2, col_loop_check
	col_loop_done_check:

	addi $t3, $t3, 1  # i++
	blt $t3, $t1, row_loop_check

	row_loop_done_check:
    

    
    li $v0, 46 # if there is nothing found then a "." is returned
   
    done_check:
    jr $ra

check_horizontal_winner:

   # (char piece, int turn) get_slot(slot[][] board, int num_rows, int num_cols, int row, int col)
   # v0: returns a 1 if there are three pieces to the right that are the same and 0 if there are not 
   
    	move $t0, $a0	# load the board into t0
	move $t1, $a1	# load the number of rows into t1
	move $t2, $a2	# lods the number of columns into t2
	move $t4, $a3	# loads the row into t4
	lw $t5, 0($sp)	# lods the column into t5
	li $t7, 0 # not really needed but whatever
	
	#algorithm to retrieve the correct memory address
	mul $t7, $t4, $t2 # i * num_columns	(in this case i is the row)
	add $t7, $t7, $t5 # i * num_columns + j (in this case j is the column)
	sll $t7, $t7, 1   # 4*(i * num_columns + j)  Mult by 4 b/c we have an array of 4-byte words
	add $t7, $t7, $t0 # base_addr + 4*(i * num_columns + j), t7 now has the memory address that we need
	
	lb $t8, 0($t7) # retrieving the ascii of the location called
	addi $t7, $t7, 2 # retrieves the ascii character the piece to the right
	beq, $t8, 0, not_a_win
	
	lb $t9, 0($t7) # load t8 to compare (t8 == t9)
	addi $t7, $t7, 2
	bne $t8, $t9, not_a_win # compare ascii character 1 and 2
	lb $t8, 0($t7)
	addi $t7, $t7, 2
	bne $t8, $t9, not_a_win # compare ascii character 2 and 3
	lb $t9, 0($t7)
	addi $t7, $t7, 2
	bne $t8, $t9, not_a_win # compare ascii character 3 and 4    	
        j four_in_a_row	
    
    not_a_win:
    li $v0, 0
    j end_horizontal_check
    four_in_a_row:
    li $v0, 1
    end_horizontal_check:
    jr $ra

check_vertical_winner:

   # (char piece, int turn) get_slot(slot[][] board, int num_rows, int num_cols, int row, int col)
   # v0: returns a 1 if there are three pieces to the right that are the same and 0 if there are not 
   
    	move $t0, $a0	# load the board into t0
	move $t1, $a1	# load the number of rows into t1
	move $t2, $a2	# lods the number of columns into t2
	move $t4, $a3	# loads the row into t4
	lw $t5, 0($sp)	# lods the column into t5
	li $t7, 0 # not really needed but whatever
	
	#algorithm to retrieve the correct memory address
	mul $t7, $t4, $t2 # i * num_columns	(in this case i is the row)
	add $t7, $t7, $t5 # i * num_columns + j (in this case j is the column)
	sll $t7, $t7, 1   # 4*(i * num_columns + j)  Mult by 4 b/c we have an array of 4-byte words
	add $t7, $t7, $t0 # base_addr + 4*(i * num_columns + j), t7 now has the memory address that we need
	
	lb $t8, 0($t7) # retrieving the ascii of the location called
	beq, $t8, 0, not_a_win_vertical
	
	move $t3, $t2 # copies the number of columns into t3
	sll $t3, $t3, 1 # multiplies the amount of columns by 2, this is the value that needs to be added
	add $t7, $t7, $t3
	
	lb $t9, 0($t7) # load t8 to compare (t8 == t9)
	add $t7, $t7, $t3
	bne $t8, $t9, not_a_win_vertical # compare ascii character 1 and 2
	lb $t8, 0($t7)
	add $t7, $t7, $t3
	bne $t8, $t9, not_a_win_vertical # compare ascii character 2 and 3
	lb $t9, 0($t7)
	add $t7, $t7, $t3
	bne $t8, $t9, not_a_win_vertical # compare ascii character 3 and 4    	
        j four_in_a_row_vertical	
    
    not_a_win_vertical:
    li $v0, 0
    j end_horizontal_check_vertical
    four_in_a_row_vertical:
    li $v0, 1
    end_horizontal_check_vertical:
    jr $ra

##############################
# EXTRA CREDIT FUNCTION
##############################


check_diagonal_winner:
    
      # char check_winner(slot[][] board, int num_rows, int num_cols)

    move $t0, $a0
    move $t1, $a1
    move $t2, $a2
    
    # need to check these values for every single value in the board
    
    # check characters to the left
    # check characters to the right
    # check characters to the bottom
    # check character to the left

    # call the get method on every single piece
    
    li $t3, 0  # i, row counter
    row_loop_diagonal:
	li $t4, 0  # j, column counter
    col_loop_diagonal:
   
      	########################################################
   	# check to see if the horizontal directions had a winner
   	########################################################
   
   	# need to save board, rows, cols, t3 and t4 onto the stack
   	addi $sp, $sp, -20
   	sw $t0, 0($sp) # store board
   	sw $t1, 4($sp) # store rows
   	sw $t2, 8($sp) # store cols
   	sw $t3, 12($sp) # store row counter
   	sw $t4, 16($sp) # store col counter    	
	# this is where we need to call the get_slot for every value combination of i and  j
	# (char piece, int turn) get_slot(slot[][] board, int num_rows, int num_cols, int row, int col)
   	 move $a0, $t0 # the matrix
    	 move $a1, $t1 # rows
   	 move $a2, $t2 # columns
   	 move $a3, $t3 # row
   	 addi $sp, $sp, -8
   	 sw $t4, 0($sp) # column
    	 sw $ra, 4($sp) # the return address
   	 jal check_diagonal
   	 lw $t4, 0($sp) # column
   	 lw $ra, 4($sp)
   	 move $t7, $v0 # retrieve the piece taken from the method, do not need the turn number
   	 addi $sp, $sp, 8 # return the value back to the stack
	# load back the values that were stores on the stack
   	lw $t0, 0($sp) # store board
   	lw $t1, 4($sp) # store rows
   	lw $t2, 8($sp) # store cols
   	lw $t3, 12($sp) # sre row counter
   	lw $t4, 16($sp) # store col counter
   	addi $sp, $sp, 20
   	
   	####################################
   	# check to see if there was a winner
   	####################################
   	
   	 beq $t7, 1, return_winner_diagonal
   	 
   	##########################################
   	# jumps to this code if a winner was found
   	##########################################
   	    	     	 
   	 j no_win_diagonal
   	 return_winner_diagonal:
   	 # this is the part where we call the get_slot method to find the character that there is four in a row of
   	
   	 move $a0, $t0 # the matrix
    	 move $a1, $t1 # rows
   	 move $a2, $t2 # columns
   	 move $a3, $t3 # row
   	 addi $sp, $sp, -8
   	 sw $t4, 0($sp) # column
    	 sw $ra, 4($sp) # the return address
   	 jal get_slot
   	 lw $t4, 0($sp) # column
   	 lw $ra, 4($sp)
   	 move $t7, $v0 # retrieve the piece taken from the method, do not need the turn number
   	 addi $sp, $sp, 8 # return the value back to the stack
   	 move $v0, $t7 # set the return value to the character found
         j done_check_diagonal
   	 no_win_diagonal:
   	 
   	 continue_check_diagonal:

	addi $t4, $t4, 1  # j++
	blt $t4, $t2, col_loop_diagonal
	col_loop_done_diagonal:

	addi $t3, $t3, 1  # i++
	blt $t3, $t1, row_loop_diagonal

	row_loop_done_diagonal:
    

    
    li $v0, 46 # if there is nothing found then a "." is returned
   
    done_check_diagonal:
    jr $ra
    
check_diagonal:

# (char piece, int turn) get_slot(slot[][] board, int num_rows, int num_cols, int row, int col)
   # v0: returns a 1 if there are three pieces to the right that are the same and 0 if there are not 
   
    	move $t0, $a0	# load the board into t0
	move $t1, $a1	# load the number of rows into t1
	move $t2, $a2	# lods the number of columns into t2
	move $t4, $a3	# loads the row into t4
	lw $t5, 0($sp)	# lods the column into t5
	li $t7, 0 # not really needed but whatever
	
	#algorithm to retrieve the correct memory address
	mul $t7, $t4, $t2 # i * num_columns	(in this case i is the row)
	add $t7, $t7, $t5 # i * num_columns + j (in this case j is the column)
	sll $t7, $t7, 1   # 4*(i * num_columns + j)  Mult by 4 b/c we have an array of 4-byte words
	add $t7, $t7, $t0 # base_addr + 4*(i * num_columns + j), t7 now has the memory address that we need
	
	lb $t8, 0($t7) # retrieving the ascii of the location called
	beq, $t8, 0, not_a_win_diagonal # need to make sure that even if they are the same, they are not 0's
	beq  $t8, 48, not_a_win_diagonal
	
	# create the value to increment by to check diagonals
	move $t3, $t2 # copies the number of columns into t3
	sll $t3, $t3, 1 # multiplies the amount of columns by 2
	addi $t3, $t3, 2
	add $t7, $t7, $t3 
	
	# check the diagonals in the bottom left to top right direction 
	lb $t9, 0($t7) # load t8 to compare (t8 == t9)
	add $t7, $t7, $t3
	bne $t8, $t9, not_a_win_diagonal_1 # compare ascii character 1 and 2
	lb $t8, 0($t7)
	add $t7, $t7, $t3
	bne $t8, $t9, not_a_win_diagonal_1 # compare ascii character 2 and 3
	lb $t9, 0($t7)
	add $t7, $t7, $t3
	bne $t8, $t9, not_a_win_diagonal_1 # compare ascii character 3 and 4
	
	j four_in_a_row_diagonal
	
	
	not_a_win_diagonal_1:
	# check the diagonals in the top left to bottom right direction
	# reset the value of t7
	#algorithm to retrieve the correct memory address
	li $t7 , 0
	mul $t7, $t4, $t2 # i * num_columns	(in this case i is the row)
	add $t7, $t7, $t5 # i * num_columns + j (in this case j is the column)
	sll $t7, $t7, 1   # 4*(i * num_columns + j)  Mult by 4 b/c we have an array of 4-byte words
	add $t7, $t7, $t0 # base_addr + 4*(i * num_columns + j), t7 now has the memory address that we need
	
	
	# check the diagonals in the bottom left to top right direction
	lb $t8, 0($t7) # load t8 to compare (t8 == t9)
	add $t7, $t7, $t3
	lb $t9, 0($t7) # load t8 to compare (t8 == t9)
	add $t7, $t7, $t3
	bne $t8, $t9, not_a_win_diagonal # compare ascii character 1 and 2
	lb $t8, 0($t7)
	add $t7, $t7, $t3
	bne $t8, $t9, not_a_win_diagonal # compare ascii character 2 and 3
	lb $t9, 0($t7)
	add $t7, $t7, $t3
	bne $t8, $t9, not_a_win_diagonal # compare ascii character 3 and 4    	    	    	    	
	    	    	    	    	    	    	    	    	    	    	    	    	
        j four_in_a_row_diagonal	
    
    not_a_win_diagonal:
    li $v0, 0
    j end_horizontal_check_diagonal
    four_in_a_row_diagonal:
    li $v0, 1
    end_horizontal_check_diagonal:
    jr $ra



##############################################################
# DO NOT DECLARE A .DATA SECTION IN YOUR HW. IT IS NOT NEEDED
##############################################################


