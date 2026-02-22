<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="Util_IO.jsp" %>
<%
    String DRIVER = "net.sourceforge.jtds.jdbc.Driver";
    String URL = "jdbc:jtds:sqlserver://127.0.0.1:1433/Bike;SendStringParameterAsUnicode=true";
    String USER = "sa";
    String PWD = "j0975035291";

    Class.forName(DRIVER);
    Connection Conn = DriverManager.getConnection(URL, USER, PWD);
    Statement stmt = Conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);

    String ID = request.getParameter("ID");//取得使用者輸入的帳號
    String pwd = req("pwd", request);//取得使用者輸入的密碼
    String sql = "";
    String OrgId = "";//資料庫內帳號ID
    String OrgName = "";//資料庫內的使用者姓名
    String ScriptStr = "";//設定錯誤提示

    if (isPost(request)) {
        sql = "select * from Org where ID = " + toStr(ID) + " and isEnable = 1";//從Org表單內找出id和isEnable等於1的id
        ResultSet rs = stmt.executeQuery(sql);
        if (rs.next()) {
            if (rs.getString("PWD").equals(pwd)) {//從資料庫拿出密碼和使用者輸入的密碼比對
                OrgId = rs.getString("OrgId");
                OrgName = rs.getString("OrgName");

                setSession("J_OrgId", OrgId, session);//存入session，IO裡面有寫好的函式
                setSession("J_OrgName", OrgName, session);
                response.sendRedirect("/Bike/Bike.jsp");//跳轉到此頁面
                return;
            } else {
                ScriptStr = "<script>alert('密碼錯誤');</script>";
            }
        } else {
            ScriptStr = "<script>alert('帳號錯誤或不存在');</script>";
        }
        rs.close();
    }

%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>用戶登入</h1>
        <form action="Login.jsp" method="post" name="loginpage">
            <table>
                <tr>
                    <td>帳號:<input type="text" name="ID" id="ID" required=""></td>
                </tr>
                <tr>
                    <td>密碼:<input type="password" name="pwd" id="pwd" required></td>
                </tr>
                <tr>
                    <td><button type="submit">登入</td>
                </tr>
            </table>
            <%= ScriptStr%>
        </form>
    </body>
</html>
