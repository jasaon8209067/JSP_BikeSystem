<%-- 
    Document   : SessionTest
    Created on : 2026年2月21日, 下午3:22:45
    Author     : jason
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="/Util_IO.jsp" %>

<%
String Name = req("Name",request);//從前端取得name的值
session.setAttribute("Name", Name);//把name存進session
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
