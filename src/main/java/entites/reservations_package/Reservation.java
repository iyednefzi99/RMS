// Reservation.java
package entites.reservations_package;

import java.time.LocalDateTime;
import java.util.UUID;
import entites.customers_package.Customer;
import entites.employees_package.Employee;
import entites.tables_package.Table;
import entites.tables_package.TableStatus;

/**
 * Represents a restaurant table reservation with all associated details.
 * Manages reservation lifecycle including creation, modification, and status changes.
 */
public class Reservation {
    private static final String ID_PREFIX = "RES-"; // Prefix for reservation ID generation
    private static final int ID_LENGTH = 12;       // Length of the random part of reservation ID

    private String reservationID;      // Unique identifier for the reservation
    private Customer customer;         // Customer who made the reservation
    private Table table;               // Table being reserved
    private LocalDateTime reservationTime; // Scheduled date/time of reservation
    private int partySize;             // Number of people in the reservation
    private String specialRequests;    // Any special requirements for the reservation
    private Employee createdBy;        // Employee who created the reservation
    private ReservationStatus status;  // Current status of the reservation
    private final LocalDateTime createdAt; // When the reservation was created (immutable)
    private LocalDateTime updatedAt;   // When the reservation was last updated

    /**
     * Constructor for creating a new reservation.
     * @param customer Customer making the reservation
     * @param table Table being reserved
     * @param reservationTime Scheduled date/time
     * @param partySize Number of people
     * @param specialRequests Any special requirements
     * @param createdBy Employee creating the reservation
     */

    public Reservation(Customer customer, Table table, LocalDateTime reservationTime,
                      int partySize, String specialRequests, Employee createdBy) {
        this.reservationID = ID_PREFIX + UUID.randomUUID().toString().substring(0, ID_LENGTH);
        this.customer = customer;
        this.table = table;
        this.reservationTime = reservationTime;
        this.partySize = partySize;
        this.specialRequests = specialRequests;
        this.createdBy = createdBy;
        this.status = ReservationStatus.CONFIRMED;
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
        
        if (table != null) {
            table.setStatus(TableStatus.RESERVED);
        }
    }

    /**
     * Constructor for loading an existing reservation from storage (with table as String ID).
     * @param reservationID Existing reservation ID
     * @param customer Customer who made reservation
     * @param tableId Table ID (as String)
     * @param reservationTime Scheduled time
     * @param partySize Number of people
     * @param specialRequests Special requirements
     * @param createdBy Employee who created it
     * @param status Current status
     */
    public Reservation(String reservationID, Customer customer, String tableId,
                      LocalDateTime reservationTime, int partySize,
                      String specialRequests, Employee createdBy,
                      ReservationStatus status) {
        this.reservationID = reservationID;
        this.customer = customer;
        this.table = null; // Table will be set separately
        this.reservationTime = reservationTime;
        this.partySize = partySize;
        this.specialRequests = specialRequests;
        this.createdBy = createdBy;
        this.status = status;
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Constructor for loading an existing reservation from storage (with Table object).
     * @param reservationID Existing reservation ID
     * @param customer Customer who made reservation
     * @param table Reserved table
     * @param reservationTime Scheduled time
     * @param partySize Number of people
     * @param specialRequests Special requirements
     * @param createdBy Employee who created it
     * @param status Current status
     * @param createdAt Creation timestamp
     * @param updatedAt Last update timestamp
     */
    public Reservation(String reservationID, Customer customer, Table table,
                      LocalDateTime reservationTime, int partySize,
                      String specialRequests, Employee createdBy,
                      ReservationStatus status, LocalDateTime createdAt,
                      LocalDateTime updatedAt) {
        this.reservationID = reservationID;
        this.customer = customer;
        this.table = table;
        this.reservationTime = reservationTime;
        this.partySize = partySize;
        this.specialRequests = specialRequests;
        this.createdBy = createdBy;
        this.status = status;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    /**
     * Marks the reservation as completed and frees the table.
     * @return true always (operation always succeeds)
     */
    public boolean complete() {
        this.status = ReservationStatus.COMPLETED;
        if (table != null) {
            table.setStatus(TableStatus.FREE);
        }
        this.updatedAt = LocalDateTime.now();
        return true;
    }

    /**
     * Marks the reservation as no-show and frees the table.
     * @return true always (operation always succeeds)
     */
    public boolean markAsNoShow() {
        this.status = ReservationStatus.NO_SHOW;
        if (table != null) {
            table.setStatus(TableStatus.FREE);
        }
        this.updatedAt = LocalDateTime.now();
        return true;
    }

    /**
     * Checks if the reservation can be modified.
     * @return true if status is CONFIRMED or PENDING, false otherwise
     */
    public boolean canBeModified() {
        return status == ReservationStatus.CONFIRMED || status == ReservationStatus.PENDING;
    }

    // Getters with documentation
    /** @return The reservation's unique ID */
    public String getReservationID() { return reservationID; }
    
    /** @return The customer who made the reservation */
    public Customer getCustomer() { return customer; }
    
    /** @return The reserved table */
    public Table getTable() { return table; }
    
    /** @return The scheduled reservation time */
    public LocalDateTime getReservationTime() { return reservationTime; }
    
    /** @return Number of people in the reservation */
    public int getPartySize() { return partySize; }
    
    /** @return Any special requests */
    public String getSpecialRequests() { return specialRequests; }
    
    /** @return Employee who created the reservation */
    public Employee getCreatedBy() { return createdBy; }
    
    /** @return Current reservation status */
    public ReservationStatus getStatus() { return status; }
    
    /** @return When the reservation was created */
    public LocalDateTime getCreatedAt() { return createdAt; }
    
    /** @return When the reservation was last updated */
    public LocalDateTime getUpdatedAt() { return updatedAt; }

    // Setters with documentation
    /** @param id New reservation ID */
    public void setReservationID(String id) {
        this.reservationID = id;
        this.updatedAt = LocalDateTime.now();
    }

    /** @param customer New customer */
    public void setCustomer(Customer customer) {
        this.customer = customer;
        this.updatedAt = LocalDateTime.now();
    }

    /** @param table New table */
    public void setTable(Table table) {
        this.table = table;
        this.updatedAt = LocalDateTime.now();
    }

    /** @param reservationTime New reservation time */
    public void setReservationTime(LocalDateTime reservationTime) {
        this.reservationTime = reservationTime;
        this.updatedAt = LocalDateTime.now();
    }

    /** @param partySize New party size */
    public void setPartySize(int partySize) {
        this.partySize = partySize;
        this.updatedAt = LocalDateTime.now();
    }

    /** @param specialRequests New special requests */
    public void setSpecialRequests(String specialRequests) {
        this.specialRequests = specialRequests;
        this.updatedAt = LocalDateTime.now();
    }

    /** @param createdBy New employee creator */
    public void setCreatedBy(Employee createdBy) {
        this.createdBy = createdBy;
        this.updatedAt = LocalDateTime.now();
    }

    /** @param status New status */
    public void setStatus(ReservationStatus status) {
        this.status = status;
        this.updatedAt = LocalDateTime.now();
    }

    /** @param updatedAt New update timestamp */
    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    /**
     * Returns a formatted string representation of the reservation.
     * @return String containing key reservation details
     */
    @Override
    public String toString() {
        return String.format("Reservation[%s] for %s at table %s on %s (%d people, Status: %s, Created: %s, Updated: %s)",
                reservationID, customer != null ? customer.getName() : "null",
                table != null ? table.getTableID() : "null",
                reservationTime, partySize, status, createdAt, updatedAt);
    }

    /**
     * Compares reservations based on their ID.
     * @param o Object to compare with
     * @return true if same reservation ID, false otherwise
     */
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Reservation that = (Reservation) o;
        return reservationID.equals(that.reservationID);
    }

    /**
     * Generates hash code based on reservation ID.
     * @return Hash code of reservation ID
     */
    @Override
    public int hashCode() {
        return reservationID.hashCode();
    }
}