// Customer.java
package entites.customers_package;

import entites.accounts_package.Account;
import java.util.Date;

// Customer class representing a customer
public class Customer {
    private String id;
    private String name;
    private String phone;
    private Account account;
    private Date lastVisited;

    public Customer(String id, String name, String phone, String username, String password, String email) {
        this(id, name, phone, username, password, email, null);
    }

    public Customer(String id, String name, String phone, String username, String password, String email, Date lastVisited) {
        this.id = id;
        this.name = name;
        this.phone = phone;
        this.account = new Account(username, password, email);
        this.lastVisited = lastVisited;
    }

    // Getters and setters
    public String getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getPhone() {
        return phone;
    }

    public Account getAccount() {
        return account;
    }

    public Date getLastVisited() {
        return lastVisited;
    }

    public String getRole() {
        return "Customer";
    }
}