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
            sql = "select * from Bike order by B_RecId";
            ResultSet rs = stmt.executeQuery(sql);
            while (rs.next()) {
        %>
            data-><%=rs.getString("B_RecId") + ":" + rs.getString("B_Name") + ":" + rs.getString("B_Number") + ":" 
                    + rs.getString("B_Color") + ":" + rs.getString("B_Country") + ":" + rs.getString("B_Datetime")%><br>
        <%
            }
        %>
        <%out.print("連接-Conn_OK");%>
        <%
            rs.close();
            rs = null;
            stmt.close();
            stmt = null;
            Conn.close();
            Conn = null;
        %>
    </body>
</html>
