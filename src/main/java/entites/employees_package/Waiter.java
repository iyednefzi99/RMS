package entites.employees_package;

import java.time.LocalDate;

/**
 * Waiter class extends the Employee class to represent a waiter in the system.
 */
public class Waiter extends Employee {
    // Constructor for creating a waiter with basic details
    public Waiter(String id, String name, String phone,
                  String username, String password, String email) {
        super(id, name, phone, username, password, email);
    }

    // Constructor for creating a waiter with a specified join date
    public Waiter(String id, String name, String phone,
                  String username, String password, String email,
                  LocalDate dateJoined) {
        super(id, name, phone, username, password, email, dateJoined);
    }

    @Override
    public String getRole() {
        return "Waiter"; // Returns the role of the employee
    }
/*
    public Order createOrder(Table table, Customer customer) {
        // Validates table and customer
        if (table == null || customer == null) {
            throw new IllegalArgumentException("Table and customer cannot be null");
        }

        System.out.printf("Creating new order for table %s, customer %s%n",
                          table.getTableID(), customer.getName());
        Order newOrder = new Order(table, customer, this);
        table.setStatus(Status.OCCUPIED); // Sets the table status to occupied
        return newOrder; // Returns the new order
    }

    public boolean addMenuItemToOrder(Order order, MenuItem item, int quantity, String specialRequest) {
        // Validates order and item
        if (order == null || item == null) {
            throw new IllegalArgumentException("Order and item cannot be null");
        }
        if (quantity <= 0) {
            throw new IllegalArgumentException("Quantity must be positive");
        }

        System.out.printf("Adding %d x %s (%.2f) to order #%s%n",
                          quantity, item.getTitle(), item.getPrice(), order.getOrderID());
        if (specialRequest != null && !specialRequest.isEmpty()) {
            System.out.println("Special request: " + specialRequest);
        }
        return order.addMenuItem(item, quantity, specialRequest); // Adds the menu item to the order
    }

    public boolean updateOrderStatus(Order order, OrderStatus newStatus) {
        // Validates order and new status
        if (order == null || newStatus == null) {
            throw new IllegalArgumentException("Arguments cannot be null");
        }

        System.out.printf("Updating order #%s from %s to %s%n",
                          order.getOrderID(), order.getStatus(), newStatus);
        order.updateStatus(newStatus); // Updates the order status

        // Sets the table status based on the new order status
        if (newStatus == OrderStatus.COMPLETED || newStatus == OrderStatus.CANCELLED) {
            order.getTable().setStatus(Status.FREE);
        }
        return true;
    }

    public double calculateOrderTotal(Order order) {
        // Validates order
        if (order == null) {
            throw new IllegalArgumentException("Order cannot be null");
        }
        return order.calculateTotal(); // Returns the total of the order
    }*/
}
