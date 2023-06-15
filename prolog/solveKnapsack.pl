% CSI 2120 – Comprehensive Assignment: Part 3 (Prolog)
% Author: Nicholas Gin (300107597)

% ////MAIN PREDICATE/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

% This is the predicate that is called by the user; it calls all other predicates to solve the knapsack problem and to produce a solution file.
% Take a Filename as input (the name of the file that will be read for the information about the items being considered in the knapsack problem)
% and outputs the total maximum value of the items that can be stored in the knapsack (Value) and the list of the names of the items that are stored 
% in the knapsack which contains the combination of items that maximizes the total value of the knapsack (L_items_list).
solveKnapsack(Filename, Value, L_items_list) :-

	% Read the contents of the file with the inputted Filename and, from the file, extract the number of items being considered (N_numberOfItems),
	% the names of each item being considered (L_items_name), the values of each item being considered (L_items_value), the weights
	% of each item being considered (L_items_weight), and the total capacity/weight that the knapsack can hold (N_capacity).
	readFile(Filename, N_numberOfItems, L_items_name, L_items_value, L_items_weight, N_capacity),

		% Now, we formulate the first row of the dynamic programming tables; each row is represented by a list.
		% For this implementation, we essentially are creating two dynamic programming tables, which are built concurrently and correspond.
		% One table will contain the maximum total value of the knapsack with capacity 0, 1, 2 up to the total capacity that the knapsack can hold.
		% The other table will contain lists consisting of the names of the items that the knapsack will contain for each iteration of the knapsack problem;
		% again for the knapsack with the capacity 0, 1, 2 up to the total capacity that the knapsack can hold.

		% The row number of the table represents the number of items we have or attempted to add to the knapsack (based on the order of the items
		% as dictated in the .txt file inputted by the user).
		% The number of columns in our dynamic programming table equals N_capacity + 1 (since each column in this table represents a total number
		% of items being contained in the knapsack; which ranges from 0 up to the total capacity of the knapsack).
		NumberOfColumns is N_capacity + 1,

		% Create a list containing only zeros; the number of zeros in this list will equal the NumberOfColumns.
		% This list represents the first row of the dynamic programming table that considers the total value of the knapsack for a given capacity
		% (which will always be a list of zeros, since when considering 0 items that can be added to the knapsack, the knapsack will always
		% have a total value of 0 for 0 items).
		fillZero(NumberOfColumns, FirstRow),

		% Create a list containing only [] (empty lists); the number of empty lists in this list will equal the NumberOfColumns.
		% This list represents the first row of the dynamic programming table that considers the list of names of each item in the knapsack for a given capacity
		% (which will always be an empty list, since when considering 0 items that can be added to the knapsack, the knapsack will never contain any items).
		fillEmptyLists(NumberOfColumns, FirstNameRow),

		% Call the knapsack predicate with the list of item values (L_items_value), list of item weights (L_items_weight), list of item names (L_items_name), 
		% the first row of the table considering the total value of the knapsack for a given capacity (FirstRow), the first row of the table considering 
		% the names of the items contained in the knapsack for a given capacity (FirstNameRow), the index of the first item that can be added to the knapsack (0), 
		% the index of the first column in the table (0), the maximum capacity that the knapsack can hold (N_capacity), and the number of items being considered 
		% in total (N_numberOfItems). The predicate shall output a list representing the final row of the table considering the total value of the knapsack 
		% for a given capacity (FinalRow) and a list representing the final row of the table considering the names of the items contained the knapsack 
		% for a given capacity (FinalNameRow).
		knapsack(L_items_value, L_items_weight, L_items_name, FirstRow, FirstNameRow, 0, 0, N_capacity, N_numberOfItems, FinalRow, FinalNameRow),

		% Since FinalRow is a list, the last value in this list is the maximum total value of items that can be stored in the knapsack (Value).
		last(FinalRow, Value),

		% Since FinalNameRow is a list, the last sublist in this list is the list of the names of the items that maximize the total value of 
		% the knapsack (L_items_list).
		last(FinalNameRow, L_items_list),

		% Call the writeFile predicate for Value and L_items_list separately (so that they are written on separate lines of the file); provide
		% the filename of the original file that contained the information about all of the items being considered as Filename for this predicate, so
		% the solution file can be created in the form of Filename.sol.
		writeFile(Value, Filename),
		writeFile(L_items_list, Filename),

		% Display to the user that the solution has been written.
		display("Solution file written.").


% ////READING CONTENTS FROM THE FILE/////////////////////////////////////////////////////////////////////////////////////////////////////////////

% This is the predicate that reads the contents of the file with the inputted Filename. From the file, it extracts the number of items
% being considered (N_numberOfItems), the names of each item being considered (L_items_name), the values of each item being considered
% (L_items_value), the weights of each item being considered (L_items_weight), and the total capacity/weight that the knapsack can hold (N_capacity).
readFile(Filename, N_numberOfItems, L_items_name, L_items_value, L_items_weight, N_capacity) :-
	% Open the file with the given Filename.
	open(Filename, read, Input),

	% The first line of the file provided by the user will always be the number of items that are being considered when solving the problem.
	% Read the first line of the file and remove any unnecessary whitespaces using split_string; this line is now a list (L_numberOfItems).
	read_string(Input, "\n", "\r", _, FirstLine),
	split_string(FirstLine, "  ", " ", L_numberOfItems),
	% Take the last and only element of L_numberOfItems as a string (S_numberOfItems) and convert it into a number (N_numberOfItems).
	last(L_numberOfItems, S_numberOfItems),
	atom_number(S_numberOfItems, N_numberOfItems),

	% Then call the readLine predicate to read every other line of the file with N_numberOfItems as a parameter.
	% N_numberOfItems indicates the number of lines in the file that readLine will read and extract item information from.
	% Receive L_file as output, which will be the list of sublists that represent the information about each item in the file.
	readLine(Input, N_numberOfItems, L_file),
	% Call the getInfoFromList on L_file to separate the information in each sublist into separate lists for the names of each item (L_items_name),
	% the values of each item (L_items_value) and the weights of each item (L_items_weight).
	getInfoFromList(L_file, L_items_name, L_items_value, L_items_weight),

	% The last line of the file (the line after the line with the information of the last item) will always be the maximum capacity 
	% that the knapsack can hold. Read the last line of the file and remove any unnecessary whitespaces using split_string; this line
	% is now a list (L_capacity).
	read_string(Input, "\n", "\r", _, LastLine),
	split_string(LastLine, "  ", " ", L_capacity),
	% Take the last and only element of L_capacity as a string (S_capacity) and convert it into a number (N_capacity).
	last(L_capacity, S_capacity),
	atom_number(S_capacity, N_capacity).

	% We now have extracted all the information about the items from the given file.

% This is the predicate we will use to read every line of the file that represents an item. Input indicates the Stream we are reading from.
% NumberOfItems indicates the number of lines this predicate will read from the file (the number of items we will extract information for).
% This predicate will output a list containing sublists that represent the information about each item in the file (L_file).
readLine(Input, NumberOfItems, [L_line|L_file]) :-
	% Only call this predicate when NumberOfItems > 0 (else, there are no more items to consider).
	NumberOfItems > 0, !,

	% Read the line of the file (as S_line).
	read_string(Input, "\n", "\r", _, S_line),

	% Split S_line at each space; the contents of this split are placed into a list (L_line).
	% L_line will always contain three elements.
    split_string(S_line, "  ", " ", L_line),

    % Add L_line to the list (L_file) that contains all sublists that represent the information about each item in the file.
    % L_line is effectively a sublist in L_file.
    % Then recursively call readLine with the NumberOfItems decremented by 1.
    readLine(Input, NumberOfItems-1, L_file).

readLine(_, _, []). % Base case

% This is the predicate that we will use to separate the information in each sublist of the list containing all of the information about
% the items (L_file) into separate lists for the names of each item (L_items_name), the values of each item (L_items_value) and 
% the weights of each item (L_items_weight).
getInfoFromList([], [], [], []). % Base case.

getInfoFromList([[Name, Value, Weight|_]|L_file], [C_Name|L_items_name], [N_Value|L_items_value], [N_Weight|L_items_weight]) :-
	% Consider the first sublist in L_file (we take the head sublist of this L_file).
	% Take the first element of the sublist (Name), convert it into a char (C_Name) and add it to L_items_name.
	string_chars(Name, C_Name),

	% Take the second element of the sublist (Value), convert it into a number (N_value) and add it to L_items_value.
	atom_number(Value, N_Value),

	% Take the third element of the sublist (Weight), convert it into a number (N_Weight) and add it to L_items_weight.
	atom_number(Weight, N_Weight),

	% Then repeat this process for every other sublist in L_file (by recursively calling this predicate using the tail we found earlier),
	% until we reach the base case (there are no more sublists to consider).
    getInfoFromList(L_file, L_items_name, L_items_value, L_items_weight).
% ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


% ////WRITING SOLUTION FILE//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
% Adapted from lecture slides (https://uottawa.brightspace.com/d2l/le/content/213483/viewContent/3528864/View):
% This is the predicate we will use to write to our solution file. X refers to the information that we will write to the solution file 
% and Filename refers to the name of the solution file.
writeFile(X, Filename) :- 
	% Remove the .txt from the inputted Filename, by calling split_string on Filename at the presence of the ".".
	% From the list outputted by split_string, take the head of this list (FilenameWithoutDot), as this is the Filename without .txt attached to it.
	split_string(Filename, ".", " ", [FilenameWithoutDot|_]),

	% The Filename of our solution will be Filename.sol; so concatenate .sol to FilenameWithoutDot. We now have the filename of our solution file.
	% (SolutionFilename).
	atom_concat(FilenameWithoutDot, '.sol', SolutionFilename),

	% Now we will start writing our solution information into the solution file (the file with the name indicated by SolutionFilename).
	open(SolutionFilename, append, F),
	write(F, X), 
	nl(F),
	close(F).
% ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


% ////FILLING THE KNAPSACK///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
% The predicates we will call to fill the knapsack in the knapsack problem.
% solveRow simulates the iteration along a row in the dynamic programming tables, and the insertion of values into this row.
% knapsack is used to recursively call solveRow to create each row in the tables.

% As parameters, knapsack takes the list of item values being considered (L_item_value), the list of item weights being considered (L_itemWeight),
% the list of item names being considered (L_itemName), the row of the dynamic programming table for item values that we will use to generate
% the next row in that table (PreviousRow), the row of the dynamic programming table for item names that we will use to generate the next row
% in that table (PreviousNameRow), the current item being considered represented by its ordering in the file (CurrentItemIndex), the current capacity
% of the knapsack being considered (CurrentCapacity), the maximum capacity that the knapsack will hold (MaxCapacity), and the number of times the knapsack
% predicate still needs to be recursively called/the number of rows in the tables that still need to be generated (Count).
% As output, we receive the last row of the table representing the item values (Z) and the last row of the table representing item names (A).

% Case 1:
knapsack(L_item_value, L_itemWeight, L_itemName, PreviousRow, PreviousNameRow, CurrentItemIndex, CurrentCapacity, MaxCapacity, Count, Z, A) :-
	% If Count is greater than 0...
	Count > 0, !,
	% Generate the current rows of each of the tables (X and Y) based on the rows provided (PreviousRow and PreviousNameRow) by calling solveRow...
	solveRow(L_item_value, L_itemWeight, L_itemName, PreviousRow, PreviousNameRow, CurrentItemIndex, CurrentCapacity, MaxCapacity, X, Y),
	% ...and then use those generated rows (X and Y) to generate the next rows of the table (Z and A) until we reach Case 2; decrement Count by 1.
	knapsack(L_item_value, L_itemWeight, L_itemName, X, Y, CurrentItemIndex + 1, CurrentCapacity, MaxCapacity, Count-1, Z, A).

% Case 2: If Count is 0, stop.
% The outputs are the inputs for the parameterized PreviousRow and the PreviousNameRow.
knapsack(_L_item_value, _L_itemWeight, _L_itemName, PreviousRow, PreviousNameRow, _CurrentItemIndex, _CurrentCapacity, _MaxCapacity, Count, PreviousRow, PreviousNameRow) :-
	Count =:= 0, !.


% The solveRow predicates are the predicates that are used to generate a row of the tables.
% As parameters, solveRow takes the list of item values being considered (L_item_value), the list of item weights being considered (L_itemWeight),
% the list of item names being considered (L_itemName), the row of the dynamic programming table for item values that we will use to generate
% the next row in that table (PreviousRow), the row of the dynamic progamming table for item names that we will use to generate the next row
% in that table (PreviousNameRow), the current item being considered represented by its ordering in the file (CurrentItemIndex), the current capacity
% of the knapsack being considered (CurrentCapacity), and the maximum capacity that the knapsack will hold (MaxCapacity).
% Each predicate will output the row of the value table that we are generating (NewRow) and the row of the item name table that we are generating (NewNameRow).

% Case 1:
% When the CurrentCapacity being considered is 0, add 0 to NewRow (as the total value when 0 items are placed in the knapsack is always 0).
% When the CurrentCapacity being considered is 0, add [] to NewNameRow (since 0 items are placed in the knapsack, there will be no item names).
solveRow(L_item_value, L_itemWeight, L_itemName, PreviousRow, PreviousNameRow, CurrentItemIndex, CurrentCapacity, MaxCapacity, [0|NewRow], [[]|NewNameRow]) :-
	CurrentCapacity =:= 0, !, % Conditions of Case 1 met.
	% Recursively call solveRow by incrementing CurrentCapacity by 1, so we can consider the next capacity that the knapsack can hold (the next column of this
	% row of the table).
	solveRow(L_item_value, L_itemWeight, L_itemName, PreviousRow, PreviousNameRow, CurrentItemIndex, CurrentCapacity + 1, MaxCapacity, NewRow, NewNameRow).

% Case 2:
% The CurrentCapacity being considered is less than or equal to the MaxCapacity that the knapsack can hold, and the weight of the current item that is
% being considered is equal to the CurrentCapacity being considered. We check if the singular value of the current item being considered is greater than the value
% of the combination of items that maximized the total value of the knapsack for the same capacity, but for one less item considered (the same column in the
% previous row of the values table/the column in the previous row of the values table with the same CurrentCapacity). If this is the case, add the value of the
% current item being considered to NewRow and add a sublist containing the name of this item to NewNameRow.
% The current item alone maximizes the total value of the knapsack better than the previous combination of items for this capacity.
solveRow(L_item_value, L_itemWeight, L_itemName, PreviousRow, PreviousNameRow, CurrentItemIndex, CurrentCapacity, MaxCapacity, [CurrentItemValue|NewRow], [CurrentItemName|NewNameRow]) :-
	CurrentCapacity =< MaxCapacity,
	getAtIndex(L_itemWeight, CurrentItemIndex, CurrentItemWeight), % Retrieve the weight of the item currently being considered from L_itemWeight list.
	CurrentItemWeight =:= CurrentCapacity,
	getAtIndex(PreviousRow, CurrentCapacity, PreviousValue), % Retrieve the total value of the combination of items in the PreviousRow list for the CurrentCapacity being considered.
	getAtIndex(L_item_value, CurrentItemIndex, CurrentItemValue), % Retrieve the value of the current item being considered.

	getAtIndex(L_itemName, CurrentItemIndex, CurrentItemName), % Retrieve the name of the current item being considered from L_itemName.

	CurrentItemValue > PreviousValue, !, % Conditions of Case 2 met.

	% Recursively call solveRow by incrementing CurrentCapacity by 1, so we can consider the next capacity that the knapsack can hold (the next column of this
	% row of the table).
	solveRow(L_item_value, L_itemWeight, L_itemName, PreviousRow, PreviousNameRow, CurrentItemIndex, CurrentCapacity + 1, MaxCapacity, NewRow, NewNameRow).

% Case 3:
% The CurrentCapacity being considered is less than or equal to the MaxCapacity that the knapsack can hold, and the weight of the current item that is
% being considered is equal to the CurrentCapacity being considered. We check if the singular value of the current item being considered is less than the value
% of the combination of items that maximized the total value of the knapsack for the same capacity, but for one less item considered (the same column in the
% previous row of the values table/the column in the previous row of the values table with the same CurrentCapacity). If this is the case, add the value from the
% previous row to NewRow and add a sublist containing the names of the items from the previous row to NewNameRow.
% The previous combination of items for this capacity maximizes the total value of the knapsack better than the current item alone.
solveRow(L_item_value, L_itemWeight, L_itemName, PreviousRow, PreviousNameRow, CurrentItemIndex, CurrentCapacity, MaxCapacity, [PreviousValue|NewRow], [PreviousItemName|NewNameRow]) :-
	CurrentCapacity =< MaxCapacity,
	getAtIndex(L_itemWeight, CurrentItemIndex, CurrentItemWeight), % Retrieve the weight of the item currently being considered from L_itemWeight list.
	CurrentItemWeight =:= CurrentCapacity,
	getAtIndex(PreviousRow, CurrentCapacity, PreviousValue),  % Retrieve the total value of the combination of items in the PreviousRow list for the CurrentCapacity being considered.
	getAtIndex(L_item_value, CurrentItemIndex, CurrentItemValue), % Retrieve the value of the current item being considered.

	getAtIndex(PreviousNameRow, CurrentCapacity, PreviousItemName), % Retrieve the sublist containing all the names of the items that maximized the total value of the knapsack for the
																	% current capacity, but for one less item considered.

	CurrentItemValue < PreviousValue, !, % Conditions of Case 3 met.

	% Recursively call solveRow by incrementing CurrentCapacity by 1, so we can consider the next capacity that the knapsack can hold (the next column of this
	% row of the table).
	solveRow(L_item_value, L_itemWeight, L_itemName, PreviousRow, PreviousNameRow, CurrentItemIndex, CurrentCapacity + 1, MaxCapacity, NewRow, NewNameRow).

% Case 4:
% The CurrentCapacity being considered is less than or equal to the MaxCapacity that the knapsack can hold, and the weight of the current item that is
% being considered is greater than the CurrentCapacity being considered. This means we can not add this item to the knapsack for this current capacity.
% Consider the combination of items that maximized the total value of the knapsack for the same capacity, but for one less item considered (the same column in the
% previous row of the values table/the column in the previous row of the values table with the same CurrentCapacity). Add the value from the
% previous row to NewRow and add a sublist containing the names of the items from the previous row to NewNameRow.
solveRow(L_item_value, L_itemWeight, L_itemName, PreviousRow, PreviousNameRow, CurrentItemIndex, CurrentCapacity, MaxCapacity, [PreviousValue|NewRow], [PreviousItemName|NewNameRow]) :-
	CurrentCapacity =< MaxCapacity,
	getAtIndex(L_itemWeight, CurrentItemIndex, CurrentItemWeight), % Retrieve the weight of the item currently being considered from L_itemWeight list.
	getAtIndex(PreviousRow, CurrentCapacity, PreviousValue), % Retrieve the total value of the combination of items in the PreviousRow list for the CurrentCapacity being considered.

	getAtIndex(PreviousNameRow, CurrentCapacity, PreviousItemName), % Retrieve the sublist containing all the names of the items that maximized the total value of the knapsack for the
																	% current capacity, but for one less item considered.

	CurrentItemWeight > CurrentCapacity, !, % Conditions of Case 4 met.

	% Recursively call solveRow by incrementing CurrentCapacity by 1, so we can consider the next capacity that the knapsack can hold (the next column of this
	% row of the table).
	solveRow(L_item_value, L_itemWeight, L_itemName, PreviousRow, PreviousNameRow, CurrentItemIndex, CurrentCapacity + 1, MaxCapacity, NewRow, NewNameRow).

% Case 5:
% The CurrentCapacity being considered is less than or equal to the MaxCapacity that the knapsack can hold, and the weight of the current item that is
% being considered is less than the CurrentCapacity being considered. We subtract the weight of the current item being considered from the CurrentCapacity of
% the knapsack; call this difference RemainingCapacity. Consider the combination of items that maximized the total value of the knapsack for the RemainingCapacity, 
% but for one less item considered. Sum this value with the value of the current item. If their summed value is greater than the value
% of the combination of items that maximized the total value of the knapsack for the same capacity, but for one less item considered (the same column in the
% previous row of the values table/the column in the previous row of the values table with the same CurrentCapacity), then add their sum to NewRow.
% Add the name of the current item to the list of item names for that combination of items from the previous row; add this sublist to NewNameRow.
solveRow(L_item_value, L_itemWeight, L_itemName, PreviousRow, PreviousNameRow, CurrentItemIndex, CurrentCapacity, MaxCapacity, [NewValue|NewRow], [NewItemName|NewNameRow]) :-
	CurrentCapacity =< MaxCapacity,
	getAtIndex(L_itemWeight, CurrentItemIndex, CurrentItemWeight), % Retrieve the weight of the item currently being considered from L_itemWeight list.
	CurrentItemWeight < CurrentCapacity,
	RemainingCapacity is CurrentCapacity - CurrentItemWeight, % Subtract the weight of the item currently being considered from the current capacity.
	getAtIndex(PreviousRow, RemainingCapacity, RemainingCapacityValue), % Retrieve the total value of the combination of items in the PreviousRow list for the RemainingCapacity in the knapsack.
	getAtIndex(L_item_value, CurrentItemIndex, CurrentItemValue), % Retrieve the value of the current item being considered.
	NewValue is RemainingCapacityValue + CurrentItemValue, % Sum RemainingCapacityValue and CurrentItemValue
	getAtIndex(PreviousRow, CurrentCapacity, PreviousValue), % Retrieve the total value of the combination of items in the PreviousRow list for the CurrentCapacity being considered.

	getAtIndex(PreviousNameRow, RemainingCapacity, RemainingName),  % Retrieve the sublist, RemainingName, containing all the names of the items that maximized the total value
																	% of the knapsack for the RemainingCapacity, but for one less item considered.

	getAtIndex(L_itemName, CurrentItemIndex, CurrentItemName), % Retrieve the name of the current item being considered from L_itemName.
	append(RemainingName, CurrentItemName, NewItemName), % Append the name of the current item to the RemainingName sublist.

	PreviousValue < NewValue, !, % Conditions for Case 5 met.

	% Recursively call solveRow by incrementing CurrentCapacity by 1, so we can consider the next capacity that the knapsack can hold (the next column of this
	% row of the table).
	solveRow(L_item_value, L_itemWeight, L_itemName, PreviousRow, PreviousNameRow, CurrentItemIndex, CurrentCapacity + 1, MaxCapacity, NewRow, NewNameRow).

% Case 6:
% The CurrentCapacity being considered is less than or equal to the MaxCapacity that the knapsack can hold, and the weight of the current item that is
% being considered is less than the CurrentCapacity being considered. We subtract the weight of the current item being considered from CurrentCapacity of
% the knapsack; call this difference RemainingCapacity. Consider the combination of items that maximized the total value of the knapsack for the RemainingCapacity, 
% but for one less item considered. Sum this value with the value of the current item. If their summed value is less than the value
% of the combination of items that maximized the total value of the knapsack for the same capacity, but for one less item considered (the same column in the
% previous row of the values table/the column in the previous row of the values table with the same CurrentCapacity), add the value from the
% previous row to NewRow and add a sublist containing the names of the items from the previous row to NewNameRow.
% The previous combination of items for this capacity maximizes the total value of the knapsack better than the new combination we just found.
solveRow(L_item_value, L_itemWeight, L_itemName, PreviousRow, PreviousNameRow, CurrentItemIndex, CurrentCapacity, MaxCapacity, [PreviousValue|NewRow], [PreviousItemName|NewNameRow]) :-
	CurrentCapacity =< MaxCapacity,
	getAtIndex(L_itemWeight, CurrentItemIndex, CurrentItemWeight), % Retrieve the weight of the item currently being considered from L_itemWeight list.
	CurrentItemWeight < CurrentCapacity,
	RemainingCapacity is CurrentCapacity - CurrentItemWeight, % Subtract the weight of the item currently being considered from the current capacity.
	getAtIndex(PreviousRow, RemainingCapacity, RemainingCapacityValue), % Retrieve the total value of the combination of items in the PreviousRow list for the RemainingCapacity in the knapsack.
	getAtIndex(L_item_value, CurrentItemIndex, CurrentItemValue), % Retrieve the value of the current item being considered.
	NewValue is RemainingCapacityValue + CurrentItemValue, % Sum RemainingCapacityValue and CurrentItemValue
	getAtIndex(PreviousRow, CurrentCapacity, PreviousValue), % Retrieve the total value of the combination of items in the PreviousRow list for the CurrentCapacity being considered.

	getAtIndex(PreviousNameRow, CurrentCapacity, PreviousItemName), % Retrieve the sublist containing all the names of the items that maximized the total value
																	% of the knapsack for the current capacity, but for one less item considered.

	PreviousValue > NewValue, !, % Conditions for Case 6 met.

	% Recursively call solveRow by incrementing CurrentCapacity by 1, so we can consider the next capacity that the knapsack can hold (the next column of this
	% row of the table).
	solveRow(L_item_value, L_itemWeight, L_itemName, PreviousRow, PreviousNameRow, CurrentItemIndex, CurrentCapacity + 1, MaxCapacity, NewRow, NewNameRow).

% Stop recursion; we have finished filling out a row of the tables when the CurrentCapacity being considered is greater than the MaxCapacity that the knapsack can hold.
solveRow(_, _, _, _, _, _, CurrentCapacity, MaxCapacity, [], []) :-
	CurrentCapacity > MaxCapacity, !.
% ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


% /////HELPER PREDICATES/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
% A predicate that retrieves the element of a list (Value) at a given index (Index).
getAtIndex([H], 0, H) :- !. 
% The first base case of getAtIndex; we have reached the index of the list that we want to retrieve an element from, 
% so output the head of the list (H) as the element we want to retrieve.
getAtIndex([H|_], 0, H) :- !.
% The second base case of getAtIndex; the index of the list that we want to retrieve an element from is 0. 
% This means we want to retrieve the head of the list, so output the had of the list (H) as the element we want to retrieve.
getAtIndex([_|T], Index, Value) :- NextIndex is Index-1, getAtIndex(T, NextIndex, Value).
% Index represents the index of the list that we want to retrieve an element from, as well as the number of indexes (NextIndex) we have to 
% iterate to the right until we reach the index of the element we want to retrieve.
% We know we have reached the element we want to retrieve when the value of NextIndex is 0.

% A predicate that fills a list, LstOfZeros, with Count zeros. 
fillZero(Count, [0|LstOfZeros]) :- 
	% If Count is greater than 0, then add a 0 to the LstOfZeros.
	Count > 0, !,
	% Then recursively call fillZero, but decrement Count by 1.
	% We will eventually call this predicate Count times and fill the LstOfZeros with Count zeros.
	fillZero(Count - 1, LstOfZeros).
% When Count is equal to 0, stop.
fillZero(Count, []) :- 
	Count =:= 0, !.

% A predicate that fills a list (LstOfEmpties) with Count empty sublists.
fillEmptyLists(Length, LstOfEmpties) :-
	% Use length to create a list, LstOfEmpties, of the inputted length, Length.
    length(LstOfEmpties, Length),
    % Use maplist to fill each element in the LstOfEmpties with an empty list.
    maplist(=([]), LstOfEmpties).
% ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


% ////REFERENCES/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
% 8_Prolog4_input_output. (n.d.). Brightspace. Retrieved April 6, 2021, from https://uottawa.brightspace.com/d2l/le/content/213483/viewContent/3528864/View.