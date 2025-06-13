// ReservationStatus.java
package entites.reservations_package;

/**
 * Enum representing all possible states a reservation can be in.
 * Tracks the complete lifecycle of a reservation from creation to completion.
 */
public enum ReservationStatus {
    PENDING,            // Reservation is awaiting confirmation
    CONFIRMED,          // Reservation has been confirmed
    CANCELED,           // Reservation was canceled
    ABANDONED,          // Reservation was abandoned without cancellation
    COMPLETED,          // Reservation was fulfilled
    NO_SHOW,            // Customer didn't arrive for reservation
    MODIFIED,           // Reservation details were changed
    EXPIRED,            // Reservation passed without action
    WAITLISTED,         // On waiting list for availability
    REJECTED,           // Reservation request was rejected
    IN_PROGRESS,        // Customers are currently using the table
    VERIFIED,           // Reservation details have been verified
    PARTIALLY_CONFIRMED,// Part of a group reservation is confirmed
    AWAITING_PAYMENT,   // Waiting for payment confirmation
    CANCELLED_BY_USER,  // Explicitly canceled by customer
    CANCELLED_BY_SYSTEM,// Canceled by system (e.g., no-show policy)
    RESCHEDULED         // Reservation was moved to different time
}