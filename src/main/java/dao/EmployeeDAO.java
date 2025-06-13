package dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;
import entites.employees_package.Employee;
import entites.employees_package.Manager;
import entites.employees_package.Receptionist;
import entites.employees_package.Waiter;

// EmployeeDAO class for managing employee-related database operations
public class EmployeeDAO implements BaseDAO<Employee> {
    private static final Logger logger = Logger.getLogger(EmployeeDAO.class.getName());
    private final AccountDAO accountDAO = new AccountDAO();

    @Override
    public Optional<Employee> get(String id) {
        if (id == null || id.trim().isEmpty()) {
            return Optional.empty();
        }

        String sql = "SELECT e.*, a.username, a.password, a.email, a.status " +
                     "FROM employees e JOIN accounts a ON e.account_username = a.username " +
                     "WHERE e.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(createEmployeeFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error retrieving employee: " + id, e);
        }
        return Optional.empty();
    }

    @Override
    public List<Employee> getAll() {
        List<Employee> employees = new ArrayList<>();
        String sql = "SELECT e.*, a.username, a.password, a.email, a.status " +
                     "FROM employees e JOIN accounts a ON e.account_username = a.username";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                try {
                    employees.add(createEmployeeFromResultSet(rs));
                } catch (SQLException e) {
                    logger.log(Level.WARNING, "Error creating employee from result set", e);
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error retrieving all employees", e);
        }
        return employees;
    }

    @Override
    public boolean save(Employee employee) {
        if (employee == null || employee.getId() == null || employee.getAccount() == null) {
            return false;
        }

        // First save the account
        if (!accountDAO.save(employee.getAccount())) {
            return false;
        }
        
        String sql = "INSERT INTO employees (id, name, phone, account_username, date_joined, role) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, employee.getId());
            stmt.setString(2, employee.getName());
            stmt.setString(3, employee.getPhone());
            stmt.setString(4, employee.getAccount().getUsername());
            stmt.setDate(5, Date.valueOf(employee.getDateJoined()));
            stmt.setString(6, getEmployeeRole(employee));
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error saving employee: " + (employee != null ? employee.getId() : "null"), e);
            return false;
        }
    }

    @Override
    public boolean update(Employee employee) {
        if (employee == null || employee.getId() == null || employee.getAccount() == null) {
            return false;
        }

        // First update the account
        if (!accountDAO.update(employee.getAccount())) {
            return false;
        }
        
        String sql = "UPDATE employees SET name = ?, phone = ?, date_joined = ?, role = ? " +
                     "WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, employee.getName());
            stmt.setString(2, employee.getPhone());
            stmt.setDate(3, Date.valueOf(employee.getDateJoined()));
            stmt.setString(4, getEmployeeRole(employee));
            stmt.setString(5, employee.getId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating employee: " + employee.getId(), e);
            return false;
        }
    }

    @Override
    public boolean delete(String id) {
        if (id == null || id.trim().isEmpty()) {
            return false;
        }

        // First get the employee to delete their account too
        Optional<Employee> employeeOpt = get(id);
        if (employeeOpt.isEmpty()) {
            return false;
        }
        
        String sql = "DELETE FROM employees WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, id);
            boolean deleted = stmt.executeUpdate() > 0;
            
            if (deleted) {
                // Delete the associated account
                return accountDAO.delete(employeeOpt.get().getAccount().getUsername());
            }
            return false;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error deleting employee: " + id, e);
            return false;
        }
    }
    
    // Helper method to create an Employee object from a ResultSet
    private Employee createEmployeeFromResultSet(ResultSet rs) throws SQLException {
        String id = rs.getString("id");
        String name = rs.getString("name");
        String phone = rs.getString("phone");
        String username = rs.getString("username");
        String password = rs.getString("password");
        String email = rs.getString("email");
        Date dateJoined = rs.getDate("date_joined");
        String role = rs.getString("role");
        
        switch (role) {
            case "WAITER":
                return new Waiter(id, name, phone, username, password, email, dateJoined.toLocalDate());
            case "MANAGER":
                return new Manager(id, name, phone, username, password, email, dateJoined.toLocalDate());
            case "RECEPTIONIST":
                return new Receptionist(id, name, phone, username, password, email, dateJoined.toLocalDate());
            default:
                throw new SQLException("Unknown employee role: " + role);
        }
    }
    
    // Method to get employees by account username
    public List<Employee> getEmployeesByAccount(String accountUsername) {
        if (accountUsername == null || accountUsername.trim().isEmpty()) {
            return Collections.emptyList();
        }

        List<Employee> employees = new ArrayList<>();
        String sql = "SELECT e.*, a.username, a.password, a.email, a.status " +
                     "FROM employees e JOIN accounts a ON e.account_username = a.username " +
                     "WHERE e.account_username = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, accountUsername);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    try {
                        employees.add(createEmployeeFromResultSet(rs));
                    } catch (SQLException e) {
                        logger.log(Level.WARNING, "Error creating employee from result set", e);
                    }
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error retrieving employees for account: " + accountUsername, e);
        }
        return employees;
    }
    /**
     * Helper method to determine the role string for database storage
     * @param employee The employee object
     * @return String representation of the employee's role
     */
    private String getEmployeeRole(Employee employee) {
        if (employee instanceof Manager) {
            return "MANAGER";
        } else if (employee instanceof Receptionist) {
            return "RECEPTIONIST";
        } else if (employee instanceof Waiter) {
            return "WAITER";
        }
        throw new IllegalArgumentException("Unknown employee type");
    }
}
