//
//  main.c
//  Vigenere Cipher Decryption
//
//  Created by anubhav choudhary on 2019-07-13.
//  Copyright © 2019 Anubhav Choudhary. All rights reserved.
//
#include <stdio.h>
#include <string.h>
char   cipherText[200] = "b\"eg!fhj!ikmk\"npnpr$qsuwuw#zxz|~";
int NO_CHAR_CHPHER(char*);


int NO_CHAR_CHPHER(char* cText)
{
    return strlen(cText);
    
}

int Space_count(int numberOfChar, char input[])
{
    int spaceCounter =0;
    for(int i=0; i < numberOfChar; i++)
    {
        if(input[i] == 32) //32 is ascii value of space
            spaceCounter++;
    }
    return spaceCounter;
}
void DECODE(int numberOfChar, int  key, char * cipherText, char * plainText)
{
    int j = 0;
    int i =0;
    int k = 0;
    int reverseOrderedKey[4];
    int n =4;
    int c =0;
    int d =0;
    int orderedKey[4] = {0,0,0,0};
    
    while(key)
    {
        
        reverseOrderedKey[k] = key %10;
        key /= 10;
        
        k++;
    }
    for (c = n - 1, d = 0; c >= 0; c--, d++)
        orderedKey[d] = reverseOrderedKey[c];
    
    for ( j=0; j <= 4; j++)
    {
        for( i=0; i<numberOfChar; i++)
        {{
            plainText[i] = cipherText[i] - orderedKey[j];
        }
            j += 1;
            if (j %4 == 0)   j = 0;
            
        }
        
        if (i == strlen(cipherText)) break;
        
    }
    
}
int main()
{
    char DECODE_STR[1000] = "Lx!ydw!vki!dhwu\"rj!vlqfu/$jv#{bu#xig#{ptvx!qi$ukpit.#mu\"zet\"wlf\"dkf\"rj!ylweqp0!kw$xcv$ujh$bih$ph#jpqomtjqitu/$jv#{bu#xig#iqqfl!qi$cgomfh/$jv#{bu#xig#iqqfl!qi$jpfvffxpjv|0!kw$xcv$ujh$tgdwpp#sg\"omhjw0!kw$xcv$ujh$tgdwpp#sg\"gesmqitu/$jv#{bu#xig#wqtlrh\"rj!jrtf.#mu\"zet\"wlf\"zmovhv!qi$egvtbku0!yh$icg$fxhvzvkmoi#ffhrvf\"xw-\"zi!jdh!prxikqk!dhjpth$vu/$xg#{fth$bno$hqlrh\"gmsgfx!vr$igdzfp/$xg#{fth$bno$hqlrh\"gmsgfx!vki!qwlft#{b{1$Jp#wiqux-\"wlf\"siskrh!ydw!ur$gcu$mkni!vki!ruitgqx!rhvjqg0!vkeu\"vsng#sg\"lxt\"qsjulitv#evvksskwmfu#moulwugg$pp#muu#ffkqk!thgfkyie.#jpt#kpqg$pt#jpt#iwko0!kq$ujh$twsisndxjxh$egjvfg#sg\"fsnrdvjurr!qqpz0";
    int numChar = NO_CHAR_CHPHER(DECODE_STR);
    int bestSpaces =0;
    int bestKey = 0;
    char plainText[1000];
    
    for (int key = 1000; key < 10000; key++)
    {
        DECODE(numChar, key, DECODE_STR, plainText);
        int numSpaces = Space_count(numChar, plainText);
        
        if (numSpaces > bestSpaces)
        {
            bestSpaces = numSpaces ;
            bestKey = key ;
            
            printf("numSpaces : %d, bestKey : %d, plainText  : %s",numSpaces, bestKey, plainText);
            printf("key : %d, numSpaces : %d\n", key, numSpaces);
            
        }
    }
}




