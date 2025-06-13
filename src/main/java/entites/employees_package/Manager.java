package entites.employees_package;

import java.time.LocalDate;

/**
 * Represents a Manager employee with elevated system privileges.
 * Extends the base Employee class.
 */
public class Manager extends Employee {



    /**
     * Creates a new Manager with basic details.
     */
    public Manager(String id, String name, String phone,
                 String username, String password, String email) {
        super(id, name, phone, username, password, email);
    }

    /**
     * Creates a new Manager with specific join date.
     */
    public Manager(String id, String name, String phone,
                 String username, String password, String email,
                 LocalDate dateJoined) {
        super(id, name, phone, username, password, email, dateJoined);
    }


    @Override
    public String getRole() {
        return "Manager"; // Returns the role of the employee
    }
}
