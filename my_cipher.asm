.data
    testKey: .word 1, 2, 3, 4		
    orderedKey: .word 0, 0, 0, 0
    reverseOrderedKey: .word 0, 0, 0, 0
    plainText: .space 1000
    cipherText: .asciiz "b\"eg!fhj!ikmk\"npnpr$qsuwuw#zxz|~"	#testting perpous 
    decryptStr: .asciiz "Lx!ydw!vki!dhwu\"rj!vlqfu/$jv#{bu#xig#{ptvx!qi$ukpit.#mu\"zet\"wlf\"dkf\"rj!ylweqp0!kw$xcv$ujh$bih$ph#jpqomtjqitu/$jv#{bu#xig#iqqfl!qi$cgomfh/$jv#{bu#xig#iqqfl!qi$jpfvffxpjv|0!kw$xcv$ujh$tgdwpp#sg\"omhjw0!kw$xcv$ujh$tgdwpp#sg\"gesmqitu/$jv#{bu#xig#wqtlrh\"rj!jrtf.#mu\"zet\"wlf\"zmovhv!qi$egvtbku0!yh$icg$fxhvzvkmoi#ffhrvf\"xw-\"zi!jdh!prxikqk!dhjpth$vu/$xg#{fth$bno$hqlrh\"gmsgfx!vr$igdzfp/$xg#{fth$bno$hqlrh\"gmsgfx!vki!qwlft#{b{1$Jp#wiqux-\"wlf\"siskrh!ydw!ur$gcu$mkni!vki!ruitgqx!rhvjqg0!vkeu\"vsng#sg\"lxt\"qsjulitv#evvksskwmfu#moulwugg$pp#muu#ffkqk!thgfkyie.#jpt#kpqg$pt#jpt#iwko0!kq$ujh$twsisndxjxh$egjvfg#sg\"fsnrdvjurr!qqpz0"
    msg1: .asciiz "numSpaces : "
    msg2: .asciiz ", bestKey : "
    msg3: .asciiz ", plainText  : "
    msg4: .asciiz "key : "
    msg5: .asciiz ", numSpaces : "
    newLine: .asciiz "\n"
.text
    main:
        # $s0 = numChar, $s1 = bestSpaces, $s2 = bestKey, $s3 = key, $s4 = numSpaces
        la $a0, decryptStr
	jal countNumberOfCharInCipher
	move $s0, $v0
	
	addi $s1, $zero, 0
	addi $s2, $zero, 0
	addi $s3, $zero, 1000
	addi $s4, $zero, 0
	loop:
	    move $a1, $s3
	    la $a2, decryptStr
	    move $a3, $s0
	    jal decrypt
	    
	    move $a0, $s0
	    la $a1, plainText
	    jal countSpaces
	    move $s4, $v0
	    
	    ble $s4, $s1, skip1
	    move $s1, $s4
	    move $s2, $s3
	    
	    # Print formatted output.
	    li $v0, 4
	    la $a0, msg1
	    syscall
	    li $v0, 1
	    move $a0, $s4
	    syscall
	    li $v0, 4
	    la $a0, msg2
	    syscall
	    li $v0, 1
	    move $a0, $s2
	    syscall
	    li $v0, 4
	    la $a0, msg3
	    syscall
	    li $v0, 4
	    la $a0, plainText
	    syscall
	    li $v0, 4
	    la $a0, msg4
	    syscall
	    li $v0, 1
	    move $a0, $s3
	    syscall
	    li $v0, 4
	    la $a0, msg5
	    syscall
	    li $v0, 1
	    move $a0, $s4
	    syscall
	    li $v0, 4
	    la $a0, newLine
	    syscall
	    skip1:
	    addi $s3, $s3, 1
	    blt $s3, 10000, loop
    	# End program.
        li $v0, 10
        syscall
        
    countNumberOfCharInCipher:
        # param: $a0 = text
        # $s1 = count
        # return: $v0 = length of text
        subi $sp, $sp, 12
        sw $s0, 0($sp)
        sw $s1, 4($sp)
        sw $ra, 8($sp)
        addi $s1, $zero, 0
        loop1:
            lb $s0, ($a0)
            beqz $s0, loop1_done
            addi $a0, $a0, 1
            addi $s1, $s1, 1
            b loop1
        loop1_done:
        move $v0, $s1
        lw $s0, 0($sp)
        lw $s1, 4($sp)
        lw $ra, 8($sp)
        addi $sp, $sp, 12
        jr $ra
        
    countSpaces:
        # param: $a0 = numberOfChar
        # param: $a1 = inputText
        # $s0 = i
        # $s1 = count
        # $s2 = input[i]
        # return: $v0 = number of spaces in inputText
        subi $sp, $sp, 16
        sw $s0, 0($sp)
        sw $s1, 4($sp)
        sw $s2, 8($sp)
        sw $ra, 12($sp)
        addi $s0, $zero, 0
        addi $s1, $zero, 0
    loop2:
            lb $s2, ($a1)
            bne $s2, ' ', skip2
            addi $s1, $s1, 1
    
    skip2:
            addi $a1, $a1, 1
            addi $s0, $s0, 1
            blt $s0, $a0, loop2
    loop2_done:
        move $v0, $s1
        lw $s0, 0($sp)
        lw $s1, 4($sp)
        lw $s2, 8($sp)
        lw $ra, 12($sp)
        addi $sp, $sp, 16
        jr $ra
        
    decrypt:
        # $a1 = key
        # $a2 = cipherText
        # $a3 = numberOfChar
        # $s0 = i, $s1 = j, $s2 = k
        # $s3 = n, $s4 = c, $s5 = d
        # $t0 = key % 10, $t2 = index of k
        subi $sp, $sp, 36
        sw $s0, 0($sp)
        sw $s1, 4($sp)
        sw $s2, 8($sp)
        sw $s3, 12($sp)
        sw $s4, 16($sp)
        sw $s5, 20($sp)
        sw $s6, 24($sp)
        sw $s7, 28($sp)
        sw $ra, 32($sp)
        addi $s0, $zero, 0
        addi $s1, $zero, 0
        addi $s2, $zero, 0
        addi $s3, $zero, 4
        addi $s4, $zero, 0
        addi $s5, $zero, 0
    loop3:
            beqz $a1, loop3_done
            rem $t0, $a1, 10
            sll $t2, $s2, 2
            sw $t0, reverseOrderedKey($t2)
            div $a1, $a1, 10
            addi $s2, $s2, 1
            b loop3
            
    loop3_done:
        subi $s4, $s3, 1
        
    loop4:
            blt $s4, $zero, loop4_done
            # $s6 = c index
            # $s7 = d index
            sll $s6, $s4, 2
            sll $s7, $s5, 2
            # $t1 = reverseOrderedKey[c]
            lw $t1, reverseOrderedKey($s6)
            sw $t1, orderedKey($s7)
            subi $s4, $s4, 1
            addi $s5, $s5, 1
            b loop4
    loop4_done:
        
        loop5:
            bgt $s1, 4, loop5_done
        loop6:
                bge $s0, $a3, loop6_done
                # plainText[i] = cipherText[i] - orderedKey[j];
                sll $t3, $s1, 2          # $t3 = index of j
                lb $t4, ($a2)            # cipherText[i]
                lw $t5, orderedKey($t3)  # orderedKey[j]
                sub $t6, $t4, $t5        # cipherText[i] - orderedKey[j]
                sb $t6, plainText($s0)
                addi $a2, $a2, 1
                addi $s1, $s1, 1
                # if (j % 4 == 0)   j = 0;
                rem $t7, $s1, 4
                bnez $t7, skip3
                addi $s1, $zero, 0
                skip3: 
                addi $s0, $s0, 1   
                b loop6
                
         loop6_done:
            # $t6 = null terminator
            addi $t6, $zero, 0
            sb $t6, plainText($s0)
            move $a0, $a2
            jal countNumberOfCharInCipher
            beq $s0, $v0, loop5_done
            addi $s1, $s1, 1
            b loop5
            
        loop5_done:
        lw $s0, 0($sp)
        lw $s1, 4($sp)
        lw $s2, 8($sp)
        lw $s3, 12($sp)
        lw $s4, 16($sp)
        lw $s5, 20($sp)
        lw $s6, 24($sp)
        lw $s7, 28($sp)
        lw $ra, 32($sp)
        addi $sp, $sp, 36
        jr $ra
        
