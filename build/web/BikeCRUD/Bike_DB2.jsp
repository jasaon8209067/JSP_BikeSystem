<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%request.setCharacterEncoding("UTF-8");%>

<!DOCTYPE html>
<html>
    <body>
        <%
            Class.forName("net.sourceforge.jtds.jdbc.Driver").newInstance();//載入驅動程式元件
            String url = "jdbc:jtds:sqlserver://127.0.0.1:1433/Bike;SendStringParameterAsUnicode=true";

            String user = "sa";
            String password = "j0975035291";
            Connection Conn = DriverManager.getConnection(url, user, password);
            Statement stmt = Conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
            String sql = "";
            for (int i = 0; i < 5; i++) {
                sql = "insert into Bike (B_Name, B_Number, B_Color, B_Country, B_CC, B_Suit) values ('宏佳騰', 0980425, '綠色', '台灣', 150, '避震器')";
                stmt.executeUpdate(sql);
            }
        %>

        <%
            stmt.close();
            stmt = null;
            Conn.close();
            Conn = null;
        %>
    </body>
</html>
