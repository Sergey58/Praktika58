package com.testservlet;

import javax.mail.Message;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.Multipart;
import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;
import javax.mail.internet.*;
import java.util.Properties;

public class sendingMail {

    private String email_adress;
    private String toEmail;
    private Properties properties;
    private String address = "cougar58rus@gmail.com";

    public sendingMail(String email) {
        email_adress = email;
        properties = new Properties();
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true");
        properties.put("mail.smtp.host", "smtp.gmail.com");
        properties.put("mail.smtp.port","587");
    }

    public boolean sendMessage() {
        Session session = Session.getInstance(properties, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return (new PasswordAuthentication("cougar58rus@gmail.com","pozd110272"));
            }
        });

        try {
            MimeMessage message = new MimeMessage(session);// от кого отправлять
            message.setFrom(new InternetAddress(address));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(email_adress));
            message.setSubject("SAY HELLO");
            message.setText("Hello.");
            Transport.send(message);
            return true;
        } catch (Exception e) {
            System.out.println(e.getMessage());
            return false;
        }
    }
}
