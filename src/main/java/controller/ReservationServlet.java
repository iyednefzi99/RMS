package controller;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import dao.CustomerDAO;
import dao.EmployeeDAO;
import dao.ReservationDAO;
import dao.TableDAO;
import entites.customers_package.Customer;
import entites.employees_package.Employee;
import entites.reservations_package.Reservation;
import entites.reservations_package.ReservationStatus;
import entites.tables_package.Table;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/reservation/*")
public class ReservationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // DAO instances for handling database operations
    private ReservationDAO reservationDAO;
    private CustomerDAO customerDAO;
    private TableDAO tableDAO;
    private EmployeeDAO employeeDAO;

    // Initialize the servlet and DAO instances
    public void init() {
        reservationDAO = new ReservationDAO();
        customerDAO = new CustomerDAO();
        tableDAO = new TableDAO();
        employeeDAO = new EmployeeDAO();
    }
    private static final Logger logger = Logger.getLogger(ReservationDAO.class.getName());
    // Handle POST requests by delegating to doGet
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    // Handle GET requests for various actions
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getPathInfo() == null ? "/list" : request.getPathInfo();

        try {
            switch (action) {
                case "/new":
                    showNewForm(request, response);
                    break;
                case "/insert":
                    insertReservation(request, response);
                    break;
                case "/delete":
                    deleteReservation(request, response);
                    break;
                case "/edit":
                    showEditForm(request, response);
                    break;
                case "/update":
                    updateReservation(request, response);
                    break;
                case "/cancel":
                    cancelReservation(request, response);
                    break;
                case "/list":
                default:
                    listReservations(request, response);
                    break;
            }
        } catch (Exception ex) {
            // Forward to error page if an exception occurs
            request.setAttribute("error", ex.getMessage());
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        }
    }

    // List all reservations
    private void listReservations(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        try {
        	List<Reservation> reservations = reservationDAO.getAll();
        
        request.setAttribute("reservations", reservations);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/reservation/reservationlist.jsp");
        dispatcher.forward(request, response);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error listing reservations", e);
            request.setAttribute("error", "Error retrieving reservations: " + e.getMessage());
            request.getRequestDispatcher("/views/reservation/reservationlist.jsp").forward(request, response);
        }
    }

    // Show the form for creating a new reservation
    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        try {
            List<Customer> customers = customerDAO.getAll();
            List<Table> tables = tableDAO.getAvailableTables();
            List<Employee> employees = employeeDAO.getAll();
            
            // Add null checks and empty collection handling
            if (customers == null || customers.isEmpty()) {
                request.setAttribute("error", "No customers available. Please create a customer first.");
                customers = new ArrayList<>(); // Empty list to prevent NPE in JSP
            }
            
            if (tables == null || tables.isEmpty()) {
                request.setAttribute("error", "No available tables. Please check table availability.");
                tables = new ArrayList<>();
            }
            
            if (employees == null || employees.isEmpty()) {
                request.setAttribute("error", "No employees available. Please create an employee first.");
                employees = new ArrayList<>();
            }
            
            request.setAttribute("customers", customers);
            request.setAttribute("tables", tables);
            request.setAttribute("employees", employees);
            request.setAttribute("statuses", ReservationStatus.values());
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("/views/reservation/reservationform.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error showing new reservation form", e);
            request.setAttribute("error", "Failed to load reservation form: " + e.getMessage());
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        }
    }

    // Show the form for editing an existing reservation
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        String id = request.getParameter("id");
        if (id == null || id.trim().isEmpty()) {
            throw new Exception("Reservation ID is required");
        }

        Reservation existingReservation = reservationDAO.get(id)
                .orElseThrow(() -> new Exception("Reservation not found with id: " + id));
        
        List<Customer> customers = customerDAO.getAll();
        List<Table> tables = tableDAO.getAll();
        List<Employee> employees = employeeDAO.getAll();
        
        request.setAttribute("reservation", existingReservation);
        request.setAttribute("customers", customers);
        request.setAttribute("tables", tables);
        request.setAttribute("employees", employees);
        request.setAttribute("statuses", ReservationStatus.values());
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/reservation/reservationform.jsp");
        dispatcher.forward(request, response);
    }

    // Insert a new reservation into the database
    private void insertReservation(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        String customerId = request.getParameter("customerId");
        String tableId = request.getParameter("tableId");
        String employeeId = request.getParameter("employeeId");
        String reservationDate = request.getParameter("reservationDate");
        String reservationTimeStr = request.getParameter("reservationTime");
        String partySize = request.getParameter("partySize");
        String specialRequests = request.getParameter("specialRequests");
        String status = request.getParameter("status");
        
        // Basic validation for required fields
        if (customerId == null || customerId.trim().isEmpty()) {
            throw new Exception("Customer selection is required");
        }
        if (tableId == null || tableId.trim().isEmpty()) {
            throw new Exception("Table selection is required");
        }
        if (employeeId == null || employeeId.trim().isEmpty()) {
            throw new Exception("Employee selection is required");
        }
        if (reservationDate == null || reservationDate.trim().isEmpty() || 
            reservationTimeStr == null || reservationTimeStr.trim().isEmpty()) {
            throw new Exception("Both date and time are required");
        }
        if (partySize == null || partySize.trim().isEmpty()) {
            throw new Exception("Party size is required");
        }

        Customer customer = customerDAO.get(customerId)
                .orElseThrow(() -> new Exception("Selected customer not found"));
        
        Table table = tableDAO.get(tableId)
                .orElseThrow(() -> new Exception("Selected table not found"));
        
        Employee employee = employeeDAO.get(employeeId)
                .orElseThrow(() -> new Exception("Selected employee not found"));
        
        try {
            LocalDate date = LocalDate.parse(reservationDate);
            LocalTime time = LocalTime.parse(reservationTimeStr);
            LocalDateTime dateTime = LocalDateTime.of(date, time);
            
            int size = Integer.parseInt(partySize);
            
            if (size <= 0) {
                throw new Exception("Party size must be positive");
            }
            if (size > table.getMaxCapacity()) {
                throw new Exception("Party size exceeds table capacity");
            }
            
            Reservation newReservation = new Reservation(
                null, // ID will be generated by DAO
                customer,
                table,
                dateTime,
                size,
                specialRequests != null ? specialRequests : "",
                employee,
                ReservationStatus.valueOf(status),
                LocalDateTime.now(),
                LocalDateTime.now()
            );

            if (reservationDAO.save(newReservation)) {
                response.sendRedirect("list");
            } else {
                throw new Exception("Failed to create reservation");
            }
        } catch (NumberFormatException e) {
            throw new Exception("Invalid party size");
        } catch (IllegalArgumentException e) {
            throw new Exception("Invalid status value");
        }
    }

    // Update an existing reservation
    private void updateReservation(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        String reservationId = request.getParameter("reservationId");
        String customerId = request.getParameter("customerId");
        String tableId = request.getParameter("tableId");
        String employeeId = request.getParameter("employeeId");
        String reservationDate = request.getParameter("reservationDate");
        String reservationTimeStr = request.getParameter("reservationTime");
        String partySize = request.getParameter("partySize");
        String specialRequests = request.getParameter("specialRequests");
        String status = request.getParameter("status");
        
        // Basic validation for required fields
        if (reservationId == null || reservationId.trim().isEmpty()) {
            throw new Exception("Reservation ID is required");
        }
        if (customerId == null || customerId.trim().isEmpty()) {
            throw new Exception("Customer selection is required");
        }
        if (tableId == null || tableId.trim().isEmpty()) {
            throw new Exception("Table selection is required");
        }
        if (employeeId == null || employeeId.trim().isEmpty()) {
            throw new Exception("Employee selection is required");
        }
        if (reservationDate == null || reservationDate.trim().isEmpty() || 
            reservationTimeStr == null || reservationTimeStr.trim().isEmpty()) {
            throw new Exception("Both date and time are required");
        }
        if (partySize == null || partySize.trim().isEmpty()) {
            throw new Exception("Party size is required");
        }

        Customer customer = customerDAO.get(customerId)
                .orElseThrow(() -> new Exception("Selected customer not found"));
        
        Table table = tableDAO.get(tableId)
                .orElseThrow(() -> new Exception("Selected table not found"));
        
        Employee employee = employeeDAO.get(employeeId)
                .orElseThrow(() -> new Exception("Selected employee not found"));
        
        try {
            LocalDate date = LocalDate.parse(reservationDate);
            LocalTime time = LocalTime.parse(reservationTimeStr);
            LocalDateTime dateTime = LocalDateTime.of(date, time);
            
            int size = Integer.parseInt(partySize);
            
            if (size <= 0) {
                throw new Exception("Party size must be positive");
            }
            if (size > table.getMaxCapacity()) {
                throw new Exception("Party size exceeds table capacity");
            }
            
            Reservation existingReservation = reservationDAO.get(reservationId)
                    .orElseThrow(() -> new Exception("Reservation not found"));
            
            existingReservation.setCustomer(customer);
            existingReservation.setTable(table);
            existingReservation.setReservationTime(dateTime);
            existingReservation.setPartySize(size);
            existingReservation.setSpecialRequests(specialRequests != null ? specialRequests : "");
            existingReservation.setCreatedBy(employee);
            existingReservation.setStatus(ReservationStatus.valueOf(status));
            existingReservation.setUpdatedAt(LocalDateTime.now());

            if (reservationDAO.update(existingReservation)) {
                response.sendRedirect("list");
            } else {
                throw new Exception("Failed to update reservation");
            }
        } catch (NumberFormatException e) {
            throw new Exception("Invalid party size");
        } catch (IllegalArgumentException e) {
            throw new Exception("Invalid status value");
        }
    }

    // Cancel a reservation
    private void cancelReservation(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        String id = request.getParameter("id");
        if (id == null || id.trim().isEmpty()) {
            throw new Exception("Reservation ID is required");
        }

        if (reservationDAO.updateReservationStatus(id, ReservationStatus.CANCELED)) {
            response.sendRedirect("list");
        } else {
            throw new Exception("Failed to cancel reservation");
        }
    }

    // Delete a reservation
    private void deleteReservation(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        String id = request.getParameter("id");
        if (id == null || id.trim().isEmpty()) {
            throw new Exception("Reservation ID is required");
        }

        if (reservationDAO.delete(id)) {
            response.sendRedirect("list");
        } else {
            throw new Exception("Failed to delete reservation");
        }
    }
    @SuppressWarnings("unused")
	private void validateReservationData(HttpServletRequest request) throws Exception {
        // Validate all required fields
        String[] requiredFields = {"customerId", "tableId", "employeeId", 
                                  "reservationDate", "reservationTime", "partySize"};
        for (String field : requiredFields) {
            if (request.getParameter(field) == null || request.getParameter(field).trim().isEmpty()) {
                throw new Exception(field + " is required");
            }
        }
        
        // Validate party size is positive
        int partySize = Integer.parseInt(request.getParameter("partySize"));
        if (partySize <= 0) {
            throw new Exception("Party size must be positive");
        }
    }
}
