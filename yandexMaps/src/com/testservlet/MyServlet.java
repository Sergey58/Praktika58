package com.testservlet;

import javax.mail.Message;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;
import java.util.ConcurrentModificationException;
import java.util.Random;
import java.util.Date;
import java.lang.ClassNotFoundException;

@WebServlet(name = "MyServlet")
public class MyServlet extends HttpServlet {

    private String result_answer = "";
    private String str = "";
    private int index = 0;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        request.setCharacterEncoding("UTF-8");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email_adress");
        response.getWriter().println(email);

        sendingMail obj = new sendingMail(email);
        obj.sendMessage();

    }

    public static String req()
    {
        String str ="";
        try {
            Class.forName("org.postgresql.Driver");
        }
        catch (ClassNotFoundException e) {
            System.err.println (e);
            System.exit (-1);
        }
        try {
            // open connection to database
            Connection connection = DriverManager.getConnection(
                    //"jdbc:postgresql://dbhost:port/dbname", "user", "dbpass");
                    "jdbc:postgresql://192.168.12.27:5432/test_db", "postgres", "password");

            // build query, here we get info about all databases"
            String query = "SELECT adres FROM penza";


            // execute query
            Statement statement = connection.createStatement ();
            ResultSet rs = statement.executeQuery (query);

            // return query result
            while ( rs.next () ) {
                // display table name

                //System.out.println("PostgreSQL Query result: " + rs.getString("adres"));

                str += rs.getString("adres");
                str +=";";
            }
            connection.close ();


        }
        catch (java.sql.SQLException e) {
            System.err.println (e);
            System.exit (-1);
        }
        return str;
    }

}