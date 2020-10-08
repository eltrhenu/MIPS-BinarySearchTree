# MIPS-BinarySearchTree

## node_creation:<br />
	make sbrk syscal with 16 bytes for new node allocation
	then puts the value,left,right and parent adreess
	for a new node except value all will be 0

## build: <br />
	to loop in aray i initialize my array index 2 because i already created root outside the build function
	then if it dont come across -9999 value it will continue to go insert function

## insert:<br />
	for given value i will create new node for my insertation and save its address
	and check the value according to node value
	if  < go left child of node
	if  > go right child of node
	when find empty space to put  its own, insert_left or insert_right will store new node address
	to current node left or right child space
## find:<br />
	take the given value and check if it can be in right side or left side of node
	then continue check if it came across its equailent value(go to hallelujah) or no reamining
	child it is stop(goes exit_tree) and sets returning values with reuiqrements



## findMinMax:<br />
	check if given value 0 or 1 then goes min or max label according to given value
##	min:<br />
		for min go the leftest child it understand if there is no left child then it mean previous left is min(goes eureka)
##	max:<br />
		for max go the rightest child it understand if there is no right child then it mean previous right is max(goes eureka)
##	eureka:<br />
		loads needed values to return registers


