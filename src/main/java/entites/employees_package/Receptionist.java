package entites.employees_package;

import java.time.LocalDate;
import java.time.LocalDateTime;
import entites.customers_package.Customer;
import entites.reservations_package.Reservation;
import entites.reservations_package.ReservationStatus;
import entites.tables_package.TableStatus;

/**
 * Represents a receptionist employee who handles reservation operations.
 * Extends the base Employee class with reservation management capabilities.
 */
public class Receptionist extends Employee {
    
    /**
     * Constructs a Receptionist with basic details.
     * Join date is automatically set to current date.
     * 
     * @param id Unique employee identifier
     * @param name Full name of employee
     * @param phone Contact phone number
     * @param username Account username
     * @param password Account password
     * @param email Account email
     */
    public Receptionist(String id, String name, String phone,
                       String username, String password, String email) {
        super(id, name, phone, username, password, email);
    }

    /**
     * Constructs a Receptionist with specific join date.
     * 
     * @param id Unique employee identifier
     * @param name Full name of employee
     * @param phone Contact phone number
     * @param username Account username
     * @param password Account password
     * @param email Account email
     * @param dateJoined Date when employee joined
     */
    public Receptionist(String id, String name, String phone,
                       String username, String password, String email,
                       LocalDate dateJoined) {
        super(id, name, phone, username, password, email, dateJoined);
    }

    /**
     * Gets the role of this employee.
     * @return String constant "Receptionist"
     */
    @Override
    public String getRole() {
        return "Receptionist";
    }

    /**
     * Creates a new reservation for a customer.
     * 
     * @param customer The customer making the reservation
     * @param dateTime The date and time for the reservation
     * @param partySize Number of people in the party
     * @param specialRequests Any special requirements
     * @return The created Reservation object
     * @throws IllegalArgumentException if any parameter is invalid
     */
    public Reservation createReservation(Customer customer, LocalDateTime dateTime,
                                      int partySize, String specialRequests) {
        // Validate input parameters
        if (customer == null) {
            throw new IllegalArgumentException("Customer cannot be null");
        }
        if (dateTime == null) {
            throw new IllegalArgumentException("Reservation time cannot be null");
        }
        if (partySize <= 0) {
            throw new IllegalArgumentException("Party size must be positive");
        }

        System.out.printf("Creating reservation for %s at %s for %d people%n",
                         customer.getName(), dateTime, partySize);
        
        // Create and return new reservation
        return new Reservation(customer, null, dateTime, partySize, specialRequests, this);
    }

    /**
     * Cancels an existing reservation.
     * Updates reservation status and frees the associated table.
     * 
     * @param reservation The reservation to cancel
     * @return true if cancellation was successful
     * @throws IllegalArgumentException if reservation is null
     */
    public boolean cancelReservation(Reservation reservation) {
        // Validate input
        if (reservation == null) {
            throw new IllegalArgumentException("Reservation cannot be null");
        }

        System.out.println("Canceling reservation #" + reservation.getReservationID());
        
        // Update reservation status
        reservation.setStatus(ReservationStatus.CANCELED);
        
        // Free the table if one was assigned
        if (reservation.getTable() != null) {
            reservation.getTable().setStatus(TableStatus.FREE);
        }
        
        return true;
    }

    /**
     * Modifies an existing reservation with new details.
     * 
     * @param reservation The reservation to modify
     * @param newDateTime New date and time for reservation
     * @param newPartySize Updated party size
     * @param newRequests Updated special requests
     * @return true if modification was successful
     * @throws IllegalArgumentException if any parameter is invalid
     */
    public boolean modifyReservation(Reservation reservation, LocalDateTime newDateTime,
                                   int newPartySize, String newRequests) {
        // Validate input parameters
        if (reservation == null) {
            throw new IllegalArgumentException("Reservation cannot be null");
        }
        if (newDateTime == null) {
            throw new IllegalArgumentException("New reservation time cannot be null");
        }
        if (newPartySize <= 0) {
            throw new IllegalArgumentException("New party size must be positive");
        }

        System.out.println("Modifying reservation #" + reservation.getReservationID());
        
        // Update reservation details
        reservation.setReservationTime(newDateTime);
        reservation.setPartySize(newPartySize);
        reservation.setSpecialRequests(newRequests);
        reservation.setStatus(ReservationStatus.MODIFIED);
        
        return true;
    }
}