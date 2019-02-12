package com.codecool.Queststore.DAO;

import java.sql.Connection;
import java.sql.DriverManager;

public class ConnectionProvider {
    public static Connection getConnection() {
        Connection con = null;
        try {
            con = DriverManager.getConnection("jdbc:postgresql://localhost:5432/queststore",
                    "postgres", "123");
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
            System.exit(0);
            System.out.println("Opened database successfully");
        }
        return con;
    }
}
