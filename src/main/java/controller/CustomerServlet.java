package controller;

import java.io.IOException;
import java.util.Date;
import java.util.List;

import dao.AccountDAO;
import dao.CustomerDAO;
import entites.accounts_package.Account;
import entites.customers_package.Customer;
import entites.customers_package.VIPCustomer;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet implementation for managing customer operations.
 * Handles CRUD operations for both regular and VIP customers.
 * Maps to URLs with pattern "/customer/*"
 */
@WebServlet("/customer/*")
public class CustomerServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CustomerDAO customerDAO;  // Data Access Object for customer operations
    private AccountDAO accountDAO;    // Data Access Object for account operations
    
    /**
     * Initializes the servlet by creating instances of CustomerDAO and AccountDAO
     */
    public void init() {
        customerDAO = new CustomerDAO();
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
                    showNewForm(request, response);  // Show customer creation form
                    break;
                case "/insert":
                    insertCustomer(request, response);  // Create new customer
                    break;
                case "/delete":
                    deleteCustomer(request, response);  // Delete customer
                    break;
                case "/edit":
                    showEditForm(request, response);  // Show customer edit form
                    break;
                case "/update":
                    updateCustomer(request, response);  // Update existing customer
                    break;
                case "/list":
                default:
                    listCustomers(request, response);  // List all customers (default)
                    break;
            }
        } catch (Exception ex) {
            // Handle errors by forwarding to error page
            request.setAttribute("error", ex.getMessage());
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        }
    }

    /**
     * Lists all customers (both regular and VIP)
     */
    private void listCustomers(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        List<Customer> customers = customerDAO.getAll();
        request.setAttribute("customers", customers);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/customer/customerlist.jsp");
        dispatcher.forward(request, response);
    }

    /**
     * Displays form for creating a new customer
     * Requires at least one existing account to be available
     */
    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        List<Account> accounts = accountDAO.getAll();
        if (accounts.isEmpty()) {
            throw new Exception("No accounts available. Please create an account first.");
        }
        request.setAttribute("accounts", accounts);  // Add available accounts
        request.setAttribute("isVip", false);  // Default to regular customer
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/customer/customerform.jsp");
        dispatcher.forward(request, response);
    }

    /**
     * Displays form for editing an existing customer
     * @throws Exception if customer ID is not provided or customer not found
     */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        String id = request.getParameter("id");
        if (id == null || id.trim().isEmpty()) {
            throw new Exception("Customer ID is required");
        }

        // Retrieve existing customer or throw exception if not found
        Customer existingCustomer = customerDAO.get(id)
                .orElseThrow(() -> new Exception("Customer not found with id: " + id));
        List<Account> accounts = accountDAO.getAll();
        
        request.setAttribute("customer", existingCustomer);
        request.setAttribute("accounts", accounts);
        // Set VIP status flag based on customer type
        request.setAttribute("isVip", existingCustomer instanceof VIPCustomer);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/customer/customerform.jsp");
        dispatcher.forward(request, response);
    }

    /**
     * Creates a new customer with provided parameters
     * Validates required fields before creation
     * Handles both regular and VIP customer creation
     */
    private void insertCustomer(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        // Get parameters from request
        String id = request.getParameter("id");
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String accountUsername = request.getParameter("accountUsername");
        boolean isVip = "on".equals(request.getParameter("isVip"));
        
        // Validate required fields
        if (id == null || id.trim().isEmpty()) {
            throw new Exception("Customer ID is required");
        }
        if (name == null || name.trim().isEmpty()) {
            throw new Exception("Name is required");
        }
        if (phone == null || phone.trim().isEmpty()) {
            throw new Exception("Phone number is required");
        }
        if (accountUsername == null || accountUsername.trim().isEmpty()) {
            throw new Exception("Account selection is required");
        }

        // Retrieve associated account
        Account account = accountDAO.get(accountUsername)
                .orElseThrow(() -> new Exception("Selected account not found"));
        
        // Create appropriate customer type based on VIP flag
        Customer newCustomer;
        if (isVip) {
            try {
                int clientDiscount = Integer.parseInt(request.getParameter("clientDiscount"));
                if (clientDiscount < 0 || clientDiscount > 50) {
                    throw new Exception("Discount must be between 0 and 50");
                }
                newCustomer = new VIPCustomer(id, name, phone, 
                    account.getUsername(), account.getPassword(), account.getEmail(),
                    new Date(), clientDiscount);
            } catch (NumberFormatException e) {
                throw new Exception("Invalid discount value");
            }
        } else {
            newCustomer = new Customer(id, name, phone, 
                account.getUsername(), account.getPassword(), account.getEmail(),
                new Date());
        }

        if (customerDAO.save(newCustomer)) {
            response.sendRedirect("list");
        } else {
            throw new Exception("Failed to insert customer");
        }
    }

    /**
     * Updates an existing customer with provided parameters
     * Validates required fields before update
     * Handles both regular and VIP customer updates
     */
    private void updateCustomer(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        // Get parameters from request
        String id = request.getParameter("id");
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String accountUsername = request.getParameter("accountUsername");
        boolean isVip = "on".equals(request.getParameter("isVip"));
        
        // Validate required fields
        if (id == null || id.trim().isEmpty()) {
            throw new Exception("Customer ID is required");
        }
        if (name == null || name.trim().isEmpty()) {
            throw new Exception("Name is required");
        }
        if (phone == null || phone.trim().isEmpty()) {
            throw new Exception("Phone number is required");
        }
        if (accountUsername == null || accountUsername.trim().isEmpty()) {
            throw new Exception("Account selection is required");
        }

        // Retrieve associated account
        Account account = accountDAO.get(accountUsername)
                .orElseThrow(() -> new Exception("Selected account not found"));
        
        // Create appropriate customer type based on VIP flag
        Customer customer;
        if (isVip) {
            try {
                int clientDiscount = Integer.parseInt(request.getParameter("clientDiscount"));
                if (clientDiscount < 0 || clientDiscount > 50) {
                    throw new Exception("Discount must be between 0 and 50");
                }
                customer = new VIPCustomer(id, name, phone, 
                    account.getUsername(), account.getPassword(), account.getEmail(),
                    new Date(), clientDiscount);
            } catch (NumberFormatException e) {
                throw new Exception("Invalid discount value");
            }
        } else {
            customer = new Customer(id, name, phone, 
                account.getUsername(), account.getPassword(), account.getEmail(),
                new Date());
        }

        if (customerDAO.update(customer)) {
            response.sendRedirect("list");
        } else {
            throw new Exception("Failed to update customer");
        }
    }

    /**
     * Deletes an existing customer
     * @throws Exception if customer ID is not provided or deletion fails
     */
    private void deleteCustomer(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        String id = request.getParameter("id");
        if (id == null || id.trim().isEmpty()) {
            throw new Exception("Customer ID is required");
        }

        if (customerDAO.delete(id)) {
            response.sendRedirect("list");
        } else {
            throw new Exception("Failed to delete customer");
        }
    }
}