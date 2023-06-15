////////////////////////////////////////////////////
// CSI 2120 – Comprehensive Assignment (Part 1)
// Author: Nicholas Gin (300107597)
////////////////////////////////////////////////////

import java.util.*;
import java.io.*;

/**
 * This class solves the Knapsack problem using two possible algorithmic solutions.
 * @author Nicholas Gin
 */
public class KnapsackProblem {

    /**
     * The main method of KnapsackProblem.
     * This method accepts a file as input and extracts information from the file; the info from the file can be used to solve the Knapsack problem for a particular Knapsack and List of Items.
     * This method calls the algorithm (Brute Force or Dynamic Programming) that will be used to solve the Knapsack problem based on the flag inputted by the user.
     * @param args[0] The filename of the .txt file with the number of Items, name, value and weight of each Item, and the weight capacity limit of the Knapsack
     * @param args[1] The flag that indicates the algorithm that will be used to solve the Knapsack problem 
     *                (the "D" flag indicates the Dynamic Programming algorithm will be used and the "F" flag indicates the Brute Force algorithm will be used)
     * @throws IOException
     */
    public static void main(String args[]) throws IOException {
    //GETTING INFORMATION FROM THE FILE//
        //Read the file inputted by the user. The file's name is found at the first index (args[0]) of the inputted String array from the command-line.
        //This file will contain the information we need to solve the Knapsack problem for a given List of Items and a particular Knapsack.
        BufferedReader reader = new BufferedReader(new FileReader(args[0]));
        //The number of Items that are being considered is always indicated on the first line of the file.
        int maxNumberOfItems = Integer.parseInt(reader.readLine().trim());


        //IDENTIFYING ITEMS FROM THE FILE//
        //Create a List that will store all Item instances that will be created based on the information in the file.
        List<Item> itemList = new ArrayList<Item>(); 
        //Each Item's name, value and weight is indicated on its own separate line in the file.
        //We know that the next "maxNumberOfItems" lines in the file will be dedicated to identifying the Items and describing each Item's name, value and weight.
        for (int i = 0; i < maxNumberOfItems; i++){ //For the next "maxNumberOfItems" lines in the file...
            //read the contents on the current line of the file.
            //The line will be formatted in a way such that it will state the Item's name, value and weight (in this order).
            //Split the contents of the current line into an array of Strings at each occurrence of a space (" ").
            String itemInfo = reader.readLine();
            String[] itemInfoParts = itemInfo.split(" "); //The array with all the contents of the line (each piece of info on an Item), split/separated by each occurrence 
            //of a space in the line.

            //We will now identify the Item on this particular line's name, value and weight.
            String itemName = ""; //The String we will set as the Item's name; initialize it as an empty String.
            int itemValue = 0; //The int we will set as the Item's value; initialize it as 0.
            int itemWeight = 0; //The int we will set as the Item's weight; initialize it as 0.

            //An Item's name, value and weight are separated from one another by spaces (1 or more in the current line of the file).
            int j = 0; //j is the currently selected index of the itemInfoParts array.
            int infoNumber = 1; //We know that each Item will always be identified by three pieces of information. 
                                //infoNumber indicates which piece of information we are looking at while reading a line in the file.
                                //1 indicates that we are reading the Item's name, 2 indicates we are reading the Item's value, and 3 indicates we are reading the Item's weight.

            //Continue this loop while j (the currently selected index of the itemInfoParts array) does not exceed the length of the itemInfoParts array and the infoNumber does not equal 4
            //(this means there is no more information that can be read, as each Item is only identified by three - and no more - pieces of information)...
            while (j < itemInfoParts.length && infoNumber != 4){    
                if (! itemInfoParts[j].equals("")){ //As long as the content at an index of the itemInfoParts array is not an empty String...
                    if (infoNumber == 1){ //If infoNumber = 1, set the content at the current index of the itemInfoParts array to be the Item's name.
                        itemName = itemInfoParts[j];
                        infoNumber++;
                    }

                    else if (infoNumber == 2){ //If infoNumber = 2, set the content at the current index of the itemInfoParts array to be the Item's value.
                        itemValue = Integer.parseInt(itemInfoParts[j]);
                        infoNumber++;
                    }

                    else { //If infoNumber = 3, set the content at the current index of the itemInfoParts array to be the Item's weight.
                        itemWeight = Integer.parseInt(itemInfoParts[j]);
                        infoNumber++;
                    }
                }

                j++; //Increment the currently selected index of the itemInfoParts array, so we can carry out the loop again or end the loop.
            }

            //Create an instance of Item by providing the discovered itemName, itemvalue and itemWeight as parameters.
            Item item = new Item(itemName, itemValue, itemWeight);

            //Add this instance of Item to the itemList.
            itemList.add(item);
        }


        //IDENTIFYING THE KNAPSACK'S MAXIMUM WEIGHT//
        //We have looped through all lines of the file that identify the Items that will be considered when we solve the Knapsack problem.
        //The last line in the file represents the maximum weight the Knapsack being considered when we solve the Knapsack problem can carry; store it as a variable.
        int maxKnapsackWeight = Integer.parseInt(reader.readLine());


        //DECIDING WHICH ALGORITHM TO RUN//
        KnapsackProblem knapsackProblem = new KnapsackProblem(); //Create an instance of KnapsackProblem.

        int[] itemValues = new int[maxNumberOfItems];   //Create an array that will store the values of each Item that can be stored in the Knapsack.
        int[] itemWeights = new int[maxNumberOfItems];  //Create an array that will store the weights of each Item that can be stored in the Knapsack.

        //Transfer the values and weights of each Item into the itemValues array and the itemWeights array respectively.
        for (int item = 0; item < itemList.size(); item++){
            itemValues[item] = itemList.get(item).getValue();
            itemWeights[item] = itemList.get(item).getWeight();
        }

        //The user's choice of algorithm to solve the Knapsack problem is found at the second index (args[1]) of the inputted String array from the command-line.
        if (args[1].equals("D") || args[1].equals("d")){ //If args[1] is "D", initiate the Dynamic Programming algorithm for the inputted List of Items and Knapsack.
            Knapsack filledKnapsackD = knapsackProblem.dynamicProgramming(maxNumberOfItems, maxKnapsackWeight, itemValues, itemWeights, itemList); //The results of the Dynamic Programming algorithm
            knapsackProblem.save(args[0], filledKnapsackD); 
            //Call the save method to write the results of the Dynamic Programming algorithm in a .txt file.
        }

        else if (args[1].equals("F") || args[1].equals("f")) { //If args[1] is "F", initiate the Brute Force algorithm for the inputted List of Items and Knapsack.
            Knapsack knapsack = new Knapsack();
            Knapsack filledKnapsackF = knapsackProblem.bruteForce(itemWeights, itemValues, maxKnapsackWeight, maxNumberOfItems, itemList, knapsack); //The results of the Brute Force algorithm
            knapsackProblem.save(args[0], filledKnapsackF); //Call the save method to write the results of the Brute Force algorithm in a .txt file.
        }

    }  

    
    /**
     * This method performs the Brute Force algorithm to solve the Knapsack problem for a particular List of Items and a particular Knapsack.
     * It is called recursively to perform the Brute Force algorithm.
     * The entire algorithm is adapted from ("0-1 Knapsack Problem: DP-10," 2020).
     * @param itemWeights An array consisting of the weights of every Item that can be stored in the Knapsack 
     * @param itemValues An array consisting of the values of every Item that can be stored in the Knapsack 
     * @param weightLeftInKnapsack The weight left in the Knapsack based on the Items that have been added to the Knapsack 
     *                             (this value is originally set to the maximum weight the Knapsack can hold for the first time this method is called from the main method)
     * @param numberOfItemsLeftToAdd The number of remaining Items that can still be added to the Knapsack
     *                               (this value is originally set to the maximum number of Items that can be added to the Knapsack for the first time this method is called from the main method)
     * @param itemList The List of Items that can be added to the Knapsack
     * @param knapsack The Knapsack that will be filled with the combination of Items that maximizes the Knapsack's total value without exceeding its weight capacity
     * @return The filled Knapsack with the combination of Items that maximizes the Knapsack's total value without exceeding its weight capacity
     */
    public Knapsack bruteForce(int[] itemWeights,  int[] itemValues, int weightLeftInKnapsack, int numberOfItemsLeftToAdd, List<Item> itemList, Knapsack knapsack){
        //The Brute Force algorithm uses recursion.
        //For each Item in the List of Items that can be added to the Knapsack (the parameterized itemList), we make a binary decision: should we add the Item to the Knapsack or not? 
        //This binary decision is represented by the two branches of a binary tree.
        //We will inspect the total value of the Knapsack twice: after adding the Item to the Knapsack and after not adding the Item to the Knapsack.
        //We will return the Knapsack in the state where it will have a higher total value, either with the Item added to it or not but via a recursive call to this method.
        //For each recursive call to this method, we will consider a different Item from the itemList.
        
        //If the number of Items that can still be added to the Knapsack or if the weight left in the Knapsack is 0, there are either no more 
        //Items that can be added to the Knapsack or the Knapsack is full (no more Items can be added to it without exceeding its weight capacity)
        if (numberOfItemsLeftToAdd == 0 || weightLeftInKnapsack == 0){
            return knapsack; 
        }
  
        //If the weight of the Item is more than the weight left in the Knapsack, then this Item can not be added to the Knapsack.
        if (itemWeights[numberOfItemsLeftToAdd - 1] > weightLeftInKnapsack){
            return bruteForce(itemWeights, itemValues, weightLeftInKnapsack, numberOfItemsLeftToAdd - 1, itemList, knapsack);
            //Recursively call this method without adding the Item to the Knapsack, but consider the next Item in the itemList in this method call by subtracting 1 from the number of Items 
            //that can still be added to the Knapsack.
        }
  
  		//Else...
        //Return the Knapsack with the higher total value of Items: 
            //Case 1 (knapsack1): The Knapsack without the Item added to it 
            //case 2 (knapsack2): The Knapsack with the Item added to it
        else{
            Knapsack knapsackWithItemAdded = new Knapsack();

            //Move all Items placed in the Knapsack from the parameters of this recursive method into a new Knapsack instance
            for (int i = 0; i < knapsack.getItems().size(); i++){
                knapsackWithItemAdded.addToItems(knapsack.getItems().get(i));
                knapsack.getItems().get(i).addToKnapsacks(knapsackWithItemAdded); //Indicate that the Item is associated to this particular Knapsack.
            }
            
            //Add the Item being considered into this new Knapsack.
            Item itemToAdd = itemList.get(numberOfItemsLeftToAdd - 1);
            itemToAdd.addToKnapsacks(knapsackWithItemAdded); //Indicate that the Item is associated to this particular Knapsack.
            knapsackWithItemAdded.addToItems(itemToAdd); //Add the Item to the Knapsack.

            Knapsack knapsack1 = bruteForce(itemWeights, itemValues, weightLeftInKnapsack, numberOfItemsLeftToAdd - 1, itemList, knapsack);
            //Recursively call this method without adding the Item to the Knapsack, but consider the next Item in the itemList in this method call by subtracting 1 from the number of Items 
            //that can still be added to the Knapsack.
            Knapsack knapsack2 = bruteForce(itemWeights, itemValues, weightLeftInKnapsack - itemWeights[numberOfItemsLeftToAdd - 1], numberOfItemsLeftToAdd - 1, itemList, knapsackWithItemAdded);
            //Recursively call this method after adding the Item to the Knapsack; consider the next Item in the itemList in this method call by subtracting 1 from the number of Items 
            //that can still be added to the Knapsack and by subtracting the weight of the Item that was just added to the Knapsack from the weight left in the Knapsack.

            //Return the Knapsack with the higher total value of Items
            if (knapsack1.getTotalValue() > knapsack2.getTotalValue()){
                return knapsack1;
            }

            else {
                return knapsack2;
            }
        }
    } 
    

    /**
     * This method performs the Dynamic Programming algorithm to solve the Knapsack problem for a particular List of Items and a particular Knapsack.
     * The entire algorithm is adapted from (Terh, 2019).
     * @param maxNumberOfItems The maximum number of Items that can be added to the Knapsack
     * @param maxKnapsackWeight The maximum weight capacity of the Knapsack
     * @param itemValues An array consisting of the values of every Item that can be stored in the Knapsack 
     * @param itemWeights An array consisting of the weights of every Item that can be stored in the Knapsack 
     * @param itemList The List of Items that can be added to the Knapsack
     * @return The filled Knapsack with the combination of Items that maximizes the Knapsack's total value without exceeding its weight capacity
     */
    public Knapsack dynamicProgramming(int maxNumberOfItems, int maxKnapsackWeight, int[] itemValues, int[] itemWeights, List<Item> itemList){
        //Create an instance of KTable that will have maxNumberOfItems + 1 rows and maxKnapsackWeight + 1 columns.
        //The row numbers of the KTable represent the number of Items we have added to or have attempted to add to the Knapsack.
        //The column numbers of the KTable represent the current weight capacity limit of the Knapsack.
        //The Knapsack at each index of the KTable represents the Knapsack with the combination of Items that maximizes the Knapsack's total value 
        //for a given number of Items that can be added to Knapsack without exceeding its weight capacity limit.
            //For example, the Knapsack at index [2][5] of the KTable holds the combination of 2 or less Items that maximizes the Knapsack's total value without exceeding 
            //a weight capacity limit of 5 kg.
        KTable ktable = new KTable(maxNumberOfItems, maxKnapsackWeight);

        //This outer for loop indicates the current number of Items that we are trying to put into the Knapsack (the rows of the KTable).
        for (int numberOfItemsInKnapsack = 1; numberOfItemsInKnapsack <= maxNumberOfItems; numberOfItemsInKnapsack++) {
          
            //This inner for loop indicates the current weight capacity limit of the Knapsack (the columns of the KTable).
            //This means that the very last index of the KTable, [maxNumberOfItems, maxKnapsackWeight], stores the Knapsack with the combination of Items that maximizes the Knapsack's total value
            //for the maximum weight capacity the Knapsack can actually hold.
            for (int currentKnapsackWeight = 1; currentKnapsackWeight <= maxKnapsackWeight; currentKnapsackWeight++) {
            //We start both loops at index 1; we know that the first row of the KTable will only be filled with empty Knapsacks.
            //(since for all Knapsacks in this row of the KTable, no Items can be added to each Knapsack – the row number is 0).

                //We try to add a new Item to the Knapsack for each progression down the rows of the KTable.
                //When determining if adding or replacing an Item in the Knapsack can increase its total value for a given weight capacity limit, we have to consider the total value
                //of the Knapsack in the row above it (the Knapsack that had one less Item that could have been added to it for the same weight capacity limit as the Knapsack we are considering now).
                int maxValWithoutCurrItem = ktable.getKnapsack(numberOfItemsInKnapsack - 1, currentKnapsackWeight).getTotalValue(); //Get the total value of the Knapsack located at
                                                                                                                                    //the row above the one we are considering now,
                                                                                                                                    //but at the same column.

                int weightOfCurrentItem = itemWeights[numberOfItemsInKnapsack - 1]; //Determine the weight of the current Item that we are considering adding to the Knapsack.

                Knapsack newKnapsack = new Knapsack(); //Initialize a new Knapsack that can be stored in the KTable.
                if (currentKnapsackWeight >= weightOfCurrentItem) { //Check if this Knapsack has space for the Item we are trying to add to it, considering the current weight capacity limit indicated by the
                                                                    //current index of the inner for loop.
                                                                    //If the current weight capacity limit for the Knapsack is greater than or equal to the weight of the Item,
                                                                    //there is still space for the Item in the Knapsack.
                    int remainingWeightAfterAddingItem = currentKnapsackWeight - weightOfCurrentItem; //Determine the remaining weight capacity the Knapsack can hold if we did add the Item to it.

                    //We want to add the Item to the combination of Items from the Knapsack that:
                        //a) is found in the row above the one we are considering now 
                        //and b) has a weight capacity limit that is equivalent to that of our remaining weight capacity limit.

                    //Again, the Knapsack at each index of the KTable represents the Knapsack with the combination of Items that maximizes the Knapsack's total value 
                    //for a given number of Items that can be added to Knapsack without exceeding its weight capacity limit.
            
                    //By adding an Item to an empty Knapsack we take up some of the weight capacity that the Knapsack can hold. If there is still space left in the Knapsack after we add the Item to it,
                    //we obviously want to add more Items to the Knapsack (the combination of Items that maximizes the total value of the Knapsack without exceeding its remaining weight capacity). This
                    //combination can only include the Items that were considered to be added or were actually added to the Knapsack before the Item we just added to Knapsack was.
                    //This combination of Items can be found in the Knapsack located one row above the one we are considering now that has our current remaining weight capacity limit as its weight capacity limit.
                    List<Item> list1 = ktable.getKnapsack(numberOfItemsInKnapsack - 1, remainingWeightAfterAddingItem).getItems();  //Get the List of Items in the aforementioned Knapsack.
                    for (int i = 0; i < list1.size(); i++){ //Add each Item in this Knapsack to the Knapsack we are currently initialziing (by association).
                        newKnapsack.addToItems(list1.get(i));  
                        list1.get(i).addToKnapsacks(newKnapsack); //Indicate that the Item is associated to this particular Knapsack we are initializing.
                    }

                    //Add the Item we are currently considering to the Knapsack we are initializing (by association).          
                    Item itemToAdd = itemList.get(numberOfItemsInKnapsack - 1); 
                    itemToAdd.addToKnapsacks(newKnapsack); //Indicate that the Item is associated to this particular Knapsack we are initializing.
                    newKnapsack.addToItems(itemToAdd);          
                }

                //If the Knapsack we just created's total value is greater than that of the Knapsack that has the same weight capacity limit but had one less Item considered to be added to it...
                if (newKnapsack.getTotalValue() > maxValWithoutCurrItem){
                    ktable.add(numberOfItemsInKnapsack, currentKnapsackWeight, newKnapsack); //Store the Knapsack we just created at its respective index in the KTable (the number of Items that we 
                                                                                             //tried to put into the Knapsack as its row number, and the weight capacity limit of the Knapsack as its column number).
                    ktable.addToListOfKnapsacks(newKnapsack); //Indicate that this KTable is associated to this particular Knapsack.

                    newKnapsack.setKTableIn(ktable); //Indicate that this Knapsack is associated to this particular KTable.
                }

                else { //Else...
                    ktable.add(numberOfItemsInKnapsack, currentKnapsackWeight, ktable.getKnapsack(numberOfItemsInKnapsack - 1, currentKnapsackWeight));
                    //Store the Knapsack that has the same weight capacity limit as the one we just created but had one less Item considered to be added to it at its respective index in 
                    //the KTable (the number of Items that we tried to put into the Knapsack as its row number, and the weight capacity limit of the Knapsack as its column number).
                    
                    ktable.addToListOfKnapsacks(ktable.getKnapsack(numberOfItemsInKnapsack - 1, currentKnapsackWeight)); //Indicate that this KTable is associated to this particular Knapsack.
                    
                    ktable.getKnapsack(numberOfItemsInKnapsack - 1, currentKnapsackWeight).setKTableIn(ktable); //Indicate that this Knapsack is associated to this particular KTable.  
                }
            }
        }

        return ktable.getKnapsack(maxNumberOfItems, maxKnapsackWeight); //Return the Knapsack located at the very last index of the KTable, [maxNumberOfItems, maxKnapsackWeight]; it contains the combination of Items that maximizes 
        //the Knapsack's total value for the maximum weight capacity the Knapsack can actually hold.
    }


    /**
     * This method writes the results of the Brute Force method or the Dynamic Programming method in a .txt file.
     * @param filename The filename of the .txt file with the number of Items, name, value and weight of each Item, and the weight limit of the Knapsack considered in the Knapsack problem 
     * @param filledKnapsack The filled Knapsack returned by either the Brute Force method or the Dynamic Programming Method
     */
    public void save(String filename, Knapsack filledKnapsack){
        try {
        	String[] filenameContents = filename.split(".txt"); //Determine the name of the inputted file without the .txt file extension.

            BufferedWriter writer = new BufferedWriter(new FileWriter(filenameContents[0]+".sol"+".txt")); //Add ".sol" to the name of the inputted file; this will be the name of the .txt file we are writing.
            try {
                Collections.sort(filledKnapsack.getItems(), new Comparator<Item>() { //Sort the Items in the Knapsack in alphabetical order by each Item's name.
                    @Override
                    public int compare(Item item1, Item item2) {
                        return item1.getName().compareTo(item2.getName());
                    }
                });

                writer.write(filledKnapsack.getTotalValue() + "\n"); //The first line of the file we are writing will be the total value of the given Knapsack.

                //Write the name of each Item in the given Knapsack in the file we are writing.
                for (int i = 0; i < filledKnapsack.getItems().size(); i++){
                    //Each Item name will be followed by a double space "  ", unless we are considering the last Item in the Knapsack.
                    if (i == filledKnapsack.getItems().size() - 1){ //(The Item we are considering is the last Item in the Knapsack)
                        writer.write(filledKnapsack.getItems().get(i).getName());
                    }
                    else { //(If the Item we are considering is not the last Item in the Knapsack)
                        writer.write(filledKnapsack.getItems().get(i).getName() + "  ");
                    }
                }

                System.out.println("File written."); //Indicate to the user that the file has been written.
            } 

            catch (IOException e) {
                System.out.println("Could not write file.");
                System.exit(1);
            }
        
            writer.close();
        }

        catch (IOException e) {
            System.out.println("Could not write file.");
            System.exit(1);
        }
    }
}


/**
* References
*/
//GeeksforGeeks. (2020, November 3). 0-1 Knapsack Problem | DP-10. https://www.geeksforgeeks.org/0-1-knapsack-problem-dp-10/. 

//Terh, F. (2019, March 28). How to solve the Knapsack Problem with dynamic programming. Medium. https://medium.com/@fabianterh/how-to-solve-the-knapsack-problem-with-dynamic-programming-eb88c706d3cf. 






