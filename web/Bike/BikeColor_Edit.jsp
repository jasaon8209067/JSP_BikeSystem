<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ include file="/Util_IO.jsp" %>
<%@ include file="Kernel.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("text/html; charset=UTF-8");

    String colorname = req("colorname", request);
    String op = req("op", request);
    String recId = req("C_RecId", request);
    String sqlEdit = "";
    String sqlAdd = "";
    int colorSort = 0;
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
            if (isPost(request)) {//判斷只有按儲存save才會執行資料庫新增或修改，再次呼叫下方的post
                if (colorname != null && !colorname.trim().equals("")) {
                    if ("Edit".equals(op)) { //如果op等於Edit,執行下面的更新動作
                        sqlEdit = "update Bike_Color set C_Name ='" + colorname + "' where C_RecId = " + recId;
                        stmt.executeUpdate(sqlEdit);
                    } else {//如果不是就做新增的動作，先要把最大的排序找出，然後找到後做+1新增一個新的資料
                        sql = "select top 1 C_Sort from Bike_Color order by C_Sort desc";//取的目前最大的排序/最新的資料
                        ResultSet rs = stmt.executeQuery(sql);
                        if (rs.next()) {
                            colorSort = rs.getInt("C_Sort") + 1;
                        } else {
                            colorSort = 1;
                        }
                        rs.close();
                        rs = null;
                        sqlAdd = "insert into Bike_Color (C_Name, C_Sort) values ('" + colorname + "', " + colorSort + ")";
                        stmt.executeUpdate(sqlAdd);
                    }
                    response.sendRedirect("BikeColor_List.jsp");//新增成功後跳回列表頁
                    return;
                }
            }

            //打開編輯頁時，把資料讀出來塞進 input value
            if ("Edit".equals(op)) {
                sql = "select * from Bike_Color where C_RecId=" + recId;
                ResultSet rs = stmt.executeQuery(sql);
                if (rs.next()) {
                    colorname = rs.getString("C_Name");
                }
                rs.close();
                rs = null;
            }


        %>

        <h1>新增顏色</h1>
        <form action="BikeColor_Edit.jsp" method="post" name="addcolor" onsubmit="return checkData();">
            <input type="hidden" name="op" value="<%= op%>">
            <input type="hidden" name="C_RecId" value="<%= recId%>">
            <table border="1" width="30%">
                <a href="BikeColor_List.jsp">列表</a>
                <tr>
                    <td>顏色名稱</td>
                    <td><input type="text" name="colorname" id="colorname" value="<%= colorname%>"></td>
                </tr>
            </table>
            <input type="submit" id="save" name="save" value="確定">
        </form>


        <script>

            // 表單送出前會先呼叫這個
            function checkData() {

                /*興趣名稱檢查*/
                if (addcolor.colorname.value === "") {
                    alert("請輸入顏色名稱");
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
