package controller;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

import dao.AccountDAO;
import dao.EmployeeDAO;
import entites.accounts_package.Account;
import entites.employees_package.Employee;
import entites.employees_package.Manager;
import entites.employees_package.Receptionist;
import entites.employees_package.Waiter;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet implementation for handling employee-related operations.
 * This servlet manages CRUD operations for employees including waiters, receptionists, and managers.
 * It interacts with EmployeeDAO and AccountDAO for data persistence.
 */
@WebServlet("/employee/*")
public class EmployeeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private EmployeeDAO employeeDAO;
    private AccountDAO accountDAO;
    
    /**
     * Initializes the servlet by creating instances of EmployeeDAO and AccountDAO.
     */
    public void init() {
        employeeDAO = new EmployeeDAO();
        accountDAO = new AccountDAO();
    }

    /**
     * Handles POST requests by delegating to doGet method.
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    /**
     * Handles GET requests and routes them to appropriate methods based on the action.
     * Supported actions: new, insert, delete, edit, update, list (default).
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getPathInfo() == null ? "/list" : request.getPathInfo();

        try {
            switch (action) {
                case "/new":
                    showNewForm(request, response);
                    break;
                case "/insert":
                    insertEmployee(request, response);
                    break;
                case "/delete":
                    deleteEmployee(request, response);
                    break;
                case "/edit":
                    showEditForm(request, response);
                    break;
                case "/update":
                    updateEmployee(request, response);
                    break;
                case "/list":
                default:
                    listEmployees(request, response);
                    break;
            }
        } catch (Exception ex) {
            request.setAttribute("error", ex.getMessage());
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        }
    }

    /**
     * Displays a list of all employees.
     */
    private void listEmployees(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        List<Employee> employees = employeeDAO.getAll();
        request.setAttribute("employees", employees);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/employee/employeelist.jsp");
        dispatcher.forward(request, response);
    }

    /**
     * Shows the form for creating a new employee.
     * Requires at least one account to be available in the system.
     */
    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        List<Account> accounts = accountDAO.getAll();
        if (accounts.isEmpty()) {
            throw new Exception("No accounts available. Please create an account first.");
        }
        request.setAttribute("accounts", accounts);
        request.setAttribute("roles", List.of("WAITER", "RECEPTIONIST", "MANAGER"));
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/employee/employeeform.jsp");
        dispatcher.forward(request, response);
    }

    /**
     * Shows the form for editing an existing employee.
     * @throws Exception if employee ID is not provided or employee not found
     */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        String id = request.getParameter("id");
        if (id == null || id.trim().isEmpty()) {
            throw new Exception("Employee ID is required");
        }

        Employee existingEmployee = employeeDAO.get(id)
                .orElseThrow(() -> new Exception("Employee not found with id: " + id));
        List<Account> accounts = accountDAO.getAll();
        
        request.setAttribute("employee", existingEmployee);
        request.setAttribute("accounts", accounts);
        request.setAttribute("roles", List.of("WAITER", "RECEPTIONIST", "MANAGER"));
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/employee/employeeform.jsp");
        dispatcher.forward(request, response);
    }

    /**
     * Inserts a new employee into the system.
     * Validates input parameters and creates the appropriate employee type based on role.
     * @throws Exception if validation fails or operation is unsuccessful
     */
    private void insertEmployee(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        String id = request.getParameter("id");
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String accountUsername = request.getParameter("accountUsername");
        String role = request.getParameter("role");
        LocalDate dateJoined = LocalDate.parse(request.getParameter("dateJoined"));
        
        // Basic validation
        if (id == null || id.trim().isEmpty()) {
            throw new Exception("Employee ID is required");
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
        if (role == null || role.trim().isEmpty()) {
            throw new Exception("Role is required");
        }
        if (dateJoined == null) {
            throw new Exception("Date joined is required");
        }

        Account account = accountDAO.get(accountUsername)
                .orElseThrow(() -> new Exception("Selected account not found"));
        
        Employee newEmployee;
        switch (role) {
            case "WAITER":
                newEmployee = new Waiter(id, name, phone, 
                    account.getUsername(), account.getPassword(), account.getEmail(),
                    dateJoined);
                break;
            case "RECEPTIONIST":
                newEmployee = new Receptionist(id, name, phone, 
                    account.getUsername(), account.getPassword(), account.getEmail(),
                    dateJoined);
                break;
            case "MANAGER":
                newEmployee = new Manager(id, name, phone, 
                    account.getUsername(), account.getPassword(), account.getEmail(),
                    dateJoined);
                break;
            default:
                throw new Exception("Invalid role specified");
        }

        if (employeeDAO.save(newEmployee)) {
            response.sendRedirect("list");
        } else {
            throw new Exception("Failed to insert employee");
        }
    }

    /**
     * Updates an existing employee's information.
     * Validates input parameters and updates the appropriate employee type based on role.
     * @throws Exception if validation fails or operation is unsuccessful
     */
    private void updateEmployee(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        String id = request.getParameter("id");
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String accountUsername = request.getParameter("accountUsername");
        String role = request.getParameter("role");
        LocalDate dateJoined = LocalDate.parse(request.getParameter("dateJoined"));
        
        // Basic validation
        if (id == null || id.trim().isEmpty()) {
            throw new Exception("Employee ID is required");
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
        if (role == null || role.trim().isEmpty()) {
            throw new Exception("Role is required");
        }
        if (dateJoined == null) {
            throw new Exception("Date joined is required");
        }

        Account account = accountDAO.get(accountUsername)
                .orElseThrow(() -> new Exception("Selected account not found"));
        
        Employee employee;
        switch (role) {
            case "WAITER":
                employee = new Waiter(id, name, phone, 
                    account.getUsername(), account.getPassword(), account.getEmail(),
                    dateJoined);
                break;
            case "RECEPTIONIST":
                employee = new Receptionist(id, name, phone, 
                    account.getUsername(), account.getPassword(), account.getEmail(),
                    dateJoined);
                break;
            case "MANAGER":
                employee = new Manager(id, name, phone, 
                    account.getUsername(), account.getPassword(), account.getEmail(),
                    dateJoined);
                break;
            default:
                throw new Exception("Invalid role specified");
        }

        if (employeeDAO.update(employee)) {
            response.sendRedirect("list");
        } else {
            throw new Exception("Failed to update employee");
        }
    }

    /**
     * Deletes an employee from the system.
     * @throws Exception if employee ID is not provided or operation is unsuccessful
     */
    private void deleteEmployee(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        String id = request.getParameter("id");
        if (id == null || id.trim().isEmpty()) {
            throw new Exception("Employee ID is required");
        }

        if (employeeDAO.delete(id)) {
            response.sendRedirect("list");
        } else {
            throw new Exception("Failed to delete employee");
        }
    }
}