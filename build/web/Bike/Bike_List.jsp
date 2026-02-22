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

        <%            Class.forName("net.sourceforge.jtds.jdbc.Driver").newInstance();//載入驅動程式元件
            String url = "jdbc:jtds:sqlserver://127.0.0.1:1433/Bike;SendStringParameterAsUnicode=true";

            String user = "sa";
            String password = "j0975035291";
            Connection Conn = DriverManager.getConnection(url, user, password);
            Statement stmt = Conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
            String sql = "SELECT B.B_RecId,"
                    + " B.B_Name,"
                    + " B.B_Number,"
                    + " B.B_CC,"
                    + " B.B_DateTime,"
                    + " B.B_Remark,"
                    + " C.C_Name AS CountryName,"
                    + " BC.C_Name AS BikeColor,"
                    + " STRING_AGG(S.S_Name, ',') AS SuitName"
                    + " FROM Bike B"
                    + " LEFT JOIN Bike_Color BC ON B.B_Color = BC.C_RecId"
                    + " LEFT JOIN Bike_Country C ON B.B_Country = C.C_RecId"//-- 這行是關鍵
                    + " OUTER APPLY STRING_SPLIT(B.B_Suit, ',') SS LEFT JOIN Bike_Suit S ON S.S_RecId = TRY_CAST(SS.value AS INT)"
                    + " GROUP BY B.B_RecId, B.B_Name, B.B_Number, B.B_CC, B.B_DateTime, B.B_Remark, C.C_Name, BC.C_Name";

            if (!keyword.equals("")) {
                sql += " HAVING B.B_Name LIKE '%" + keyword + "%' "
                        + " OR B.B_Number LIKE '%" + keyword + "%' "
                        + " OR C.C_Name LIKE '%" + keyword + "%' "
                        + " OR BC.C_Name LIKE '%" + keyword + "%' "
                        + " OR STRING_AGG(S.S_Name, ',') LIKE '%" + keyword + "%' ";
            } else {
                sql += " ORDER BY B.B_RecId DESC";
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
        <form action="Bike_List.jsp" method="post" id="B_Frm" name="B_Frm">

            <table border="0" width="100%">
                <tr>
                    <td><a href="Bike_List.jsp">列表</a>&nbsp;&nbsp;&nbsp;<a href="Bike_Edit.jsp">新增</a></td>
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
                    <td>名稱</td>
                    <td>車牌號碼</td>
                    <td>顏色</td>
                    <td>國家</td>
                    <td>排氣量</td>
                    <td>配備</td>
                    <td>備註</td>
                    <td>時間</td>
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
                    <td><%= rs.getString("B_Name")%></td>
                    <td><%= rs.getString("B_Number")%></td>
                    <td><%= rs.getString("BikeColor")%></td>
                    <td><%= rs.getString("CountryName")%></td>
                    <td><%= rs.getString("B_CC") + "c.c"%></td>
                    <td><%= rs.getString("SuitName")%></td>
                    <td><%= rs.getString("B_Remark")%></td>
                    <td><%= rs.getString("B_DateTime")%></td>
                </tr>
                <%
                            if (!rs.next()) {
                                break;
                            }
                        }
                    }

                %>
            </table>
        </form>

        <%            rs.close();
            rs = null;
            stmt.close();
            stmt = null;
            Conn.close();
            Conn = null;
        %>
    </body>
</html>
