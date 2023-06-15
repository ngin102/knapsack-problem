#lang racket
;////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
; CSI 2120 – Comprehensive Assignment (Part 4)
; Author: Nicholas Gin (300107597)
;////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

;////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
; The function that is called by the user; it calls all other functions to solve the knapsack problem and to produce a solution file.
; solveKnapsack takes a filename as a parameter (the name of the file that will be read for the information about the items being considered in the knapsack problem).
(define (solveKnapsack filename)
  ; Get the maxWeight of the knapsack from the file by calling the getMaxWeight function; bind it to maxWeight.
  (let ((maxWeight (getMaxWeight filename)))
    ; Translate the contents of the file into a list; bind this list to fileContents.
    ; For example, the contents of p1.txt will be translated into the following list: '(4 A 1 1 B 6 2 C 10 3 D 15 5 7).
    (let ((fileContents (translateFileToList filename '())))
    ; Determine the length of fileContents but not including the first and last elements of this list (the first and last elements of this list represent the number
    ; of items being considered and the maximum capacity of the knapsack respectively) by finding the length of fileContents and subtracting 2; bind this difference
    ; to size.
    (let ((size (- (length fileContents) 2)))
    ; Use splitUp to create a list containing sublists that represent each item as they are described in the file; bind this list to items.
    ; Since we only want to consider the information of the items in fileContents and not the number of items being considered and the maximum capacity of the knapsack,
    ; (the first and last elements in fileContents respectively) we don't call splitUp on the entirety of the fileContents list. We remove the last element of 
    ; fileContents by calling removeLast on it and we remove its first element by calling cdr on it. This is the list we call splitUp on. Again, the length of 
    ; this list is indicated by the value we bound to "size". Provide an empty list for the parameterized newLst of splitUp, as we want to create a list 
    ; containing all of the sublists from scratch.
    ; For more information on how the splitUp function works, please see the splitUp function.
    (let ((items (splitUp size (removeLast (cdr fileContents)) '())))
    ; Call knapsack (with maxWeight and items as parameters) to produce the filled knapsack (the solution) for the specified items and knapsack capacity
    ; as detailed in the file given by the user; bind the solution to solution.
    (let ((solution (knapsack maxWeight items)))
      ; The solution produced by knapsack is a list that contains two elements: the total value of the solution knapsack and a sublist containing the names
      ; of all the elements in the solution knapsack. For example, the solution of p1.txt is '(21 (B D))
      ; Because of the way the function createSolution works, we want to take the item names out of the sublist and put them into the main list with the total value;
      ; in other words, we want to convert the solution list into '(21 B D).
      ; We do this by calling append on the (car (cdr solution)) (the sublist of items) and (car solution) (the total value).
      (let ((solutionItems (car (cdr solution))))
        (let ((solutionValue (list (car solution))))
          ; We call createSolution on the list we just created as well as the filename of the input file provided by the user.
          ; createSolution will produce a solution file, named the given filename.sol, that displays the contents of the solution knapsack.
          (createSolution (append solutionValue solutionItems) filename)))))))))
;////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


;////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
; Functions needed to read and handle information from the file.

; This function is taken and slightly adapted from Slide 12 of Scheme4_IO_sort slides (https://uottawa.brightspace.com/d2l/le/content/213483/viewContent/3605436/View):
; This function translates all contents of the user-provided file into a list.
; For example, the contents of p1.txt will be translated into a list: '(4 A 1 1 B 6 2 C 10 3 D 15 5 7).
(define (translateFileToList filename output)
  (let ((p (open-input-file filename))) ; Open the file; assign this to p.
  (let f ((x (read p))) ; Read from the file p and assign what we read from it to x.
    (if (eof-object? x) ; If x is the end of the file, close the file and return an empty list.
	(begin
	  (close-input-port p)
	  '())
	(cons x (f (read p))))))) ; Else, add whatever we read to whatever we're going to read from the recursive call to the file (we are constructing a list of
  ; all the contents in the file).


; This function splits up the list containing the contents of the user-provided file into a new list containing sublists that represent each item.
; In order to carry out this process, this function takes the following as parameters: the length of the list we are splitting up (lngth),
; the list we are splitting up (lst), and the list we form that contains all of the sublists (newLst).
; In the case of p1.txt, via solveKnapsack, we will pass the following list, lst, to be split up into sublists: '(A 1 1 B 6 2 C 10 3 D 15 5 7).
; For every 3 elements in lst, the function will create a sublist that is added to newLst; each sublist represents all the details about an item.
; So, in this case, newLst will be: '((A 1 1) (B 6 2) (C 10 3) (D 15 5)).
(define (splitUp lngth lst newLst)
  (cond
    ; If lst is empty, we have iterated through the entirety of lst and we have finished creating newLst.
    [(empty? lst) '()]
    ; If lngth > 1, call "take" on lst for the first 3 elements of lst.
    ; For example, the first iteration of this function for lst, '((A 1 1) (B 6 2) (C 10 3) (D 15 5)), will produce the sublist '(A 1 1).
    ; We then add this sublist to the newList.
    ; Decrease lngth by 3 and remove the first three elements of lst by calling cdr three times on it.
    ; We then recursively call this function for the rest of this modified, shortened lst, repeating the same steps until lst is empty.
    [(> lngth 1) (cons (take lst 3) (splitUp (- lngth 3) (cdr (cdr (cdr lst))) newLst))]))


; This function removes the last element of a list, lst.
; To accomplish the removal of the last element of lst, we first reverse the ordering of lst. We then remove the first element from the reversed lst
; by calling cdr, and finally reverse the reversed lst to restore the original ordering of lst (but without the last item in lst present).
(define (removeLast lst) (reverse (cdr (reverse lst))))


; This function retrieves the maximum weight/capacity that the knapsack can hold given an input file.
(define (getMaxWeight filename)
  ; Convert the contents of the file into a list using the translateFileToList function; bind this list to lst.
  (let ((lst (translateFileToList filename '())))
    ; The maximum weight that the knapsack can hold will always be indicated on the last line of the input file provided by the user.
    ; This means that the maximum weight can be found as the last element of lst, return the last element of lst as the maximum weight.
    (last lst)))
;////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


;////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
; Functions needed to run Brute Force algorithm:

; This function gets the value associated with an item.
; From an item sublist, the second value in the sublist indicates the value of the item.
; For example, in the item sublist, '(B 6 2), 6 is the item's value.
(define (itemValue itemSublist)
  ; Get the second value from the parameterized itemSublist by calling cadr on the itemSublist.
  (cadr itemSublist))


; This function gets the weight associated with an item.
; From an item sublist, the third value in the sublist indicates the weight of the item.
; For example, in the item sublist, '(B 6 2), 2 is the item's weight.
(define (itemWeight itemSublist)
  ; Get the third value from the parameterized itemSublist by calling caddr on the itemSublist.
  (caddr itemSublist))


; This function gets the culminative, total value of all the items in a parameterized knapsack.
(define (sumTotalKnapsackValue knapsack)
  ; Use map to create a list containing the itemValues of each item in the parameterized knapsack.
  ; For example, mapping itemValue to the knapsack represented by the list '((A 1 1) (B 6 2) (C 10 3) (D 15 5))
  ; will produce the list '(1 6 10 15), which is the list containing each item from the knapsack's itemValue (itemValue is called on each sublist in the list).
  ; Use apply + on the mapping to sum together all of the itemValues in that list.
  ; This sum represents the culminative, total value of all the items in the knapsack.
  (apply + (map itemValue knapsack)))


; This function gets the culminative, total weight of all the items in a parameterized knapsack.
(define (sumTotalKnapsackWeight knapsack)
  ; Use map to create a list containing the itemWeights of each item in the parameterized knapsack.
  ; For example, mapping itemWeight to the knapsack represented by the list '((A 1 1) (B 6 2) (C 10 3) (D 15 5))
  ; will produce the list '(1 2 3 5), which is the list containing each item from the knapsack's itemWeight (itemWeight is called on each sublist in the list).
  ; Use apply + on the mapping to sum together all of the itemWeights in that list.
  ; This sum represents the culminative, total weight of all the items in the knapsack.
  (apply + (map itemWeight knapsack)))


; This function compares the totalValues of two knapsacks: a knapsack with an item included (knapsackWithItem) and a knapsack without an item included (knapsackWithoutItem)
; If the total weight of the knapsackWithItem is not greater than the maxWeight (provided in parameters) that the knapsack can contain and the total value of the knapsackWithItem
; is greater than the total value of the knapsackWithoutItem, then return the knapsackWithItem. Else, return the knapsackWithoutItem. Of the two given knapsacks, we want to return the
; knapsack with the highest total value. To determine the total weight of knapsackWithItem, we call sumTotalKnapsackWeight on it. To determine the total values of the two knapsacks,
; we call sumTotalKnapsackValues on each of these knapsacks respectively.
(define (max knapsackWithItem knapsackWithoutItem maxWeight)
  (if (and (not (> (sumTotalKnapsackWeight knapsackWithItem) maxWeight)) (> (sumTotalKnapsackValue knapsackWithItem) (sumTotalKnapsackValue knapsackWithoutItem)))
   knapsackWithItem knapsackWithoutItem))


; This function is included to match the function described in the assignment outline.
; It takes, as parameters, a maximum weight that the knapsack can hold (maxWeight) as well as a list containing sublists that represent the items that can be put into the knapsack (items).
; The function then calls bruteForce using the parameterized maxWeight and items to produce a filledKnapsack (the solution to the knapsack problem); the filledKnapsack is first set to an
; empty list since items will be added to it. The solution produced by bruteForce is bound to solution.
; To output the information about the solution knapsack in the format described in the assignment outline, we create a list that contains the total value of the solution knapsack (to calculate
; this value, we call sumTotalKnapsackValue on the solution knapsack) and a sublist containing the names of all the items in the solution knapsack (to create the sublist, we map the
; first element in every sublist in the solution knapsack to a new list and reverse the ordering of this list so the names are in alphabetical order).
(define (knapsack maxWeight items)
  (let ((solution (bruteForce maxWeight '() items)))
  (list (sumTotalKnapsackValue solution) (reverse (map car solution)))))


; This function performs the brute force algorithm to solve the knapsack problem for a given list that contains sublists which represent the items that can be put into the knapsack (items)
; and a maximum weight that the knapsack can contain (maxWeight). The final solution, the set of items that maximizes the total value of the knapsack for its maximum weight, will be placed
; in filledKnapsack (the solution).
; For each item described in "items", we make a binary decision: should we add the item to the filledKnapsack or not?
; This binary decision is represented by the two branches of a binary tree.
; We will inspect the total value of the filledKnapsack twice: after adding the item to it and after not adding the item to it.
; We will return the filledKnapsack in the state where it will have a higher total value, either with the item added to it or not via a recursive call to this function and a call to the
; max function.
; For each recursive call to this function, we will consider a different item from "items."
; After the algorithm completes and the binary tree is finished, we find filledKnapsack with the combination of items that maximizes the knapsack's total value without exceeding its max weight capacity.
(define (bruteForce maxWeight filledKnapsack items)
  [cond
    ; If there are no items to put into the filledKnapsack, then return filledKnapsack.
    ((null? items) filledKnapsack)
    ; If there are items to consider...then we consider two cases:
    ; Case 1: filledKnapsack after adding an item to it (by adding the first found element in "items" (car items) to the filledKnapsack)
    ; Case 2: filledKnapsack without an item added to it
    ; Calling the function, max, providing both of these cases as separate parameterized knapsacks will return the knapsack with the higher total value between the two.
    (else
    (max (bruteForce maxWeight (cons (car items) filledKnapsack) (cdr items)) (bruteForce maxWeight filledKnapsack (cdr items)) maxWeight))])
    ; For Case 1: Recursively call this function after adding the item to the Knapsack; consider the next items in "items" in this function call by considering "items" with its
    ; first element removed (call cdr on items).
    ; For Case 2: Recursively call this function without adding the item to the Knapsack; consider the next items in "items" in this function call by considering "items" with its
    ; first element removed (call cdr on items).
;////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


;////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
; The function used to create the solution file.
; The function takes a filename as input, so that the solution file can be written in the form filename.sol.
; This function calls an adapted version of proc-out-file from Slides 13-14 of Scheme4_IO_sort slides (https://uottawa.brightspace.com/d2l/le/content/213483/viewContent/3605436/View)
; to write the solution file.
(define (createSolution lst filename) 

  ; proc-out-file opens and closes the document we will write.
  (define proc-out-file
    (lambda (filename proc)
      (let ((p (open-output-file filename #:exists 'replace))) ; Open the file we will write to; if the file already exists, replace it.
        (let ((v (proc p)))
          (close-output-port p)
          v))))
  
  (proc-out-file (string-append (substring filename 0 (- (string-length filename) 4)) ".sol")
                 ; The name of the solution file will be the filename.sol. Since the inputted filename will be the filename.txt,
                 ; we need to remove .txt from the filename so the solution file is not named filename.txt.sol.
                 ; To remove .txt from filename.txt, take the substring as indicated, then append ".sol"; this will be the solution filename.
    ; A lambda to write to the file.
    (lambda (p)
       (let f ((l lst)) 
         (cond
           ; If l is not null and the first element of l is a number, write the first element of l in the file and then an new line.
           ; Call f recursively for the rest of l.
           [(and (not (null? l)) (number? (car l)))
             (begin
               (write (car l) p)
               (newline p)
               (f (cdr l)))]
           ; If l is not null and the first element of l is not a number, write the first element of l in the file and then two blank spaces.
           ; Call f recursively for the rest of l.
           [(and (not (null? l)) (not (number? (car l))) (eq? (length l) 1))
              (write (car l) p)]
           [(and (not (null? l)) (not (number? (car l))))
            (begin
              (write (car l) p)
              (display '| | p) ; Writes a blank space.
              (display '| | p) ; Writes another blank space.
              (f (cdr l)))]
           [(null? l) null]))))
  ; Display this message in the console.
  (display "Solution file created."))
;////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


;////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
; References:
; Knapsack Problem/0-1. (2020, December 21). Rosetta Code. Retrieved April 4, 2021, from https://rosettacode.org/wiki/Knapsack_problem/0-1#Racket. 
; Scheme4_IO_sort. (n.d.). Brightspace. Retrieved April 4, 2021, from https://uottawa.brightspace.com/d2l/le/content/213483/viewContent/3605436/View.