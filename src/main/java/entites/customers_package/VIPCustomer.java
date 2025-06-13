// VIPCustomer.java
package entites.customers_package;

import java.util.Date;

/**
 * VIPCustomer class extends the Customer class to represent a VIP customer with a discount.
 */
public class VIPCustomer extends Customer {
    private int clientDiscount; // Discount percentage for VIP customers

    // Constructor for creating a VIP customer with a default discount of 10%
    public VIPCustomer(String id, String name, String phone,
                     String username, String password, String email) {
        super(id, name, phone, username, password, email);
        this.clientDiscount = 10;
    }

    // Constructor for creating a VIP customer with a specified discount
    public VIPCustomer(String id, String name, String phone,
                     String username, String password, String email,
                     int clientDiscount) {
        super(id, name, phone, username, password, email);
        setClientDiscount(clientDiscount);
    }

    // Constructor for creating a VIP customer with last visited date and specified discount
    public VIPCustomer(String id, String name, String phone,
                     String username, String password, String email,
                     Date lastVisited, int clientDiscount) {
        super(id, name, phone, username, password, email, lastVisited);
        setClientDiscount(clientDiscount);
    }

    @Override
    public String getRole() {
        return "VIP Customer"; // Returns the role of the customer
    }

    public int getClientDiscount() {
        return clientDiscount; // Returns the client discount
    }

    public void setClientDiscount(int clientDiscount) {
        // Validates the discount percentage
        if (clientDiscount < 0 || clientDiscount > 50) {
            throw new IllegalArgumentException("Discount must be between 0 and 50 percent");
        }
        this.clientDiscount = clientDiscount; // Sets the client discount
    }

    public double applyDiscount(double amount) {
        // Applies the discount to the given amount
        return amount * (100 - clientDiscount) / 100.0;
    }
}