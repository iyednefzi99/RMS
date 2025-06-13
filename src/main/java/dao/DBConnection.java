package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

// DBConnection class for managing database connections
public class DBConnection {
    private static final Logger logger = Logger.getLogger(DBConnection.class.getName());
    private static volatile Connection connection = null;

    // Database configuration constants
    private static final String JDBC_DRIVER = "com.mysql.cj.jdbc.Driver";
    private static final String DB_URL = "jdbc:mysql://localhost:3306/restaurant_management";
    private static final String USER = "root";
    private static final String PASSWORD = "";

    static {
        initializeDriver();
    }

    // Method to initialize the JDBC driver
    private static void initializeDriver() {
        try {
            Class.forName(JDBC_DRIVER);
            logger.log(Level.INFO, "MySQL JDBC Driver successfully loaded");
        } catch (ClassNotFoundException e) {
            logger.log(Level.SEVERE, "MySQL JDBC Driver not found. Include it in your library path", e);
            throw new ExceptionInInitializerError("Failed to load JDBC driver");
        }
    }

    // Method to get a database connection
    public static Connection getConnection() throws SQLException {
        if (connection == null || connection.isClosed()) {
            synchronized (DBConnection.class) {
                if (connection == null || connection.isClosed()) {
                    try {
                        connection = DriverManager.getConnection(DB_URL, USER, PASSWORD);
                        connection.setAutoCommit(true); // Enable auto-commit by default
                        logger.log(Level.INFO, "Database connection established successfully");
                    } catch (SQLException e) {
                        logger.log(Level.SEVERE, "Error establishing database connection", e);
                        throw e;
                    }
                }
            }
        }
        return connection;
    }

    // Method to close the database connection
    public static void closeConnection() {
        if (connection != null) {
            synchronized (DBConnection.class) {
                if (connection != null) {
                    try {
                        connection.close();
                        logger.log(Level.INFO, "Database connection closed successfully");
                    } catch (SQLException e) {
                        logger.log(Level.SEVERE, "Error closing database connection", e);
                    } finally {
                        connection = null; // Ensure reference is cleared
                    }
                }
            }
        }
    }

    // Method to test the database connection
    public static boolean testConnection() {
        try (Connection conn = getConnection()) {
            return conn.isValid(2); // 2 second timeout
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Connection test failed", e);
            return false;
        }
    }
}
