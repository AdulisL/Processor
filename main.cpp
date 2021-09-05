#include <stdio.h>
#include <iostream>
#include <string.h>
#include <fstream>
#define MESSAGE_END   128
#define MESSAGE_START  64
#define LFSR_START 63
#define LFSR_TAP 62
#define PRE_SPACE 61
#define MINCOUNT 10
#define MAXCOUNT 15
#define SPACE 0x20
using namespace std;
typedef unsigned char byte;      // 8-bit
typedef unsigned int position;
typedef unsigned int amount;

// 9 candidate maximal 7-bit LFSR tap ptrns
const char LFSR_ptrn[] = {0x60, 0x48, 0x78, 0x72, 0x6A, 0x69, 0x5C, 0x7E, 0x7B};

//Get the nth position LFSR
byte get(byte b, position p){
    return (b & (1 << p)) >> p; // extracting bit
}

// Set the nth position LFSR
byte set(byte b, position p, amount n){
    position mask = 1 << p;
    return b & ~mask | ((n << p) & mask);  //
}

// LFSR
byte lfsr_state(byte b, byte tap){
    if(tap > 0x08) tap = tap & 0x07;
    // start tap pattern
    switch (tap) {
        case 0x01:
            tap = get(b, LFSR_ptrn[6]) ^ get(b, LFSR_ptrn[3]);
            cout << "tap: 0x01: " << tap << endl;
            break;
        case 0x02:
            tap = get(b, LFSR_ptrn[6]) ^ get(b, LFSR_ptrn[5]) ^ get(b, LFSR_ptrn[4])
                  ^ get(b, LFSR_ptrn[3]);
            cout << "tap: 0x02: " << tap << endl;
            break;
        case 0x03:
            tap = get(b, LFSR_ptrn[6]) ^ get(b, LFSR_ptrn[5]) ^ get(b, LFSR_ptrn[4])
                  ^ get(b, LFSR_ptrn[1]);
            cout << "tap: 0x03: " << tap << endl;
            break;
        case 0x04:
            tap = get(b, LFSR_ptrn[6]) ^ get(b, LFSR_ptrn[5]) ^ get(b, LFSR_ptrn[3])
                  ^ get(b, LFSR_ptrn[1]);
            cout << "tap: 0x04: " << tap << endl;
            break;
        case 0x05:
            tap = get(b, LFSR_ptrn[6]) ^ get(b, LFSR_ptrn[5]) ^ get(b, LFSR_ptrn[3])
                  ^ get(b, LFSR_ptrn[0]);
            cout << "tap: 0x05: " << tap << endl;
            break;
        case 0x06:
            tap = get(b, LFSR_ptrn[6]) ^ get(b, LFSR_ptrn[4]) ^ get(b, LFSR_ptrn[3])
                  ^ get(b, LFSR_ptrn[2]);
            cout << "tap: 0x06: " << tap << endl;
            break;
        case 0x07:
            tap = get(b, LFSR_ptrn[6]) ^ get(b, LFSR_ptrn[5]) ^ get(b, LFSR_ptrn[4])
                  ^ get(b, LFSR_ptrn[3]) ^ get(b, LFSR_ptrn[2]) ^ get(b, LFSR_ptrn[1]);
            cout << "tap: 0x07: " << tap << endl;
            break;
        case 0x08:
            tap = get(b, LFSR_ptrn[6]) ^ get(b, LFSR_ptrn[5]) ^ get(b, LFSR_ptrn[4])
                  ^ get(b, LFSR_ptrn[3]) ^ get(b, LFSR_ptrn[1]) ^ get(b, LFSR_ptrn[0]);
            cout << "tap: 0x08: " << tap << endl;
            break;
        default:
            tap = get(b, LFSR_ptrn[6]) ^ get(b, LFSR_ptrn[5]);
            cout << "tap: 0x00: " << tap << endl;
    }// end of tap patterns

    b = b << 1; //lfsr_state
    set(b, 0, (amount) tap);
    return b;
}

byte lfsr_function(byte input){
      return input =  (input << 1) ^ (input & LFSR_ptrn[0]);

}

char *encrypt (char * message){
    int i;
    int str_len = strlen(message); // incoming string length
    int LFSR_init; // one of 127 possible NONZERO starting
    char lfsr_state[MESSAGE_START]; // states of program 1 encrypting LFSR
    char msg_padded[MESSAGE_START]; // original message, plus pre/post padding
    char msg_encrypto[MESSAGE_START]; // encrypted message according to the DUT
    int pre_length; // space char bytes before first char in message (10 -> 15)
    unsigned char b;

    // now select a starting LFSR state - any nonzero value will do
    LFSR_init = rand() >> 2;
    if(!LFSR_init) LFSR_init = 0x01; // prevents illegal starting state = 7'b0
    lfsr_state[0] = LFSR_init;  // any nonzero value (zero may be helpful for debug)

    // Setting up number of prepending space char
    pre_length = rand() >> MINCOUNT;
    if(pre_length < MINCOUNT) pre_length = MINCOUNT; // prevents pre_length < 10
    else if(pre_length > MAXCOUNT) pre_length = MAXCOUNT;

    // Step_1: Pre-fill message padded with ASCII 0x20
    for (i = 0; i < MESSAGE_START; i++) {
        msg_padded[i] = SPACE;
    }

    // Step_2: Overwrite up to 54 of these spaces w/ message itself
    for (i = 0; i < str_len; i++) {
        msg_padded[pre_length+i] = message[i]; // load the message
    }

    // Step_3: Compute and store the LFSR sequence
    for(i = 0; i < LFSR_START; i++){
//        lfsr_state[i+1] = lfsr_function(lfsr_state[i]);
        lfsr_state[i + 1] = (lfsr_state[i] << 1) ^ (lfsr_state[i] &
        LFSR_ptrn[0]);
    }

    // Step_4: Encrypt the message character-by-character, then prepend parity
    for (i = 0; i < MESSAGE_START; i++) {
        msg_encrypto[i] = msg_padded[i] ^ lfsr_state[i];
    }
    return msg_encrypto;
}

int main() {
    // Initiation of Data
    int msg_len = 0;
    char *message = "Mr. Watson, come here. I want to see you.";
    char *encrypted;
    char *read = "";
    char c;
    int len = strlen(message);
    int arr_len_taps = sizeof(LFSR_ptrn); // 9-LFSR_ptrn

    ifstream to_read("test_in.txt"); // file to read
    ofstream to_write("test_out.txt"); // file to write
    if(!to_read.is_open()) cout << "File to READ not found." << endl;
    else{
        while(!to_read.eof()){
            read[msg_len] = to_read.get();
            msg_len++;
        }
        msg_len--;
        cout << "Test reached line 155" << endl;
    }
    to_read.clear();

    // Encryption
//    encrypted = encrypt(message);
//    encrypted = message;


    // Test for accessing DM
//    for (i = 0; i < len; i++) // sizeof(message)/message[0]
//        {
//        printf("Tap[%d]: %c \n", i, *encrypted);
//        encrypted++;
//        }

    if(!to_write.is_open()) cout << "File to WRITE not opened." << endl;
    else{
        while(*read != '\377'){
            cout << *read;
            to_write.put(*read);
            read++;
        }
        cout << endl;
    }

    to_read.close();
    to_write.close();
    printf("\nTest for reaching end line!");
    return 0;
}
