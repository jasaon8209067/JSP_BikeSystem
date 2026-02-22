<%-- 
    Document   : Menu.jsp
    Created on : 2026年2月2日, 下午4:07:16
    Author     : jason
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ include file="/Util_IO.jsp" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>列表目錄</h1>
        
        <%  Class.forName("net.sourceforge.jtds.jdbc.Driver").newInstance();//載入驅動程式元件
            String url = "jdbc:jtds:sqlserver://127.0.0.1:1433/Friend;SendStringParameterAsUnicode=true";

            String user = "sa";
            String password = "j0975035291";
            Connection Conn = DriverManager.getConnection(url, user, password);
            Statement stmt = Conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);

            String sql = "";

         

            String typestr = "";
            sql = "select * from Friend_Type order by T_Sort desc";
            ResultSet rsType = stmt.executeQuery(sql);

            while (rsType.next()) {
                String tId = rsType.getString("T_RecId");
                String tName = rsType.getString("T_Name");
                // 產生連結，點擊後會帶關鍵字去 List 頁面搜尋該類別
                typestr += "<a target='FrmBody' href='Friend_List.jsp?t=" + tId + "'>" + tName + "</a><br>";
            }
            rsType.close();
            rsType = null;


        %>
        
        <!--target="_blamk"-->
        <base target="BikeBody">
        <a href="Bike_List.jsp" >機車列表</a><br>
        <a href="Bike_Edit.jsp">新增機車</a><br>
        <a href="BikeCountry_List.jsp">出廠國家管理</a><br>
        <a href="BikeSuit_List.jsp">裝備管理</a><br>
        <a href="BikeColor_List.jsp">車輛顏色管理</a><br>
    </body>
</html>
