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
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.math.BigInteger;


@WebServlet(name = "MyServlet")
public class MyServlet extends HttpServlet {

    private String login = "";
    private String password = "";
    private String result;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("I'm here.");
        login = request.getParameter("auth_login");
        password = request.getParameter("auth_password");
        password = md5Custom(password);
        authorization();
        response.getWriter().println(result);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("I'm here.");
        login = request.getParameter("reg_login");
        password = request.getParameter("reg_password");
        password = md5Custom(password);
        registration();
        response.getWriter().println(result);
    }

    public static String md5Custom(String st) {
        MessageDigest messageDigest = null;
        byte[] digest = new byte[0];

        try {
            messageDigest = MessageDigest.getInstance("MD5");
            messageDigest.reset();
            messageDigest.update(st.getBytes());
            digest = messageDigest.digest();
        } catch (NoSuchAlgorithmException e) {
            // тут можно обработать ошибку
            // возникает она если в передаваемый алгоритм в getInstance(,,,) не существует
            e.printStackTrace();
        }

        BigInteger bigInt = new BigInteger(1, digest);
        String md5Hex = bigInt.toString(16);

        while( md5Hex.length() < 32 ){
            md5Hex = "0" + md5Hex;
        }

        return md5Hex;
    }

    public void registration() {
        Connection connection;
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            System.out.println("Where is your Driver?");
            e.printStackTrace();
            return;
        }

        try {
            connection = DriverManager.getConnection("jdbc:postgresql://192.168.12.27:5432/database_auth", "postgres", "password");
        } catch (SQLException e) {
            System.out.println("Connection Failed");
            e.printStackTrace();
            return;
        }
        Statement statement;
        try {
            statement = connection.createStatement();
            ResultSet rs = statement.executeQuery(
                    "SELECT * FROM data WHERE login = '"+ login +"'"
            );
            if (rs.next()) {
                System.out.println(rs.getString("login"));
                result = "l";
                System.out.println("Login is founded.");
            }
            else {
                rs = statement.executeQuery(
                        "INSERT INTO data VALUES ('" + login + "','" + password + "') RETURNING 0"
                );
                if (rs.next()) {
                    result = "y";
                    System.out.println("Регистрация прошла успешно!");
                }
            }

        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }

    public void authorization() {
        Connection connection;
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            System.out.println("Where is your Driver?");
            e.printStackTrace();
            return;
        }

        try {
            connection = DriverManager.getConnection("jdbc:postgresql://192.168.12.27:5432/database_auth", "postgres", "password");
        } catch (SQLException e) {
            System.out.println("Connection Failed");
            e.printStackTrace();
            return;
        }
        Statement statement;
        try {
            statement = connection.createStatement();
            ResultSet rs = statement.executeQuery(
                    "SELECT login FROM data WHERE login='" + login + "'"
            );
            if (rs.next()) {
                System.out.println(rs.getString("login"));
                rs = statement.executeQuery(
                        "SELECT password FROM data WHERE password='" + password + "' AND login='" + login + "'"
                );
                if (rs.next()) {
                    result = "y";
                    System.out.println(rs.getString("password"));
                }
                else {
                    result = "p";
                    System.out.println("Password is not correct.");
                }
            }
            else {
                result = "l";
                System.out.println("Login is not founded.");
            }

        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
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