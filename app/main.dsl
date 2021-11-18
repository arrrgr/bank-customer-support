import "commonReactions/all.dsl";

context 
{
    // declare input variables phone and name  - these variables are passed at the outset of the conversation. In this case, the phone number and customer’s name 
    input phone: string;

    // declare storage variables 
    output first_name: string = "";
    output last_name: string = "";

}

// declaring external functions


start node root 
{
    do 
    {
        #connectSafe($phone);
        #waitForSpeech(1000);
        #sayText("Hi, welcome to Chase Bank, my name is Dasha, may I have your name please?");
        wait *;
    }   
    transitions 
    {

    }
}

digression how_may_i_help
{
    conditions {on #messageHasData("first_name");} 
    do 
    {
        set $first_name =  #messageGetData("first_name")[0]?.value??"";
        set $last_name =  #messageGetData("last_name")[0]?.value??"";
        #sayText("Awesome, nice to meet you " + $first_name + ", how may I assist you today?");
        wait *;
    }
}

digression debit_card_intenational_student

{
    conditions {on #messageHasIntent("international_student") and #messageHasIntent("debit_card");} 
    do
    {
        #sayText("You can definitely open a checking account with us.");
        wait *;
    }   
}

digression open_debit_docs_needed
{
    conditions {on #messageHasIntent("open_debit_docs_needed");} 
    do 
    {     
        #sayText("Oh that's an easy part. You’ll just need two forms of valid IDs. That's it!"); 
        wait*;
    }
}

digression how_soon_receive_debit_card
{
    conditions {on #messageHasIntent("how_soon_receive_debit_card");} 
    do 
    {     
        #sayText("Generally speaking, you’ll get it within three to five business days. Doesn't usually take any longer than that. You'll have your debit card in no time is what I'm trying to say."); 
        wait*;
    }
}


digression debit_via_mail
{
    conditions {on #messageHasIntent("debit_via_mail");} 
    do 
    {     
        #sayText("Yes. Unfortunately, the card can be only sent to the address you specify. There’s no option to pick it up at the bank."); 
        wait*;
    }
}

digression debit_card_cashback
{
    conditions {on #messageHasIntent("debit_card_cashback");} 
    do 
    {     
        #sayText("Um yes, some merchants will offer you cashback. As of now, that's the only way of geting cashback."); 
        wait*;
    }
}

digression international_student_credit_card
{
    conditions {on #messageHasIntent("credit_card");} 
    do
    {
        #sayText("Oh certainly, we offer Freedom student card and it’s definitely welcome for any international student to have.");
        wait *;
    }   
}

node no_ssn
{
    do 
    {     
        #sayText("Are you currently applying for one?"); 
        wait*;
    }
    transitions
    {
        ssn_explain: goto ssn_explain on #messageHasIntent("no");
    }
}

node ssn_explain
{
    do 
    {     
        #sayText("You would need one, or you’d need to apply for one in order to apply for a credit card application. And if you apply for the SSN and get a confirmation letter then we can use that as well. So you would need an I-10 or the social."); 
        wait*;
    }
}

digression fees_associated_credit
{
    conditions {on #messageHasIntent("fees_associated_credit");} 
    do 
    {     
        #sayText("Nope, no fees at all."); 
        wait*;
    }
}

digression documents_apply_credit
{
    conditions {on #messageHasIntent("documents_apply_credit");} 
    do 
    {     
        #sayText("Okay, absolutely. In most cases we would require to provide verification of your name, date of birth, and social security number. It can be a social security card or if you have an I-10 that works too. And for the address we’d need like a lease or a rental agreement, utility bill or a bank statement."); 
        wait*;
    }
    transitions
    {
        no_ssn: goto no_ssn on #messageHasIntent("no_ssn");
    }
}

digression credit_monthly_fee
{
    conditions {on #messageHasIntent("credit_monthly_fee");} 
    do 
    {     
        #sayText("There might be an annual fee depending on the type of card you decide to apply for. Like for example Chase Freedom cards and Freedom Student cards don’t have any fee.."); 
        wait*;
    }
}

digression debit_monthly_fee
{
    conditions {on #messageHasIntent("debit_monthly_fee");} 
    do 
    {     
        #sayText("With debit cards you might pay a twelve-dollar monthly fee but if you keep a certain amount on your card, you wouldn’t have to pay that fee."); 
        wait*;
    }
}

digression how_long_receive_credit_card
{
    conditions {on #messageHasIntent("how_long_receive_credit_card");} 
    do 
    {     
        #sayText("Gotcha. It might take around one to two weeks but if you expedite it, you can get it within one or two business days."); 
        wait*;
    }
}

digression expedited_paid
{
    conditions {on #messageHasIntent("expedited_paid");} 
    do 
    {     
        #sayText("It’s absolutely free."); 
        wait*;
    }
}

digression how_long_expedited
{
    conditions {on #messageHasIntent("how_long_expedited");} 
    do 
    {     
        #sayText("It depends of the verification process mainly. They can take up to 30 days to process your application, or they can even process it within an hour or minute. So it depends.."); 
        wait*;
    }
}

digression can_help_else
{
    conditions {on #messageHasIntent("got_you");} 
    do 
    {     
        #sayText("Is there anything else I can help you with today?"); 
        wait*;
    }
}


digression thats_it_bye
{
    conditions {on #messageHasIntent("thank_you") or #messageHasIntent("that_would_be_it");} 
    do 
    {     
        #sayText("No problem, happy to help. I hope you have a great rest of your day. Bye!"); 
        #disconnect();
        exit;
    }
}


//final and additional 

digression can_help 
{
    conditions {on #messageHasIntent("need_help");} 
    do
    {
        #sayText("How can I help you?");
        wait*;
    }
}


// additional digressions 

digression how_are_you
{
    conditions {on #messageHasIntent("how_are_you");}
    do 
    {
        #sayText("I'm well, thank you!", repeatMode: "ignore");
        #repeat(); // let the app know to repeat the phrase in the node from which the digression was called, when go back to the node 
        return; // go back to the node from which we got distracted into the digression 
    }
}

digression bye 
{
    conditions { on #messageHasIntent("bye"); }
    do 
    {
        #sayText("Sorry we didn't see this through. Call back another time. Bye!");
        #disconnect();
        exit;
    }
}
