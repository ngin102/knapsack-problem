////////////////////////////////////////////////////
// CSI 2120 – Comprehensive Assignment (Part 1)
// Author: Nicholas Gin (300107597)
////////////////////////////////////////////////////

import java.util.*;
import java.io.*;

/**
 * This class represents the KTable, the 2D matrix that will hold all the Knapsack instances required to perform the Dynamic Programming algorithm.
 */
public class KTable{
    //INSTANCE VARIABLES
    private Knapsack[][] matrix;                    //The 2D matrix that holds instances of Knapsack

    private List<Knapsack> knapsacksAssociatedWith; //ASSOCIATION: The association between the KTable and the Knapsacks in the KTable

    /**
     * Constructs a KTable object.
     */
    public KTable(){
        ;
    }

    /**
     * Constructs a KTable object given the maximum number of Items and the maximum weight a Knapsack can hold.
     * @param numberOfItems The maximum number of Items that can be added to the Knapsack 
     * @param maximumWeight The maximum weight capacity of the Knapsack
     */
    public KTable(int numberOfItems, int maximumWeight){
        matrix = new Knapsack[numberOfItems + 1][maximumWeight + 1];    //The matrix is made up of (numberOfItems + 1) rows and (maximumWeight + 1) columns.
        knapsacksAssociatedWith = new ArrayList<Knapsack>();

        //Initialize the matrix of the KTable with an empty Knapsack in each index of the matrix.
        for (int r = 0; r < numberOfItems + 1; r++) {
            for (int c = 0; c < maximumWeight + 1; c++) {
                Knapsack knapsack = new Knapsack();
                matrix[r][c] = knapsack;
            }
        }
    }

    /**
     * This method places a Knapsack at a given 2D index (row, column) in the KTable's matrix.
     * @param row A given row of the KTable's matrix
     * @param column A given column of the KTable's matrix
     * @param addedKnapsack The Knapsack that will be placed in the KTable's matrix at the indicated row and column.
     */
    public void add (int row, int column, Knapsack addedKnapsack){
        matrix[row][column] = addedKnapsack;
    }

    /**
     * THis method returns the total value of all the Items contained in a Knapsack placed at a given 2D index (row, column) of the KTable's matrix.
     * @param row A given row of the KTable's matrix
     * @param column A given column of the KTable's matrix
     * @return The total value of all the Items contained in a Knapsack at a given 2D index of the KTable's matrix
     */
    public int getTotalValue (int row, int column){
        return matrix[row][column].getTotalValue();
    }

    /**
     * This method returns the Knapsack currently placed at a given 2D index (row, column) in the KTable's matrix.
     * @param row A given row of the KTable's matrix
     * @param column A given column of the KTable's matrix
     * @return The Knapsack currently placed at a given 2D index of the KTable's matrix
     */
    public Knapsack getKnapsack (int row, int column){
        return matrix[row][column];
    }

    /**
     * This method indicates that the KTable is associated to a particular Knapsack by adding the Knapsack to
     * the List of Knapsacks the KTable is associated to
     * @param knapsack The Knapsack that will be associated to the KTable
     */
    public void addToListOfKnapsacks (Knapsack knapsack){
        knapsacksAssociatedWith.add(knapsack);
    }

    /**
     * This method returns the List of Knapsacks the KTable is associated to
     * @return The List of Knapsacks the KTable is associated to
     */
    public List<Knapsack> getKnapsacksAssociatedWith(){
        return knapsacksAssociatedWith;
    }
}