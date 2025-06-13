package controller;

import java.io.IOException;

import java.util.List;
import dao.TableDAO;
import entites.tables_package.SeatType;
import entites.tables_package.Table;
import entites.tables_package.*;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * TableServlet handles HTTP requests related to table management.
 * It supports operations such as listing, creating, updating, and deleting tables.
 */
@WebServlet("/table/*")
public class TableServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private TableDAO tableDAO;

    /**
     * Initializes the TableDAO instance.
     */
    public void init() {
        tableDAO = new TableDAO();
    }

    /**
     * Handles POST requests by delegating to doGet.
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    /**
     * Handles GET requests and directs to the appropriate action based on the URL path.
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
                    insertTable(request, response);
                    break;
                case "/delete":
                    deleteTable(request, response);
                    break;
                case "/edit":
                    showEditForm(request, response);
                    break;
                case "/update":
                    updateTable(request, response);
                    break;
                case "/list":
                default:
                    listTables(request, response);
                    break;
            }
        } catch (Exception ex) {
            // Forward to error page if an exception occurs
            request.setAttribute("error", ex.getMessage());
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        }
    }

    /**
     * Lists all tables and forwards the request to the table list view.
     */
    private void listTables(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        List<Table> tables = tableDAO.getAll();
        request.setAttribute("tables", tables);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/table/tablelist.jsp");
        dispatcher.forward(request, response);
    }

    /**
     * Shows the form for creating a new table.
     */
    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        request.setAttribute("statusValues", TableStatus.values());
        request.setAttribute("seatTypes", SeatType.values());
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/table/tableform.jsp");
        dispatcher.forward(request, response);
    }

    /**
     * Shows the form for editing an existing table.
     */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        String id = request.getParameter("id");
        if (id == null || id.trim().isEmpty()) {
            throw new Exception("Table ID is required");
        }

        Table table = tableDAO.get(id)
                .orElseThrow(() -> new Exception("Table not found with id: " + id));
        
        request.setAttribute("table", table);
        request.setAttribute("statusValues", TableStatus.values());
        request.setAttribute("seatTypes", SeatType.values());
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/table/tableform.jsp");
        dispatcher.forward(request, response);
    }

    /**
     * Inserts a new table into the database.
     */
    private void insertTable(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        int maxCapacity = Integer.parseInt(request.getParameter("maxCapacity"));
        int locationIdentifier = Integer.parseInt(request.getParameter("locationIdentifier"));
        TableStatus status = TableStatus.valueOf(request.getParameter("status"));
        SeatType seatType = SeatType.valueOf(request.getParameter("seatType"));

        // Basic validation
        if (maxCapacity <= 0) {
            throw new Exception("Capacity must be positive");
        }
        if (locationIdentifier < 0) {
            throw new Exception("Location identifier cannot be negative");
        }

        Table newTable = new Table(maxCapacity, locationIdentifier, seatType);
        newTable.setStatus(status);

        if (tableDAO.save(newTable)) {
            response.sendRedirect("list");
        } else {
            throw new Exception("Failed to insert table");
        }
    }

    /**
     * Updates an existing table in the database.
     */
    private void updateTable(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        String tableId = request.getParameter("id");
        int maxCapacity = Integer.parseInt(request.getParameter("maxCapacity"));
        int locationIdentifier = Integer.parseInt(request.getParameter("locationIdentifier"));
        TableStatus status = TableStatus.valueOf(request.getParameter("status"));
        SeatType seatType = SeatType.valueOf(request.getParameter("seatType"));

        Table table = tableDAO.get(tableId)
                .orElseThrow(() -> new Exception("Table not found with id: " + tableId));
        
        table.setMaxCapacity(maxCapacity);
        table.setLocationIdentifier(locationIdentifier);
        table.setStatus(status);
        table.setTypeofseat(seatType);

        if (tableDAO.update(table)) {
            response.sendRedirect("list");
        } else {
            throw new Exception("Failed to update table");
        }
    }

    /**
     * Deletes a table from the database.
     */
    private void deleteTable(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        String id = request.getParameter("id");
        if (id == null || id.trim().isEmpty()) {
            throw new Exception("Table ID is required");
        }

        if (tableDAO.delete(id)) {
            response.sendRedirect("list");
        } else {
            throw new Exception("Failed to delete table");
        }
    }
}
