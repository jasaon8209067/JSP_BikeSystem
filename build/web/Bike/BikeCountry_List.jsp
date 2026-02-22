<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ include file="/Util_IO.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("text/html; charset=UTF-8");

    String keyword = req("keyword", request);
    int ttl = 0;//總筆數
    int pageSize = 5;
    int ttlPage = 0;//總頁數
    int pages = 0;
    String op = req("op",request);
    String recId = req("C_RecId",request);

    String p = req("p", request);//獲取頁數p的值
    if (!p.equals("")) {
        pages = Integer.parseInt(p);//字串轉數字
    } else {
        pages = 1;
    }
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
            String sqlEdit = "";
            String sqlDel = "";
            String sqlUp = "";
            String sqlDown = "";
            ResultSet rsSort = null;
            int nowSort = 0;//現在的排序
            ResultSet rsUp = null;
            ResultSet rsDown = null;
            String upRecId = "";
            String upSort = "";
            String downRecId = "";
            String downSort = "";
            

            //刪除sql
            if ("Del".equals(op)) {
                sqlDel = "delete from Bike_Country where C_RecId =" + recId;
                stmt.executeUpdate(sqlDel);
            }

            //往上移動
                if ("Up".equals(op)) {
                    sqlUp = "select C_Sort from Bike_Country where C_RecId =" + recId;//找出現在的排序sort
                    rsSort = stmt.executeQuery(sqlUp);

                    if (rsSort.next()) {
                        nowSort = rsSort.getInt("C_Sort");
                        sqlUp = "SELECT TOP 1 C_Sort, C_RecId FROM Bike_Country WHERE C_Sort < " + nowSort + " order by C_Sort desc ";
                        rsUp = stmt.executeQuery(sqlUp);//找出上面一筆的排序

                        if (rsUp.next()) {
                            upRecId = rsUp.getString("C_RecId");
                            upSort = rsUp.getString("C_Sort");
                        }
                        rsUp.close();
                        rsUp = null;
                        //先判斷上方是否還有資料，如果無就不做交換
                        if (upSort != null && !upSort.equals("")) {
                            sqlUp = "UPDATE Bike_Country SET C_Sort = " + upSort + " WHERE C_RecId = " + recId;//自己和上面的交換位置
                            stmt.executeUpdate(sqlUp);
                            sql = "update Bike_Country set C_sort = " + nowSort + " where C_RecId = " + upRecId;//上面的交換成自己的位置
                            stmt.executeUpdate(sql);
                        }
                    }
                    rsSort.close();
                    rsSort = null;

                }

                //往下移動
                if ("Down".equals(op)) {
                    sqlDown = "select C_Sort from Bike_Country where C_RecId =" + recId;//找出現在的排序sort
                    rsSort = stmt.executeQuery(sqlDown);

                    if (rsSort.next()) {
                        nowSort = rsSort.getInt("C_Sort");
                        sqlDown = "SELECT TOP 1 C_Sort, C_RecId FROM Bike_Country WHERE C_Sort > " + nowSort + " order by C_Sort asc ";
                        rsDown = stmt.executeQuery(sqlDown);//找出下面一筆的排序

                        if (rsDown.next()) {
                            downRecId = rsDown.getString("C_RecId");
                            downSort = rsDown.getString("C_Sort");
                        }
                        rsDown.close();
                        rsDown = null;
                        //先判斷上方是否還有資料，如果無就不做交換
                        if (downSort != null && !downSort.equals("")) {
                            sqlDown = "UPDATE Bike_Country SET C_Sort = " + downSort + " WHERE C_RecId = " + recId;//自己和下面的交換位置
                            stmt.executeUpdate(sqlDown);
                            sql = "update Bike_Country set C_sort = " + nowSort + " where C_RecId = " + downRecId;//下面的交換成自己的位置
                            stmt.executeUpdate(sql);
                        }
                    }
                    rsSort.close();
                    rsSort = null;
                    response.sendRedirect("BikeCountry_List.jsp");
                    return;
                }

                
            if (!keyword.equals("")) {
                sql = "select * from Bike_Country where (C_Name like '%" + keyword + "%' or C_Sort like '%" + keyword + "%') order by C_Sort";
            } else {
                sql = "select * from Bike_Country order by C_Sort";
            }
//            out.print(sql);
            ResultSet rs = stmt.executeQuery(sql);
            rs.last();//顯示到最後一筆
            ttl = rs.getRow();//獲得總筆數
            out.print("總筆數:" + ttl);
            rs.beforeFirst();//再回到第一筆
            ttlPage = (ttl + pageSize - 1) / pageSize;//總頁數公式
            rs.relative((pages - 1) * pageSize);//頁數公式

            String selectPage = "<select name='p' onchange='B_Frm.submit();'>";
            for (int i = 1; i <= ttlPage; i++) {
                selectPage = selectPage + "<option value='" + i + "' " + isSelected(p, String.valueOf(i)) + ">" + i + "</option>";//HTML語法+副函式isSelected
            }
            selectPage += "</select>";
        %>
        <form action="BikeCountry_List.jsp" method="post" id="B_Frm" name="B_Frm">

            <table border="0" width="100%">
                <tr>
                    <td><a href="BikeCountry_List.jsp">列表</a>&nbsp;&nbsp;&nbsp;<a href="BikeCountry_Edit.jsp">新增</a></td>
                    <td align="right"><input type="text" name="keyword" id="keyword" value="">
                        <input type="submit" name="search" id="search" value="搜尋">                    
                    </td>
                </tr>
                <tr>
                    <td>總頁數:<%=ttlPage%></td>
                    <td align="right">頁數<%=selectPage%>/<%=ttlPage%></td>
                </tr>
            </table>
            <table border="1" width="100%">
                <tr>
                    <td>項次</td>
                    <td>國家</td>
                    <td>排序</td>
                    <td>功能</td>
                </tr>
                <%
//                    int i = 1;
//                    while (rs.next()) {
                    ttlPage = ((ttl - 1) + pageSize) / pageSize;//顯示一頁幾筆的公式，不讓資料顯示不完全
                    if (rs.next()) {
                        for (int i = 1; i <= pageSize; i++) {
                %>
                <tr>
                    <td><%= i%></td>
                    <td><%= rs.getString("C_Name")%></td>
                    <td><%= rs.getString("C_Sort")%></td>
                    <td><a href="BikeCountry_Edit.jsp?op=Edit&C_RecId=<%= rs.getString("C_RecId")%>">編輯</a>&nbsp;&nbsp;&nbsp;
                        <a href="javascript:void(0)" onclick="Del('BikeCountry_List.jsp?op=del&C_RecId=<%= rs.getString("C_RecId")%>')">刪除</a>&nbsp;&nbsp;&nbsp;
                        <a href="BikeCountry_List.jsp?op=Up&C_RecId=<%= rs.getString("C_RecId")%>">上</a>&nbsp;&nbsp;&nbsp;
                        <a href="BikeCountry_List.jsp?op=Down&C_RecId=<%= rs.getString("C_RecId")%>">下</a>
                    </td>
                </tr>
                <%
                            if (!rs.next()) {
                                break;
                            }
                        }
                    }

                %>
            </table>
        <script>
            function Del(url) {
                if (confirm("是否確定要刪除"))
                    location.href = url;
            }
        </script>
        </form>

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
