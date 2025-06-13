package controller;

import java.io.IOException;

import java.util.List;

import dao.AccountDAO;
import entites.accounts_package.Account;
import entites.accounts_package.AccountStatus;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


/**
 * Servlet implementation for handling account-related operations.
 * Provides CRUD functionality with soft delete capabilities and account restoration.
 * Maps to URLs with pattern "/account/*"
 */
@WebServlet("/account/*")
public class AccountServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AccountDAO accountDAO;  // Data Access Object for account operations

    /**
     * Initializes the servlet by creating an instance of AccountDAO
     */
    public void init() {
        accountDAO = new AccountDAO();
    }

    /**
     * Handles HTTP POST requests by delegating to doGet
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    /**
     * Main method handling all HTTP GET requests.
     * Routes requests to appropriate handler methods based on the action path.
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Determine action from path info, default to "/list" if none specified
        String action = request.getPathInfo() == null ? "/list" : request.getPathInfo();

        try {
            // Route to appropriate method based on action
            switch (action) {
                case "/new":
                    showNewForm(request, response);  // Show account creation form
                    break;
                case "/insert":
                    insertAccount(request, response);  // Create new account
                    break;
                case "/delete":
                    deleteAccount(request, response);  // Soft delete account
                    break;
                case "/edit":
                    showEditForm(request, response);  // Show account edit form
                    break;
                case "/update":
                    updateAccount(request, response);  // Update existing account
                    break;
                case "/restore":
                    restoreAccount(request, response);  // Restore soft-deleted account
                    break;
                case "/deleted":
                    listDeletedAccounts(request, response);  // List deleted accounts
                    break;
                case "/list":
                	listAccounts(request, response);  // List deleted accounts
                    break;
                default:
                    listAccounts(request, response);  // List active accounts (default)
                    break;
            }
        } catch (Exception ex) {
            // Handle errors by forwarding to error page
            request.setAttribute("error", ex.getMessage());
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        }
    }

    /**
     * Lists all active accounts
     */
    private void listAccounts(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        List<Account> accounts = accountDAO.getAll();
        request.setAttribute("accounts", accounts);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/account/accountlist.jsp");
        dispatcher.forward(request, response);
    }

    /**
     * Lists all soft-deleted accounts
     */
    private void listDeletedAccounts(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        List<Account> accounts = accountDAO.getDeletedAccounts();
        request.setAttribute("accounts", accounts);
        request.setAttribute("showDeleted", true);  // Flag to indicate showing deleted accounts
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/account/deletedaccounts.jsp");
        dispatcher.forward(request, response);
    }

    /**
     * Displays form for creating a new account
     */
    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        request.setAttribute("accountStatuses", AccountStatus.values());  // Add status options
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/account/accountform.jsp");
        dispatcher.forward(request, response);
    }

    /**
     * Displays form for editing an existing account
     */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        String username = request.getParameter("username");
        if (username == null || username.trim().isEmpty()) {
            throw new Exception("Username is required");
        }

        // Retrieve existing account or throw exception if not found
        Account existingAccount = accountDAO.get(username)
                .orElseThrow(() -> new Exception("Account not found with username: " + username));
        
        request.setAttribute("account", existingAccount);
        request.setAttribute("accountStatuses", AccountStatus.values());
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/account/accountform.jsp");
        dispatcher.forward(request, response);
    }

    /**
     * Creates a new account with provided parameters
     * Validates required fields before creation
     */
    private void insertAccount(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        // Get parameters from request
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String status = request.getParameter("status");

        // Validate required fields
        if (username == null || username.trim().isEmpty()) {
            throw new Exception("Username is required");
        }
        if (password == null || password.trim().isEmpty()) {
            throw new Exception("Password is required");
        }
        if (email == null || email.trim().isEmpty()) {
            throw new Exception("Email is required");
        }

        // Create and save new account
        Account newAccount = new Account(username, password, email);
        newAccount.setStatus(AccountStatus.valueOf(status));

        if (accountDAO.save(newAccount)) {
            request.getSession().setAttribute("success", "Account created successfully");
            response.sendRedirect("list");
        } else {
            throw new Exception("Failed to insert account");
        }
    }

    /**
     * Updates an existing account
     * Only updates password if a new one is provided
     * Maintains deleted status and timestamp
     */
    private void updateAccount(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        // Get parameters from request
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String status = request.getParameter("status");

        // Validate required fields
        if (username == null || username.trim().isEmpty()) {
            throw new Exception("Username is required");
        }
        if (email == null || email.trim().isEmpty()) {
            throw new Exception("Email is required");
        }

        // Retrieve existing account or throw exception if not found
        Account existingAccount = accountDAO.get(username)
                .orElseThrow(() -> new Exception("Account not found"));

        // Only update password if provided, otherwise keep existing password
        String finalPassword = (password == null || password.trim().isEmpty()) 
            ? existingAccount.getPassword() 
            : password;

        // Create updated account object
        Account account = new Account(username, finalPassword, email);
        account.setStatus(AccountStatus.valueOf(status));
        account.setDeleted(existingAccount.isDeleted());  // Maintain deleted status
        account.setDeletedAt(existingAccount.getDeletedAt());  // Maintain deletion timestamp

        if (accountDAO.update(account)) {
            request.getSession().setAttribute("success", "Account updated successfully");
            response.sendRedirect("list");
        } else {
            throw new Exception("Failed to update account");
        }
    }

    /**
     * Performs soft delete of an account (marks as deleted rather than permanent removal)
     */
    private void deleteAccount(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        String username = request.getParameter("username");
        if (username == null || username.trim().isEmpty()) {
            throw new Exception("Username is required");
        }

        if (accountDAO.delete(username)) {
            request.getSession().setAttribute("success", "Account marked as deleted successfully");
            response.sendRedirect("list");
        } else {
            throw new Exception("Failed to delete account");
        }
    }

    /**
     * Restores a soft-deleted account
     */
    private void restoreAccount(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        String username = request.getParameter("username");
        if (username == null || username.trim().isEmpty()) {
            throw new Exception("Username is required");
        }

        if (accountDAO.restore(username)) {
            request.getSession().setAttribute("success", "Account restored successfully");
            response.sendRedirect("list");
        } else {
            throw new Exception("Failed to restore account");
        }
    }
}