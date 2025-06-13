// TableDAO.java
package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

import entites.tables_package.SeatType;
import entites.tables_package.Table;
import entites.tables_package.TableStatus;

/**
 * Data Access Object (DAO) for handling all database operations related to restaurant tables.
 * Implements CRUD (Create, Read, Update, Delete) operations for the Table entity.
 * Manages table status changes and ensures data consistency.
 */
public class TableDAO implements BaseDAO<Table> {
    private static final Logger logger = Logger.getLogger(TableDAO.class.getName());

    /**
     * Retrieves a specific table by its unique identifier.
     * @param tableId The unique ID of the table to retrieve
     * @return Optional containing the Table if found, empty Optional otherwise
     * @throws IllegalArgumentException if tableId is null or empty
     */
    @Override
    public Optional<Table> get(String tableId) {
        // Input validation
        if (tableId == null || tableId.trim().isEmpty()) {
            logger.log(Level.WARNING, "Attempt to retrieve table with null or empty ID");
            return Optional.empty();
        }

        String sql = "SELECT * FROM tables WHERE table_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, tableId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(createTableFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error retrieving table with ID: " + tableId, e);
        }
        return Optional.empty();
    }

    /**
     * Retrieves all tables from the database.
     * @return List of all Table objects in the system
     */
    @Override
    public List<Table> getAll() {
        List<Table> tables = new ArrayList<>();
        String sql = "SELECT * FROM tables";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                tables.add(createTableFromResultSet(rs));
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error retrieving all tables from database", e);
        }
        return tables;
    }
    /**
     * Retrieves all tables that are currently available (status = FREE).
     * @return List of available Table objects
     */
    public List<Table> getAvailableTables() {
        List<Table> availableTables = new ArrayList<>();
        String sql = "SELECT * FROM tables WHERE status = 'FREE'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                availableTables.add(createTableFromResultSet(rs));
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error retrieving available tables", e);
        }
        return availableTables;
    }

    /**
     * Saves a new table to the database.
     * @param table The Table object to persist
     * @return true if operation succeeded, false otherwise
     * @throws IllegalArgumentException if table or table ID is null
     */
    
    @Override
    public boolean save(Table table) {
        if (table == null || table.getTableID() == null) {
            logger.log(Level.WARNING, "Attempt to save null table or table with null ID");
            return false;
        }

        String sql = "INSERT INTO tables (table_id, status, max_capacity, location_identifier, seat_type) " +
                     "VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            // Set all parameters for the prepared statement
            stmt.setString(1, table.getTableID());
            stmt.setString(2, table.getStatus().name());
            stmt.setInt(3, table.getMaxCapacity());
            stmt.setInt(4, table.getLocationIdentifier());
            stmt.setString(5, table.getTypeofseat().name());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error saving table with ID: " + table.getTableID(), e);
            return false;
        }
    }

    /**
     * Updates an existing table in the database.
     * @param table The Table object with updated information
     * @return true if update succeeded, false otherwise
     * @throws IllegalArgumentException if table or table ID is null
     */
    @Override
    public boolean update(Table table) {
        if (table == null || table.getTableID() == null) {
            logger.log(Level.WARNING, "Attempt to update null table or table with null ID");
            return false;
        }

        String sql = "UPDATE tables SET status = ?, max_capacity = ?, location_identifier = ?, seat_type = ? " +
                     "WHERE table_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, table.getStatus().name());
            stmt.setInt(2, table.getMaxCapacity());
            stmt.setInt(3, table.getLocationIdentifier());
            stmt.setString(4, table.getTypeofseat().name());
            stmt.setString(5, table.getTableID());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating table with ID: " + table.getTableID(), e);
            return false;
        }
    }

    /**
     * Deletes a table from the database.
     * @param tableId The unique ID of the table to delete
     * @return true if deletion succeeded, false otherwise
     * @throws IllegalArgumentException if tableId is null or empty
     */
    @Override
    public boolean delete(String tableId) {
        if (tableId == null || tableId.trim().isEmpty()) {
            logger.log(Level.WARNING, "Attempt to delete table with null or empty ID");
            return false;
        }

        String sql = "DELETE FROM tables WHERE table_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, tableId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error deleting table with ID: " + tableId, e);
            return false;
        }
    }

    /**
     * Creates a Table object from a database ResultSet.
     * @param rs The ResultSet containing table data
     * @return Fully populated Table object
     * @throws SQLException if there's an error accessing ResultSet data
     * @throws IllegalArgumentException if required fields are missing or invalid
     */
    private Table createTableFromResultSet(ResultSet rs) throws SQLException {
        // Extract all fields from ResultSet
        String tableId = rs.getString("table_id");
        TableStatus status = TableStatus.valueOf(rs.getString("status"));
        int maxCapacity = rs.getInt("max_capacity");
        int locationIdentifier = rs.getInt("location_identifier");
        SeatType seatType = SeatType.valueOf(rs.getString("seat_type"));
        
        // Create new table with basic attributes
        Table table = new Table(maxCapacity, locationIdentifier, seatType);
        table.setTableID(tableId);
        table.setStatus(status);
        
        return table;
    }
}