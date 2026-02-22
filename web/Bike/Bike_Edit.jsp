<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ include file="/Util_IO.jsp" %>
<%@ include file="Kernel.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("text/html; charset=UTF-8");

    //基本接收資料
    String bikename = req("bikename", request);
    String bikenumber = req("bikenumber", request);
    String bikecolor = req("bikecolor", request);
    String bikecountry = req("bikecountry", request);
    String bikecc = req("bikecc", request);
    String bikeremark = req("bikeremark", request);
    // ====== 組合多選配備 ======
    String[] bikesuitarray = request.getParameterValues("bikesuit");
    String bikesuit = "";

    if (bikesuitarray != null) {
        StringBuilder sb = new StringBuilder();

        for (int i = 0; i < bikesuitarray.length; i++) {
            if (i > 0) {
                sb.append(",");
            }
            sb.append(bikesuitarray[i]);
        }

        bikesuit = sb.toString();
    }

    
    //
    String recId = req("B_RecId", request);
    String op = req("op", request);

    if (bikesuitarray != null) {
        for (int i = 0; i < bikesuitarray.length; i++) {
            bikesuit += bikesuitarray[i] + ",";
        }
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
            String sqlche = "";
            String sqlcol = "";
            String sqlsel = "";

            //使用函式isPost，新增
            if (isPost(request)) {
                if (bikename != null && !bikename.trim().equals("") && bikenumber != null && !bikenumber.trim().equals("")) {
                    if ("Edit".equals(op)) {
                        sql = "update Bike set "
                                + "B_Name = " + toStr(bikename) + ", "
                                + "B_Number = " + toStr(bikenumber) + ", "
                                + "B_Color = " + toStr(bikecolor) + ", "
                                + "B_country = " + toStr(bikecountry) + ", "
                                + "B_CC = " + toStr(bikecc) + ", "
                                + "B_Suit = " + toStr(bikesuit) + ", "
                                + "B_Remark = " + toStr(bikeremark) + " "
                                + "where B_RecId= " + recId;
                    } else {
                        sql = "insert into Bike (B_Name, B_Number, B_Color, B_Country, B_CC, B_Suit, B_Remark) values(" + toStr(bikename) + ", " + toStr(bikenumber) + ", " + toStr(bikecolor) + ", " + toStr(bikecountry) + ", " + toStr(bikecc) + ", " + toStr(bikesuit) + ", " + toStr(bikeremark) + ")";
                    }
                    stmt.executeUpdate(sql);
                    response.sendRedirect("Bike_List.jsp");
                    return;
                }
            }

            //如果op等於edit，進行編輯動作
            if (op.equals("Edit")) {
                sqlEdit = "select * from Bike where B_RecId = " + recId;
                ResultSet rsEdit = stmt.executeQuery(sqlEdit);
                if (rsEdit.next()) {
                    bikename = rsEdit.getString("B_Name");
                    bikenumber = rsEdit.getString("B_Number");
                    bikecolor = rsEdit.getString("B_Color");
                    bikecountry = rsEdit.getString("B_Country");
                    bikecc = rsEdit.getString("B_CC");
                    bikesuit = rsEdit.getString("B_Suit");
                    bikeremark = rsEdit.getString("B_Remark");
                }
                rsEdit.close();
            }

            //checkbox配備多選
            Statement stmtSuit = Conn.createStatement();
            String sqlSuit = "";
            ResultSet rsSuit = null;

            String bikesuitStr = "";
            String checkStr = "";
            int S_count = 0;
            String sName = "";

            sqlSuit = "SELECT S_RecId, S_Name FROM Bike_Suit ORDER BY S_Sort DESC";
            rsSuit = stmtSuit.executeQuery(sqlSuit);

            while (rsSuit.next()) {

                S_count++;

                sName = rsSuit.getString("S_Name");
                String sId = rsSuit.getString("S_RecId");

                // 判斷是否已勾選
                // bikesuit 是你從資料庫抓出來的字串，例如: 1,3,5,
                checkStr = isCheckedforcheckBox(bikesuit, "," + sId + ",");

                // 每一個 checkbox 給「唯一 id」
                bikesuitStr += "<input type='checkbox' name='bikesuit' id='bikesuit" + sId + "' value='" + sId + "' " + checkStr + ">" + sName;

                // 每 3 個換行（排版）
                if (S_count % 3 == 0) {
                    bikesuitStr += "<br>";
                }
            }

            rsSuit.close();
            stmtSuit.close();

            //radio顏色單選
            String colorStr = "";
            sqlcol = "select * from Bike_Color order by C_Sort desc";
            ResultSet rsColor = stmt.executeQuery(sqlcol);
            while (rsColor.next()) {
                //取得每一個顏色的id和name
                String colorValue = rsColor.getString("C_RecId");
                String colorName = rsColor.getString("C_Name");

                colorStr += "<input type='radio' name='bikecolor' id='bikecolor' " + isChecked(bikecolor, colorValue) + " ";
                colorStr += "value='" + colorValue + "'>" + colorName;
            }
            rsColor.close();
            rsColor = null;

            //select下拉式選單
            String countryStr = "<select name ='bikecountry'>";
            sqlsel = "select * from Bike_Country order by C_Sort";
            ResultSet rsCountry = stmt.executeQuery(sqlsel);

            while (rsCountry.next()) {
                String countryValue = rsCountry.getString("C_RecId");
                String countryName = rsCountry.getString("C_Name");

                countryStr += "<option value='" + countryValue + "' " + isSelected(bikecountry, countryValue) + ">" + countryName + "</option>";
            }
            countryStr += "</select >";
            rsCountry.close();
            rsCountry = null;

//有寫入資料，但是多選的配備無法多選，國家選擇後未寫入(應該查SQL語法)，備註也沒有被寫入

        %>

        <h1>新增機車</h1>
        <form action="Bike_Edit.jsp" method="post" name="BikeEdit">
            <input type="hidden" name="op" value="<%= op%>">
            <input type="hidden" name="B_RecId" value="<%= recId%>">
            <table border="1" width="45%">
                <a href="Bike_List.jsp">列表</a>
                <tr>
                    <td>名稱:</td>
                    <td><input type="text" id="bikename" name="bikename" value="<%= bikename%>"></td>
                </tr>
                <tr>
                    <td>車牌號碼:</td>
                    <td><input type="text" id="bikenumber" name="bikenumber" value="<%= bikenumber%>"></td>
                </tr>
                <tr>
                    <td>顏色:</td>
                    <td><%= colorStr%></td>
                </tr>
                <tr>
                    <td>國家:</td>
                    <td><%= countryStr%></td>
                </tr>
                <tr>
                    <td>排氣量:</td>
                    <td><input type="text" id="bikecc" name="bikecc" value="<%= bikecc%>"></td>
                </tr>
                <tr>
                    <td>配備:</td>
                    <td><%= bikesuitStr%></td>
                </tr>
                <tr>
                    <td>備註:</td>
                    <td><textarea id="bikeremark" name="bikeremark"><%=bikeremark%></textarea></td>                    
                </tr>
            </table>
            <input type="submit" name="addbike" id="addbike" value="新增">
        </form>



        <script>

            // 表單送出前會先呼叫這個



        </script>


        <%
            stmt.close();
            stmt = null;
            Conn.close();
            Conn = null;
        %>


    </body>
</html>
