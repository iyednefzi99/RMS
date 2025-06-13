// TableStatus.java
package entites.tables_package;

/**
 * Enum representing all possible statuses a restaurant table can have.
 * This helps track the current state of each table in the restaurant management system.
 */
public enum TableStatus {
    FREE,               // Table is available for new customers
    RESERVED,           // Table has been reserved for future use
    OCCUPIED,           // Table is currently being used by customers
    CANCELED,           // Reservation for this table was canceled
    WAITLISTED,         // Table is on a waitlist for reservations
    IN_SERVICE,         // Table is currently being served
    OUT_OF_SERVICE,     // Table is temporarily unavailable
    PENDING,            // Table status is pending confirmation
    UNAVAILABLE,        // Table is not available for any use
    READY_FOR_CLEANING, // Table needs cleaning
    BEING_CLEANED,      // Table is currently being cleaned
    BOOKED,             // Table has been booked (similar to reserved)
    CHECKED_OUT,        // Customers have left but table needs processing
    TEMPORARILY_CLOSED, // Table is closed temporarily
    RESERVED_FOR_EVENT, // Table reserved for a special event
    PARTIALLY_OCCUPIED; // Table is partially occupied (some seats available)
}