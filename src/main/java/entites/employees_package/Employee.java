package entites.employees_package;

import java.time.LocalDate;

import entites.accounts_package.*;

/**
 * Abstract Employee class representing a generic employee with common attributes and methods.
 */
public abstract class Employee {
    private final String id; // Unique identifier for the employee
    private String name; // Name of the employee
    private String phone; // Phone number of the employee
    private final Account account; // Account associated with the employee
    private LocalDate dateJoined; // Date when the employee joined

    // Constructor for creating an employee with basic details
    public Employee(String id, String name, String phone,
                   String username, String password, String email) {
        this.id = id;
        this.name = name;
        this.phone = phone;
        this.account = new Account(username, password, email);
        this.dateJoined = LocalDate.now(); // Sets the join date to today
    }

    // Constructor for creating an employee with a specified join date
    public Employee(String id, String name, String phone,
                   String username, String password, String email,
                   LocalDate dateJoined) {
        this(id, name, phone, username, password, email);
        setDateJoined(dateJoined);
    }

    // Getters
    public String getId() { return id; }
    public String getName() { return name; }
    public String getPhone() { return phone; }
    public Account getAccount() { return account; }
    public LocalDate getDateJoined() { return dateJoined; }

    // Setters
    public void setName(String name) {
        this.name = name; // Sets the name of the employee
    }

    public void setPhone(String phone) {
        this.phone = phone; // Sets the phone number of the employee
    }
    /**
     * Sets the employee's join date with validation.
     * @param dateJoined The join date to set
     * @throws IllegalArgumentException if date is null or in the future
     */
    public void setDateJoined(LocalDate dateJoined) {
        if (dateJoined == null) {
            throw new IllegalArgumentException("Join date cannot be null");
        }
        if (dateJoined.isAfter(LocalDate.now())) {
            throw new IllegalArgumentException("Join date cannot be in the future");
        }
        this.dateJoined = dateJoined;
    }
    
    /**
     * Abstract method to get the employee's role.
     * @return String representing the employee's role
     */
    public abstract String getRole();
    @Override
    public String toString() {
        return getClass().getSimpleName() + "{" +
                "id='" + id + '\'' +
                ", name='" + name + '\'' +
                ", phone='" + phone + '\'' +
                ", accountUsername='" + account.getUsername() + '\'' +
                ", dateJoined=" + dateJoined +
                '}'; // Returns a string representation of the employee
    }
}
