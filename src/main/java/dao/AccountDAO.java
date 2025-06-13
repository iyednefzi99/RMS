package dao;

import java.sql.*;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import entites.accounts_package.Account;
import entites.accounts_package.AccountStatus;

// AccountDAO class for managing account-related database operations
public class AccountDAO implements BaseDAO<Account> {
    private static final Logger logger = Logger.getLogger(AccountDAO.class.getName());

    @Override
    public Optional<Account> get(String username) {
        if (username == null || username.trim().isEmpty()) {
            return Optional.empty();
        }

        String sql = "SELECT username, password, email, status, is_deleted, deleted_at FROM accounts WHERE username = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, username);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Account account = new Account(
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("email")
                    );
                    account.setStatus(AccountStatus.valueOf(rs.getString("status")));
                    account.setDeleted(rs.getBoolean("is_deleted"));
                    Timestamp deletedAt = rs.getTimestamp("deleted_at");
                    account.setDeletedAt(deletedAt != null ? deletedAt.toLocalDateTime() : null);
                    return Optional.of(account);
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error retrieving account: " + username, e);
        } catch (IllegalArgumentException e) {
            logger.log(Level.WARNING, "Invalid account status for user: " + username, e);
        }
        return Optional.empty();
    }

    @Override
    public List<Account> getAll() {
        List<Account> accounts = new ArrayList<>();
        String sql = "SELECT username, password, email, status, is_deleted, deleted_at FROM accounts WHERE is_deleted = FALSE";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                try {
                    Account account = new Account(
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("email")
                    );
                    account.setStatus(AccountStatus.valueOf(rs.getString("status")));
                    account.setDeleted(rs.getBoolean("is_deleted"));
                    if (rs.getTimestamp("deleted_at") != null) {
                        account.setDeletedAt(rs.getTimestamp("deleted_at").toLocalDateTime());
                    }
                    accounts.add(account);
                } catch (IllegalArgumentException e) {
                    logger.log(Level.WARNING, "Skipping account with invalid status", e);
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error retrieving all accounts", e);
        }
        return accounts;
    }

    // New method to get deleted accounts
    public List<Account> getDeletedAccounts() {
        List<Account> accounts = new ArrayList<>();
        String sql = "SELECT username, password, email, status, is_deleted, deleted_at FROM accounts WHERE is_deleted = TRUE";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                try {
                    Account account = new Account(
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("email")
                    );
                    account.setStatus(AccountStatus.valueOf(rs.getString("status")));
                    account.setDeleted(rs.getBoolean("is_deleted"));
                    if (rs.getTimestamp("deleted_at") != null) {
                        account.setDeletedAt(rs.getTimestamp("deleted_at").toLocalDateTime());
                    }
                    accounts.add(account);
                } catch (IllegalArgumentException e) {
                    logger.log(Level.WARNING, "Skipping account with invalid status", e);
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error retrieving deleted accounts", e);
        }
        return accounts;
    }

    @Override
    public boolean save(Account account) {
        if (account == null || account.getUsername() == null || 
            account.getPassword() == null || account.getEmail() == null) {
            return false;
        }

        String sql = "INSERT INTO accounts (username, password, email, status, is_deleted) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, account.getUsername());
            stmt.setString(2, account.getPassword());
            stmt.setString(3, account.getEmail());
            stmt.setString(4, account.getStatus().name());
            stmt.setBoolean(5, account.isDeleted());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error saving account: " + account.getUsername(), e);
            return false;
        }
    }

    @Override
    public boolean update(Account account) {
        if (account == null || account.getUsername() == null) {
            return false;
        }

        String sql = "UPDATE accounts SET password = ?, email = ?, status = ?, is_deleted = ?, deleted_at = ? WHERE username = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, account.getPassword());
            stmt.setString(2, account.getEmail());
            stmt.setString(3, account.getStatus().name());
            stmt.setBoolean(4, account.isDeleted());
            stmt.setTimestamp(5, account.getDeletedAt() != null ? 
                Timestamp.valueOf(account.getDeletedAt()) : null);
            stmt.setString(6, account.getUsername());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating account: " + account.getUsername(), e);
            return false;
        }
    }

    @Override
    public boolean delete(String username) {
        if (username == null || username.trim().isEmpty()) {
            return false;
        }

        String sql = "UPDATE accounts SET is_deleted = TRUE, status = 'DELETED', deleted_at = CURRENT_TIMESTAMP WHERE username = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, username);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error soft-deleting account: " + username, e);
            return false;
        }
    }

    // New method to restore account
    public boolean restore(String username) {
        if (username == null || username.trim().isEmpty()) {
            return false;
        }

        String sql = "UPDATE accounts SET is_deleted = FALSE, status = 'ACTIVE', deleted_at = NULL WHERE username = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, username);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error restoring account: " + username, e);
            return false;
        }
    }

    // Additional methods for account management
    public boolean exists(String username) {
        if (username == null || username.trim().isEmpty()) {
            return false;
        }

        String sql = "SELECT 1 FROM accounts WHERE username = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, username);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error checking account existence for username: " + username, e);
            return false;
        }
    }

    public boolean changePassword(String username, String newPassword) {
        if (username == null || username.trim().isEmpty() || newPassword == null || newPassword.trim().isEmpty()) {
            return false;
        }

        String sql = "UPDATE accounts SET password = ? WHERE username = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, newPassword);
            stmt.setString(2, username);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error changing password for user: " + username, e);
            return false;
        }
    }

    public Optional<String> getEmail(String username) {
        if (username == null || username.trim().isEmpty()) {
            return Optional.empty();
        }

        String sql = "SELECT email FROM accounts WHERE username = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, username);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(rs.getString("email"));
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error retrieving email for user: " + username, e);
        }
        return Optional.empty();
    }

    public boolean validateCredentials(String username, String password) {
        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            return false;
        }

        String sql = "SELECT password FROM accounts WHERE username = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, username);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    String storedPassword = rs.getString("password");
                    return storedPassword != null && storedPassword.equals(password);
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error validating credentials for user: " + username, e);
        }
        return false;
    }

    public int countAll() {
        String sql = "SELECT COUNT(*) FROM accounts";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error counting accounts", e);
        }
        return 0;
    }
}
