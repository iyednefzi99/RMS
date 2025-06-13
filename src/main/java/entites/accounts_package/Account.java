package entites.accounts_package;

import java.time.LocalDateTime;

/**
 * The Account class represents a user account with attributes such as username, password, email, 
 * account status, and deletion information. It provides methods for managing account details 
 * and password resets.
 */
public class Account {
    private String username;
    private String password;
    private String email;
    private AccountStatus status;
    private boolean isDeleted;
    private LocalDateTime deletedAt;

    /**
     * Constructor to initialize an Account object with username, password, and email.
     * The account status is set to ACTIVE by default, and it is not marked as deleted.
     *
     * @param username the username of the account
     * @param password the password of the account
     * @param email the email associated with the account
     */
    public Account(String username, String password, String email) {
        this.username = username;
        this.password = password;
        this.email = email;
        this.status = AccountStatus.ACTIVE;
        this.isDeleted = false;
        this.deletedAt = null;
    }

    // Getters and setters
    public String getUsername() { 
        return username; 
    }
    public void setUsername(String username) { 
        this.username = username; 
    }
    public String getPassword() { 
        return password; 
    }
    public void setPassword(String password) { 
        this.password = password; 
    }
    public String getEmail() { 
        return email; 
    }
    public void setEmail(String email) { 
        this.email = email; 
    }
    public AccountStatus getStatus() { 
        return status; 
    }
    public void setStatus(AccountStatus status) { 
        this.status = status; 
    }

    public boolean isDeleted() {
        return isDeleted;
    }

    public void setDeleted(boolean isDeleted) {
        this.isDeleted = isDeleted;
    }

    public LocalDateTime getDeletedAt() {
        return deletedAt;
    }

    public void setDeletedAt(LocalDateTime deletedAt) {
        this.deletedAt = deletedAt;
    }

    /**
     * Resets the password of the account. This method does not check the old password or account status.
     *
     * @param oldPassword the current password of the account
     * @param newPassword the new password to set
     * @return true if the password was reset successfully
     */
    public boolean resetPassword(String oldPassword, String newPassword) {
        setPassword(newPassword);
        return true;
    }

    /**
     * Forces a password reset for the account. This method does not check the account status.
     *
     * @param newPassword the new password to set
     * @return true if the password was reset successfully
     */
    public boolean forceResetPassword(String newPassword) {
        setPassword(newPassword);
        return true;
    }
}
