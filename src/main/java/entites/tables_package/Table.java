// Table.java
package entites.tables_package;

import java.util.UUID;

/**
 * Represents a table in the restaurant with its attributes and status.
 * Contains information about the table's capacity, location, and seating type.
 */
public class Table {
    private String tableID;            // Unique identifier for the table
    private TableStatus status;        // Current status of the table
    private int maxCapacity;           // Maximum number of people the table can accommodate
    private int locationIdentifier;    // Identifier for the table's physical location
    private SeatType typeofseat;      // Type of seating (e.g., booth, bar)

    /**
     * Constructs a new Table with specified attributes.
     * @param maxCapacity Maximum capacity of the table
     * @param locationIdentifier Identifier for the table's location
     * @param typeofseat Type of seating for the table
     */
    public Table(int maxCapacity, int locationIdentifier, SeatType typeofseat) {
        this.tableID = "TBL-" + UUID.randomUUID().toString().substring(0, 8);
        this.maxCapacity = maxCapacity;
        this.locationIdentifier = locationIdentifier;
        this.typeofseat = typeofseat;
        this.status = TableStatus.FREE; // New tables are initially free
    }

    /**
     * Checks if the table is currently available for seating.
     * @return true if table is free, false otherwise
     */
    public boolean isAvailable() {
        return status == TableStatus.FREE;
    }

    // Getters and Setters with brief descriptions

    /** @return The table's unique identifier */
    public String getTableID() { return tableID; }
    
    /** @return The type of seating at the table */
    public SeatType getTypeofseat() { return typeofseat; }
    
    /** @param typeofseat The new seating type to set */
    public void setTypeofseat(SeatType typeofseat) { this.typeofseat = typeofseat; }
    
    /** @return The current status of the table */
    public TableStatus getStatus() { return status; }
    
    /** @param status The new status to set for the table */
    public void setStatus(TableStatus status) { this.status = status; }
    
    /** @return The maximum capacity of the table */
    public int getMaxCapacity() { return maxCapacity; }
    
    /** @return The location identifier of the table */
    public int getLocationIdentifier() { return locationIdentifier; }
    
    /** @param maxCapacity The new maximum capacity to set */
    public void setMaxCapacity(int maxCapacity) { this.maxCapacity = maxCapacity; }
    
    /** @param locationIdentifier The new location identifier to set */
    public void setLocationIdentifier(int locationIdentifier) { 
        this.locationIdentifier = locationIdentifier; 
    }
    
    /** @param tableID The new table ID to set */
    public void setTableID(String tableID) { this.tableID = tableID; }

    /**
     * Returns a string representation of the table.
     * @return String containing all table attributes
     */
    @Override
    public String toString() {
        return "Table [tableID=" + tableID + ", status=" + status + ", maxCapacity=" + maxCapacity
                + ", locationIdentifier=" + locationIdentifier + ", typeofseat=" + typeofseat + "]";
    }
}