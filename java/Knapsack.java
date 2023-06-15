////////////////////////////////////////////////////
// CSI 2120 – Comprehensive Assignment (Part 1)
// Author: Nicholas Gin (300107597)
////////////////////////////////////////////////////

import java.util.*;
import java.io.*;

/**
 * This class represents a Knapsack that can hold up to a certain weight of Items and that has a total value based on the Items it holds.
 */
public class Knapsack{ 
    //INSTANCE VARIABLES
    private int maxWeight;              //The maximum weight that the Knapsack can hold.   
    private int totalValue;             //The total, cumulative value of the Items placed in the Knapsack.

    private List<Item> itemsInKnapsack; //ASSOCIATION: The association between the Knapsack and the Items it is currently storing.
    private KTable kTableIn;     //ASSOCIATION: The association between the Knapsack and the KTable it is stored in.

    /**
     * Constructs a Knapsack object.
     */
    public Knapsack(){
        maxWeight = 0; //Initialize the maximum weight capacity of the Knapsack as 0.
        totalValue = 0; //Initialize the total value of the Knapsack as 0.
        itemsInKnapsack = new ArrayList<Item>();
        kTableIn = new KTable();
    }

    /**
     * This method sets the maximum weight that the Knapsack can hold.
     * @param maxWeight The maximum weight that the Knapsack can hold
     */
    public void setMaxWeight(int maxWeight){
        this.maxWeight = maxWeight;
    }

    /**
     * This method adds an Item to the List of Items in the Knapsack (associated to the Knapsack).
     * @param item The Item that is to be added to the List of Items in the Knapsack (associated to the Knapsack)
     */
    public void addToItems(Item item){
        itemsInKnapsack.add(item); //Add the indicated Item to the List of Items in the Knapsack.
        totalValue = totalValue + item.getValue(); //Increment the total value of the Knapsack by the value of the Item that was added to it.
    }

    /**
     * This method removes an Item from the List of Items in the Knapsack (removes an association between the Knapsack and the Item).
     * @param item The Item that is to be removed from the List of Items in the Knapsack
     */
    public void removeFromItems(Item item){
        itemsInKnapsack.remove(item); //Remove the indicated Item from the List of Items in the Knapsack.
        totalValue = totalValue - item.getValue(); //Decrement the total value of the Knapsack by the value of the Item that was removed from it.
    }

    /**
     * This method returns the currently set maximum weight that the Knapsack can hold.
     * @return The currently set maximum weight that the Knapsack can hold
     */
    public int getMaxWeight(){
        return maxWeight;
    }

    /**
     * This method returns the total value of the all Items currently contained in the Knapsack.
     * @return The total value of all the Items currently contained in the Knapsack
     */
    public int getTotalValue(){
        return totalValue;
    }

    /**
     * This method returns the List of Items currently contained in/associated to the Knapsack.
     * @return The List of Items currently contained in/associated to the Knapsack
     */
    public List<Item> getItems(){
        return itemsInKnapsack;
    }

    /**
     * This method indicates that the Knapsack is associated to a particular KTable.
     * @param kTable The KTable the Knapsack is associated to
     */
    public void setKTableIn(KTable kTable){
        this.kTableIn = kTable;
    }

    /**
     * This method returns the KTable associated to the Knapsack.
     * @return The KTable the Knapsack is associated to
     */
    public KTable getKTableIn(){
        return kTableIn;
    }

}