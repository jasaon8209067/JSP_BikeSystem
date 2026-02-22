<%-- 
    Document   : SessionGet
    Created on : 2026年2月21日, 下午3:27:12
    Author     : jason
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="/Util_IO.jsp" %>
<%
    String Name = (String) session.getAttribute("Name");//從session取得資料，前面加入(String)是強制轉型為字串
    out.print("Name=>" + Name);
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Hello World!</h1>
    </body>
</html>
