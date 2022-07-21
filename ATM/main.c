#include <at89c5131.h>
#include "endsem.h"

char S_str[5]= {49,48,48,48,48};   //String for Balance Sita
char G_str[5] = {49,48,48,48,48};  //String for Balance Gita
char a_str[5] = {0,0,0,0,0};
char n500_s[2]= {0,0};    // STRING FOR 500RS NOTE
char n100_s[2]= {0,0};    // STRING FOR 100RS NOTE
char p1[5] = {"E","E","3","3","7"};
char p2[5] = {"U","P","L","A","B"};

char password[5] = {0,0,0,0,0} ;   //PASSWORD ARRAY
//Main function

//-------------------------------------------------
void main(void)
{
	  uart_init();            // Please finish this function in endsem.h 
    while (1)
    {
      // YOUR CODE GOES HERE
			bool pstate = true;
			unsigned char ch = 0;
			unsigned char acc_no = 0;
			unsigned char val1 = 0;
			unsigned char val2 = 0;
			unsigned int i;
			unsigned int money1 = 0;
			unsigned int money2 = 0;
			int balance = 0;
			unsigned int n500 = 0;
			unsigned int n100 = 0;
			// Initial State
			transmit_string("Press A for Account display and W for withdrawing cash\r\n");
			ch = receive_char();
			if (ch == 'a' | ch == 'A'){
				// Account Display
				transmit_string("Hello, Please enter Account Number\r\n");
				acc_no = receive_char();
				if (acc_no == '1'){
					// Sita
					transmit_string("Please enter password:\r\n");
					for(i=0;i<5;i++){
						ch = receive_char();
						if(ch != p1[i]){pstate = false;}
					}
					if(pstate){
					transmit_string("Account Holder: Sita\r\n");
					transmit_string("Account Balance: ");
					//transmit_string(S_str);
					for(i=0;i<5;i++){transmit_char(S_str[i]);}
					transmit_string("\r\n");
				  }
				}
				else if (acc_no == '2'){
					// Gita
					transmit_string("Account Holder: Gita\r\n");
					transmit_string("Account Balance: ");
					//transmit_string(G_str);
					for(i=0;i<5;i++){transmit_char(G_str[i]);}
					transmit_string("\r\n");
				}
				else{
					transmit_string("No such account, please enter valid details\r\n");
				}		
			}
			else if (ch == 'w' | ch == 'W'){
				// Withdraw Cash
				transmit_string("Withdraw state, enter account number\r\n");
				acc_no = receive_char();
				if (acc_no == '1' | acc_no == '2'){
					// Sita or Gita
					if (acc_no == '1'){
						// Sita
						transmit_string("Account Holder: Sita\r\n");
						transmit_string("Account Balance: ");
						for(i=0;i<5;i++){transmit_char(S_str[i]); a_str[i] = S_str[i];}
						transmit_string("\r\n");
				  }
					else{
						// Gita
						transmit_string("Account Holder: Gita\r\n");
						transmit_string("Account Balance: ");
						for(i=0;i<5;i++){transmit_char(G_str[i]); a_str[i] = G_str[i];}
						transmit_string("\r\n");
					}
					
					transmit_string("Enter Amount, in hundreds\r\n");
					val1 = receive_char();
					val2 = receive_char();
					if((val1 >= 48 && val1 <= 57) && (val2 >=48 && val2 <=57)){
						// Valid Amount
						if(val1 > a_str[1] && a_str[0] == 48){
							transmit_string("Insufficient Funds\r\n");
						}
						else if(val1 == a_str[1] && val2 > a_str[2] && a_str[0] == 48){
							transmit_string("Insufficient Funds\r\n");
						}
						else{
							// Transaction Possible
							money1 = money1 + (a_str[0]-48)*10000;
							money1 = money1 + (a_str[1]-48)*1000;
							money1 = money1 + (a_str[2]-48)*100;
							money1 = money1 + (a_str[3]-48)*10;
							money1 = money1 + (a_str[4]-48)*1;
							money2 = (val1 - 48)*1000 + (val2 - 48)*100;
							//money1 = money1 - money2;
							balance = money1-money2;
              transmit_string("Remaining Balance: ");
							int_to_string(balance, a_str);
							for(i=0;i<5;i++){transmit_char(a_str[i]);}
							transmit_string("\r\n");
							transmit_string("500 Notes: ");
							n500 = (val1 - 48)*2 + (val2 - 48)/5;
							n100 = (val2 - 48)%5;
							n500_s[0] = 48 + n500/10;
							n500_s[1] = 48 + n500%10;
							n100_s[0] = 48;
							n100_s[1] = 48 + n100;
							
							
							for(i=0;i<2;i++){transmit_char(n500_s[i]);}
							transmit_string(", 100 Notes: ");
							for(i=0;i<2;i++){transmit_char(n100_s[i]);}
							transmit_string("\r\n");
						}
					}
					else{transmit_string("Invalid Amount\r\n");}
				}
				else{
					transmit_string("No such account, please enter valid details\r\n");
				}		
				if (acc_no == '1'){
					for(i=0;i<5;i++){S_str[i] = a_str[i];}
				}
				else{
					for(i=0;i<5;i++){G_str[i] = a_str[i];}
				}
			}
			else{
					// Invalid Entry
			}
		}
}


