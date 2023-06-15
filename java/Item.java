////////////////////////////////////////////////////
// CSI 2120 – Comprehensive Assignment (Part 1)
// Author: Nicholas Gin (300107597)
////////////////////////////////////////////////////

import java.util.*;
import java.io.*;

/**
 * This class represents an Item that has a name, value and weight and that can be "stored" in a Knapsack.
 * @author Nicholas Gin
 */
public class Item{
    //INSTANCE VARIABLES
    private String name;                //The name given to the Item
    private int value;                  //The value given to the Item
    private int weight;                 //The weight given to the Item

    private List<Knapsack> knapsacks;   //ASSOCIATION: The List of Knapsacks the Item is contained in (associated to)

    /**
     * Constructs an Item object with no input given in the parameters.
     */
    public Item(){
        name = ""; //Initialize the name of the Item as 0.
        value = 0; //Initialize the value of the Item as 0.
        weight = 0; //Initialize the weight of the Item as 0.
        knapsacks = new ArrayList<Knapsack>(); 
    }

    /**
     * Constructs an Item object with an inputted name, value and weight for the Item.
     * @param name The name of the Item
     * @param value The value of the Item
     * @param weight The weight of the Item
     */
    public Item(String name, int value, int weight){
        this.name = name;
        this.value = value;
        this.weight = weight;
        knapsacks = new ArrayList<Knapsack>(); 
    }

    /**
     * This method returns the name given to the Item.
     * @return The name of the Item
     */
    public String getName(){
        return name;
    }

    /**
     * This method returns the value given to the Item.
     * @return The value of the Item
     */
    public int getValue(){
        return value;
    }
  
    /**
     * This method returns the weight given to the Item.
     * @return The weight of the Item
     */
    public int getWeight(){
        return weight;
    }

    /**
     * This method returns the List of Knapsacks associated to the Item.
     * @return The List of Knapsacks associated to the Item
     */
    public List<Knapsack> getKnapsacks(){
        return knapsacks;
    }

    /**
     * This method indicates that the Item is associated to a particular Knapsack by adding the Knapsack to
     * the List of Knapsacks the Item is associated to
     * @param knapsack The Knapsack the Item is being associated to
     */
    public void addToKnapsacks(Knapsack knapsack){
        knapsacks.add(knapsack);
    }
}