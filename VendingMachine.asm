# lab6.asm
# Angelina Castillo
# Vending machine program depicting a vending machine for the zombie apocalypse

	.intel_syntax noprefix
	.data

VendingMachine:
		.ascii	"Zombie Apocalypse Resources Vending Machine\n\n\0"
	
Baseballbat:
	        .ascii	"1.Baseball Bat ($100)\n\0)"
Katana:
	        .ascii	"2.Katana ($500)\n\0"
Candybar:
	        .ascii	"3.Candy bar ($350)\n\0"
Hotsauce:
	        .ascii	"4.Hot Sauce ($300)\n\0"
CancelOrder:
		.ascii	"5.Cancel the order ($0)\n\0"
Moneyprompt:
		.ascii	"How much money was inserted?\n\0"
Moneyin:
		.quad	0
Entersel:
		.ascii	"Enter your selection:\n\0"
Selected:
		.ascii	"\nYou selected:\n\0"
Change:
		.ascii	"\nYour change is \0"
Dollars:
		.ascii	" dollars\n\0"

Items:
	.quad	Baseballbat
	.quad	Katana
	.quad	Candybar
	.quad	Hotsauce
	.quad	CancelOrder
Costs:
	.quad	100
	.quad	500
	.quad	350
	.quad	300
	.quad	0

.text
.global	_start
	
_start:
	
	lea	rbx, VendingMachine		#Printing vending machine name and items
	call	PrintCString
	lea	rbx, Baseballbat
	call	PrintCString
	lea	rbx, Katana
	call	PrintCString
	lea	rbx, Candybar
	call	PrintCString
	lea	rbx, Hotsauce
	call	PrintCString
	lea	rbx, CancelOrder
	call	PrintCString	

						#input from user
	lea	rbx, Moneyprompt
	call	PrintCString
	call	ScanInt
	mov	Moneyin, rbx	#amount saved in Moneyin variable

	#selection and print of item
	jmp	SelectingItem

	call	EndProgram

SelectingItem:
	lea     rbx, Entersel
	call    PrintCString
	call    ScanInt
	mov     rax, rbx
	cmp	rax, 0			#checks if rax is 0
	jle	SelectingItem	
	cmp	rax, 6			# there are 5 items. Checks if selection is out of range
	jge	SelectingItem

	sub	rax, 1			# Checks it user has enough money to spend on selected item
	mov     rbx, [Costs + rax * 8]
	cmp	Moneyin, rbx
	jl	SelectingItem	# if selection is valid but money is not, return to the beginning of the loop
	
	jmp	PrintItem

PrintItem:
	# after passing tests to make sure selection and money amount is valid, print the item 
	lea     rbx, Selected
	call    PrintCString
	mov     rbx, [Items + rax * 8]
	call    PrintCString
	
	jmp	Moneyleft
	
Moneyleft:
	# Relay the change prompt to let the user know how much money they have left
	lea	rbx, Change
	call	PrintCString

	mov     rbx, [Costs + rax * 8]
	sub	Moneyin, rbx
	
	mov	rbx, Moneyin
	call	PrintInt
	lea	rbx, Dollars
	call	PrintCString
	
	call	EndProgram
