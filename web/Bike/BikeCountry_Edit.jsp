<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ include file="/Util_IO.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("text/html; charset=UTF-8");

    String countryname = req("countryname", request);
    String op = req("op", request);
    String recId = req("C_RecId", request);
    String sqlEdit = "";
    String sqlAdd = "";
    int countrySort = 0;
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <%  Class.forName("net.sourceforge.jtds.jdbc.Driver").newInstance();//載入驅動程式元件
            String url = "jdbc:jtds:sqlserver://127.0.0.1:1433/Bike;SendStringParameterAsUnicode=true";

            String user = "sa";
            String password = "j0975035291";
            Connection Conn = DriverManager.getConnection(url, user, password);
            Statement stmt = Conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
            String sql = "";
            if (isPost(request)) {
                if (countryname != null && !countryname.trim().equals("")) {
                    if ("Edit".equals(op)) {
                        sqlEdit = "update Bike_Country set C_Name = '" + countryname + "' where C_RecId =" + recId;
                        stmt.executeUpdate(sqlEdit);
                    } else {
                        sql = "select top 1 C_Sort from Bike_Country order by C_Sort desc";
                        ResultSet rs = stmt.executeQuery(sql);
                        if (rs.next()) {
                            countrySort = rs.getInt("C_Sort") + 1;
                        } else {
                            countrySort = 1;
                        }
                        rs.close();
                        rs = null;
                        sqlAdd = "insert into Bike_Country(C_Name, C_Sort) values('" + countryname + "', " + countrySort +")";
                        stmt.executeUpdate(sqlAdd);
                    }
                    response.sendRedirect("BikeCountry_List.jsp");
                    return;
                }
            }

            if ("Edit".equals(op)) {
                sql = "select * from Bike_Country where C_RecId=" + recId;
                ResultSet rs = stmt.executeQuery(sql);
                if (rs.next()) {
                    countryname = rs.getString("C_Name");
                }
                rs.close();
                rs = null;

            }

        %>

        <h1>新增國家</h1>
        <form action="BikeCountry_Edit.jsp" method="post" name="addcountry" onsubmit="return checkData();">
            <input type="hidden" name="op" value="<%= op%>">
            <input type="hidden" name="C_RecId" value="<%= recId%>">
            <table border="1" width="30%">
                <a href="BikeCountry_List.jsp">列表</a>
                <tr>
                    <td>國家名稱</td>
                    <td><input type="text" name="countryname" id="countryname" value="<%= countryname%>"></td>
                </tr>
            </table>
            <input type="submit" id="save" name="save" value="確定">
        </form>


        <script>

            // 表單送出前會先呼叫這個
            function checkData() {

                /*興趣名稱檢查*/
                if (addcountry.countryname.value === "") {
                    alert("請輸入國家名稱");
                    return false;
                }
                // 全部通過才送出
                return true;
            }


        </script>


        <%
            stmt.close();
            stmt = null;
            Conn.close();
            Conn = null;
        %>


    </body>
</html>
