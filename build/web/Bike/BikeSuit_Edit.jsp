<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ include file="/Util_IO.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("text/html; charset=UTF-8");

    String suitname = req("suitname", request);
    String op = req("op", request);
    String recId = req("S_RecId", request);
    String sqlEdit = "";
    String sqlAdd = "";
    int suitSort = 0;
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
                if (suitname != null && !suitname.trim().equals("")) {
                    if ("Edit".equals(op)) {
                        sqlEdit = "update Bike_Suit set S_Name = '" + suitname + "' where S_RecId =" + recId;
                        stmt.executeUpdate(sqlEdit);

                    } else {
                        sql = "select top 1 S_Sort from Bike_Suit order by S_Sort desc";
                        ResultSet rs = stmt.executeQuery(sql);
                        if (rs.next()) {
                            suitSort = rs.getInt("S_Sort") + 1;
                        } else {
                            suitSort = 1;
                        }
                        rs.close();
                        rs = null;
                        sqlAdd = "insert into Bike_Suit(S_Name, S_Sort) values('" + suitname + "', " + suitSort + ")";
                        stmt.executeUpdate(sqlAdd);
                    }
                    response.sendRedirect("BikeSuit_List.jsp");
                    return;
                }
            }

            if ("Edit".equals(op)) {
                sql = "select * from Bike_Suit where S_RecId =" + recId;
                ResultSet rs = stmt.executeQuery(sql);
                if (rs.next()) {
                    suitname = rs.getString("S_Name");

                }
            
                rs.close();
                rs = null;
            }


        %>

        <h1>新增配備</h1>
        <form action="BikeSuit_Edit.jsp" method="post" name="addsuit" onsubmit="return checkData();">
            <input type="hidden" name="op" value="<%= op%>">
            <input type="hidden" name="S_RecId" value="<%= recId%>">
            <table border="1" width="30%">
                <a href="BikeSuit_List.jsp">列表</a>
                <tr>
                    <td>配備s名稱</td>
                    <td><input type="text" name="suitname" id="suitname" value="<%= suitname%>"></td>
                </tr>
            </table>
            <input type="submit" id="save" name="save" value="確定">
        </form>


        <script>

            // 表單送出前會先呼叫這個
            function checkData() {

                /*興趣名稱檢查*/
                if (addsuit.suitname.value === "") {
                    alert("請輸入配備名稱");
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
