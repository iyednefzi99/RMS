package dao;

import java.sql.*;
import java.sql.Date;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import entites.customers_package.Customer;
import entites.customers_package.VIPCustomer;

// CustomerDAO class for managing customer-related database operations
public class CustomerDAO implements BaseDAO<Customer> {
    private static final Logger logger = Logger.getLogger(CustomerDAO.class.getName());
    
    @Override
    public Optional<Customer> get(String id) {
        if (id == null || id.trim().isEmpty()) {
            return Optional.empty();
        }

        String sql = "SELECT c.*, a.username, a.password, a.email, a.status " +
                     "FROM customers c JOIN accounts a ON c.account_username = a.username " +
                     "WHERE c.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(createCustomerFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error retrieving customer: " + id, e);
        }
        return Optional.empty();
    }

    @Override
    public List<Customer> getAll() {
        List<Customer> customers = new ArrayList<>();
        String sql = "SELECT c.*, a.username, a.password, a.email, a.status " +
                     "FROM customers c JOIN accounts a ON c.account_username = a.username";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                try {
                    customers.add(createCustomerFromResultSet(rs));
                } catch (SQLException e) {
                    logger.log(Level.WARNING, "Error creating customer from result set", e);
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error retrieving all customers", e);
        }
        return customers;
    }

    @Override
    public boolean save(Customer customer) {
        if (customer == null || customer.getId() == null || customer.getAccount() == null) {
            return false;
        }

        String sql = "INSERT INTO customers (id, name, phone, account_username, last_visited, client_discount) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, customer.getId());
            stmt.setString(2, customer.getName());
            stmt.setString(3, customer.getPhone());
            stmt.setString(4, customer.getAccount().getUsername());
            
            Timestamp lastVisited = customer.getLastVisited() != null ? 
                new Timestamp(customer.getLastVisited().getTime()) :
                new Timestamp(System.currentTimeMillis());
            stmt.setTimestamp(5, lastVisited);

            if (customer instanceof VIPCustomer) {
                stmt.setInt(6, ((VIPCustomer) customer).getClientDiscount());
            } else {
                stmt.setInt(6, 0);
            }
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error saving customer: " + (customer != null ? customer.getId() : "null"), e);
            return false;
        }
    }

    @Override
    public boolean update(Customer customer) {
        if (customer == null || customer.getId() == null || customer.getAccount() == null) {
            return false;
        }

        String sql = "UPDATE customers SET name = ?, phone = ?, account_username = ?, " +
                     "last_visited = ?, client_discount = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, customer.getName());
            stmt.setString(2, customer.getPhone());
            stmt.setString(3, customer.getAccount().getUsername());
            stmt.setTimestamp(4, new Timestamp(customer.getLastVisited().getTime()));
            
            if (customer instanceof VIPCustomer) {
                stmt.setInt(5, ((VIPCustomer) customer).getClientDiscount());
            } else {
                stmt.setInt(5, 0);
            }
            
            stmt.setString(6, customer.getId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating customer: " + customer.getId(), e);
            return false;
        }
    }

    @Override
    public boolean delete(String id) {
        if (id == null || id.trim().isEmpty()) {
            return false;
        }

        String sql = "DELETE FROM customers WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error deleting customer: " + id, e);
            return false;
        }
    }
    
    // Helper method to create a Customer object from a ResultSet
    private Customer createCustomerFromResultSet(ResultSet rs) throws SQLException {
        String id = rs.getString("id");
        String name = rs.getString("name");
        String phone = rs.getString("phone");
        String username = rs.getString("username");
        String password = rs.getString("password");
        String email = rs.getString("email");
        Date lastVisited = rs.getTimestamp("last_visited") != null ? 
                new Date(rs.getTimestamp("last_visited").getTime()) : 
                null;
        int clientDiscount = rs.getInt("client_discount");
        
        if (clientDiscount > 0) {
            return new VIPCustomer(id, name, phone, username, password, email, lastVisited, clientDiscount);
        } else {
            return new Customer(id, name, phone, username, password, email, lastVisited);
        }
    }
    
    // Method to get customers by account username
    public List<Customer> getCustomersByAccount(String accountUsername) {
        if (accountUsername == null || accountUsername.trim().isEmpty()) {
            return Collections.emptyList();
        }

        List<Customer> customers = new ArrayList<>();
        String sql = "SELECT c.*, a.username, a.password, a.email, a.status " +
                     "FROM customers c JOIN accounts a ON c.account_username = a.username " +
                     "WHERE c.account_username = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, accountUsername);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    try {
                        customers.add(createCustomerFromResultSet(rs));
                    } catch (SQLException e) {
                        logger.log(Level.WARNING, "Error creating customer from result set", e);
                    }
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error retrieving customers for account: " + accountUsername, e);
        }
        return customers;
    }
    
    // Method to update the last visited timestamp for a customer
    public boolean updateLastVisited(String customerId) {
        if (customerId == null || customerId.trim().isEmpty()) {
            return false;
        }

        String sql = "UPDATE customers SET last_visited = CURRENT_TIMESTAMP WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, customerId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating last visited for customer: " + customerId, e);
            return false;
        }
    }
}
