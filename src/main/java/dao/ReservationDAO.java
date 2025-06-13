// ReservationDAO.java
package dao;

import java.sql.*;

import java.time.LocalDateTime;
import java.util.*;
import java.util.logging.*;

import entites.customers_package.Customer;
import entites.employees_package.Employee;
import entites.reservations_package.*;
import entites.tables_package.*;

/**
 * Data Access Object (DAO) for handling all database operations related to reservations.
 * Manages reservation lifecycle including creation, modification, and cancellation.
 * Coordinates with TableDAO to maintain table status consistency.
 */
public class ReservationDAO implements BaseDAO<Reservation> {
    private static final Logger logger = Logger.getLogger(ReservationDAO.class.getName());

    /**
     * Retrieves a reservation by its unique ID.
     * @param reservationId The unique reservation ID
     * @return Optional containing Reservation if found, empty otherwise
     */
    @Override
    public Optional<Reservation> get(String reservationId) {
        if (reservationId == null || reservationId.trim().isEmpty()) {
            logger.log(Level.WARNING, "Attempt to retrieve reservation with null or empty ID");
            return Optional.empty();
        }

        String sql = "SELECT r.*, e.role as employee_role FROM reservations r " +
                     "JOIN employees e ON r.created_by = e.id " +
                     "WHERE r.reservation_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, reservationId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(createReservationFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error retrieving reservation ID: " + reservationId, e);
        }
        return Optional.empty();
    }

    /**
     * Retrieves all reservations from the database.
     * @return List of all Reservation objects
     */
    @Override
    public List<Reservation> getAll() {
        List<Reservation> reservations = new ArrayList<>();
        String sql = "SELECT r.*, e.role as employee_role FROM reservations r " +
                     "JOIN employees e ON r.created_by = e.id";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                try {
                    reservations.add(createReservationFromResultSet(rs));
                } catch (SQLException e) {
                    logger.log(Level.WARNING, "Error parsing reservation data", e);
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error retrieving all reservations", e);
        }
        return reservations;
    }
    /**
     * Saves or updates a reservation in a transactional manner.
     * Manages table status changes automatically.
     * @param reservation The Reservation object to save
     * @return true if operation succeeded, false otherwise
     */
    @Override
    public boolean save(Reservation reservation) {
        if (reservation == null) {
            logger.log(Level.WARNING, "Attempt to save null reservation");
            return false;
        }

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Begin transaction
            
            try {
                // Update associated table status if needed
                if (!updateTableStatus(conn, reservation)) {
                	  try {
                          conn.rollback();
                      } catch (SQLException e) {
                          logger.log(Level.WARNING, "Rollback failed", e);
                      }
                      return false;
                  }


                // Save reservation data
                if (!persistReservation(conn, reservation)) {
                    try {
                        conn.rollback();
                    } catch (SQLException e) {
                        logger.log(Level.WARNING, "Rollback failed", e);
                    }
                    return false;
                }
                conn.commit();
                return true;
            } catch (SQLException e) {
                try {
                    if (conn != null) conn.rollback();
                } catch (SQLException ex) {
                    logger.log(Level.SEVERE, "Error during transaction rollback", ex);
                }
                logger.log(Level.SEVERE, "Transaction failed", e);
                return false;
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting connection", e);
            return false;
        } finally {
            if (conn != null) {
                try {
                    if (!conn.getAutoCommit()) {
                        conn.setAutoCommit(true); // Reset auto-commit before closing
                    }
                    conn.close();
                } catch (SQLException e) {
                    logger.log(Level.WARNING, "Error closing connection", e);
                }
            }
        }
    }

    /**
     * Updates table status based on reservation changes
     * @param conn Active database connection
     * @param reservation Reservation being processed
     * @return true if update succeeded
     */
    private boolean updateTableStatus(Connection conn, Reservation reservation) throws SQLException {
        if (reservation.getTable() == null || reservation.getTable().getTableID() == null) {
            return true;
        }

        TableDAO tableDAO = new TableDAO();
        Optional<Table> tableOpt = tableDAO.get(reservation.getTable().getTableID());
        if (tableOpt.isPresent()) {
            Table table = tableOpt.get();
            table.setStatus(reservation.getStatus() == ReservationStatus.CANCELED ? 
                          TableStatus.FREE : TableStatus.RESERVED);
            return tableDAO.update(table); // Modified to accept connection
        }
        return true;
    }

    /**
     * Persists reservation data to database
     * @param conn Active database connection
     * @param reservation Reservation to save
     * @return true if operation succeeded
     */
    private boolean persistReservation(Connection conn, Reservation reservation) throws SQLException {
        String sql = "INSERT INTO reservations (reservation_id, customer_id, table_id, reservation_time, " +
                    "party_size, special_requests, created_by, status, created_at, updated_at) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?) " +
                    "ON DUPLICATE KEY UPDATE " +
                    "table_id = VALUES(table_id), " +
                    "reservation_time = VALUES(reservation_time), " +
                    "party_size = VALUES(party_size), " +
                    "special_requests = VALUES(special_requests), " +
                    "status = VALUES(status), " +
                    "updated_at = VALUES(updated_at)";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            // Set all parameters
            int paramIndex = 1;
            stmt.setString(paramIndex++, reservation.getReservationID());
            stmt.setString(paramIndex++, reservation.getCustomer().getId());
            stmt.setString(paramIndex++, reservation.getTable() != null ? 
                         reservation.getTable().getTableID() : null);
            stmt.setTimestamp(paramIndex++, Timestamp.valueOf(reservation.getReservationTime()));
            stmt.setInt(paramIndex++, reservation.getPartySize());
            stmt.setString(paramIndex++, reservation.getSpecialRequests());
            stmt.setString(paramIndex++, reservation.getCreatedBy().getId());
            stmt.setString(paramIndex++, reservation.getStatus().name());
            stmt.setTimestamp(paramIndex++, Timestamp.valueOf(reservation.getCreatedAt()));
            stmt.setTimestamp(paramIndex, Timestamp.valueOf(reservation.getUpdatedAt()));
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error persisting reservation", e);
            throw e; // rethrow to handle in calling method
        }
    }

    /**
     * Updates an existing reservation (uses save internally)
     * @param reservation Reservation to update
     * @return true if update succeeded
     */
    public boolean update(Connection conn,Reservation reservation) {
        return save(reservation);
    }

    /**
     * Deletes a reservation and updates associated table status
     * @param reservationId ID of reservation to delete
     * @return true if deletion succeeded
     */
    @Override
    public boolean delete(String reservationId) {
        if (reservationId == null || reservationId.trim().isEmpty()) {
            logger.log(Level.WARNING, "Attempt to delete reservation with null or empty ID");
            return false;
        }

        // First retrieve the reservation to handle table status
        Optional<Reservation> reservationOpt = get(reservationId);
        if (reservationOpt.isPresent()) {
            Reservation reservation = reservationOpt.get();
            if (reservation.getTable() != null) {
                TableDAO tableDAO = new TableDAO();
                Optional<Table> tableOpt = tableDAO.get(reservation.getTable().getTableID());
                if (tableOpt.isPresent()) {
                    Table table = tableOpt.get();
                    table.setStatus(TableStatus.FREE);
                    tableDAO.update(table);
                }
            }
        }

        // Delete the reservation record
        String sql = "DELETE FROM reservations WHERE reservation_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, reservationId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error deleting reservation ID: " + reservationId, e);
            return false;
        }
    }

    /**
     * Creates a Reservation object from database ResultSet
     * @param rs ResultSet containing reservation data
     * @return Fully populated Reservation object
     * @throws SQLException if data access error occurs
     */
    private Reservation createReservationFromResultSet(ResultSet rs) throws SQLException {
        // Extract all fields from ResultSet
        String reservationId = rs.getString("reservation_id");
        String customerId = rs.getString("customer_id");
        String tableId = rs.getString("table_id");
        LocalDateTime reservationTime = rs.getTimestamp("reservation_time").toLocalDateTime();
        int partySize = rs.getInt("party_size");
        String specialRequests = rs.getString("special_requests");
        String createdBy = rs.getString("created_by");
        ReservationStatus status = ReservationStatus.valueOf(rs.getString("status"));
        LocalDateTime createdAt = rs.getTimestamp("created_at").toLocalDateTime();
        LocalDateTime updatedAt = rs.getTimestamp("updated_at").toLocalDateTime();
        
        // Retrieve related entities
        Customer customer = new CustomerDAO().get(customerId).orElse(null);
        Employee employee = new EmployeeDAO().get(createdBy).orElse(null);
        Table table = tableId != null ? new TableDAO().get(tableId).orElse(null) : null;
        
        return new Reservation(reservationId, customer, table, reservationTime, partySize, 
                             specialRequests, employee, status, createdAt, updatedAt);
    }
    /**
     * Updates the status of a specific reservation.
     * @param reservationId ID of the reservation to update
     * @param newStatus New status to set
     * @return true if update was successful, false otherwise
     */
    public boolean updateReservationStatus(String reservationId, ReservationStatus newStatus) {
        if (reservationId == null || reservationId.trim().isEmpty() || newStatus == null) {
            logger.log(Level.WARNING, "Invalid parameters for updateReservationStatus");
            return false;
        }

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Start transaction
            
            // First get the current reservation to check table status
            Optional<Reservation> reservationOpt = get(reservationId);
            if (reservationOpt.isEmpty()) {
                conn.rollback();
                return false;
            }
            
            Reservation reservation = reservationOpt.get();
            
            // Update table status if needed
            if (reservation.getTable() != null) {
                TableDAO tableDAO = new TableDAO();
                Table table = reservation.getTable();
                
                // Free the table if reservation is being canceled or completed
                if (newStatus == ReservationStatus.CANCELED || newStatus == ReservationStatus.COMPLETED) {
                    table.setStatus(TableStatus.FREE);
                } 
                // Reserve the table if status is being changed to confirmed
                else if (newStatus == ReservationStatus.CONFIRMED) {
                    table.setStatus(TableStatus.RESERVED);
                }
                
                if (!tableDAO.update(table)) {
                    conn.rollback();
                    return false;
                }
            }
            
            // Update the reservation status
            String sql = "UPDATE reservations SET status = ?, updated_at = ? WHERE reservation_id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, newStatus.name());
                stmt.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
                stmt.setString(3, reservationId);
                
                boolean success = stmt.executeUpdate() > 0;
                if (success) {
                    conn.commit();
                    return true;
                } else {
                    conn.rollback();
                    return false;
                }
            }
        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) {
                    logger.log(Level.SEVERE, "Error during transaction rollback", ex);
                }
            }
            logger.log(Level.SEVERE, "Error updating reservation status", e);
            return false;
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); } catch (SQLException e) {
                    logger.log(Level.WARNING, "Error resetting auto-commit", e);
                }
            }
        }
    }

	
	@Override
	public boolean update(Reservation t) {
	    if (t == null) {
	        logger.log(Level.WARNING, "Attempt to update null reservation");
	        return false;
	    }
	    return save(t); // Reuse save logic which handles updates
	}
}