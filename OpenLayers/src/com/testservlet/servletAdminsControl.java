package com.testservlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigInteger;
import java.sql.*;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import com.testservlet.MyServlet;
import org.json.simple.JSONObject;
import org.json.simple.JSONArray;

@WebServlet(name = "servletAdminsControl")
public class servletAdminsControl extends HttpServlet {

    private String action;
    private JSONArray arr_result = new JSONArray();
    private String result;
    private String addUserResult;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        action = request.getParameter("action");
        System.out.println(action);
        switch (action) {
            case "getUsersData": {
                String sortBy = request.getParameter("sortBy");
                getUsersData(sortBy);
                arr_result.writeJSONString(response.getWriter());
                arr_result.clear();
                break;
            }
            case "addNewUser": {
                String login = request.getParameter("login");
                String password = request.getParameter("password");
                password = MyServlet.md5Custom(password);
                String access_data = request.getParameter("access_data");
                System.out.println(access_data);
                addNewUser(login, password);

                String str;

                if (!access_data.isEmpty() && addUserResult != "l") {
                    access_data += ",";
                    str = "";
                    for (int i=0;i<access_data.length();i++) {
                        if (access_data.charAt(i) != ',')
                            str += access_data.substring(i, i+1);
                        else {
                            System.out.println(str);
                            addAccessMapForUser(login ,str);
                            str = "";
                        }
                    }
                }
                response.getWriter().println(addUserResult);
                break;
            }
            case "deleteUser": {
                String ids = request.getParameter("id") + ",";
                String str = "";
                for (int i=0;i<ids.length();i++) {
                    if (ids.charAt(i) != ',') {
                        str += ids.substring(i, i+1);
                    }
                    else {
                        deleteUser_stepRights(str);
                        String temp_img_id = deleteUser_stepUser(str);
                        deleteUser_stepImage(temp_img_id);
                        str = "";
                    }
                }
                response.getWriter().println(result);
            }
            case "changeUserRights": {
                String id = request.getParameter("id");
                String login = request.getParameter("login");
                String access_data = request.getParameter("access_data");
                access_data += ",";
                String str = "";
                deleteRights(id);
                for (int i=0;i<access_data.length();i++) {
                    if (access_data.charAt(i) != ',')
                        str += access_data.substring(i, i+1);
                    else {
                        addAccessMapForUser(login, str);
                        str = "";
                    }
                }
                response.getWriter().println(result);
            }
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    protected void getUsersData(String sortBy) {
        System.out.println("I'm in getUsersData");
        Connection connection;
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            System.out.println("Where is your Driver?");
            e.printStackTrace();
            return;
        }

        try {
            connection = DriverManager.getConnection("jdbc:postgresql://192.168.12.27:5432/users_data", "postgres", "password");
        } catch (SQLException e) {
            System.out.println("Connection Failed");
            e.printStackTrace();
            return;
        }
        Statement statement;
        Statement statement2;
        try {
            ResultSet rs2;
            statement = connection.createStatement();
            statement2 = connection.createStatement();
            ResultSet rs = statement.executeQuery(
                    "SELECT id, login, password FROM users ORDER BY " + sortBy
            );
            while (rs.next()) {
                JSONObject objJson = new JSONObject();
                JSONArray arrJson = new JSONArray();

                String id = rs.getString("id");
                String login = rs.getString("login");
                String password = rs.getString("password");

                System.out.println(id + ' ' + login + ' ' + password);

                objJson.put("id", id);
                objJson.put("login", login);
                objJson.put("password", password);

                rs2 = statement2.executeQuery(
                        "SELECT access_data FROM rigths WHERE user_id=" + id
                );
                while (rs2.next()) {
                    arrJson.add(rs2.getString("access_data"));
                }
                if (arrJson.isEmpty())
                    objJson.put("access_maps_array", "");
                else
                    objJson.put("access_maps_array", arrJson);

                arr_result.add(objJson);
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        System.out.println(arr_result.toString());
    }

    protected void addNewUser(String login, String password) {
        Connection connection;
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            System.out.println("Where is your Driver?_");
            e.printStackTrace();
            return;
        }

        try {
            connection = DriverManager.getConnection("jdbc:postgresql://192.168.12.27:5432/users_data", "postgres", "password");
        } catch (SQLException e) {
            System.out.println("Connection Failed_");
            e.printStackTrace();
            return;
        }
        Statement statement;
        try {
            statement = connection.createStatement();

            ResultSet rs = statement.executeQuery(
                    "SELECT * FROM users WHERE login='" + login + "'"
            );
            if (rs.next()) {
                addUserResult = "l";
                return;
            }
            else {
                addUserResult = "y";
                rs = statement.executeQuery(
                        "INSERT INTO users (login, password) VALUES('" + login + "', '" + password + "');"
                );
            }

        } catch (SQLException e) {
            System.out.println(e.getMessage());
            //result = "n";
        }
        System.out.println(result);
    }

    protected void addAccessMapForUser(String login, String access_map) {
        System.out.println("addAccessMapForUser");
        Connection connection;
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            System.out.println("Where is your Driver?_");
            e.printStackTrace();
            return;
        }

        try {
            connection = DriverManager.getConnection("jdbc:postgresql://192.168.12.27:5432/users_data", "postgres", "password");
        } catch (SQLException e) {
            System.out.println("Connection Failed_");
            e.printStackTrace();
            return;
        }
        Statement statement;
        try {
            statement = connection.createStatement();

            result = "y";
            ResultSet rs = statement.executeQuery(
                    "SELECT id FROM users WHERE login='" + login + "'"
            );
            String temp_id;
            if (rs.next()) {
                temp_id = rs.getString("id");
                System.out.println(temp_id);

                rs = statement.executeQuery(
                        "INSERT INTO rigths (access_data, user_id) VALUES(" + access_map +", " + temp_id +");"
                );
            }
            else
                result = "n";


        } catch (SQLException e) {
            System.out.println(e.getMessage());
            //result = "n";
        }
        System.out.println(result);
    }

    protected void deleteUser_stepRights(String id) {
        Connection connection;
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            System.out.println("Where is your Driver?__");
            e.printStackTrace();
            return;
        }

        try {
            connection = DriverManager.getConnection("jdbc:postgresql://192.168.12.27:5432/users_data", "postgres", "password");
        } catch (SQLException e) {
            System.out.println("Connection Failed__");
            e.printStackTrace();
            return;
        }
        Statement statement;
        try {
            statement = connection.createStatement();

            ResultSet rs = statement.executeQuery(
                    "SELECT id FROM users WHERE id=" + id
            );

            if (!rs.next())
                result = "i";
            else {
                rs = statement.executeQuery(
                        "SELECT user_id FROM rigths WHERE user_id=" + id
                );
                if (rs.next()) {
                    rs = statement.executeQuery(
                            "DELETE FROM rigths WHERE user_id=" + id
                    );
                    System.out.println("rigths deleted");
                    if (!rs.next())
                        System.out.println("rigths deleted");
                }
            }

        } catch (SQLException e) {
            System.out.println(e.getMessage());
            //result = "n";
        }
        System.out.println(result);
    }

    protected String deleteUser_stepUser(String id) {
        Connection connection;
        String img_id = "";
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            System.out.println("Where is your Driver?___");
            e.printStackTrace();
            return "";
        }

        try {
            connection = DriverManager.getConnection("jdbc:postgresql://192.168.12.27:5432/users_data", "postgres", "password");
        } catch (SQLException e) {
            System.out.println("Connection Failed___");
            e.printStackTrace();
            return "";
        }
        Statement statement;
        try {
            statement = connection.createStatement();

            ResultSet rs = statement.executeQuery(
                    "SELECT image_id FROM users WHERE id=" + id
            );
            if (rs.next())
                img_id = rs.getString("image_id");
            rs = statement.executeQuery(
                    "DELETE FROM users WHERE id=" + id
            );
            System.out.println("user deleted");

        } catch (SQLException e) {
            System.out.println(e.getMessage());
            //result = "n";
        }
        //System.out.println(result);
        return img_id;
    }

    protected void deleteUser_stepImage(String img_id) {
        Connection connection;
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            System.out.println("Where is your Driver?____");
            e.printStackTrace();
            return;
        }

        try {
            connection = DriverManager.getConnection("jdbc:postgresql://192.168.12.27:5432/users_data", "postgres", "password");
        } catch (SQLException e) {
            System.out.println("Connection Failed____");
            e.printStackTrace();
            return;
        }
        Statement statement;
        try {
            statement = connection.createStatement();

            ResultSet rs = statement.executeQuery(
                    "DELETE FROM images WHERE id=" + img_id
            );
            System.out.println("image deleted");

        } catch (SQLException e) {
            System.out.println(e.getMessage());
            //result = "n";
        }
        System.out.println(result);
    }

    protected void deleteRights(String id) {
        Connection connection;
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            System.out.println("Where is your Driver?___");
            e.printStackTrace();
            return;
        }

        try {
            connection = DriverManager.getConnection("jdbc:postgresql://192.168.12.27:5432/users_data", "postgres", "password");
        } catch (SQLException e) {
            System.out.println("Connection Failed___");
            e.printStackTrace();
            return;
        }
        Statement statement;
        try {
            statement = connection.createStatement();

            ResultSet rs = statement.executeQuery(
                    "DELETE FROM rigths WHERE id=" + id
            );

        } catch (SQLException e) {
            System.out.println(e.getMessage());
            //result = "n";
        }
    }
};

